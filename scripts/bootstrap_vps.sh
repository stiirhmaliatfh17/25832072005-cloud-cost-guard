#!/usr/bin/env bash
# Cloud Cost Guard - skrip sekali jalan. JALANKAN DI DALAM VPS (prompt: ubuntu@ip-...), bukan di Mac.
# Pakai:  bash bootstrap_vps.sh 2>&1 | tee ~/hasil-bootstrap.txt
set -uo pipefail
BUCKET="ccg-backup-25832072005"
step(){ echo; echo "=== $* ($(date -u +%FT%TZ)) ==="; }
if [ "$(whoami)" != "ubuntu" ] || [ ! -f /etc/os-release ] || ! grep -qi ubuntu /etc/os-release; then
  echo "STOP: skrip ini harus dijalankan di VPS Ubuntu sebagai user ubuntu." ; exit 1; fi

TOKEN=$(curl -s -m 3 -X PUT http://169.254.169.254/latest/api/token -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
imds(){ curl -s -m 3 -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/$1"; }
IP="$(imds public-ipv4)"; FQDN="${IP//./-}.sslip.io"

step "EV-01 Spesifikasi VPS"
echo "instance-type : $(imds instance-type)"; echo "region        : $(imds placement/region)"; echo "az            : $(imds placement/availability-zone)"
echo "public-ipv4   : $IP"; echo "fqdn          : $FQDN"; head -3 /etc/os-release; echo "vCPU: $(nproc)"; free -h; lsblk; df -h /

step "Pasang paket"
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-venv sqlite3 dnsutils curl gnupg unzip debian-keyring debian-archive-keyring apt-transport-https
if ! command -v aws >/dev/null; then
  sudo snap install aws-cli --classic || { curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscli.zip && unzip -q -o /tmp/awscli.zip -d /tmp && sudo /tmp/aws/install; }
fi
aws --version
if ! command -v caddy >/dev/null; then
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor --yes -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list >/dev/null
  sudo apt-get update -y && sudo apt-get install -y caddy
fi
caddy version

step "Aplikasi minimal"
mkdir -p ~/ccg/scripts ~/backups && cd ~/ccg
[ -d venv ] || python3 -m venv venv
./venv/bin/pip install -q flask gunicorn
sudo mkdir -p /var/lib/ccg && sudo chown ubuntu:ubuntu /var/lib/ccg
cat > ~/ccg/app.py <<'EOF_APP'
import os, sqlite3
from flask import Flask, request, redirect
from markupsafe import escape

DB = os.environ.get("CCG_DB", "/var/lib/ccg/ccg.db")
app = Flask(__name__)

def db():
    con = sqlite3.connect(DB)
    con.row_factory = sqlite3.Row
    con.execute("create table if not exists instances(id integer primary key, nama text not null, tipe text not null, start_time text not null)")
    return con

@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/")
def index():
    rows = db().execute("select * from instances order by id desc").fetchall()
    items = "".join(f"<li>{escape(r['nama'])} ({escape(r['tipe'])}) mulai {escape(r['start_time'])}</li>" for r in rows)
    return ("<h1>Cloud Cost Guard</h1><p>Sumber angka: estimasi input manual (simulasi)</p>"
            "<form method=post action=/instances>"
            "<input name=nama placeholder=nama> <input name=tipe placeholder=tipe> <input name=start_time placeholder='2026-11-09T10:00'>"
            "<button>Tambah</button></form><ul>" + items + "</ul>")

@app.post("/instances")
def add():
    nama, tipe, start = (request.form.get(k, "").strip() for k in ("nama", "tipe", "start_time"))
    if not (nama and tipe and start):
        return "Input tidak valid", 400
    c = db()
    c.execute("insert into instances(nama,tipe,start_time) values(?,?,?)", (nama, tipe, start))
    c.commit()
    return redirect("/")
EOF_APP
cat > ~/ccg/scripts/backup.sh <<'EOF_BK'
#!/usr/bin/env bash
# Backup database Cloud Cost Guard: .backup -> integrity_check -> gzip -> SHA-256 -> manifest -> (opsional) S3
set -euo pipefail
DB="${CCG_DB:-/var/lib/ccg/ccg.db}"
OUT="${CCG_BACKUP_DIR:-/var/backups/ccg}"
BUCKET="${CCG_BACKUP_BUCKET:-}"      # contoh: ccg-backup-25832072005 ; kosong = hanya lokal
PREFIX="${CCG_BACKUP_PREFIX:-ccg}"
KEEP_LOCAL="${CCG_KEEP_LOCAL:-7}"
TS="$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$OUT"
SNAP="$OUT/ccg-$TS.db"

[ -f "$DB" ] || { echo "Database tidak ditemukan: $DB" >&2; exit 1; }
START=$(date +%s)
sqlite3 "$DB" ".backup '$SNAP'"
RES="$(sqlite3 "$SNAP" 'PRAGMA integrity_check;')"
[ "$RES" = "ok" ] || { echo "integrity_check GAGAL: $RES" >&2; rm -f "$SNAP"; exit 1; }

python3 - "$SNAP" "$DB" "$TS" <<'PY'
import sqlite3, json, sys, os
snap, src, ts = sys.argv[1:4]
con = sqlite3.connect(snap)
tables = [r[0] for r in con.execute("select name from sqlite_master where type='table' and name not like 'sqlite_%'")]
counts = {t: con.execute(f'select count(*) from "{t}"').fetchone()[0] for t in tables}
json.dump({"created_utc": ts, "source_db": src, "row_counts": counts}, open(snap + ".rows.json", "w"))
PY

gzip -9 "$SNAP"
FILE="$SNAP.gz"
SUM="$(sha256sum "$FILE" | awk '{print $1}')"
python3 - "$FILE" "$SUM" <<'PY'
import json, sys, os
f, s = sys.argv[1:3]
rows = json.load(open(f[:-3] + ".rows.json"))
rows.update({"file": os.path.basename(f), "bytes": os.path.getsize(f), "sha256": s, "integrity_check": "ok"})
json.dump(rows, open(f + ".manifest.json", "w"), indent=2)
PY
rm -f "${SNAP}.rows.json"
echo "$SUM  $(basename "$FILE")" > "$FILE.sha256"

if [ -n "$BUCKET" ]; then
  for f in "$FILE" "$FILE.sha256" "$FILE.manifest.json"; do
    aws s3 cp "$f" "s3://$BUCKET/$PREFIX/$(basename "$f")" --sse AES256 --only-show-errors
  done
  echo "Terunggah ke s3://$BUCKET/$PREFIX/"
fi

# retensi lokal
ls -1t "$OUT"/ccg-*.db.gz 2>/dev/null | tail -n +"$((KEEP_LOCAL+1))" | while read -r old; do rm -f "$old" "$old.sha256" "$old.manifest.json"; done
echo "OK $(basename "$FILE") sha256=$SUM durasi=$(( $(date +%s) - START ))s"
EOF_BK
cat > ~/ccg/scripts/restore.sh <<'EOF_RS'
#!/usr/bin/env bash
# Restore backup ke berkas target (default: staging, tidak menimpa produksi tanpa --force)
# Pakai: restore.sh <ccg-....db.gz> [target.db] [--force]
set -euo pipefail
GZ="${1:?Berkas backup (.db.gz) wajib}"
TARGET="${2:-/tmp/ccg-restore-test.db}"
FORCE="${3:-}"
START=$(date +%s)
[ -f "$GZ.sha256" ] && (cd "$(dirname "$GZ")" && sha256sum -c "$(basename "$GZ").sha256") || { echo "Checksum tidak cocok atau tidak ada" >&2; exit 1; }
if [ -e "$TARGET" ] && [ "$FORCE" != "--force" ]; then echo "Target sudah ada: $TARGET (pakai --force)" >&2; exit 1; fi
TMP="$(mktemp --suffix=.db)"
gunzip -c "$GZ" > "$TMP"
RES="$(sqlite3 "$TMP" 'PRAGMA integrity_check;')"
[ "$RES" = "ok" ] || { echo "integrity_check GAGAL: $RES" >&2; exit 1; }
if [ -f "$GZ.manifest.json" ]; then
python3 - "$TMP" "$GZ.manifest.json" <<'PY'
import sqlite3, json, sys
con = sqlite3.connect(sys.argv[1]); m = json.load(open(sys.argv[2]))
bad = 0
for t, n in m["row_counts"].items():
    got = con.execute(f'select count(*) from "{t}"').fetchone()[0]
    print(f"{t}: manifest={n} restore={got}", "OK" if got == n else "BEDA")
    bad += got != n
sys.exit(1 if bad else 0)
PY
fi
install -m 600 "$TMP" "$TARGET"; rm -f "$TMP"
echo "RESTORE OK -> $TARGET durasi=$(( $(date +%s) - START ))s"
EOF_RS
chmod +x ~/ccg/scripts/*.sh

sudo tee /etc/systemd/system/ccg.service >/dev/null <<'EOF_SVC'
[Unit]
Description=Cloud Cost Guard
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/ccg
Environment=CCG_DB=/var/lib/ccg/ccg.db
ExecStart=/home/ubuntu/ccg/venv/bin/gunicorn -w 1 -b 127.0.0.1:8000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF_SVC
sudo systemctl daemon-reload && sudo systemctl enable --now ccg
sleep 3
echo "health lokal: $(curl -s http://127.0.0.1:8000/health)"

step "EV-02 HTTPS (Caddy + $FQDN)"
printf '%s {\n    reverse_proxy 127.0.0.1:8000\n}\n' "$FQDN" | sudo tee /etc/caddy/Caddyfile >/dev/null
sudo caddy validate --config /etc/caddy/Caddyfile
sudo systemctl restart caddy
sudo ufw allow 22/tcp && sudo ufw allow 80/tcp && sudo ufw allow 443/tcp && sudo ufw --force enable
sudo ufw status verbose
echo "(menunggu sertifikat 40 detik)"; sleep 40
echo "dig: $(dig +short "$FQDN" | head -1) (harus $IP)"
curl -sI "http://$FQDN/" | head -3
curl -s -o /dev/null -w "HTTPS /health: %{http_code} %{time_total}s\n" "https://$FQDN/health"
echo | openssl s_client -connect "$FQDN:443" -servername "$FQDN" 2>/dev/null | openssl x509 -noout -issuer -dates

step "EV-09 Data uji dan validasi input"
for i in $(seq 1 25); do curl -s -o /dev/null -d "nama=uji-$i&tipe=t3.micro&start_time=2026-11-09T10:00" http://127.0.0.1:8000/instances; done
echo "jumlah baris: $(sqlite3 /var/lib/ccg/ccg.db 'select count(*) from instances;')"
echo "input kosong -> HTTP $(curl -s -o /dev/null -w '%{http_code}' -d 'nama=&tipe=&start_time=' http://127.0.0.1:8000/instances) (harapan 400)"

step "EV-05 Backup ke S3"
export CCG_DB=/var/lib/ccg/ccg.db CCG_BACKUP_DIR=$HOME/backups CCG_BACKUP_BUCKET=$BUCKET
bash ~/ccg/scripts/backup.sh
echo "--- isi bucket:"; aws s3 ls "s3://$BUCKET/ccg/" --region ap-southeast-1
LATEST=$(ls -1t ~/backups/ccg-*.db.gz | head -1); echo "--- manifest:"; cat "$LATEST.manifest.json"; echo; cat "$LATEST.sha256"

step "EV-06 Restore drill (simulasi hilang data)"
BEFORE=$(sqlite3 /var/lib/ccg/ccg.db 'select count(*) from instances;'); T0=$(date +%s); echo "baris sebelum: $BEFORE; mulai: $(date +%T)"
sudo systemctl stop ccg && mv /var/lib/ccg/ccg.db /var/lib/ccg/ccg.db.hilang
bash ~/ccg/scripts/restore.sh "$LATEST" /var/lib/ccg/ccg.db
sudo systemctl start ccg; sleep 3
echo "baris sesudah: $(sqlite3 /var/lib/ccg/ccg.db 'select count(*) from instances;'); integrity: $(sqlite3 /var/lib/ccg/ccg.db 'PRAGMA integrity_check;')"
echo "health: $(curl -s http://127.0.0.1:8000/health); selesai: $(date +%T); durasi (RTO): $(( $(date +%s) - T0 )) detik"

step "Penggunaan sumber daya"
free -h; ps -o pid,rss,cmd -C gunicorn | head -5
step "SELESAI - tempel seluruh keluaran ini ke Claude"
