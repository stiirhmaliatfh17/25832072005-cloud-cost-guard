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
