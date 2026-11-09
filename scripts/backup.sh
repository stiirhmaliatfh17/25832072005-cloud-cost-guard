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
