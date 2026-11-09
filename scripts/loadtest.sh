#!/usr/bin/env bash
# Uji beban M11. Jalankan dari LUAR VPS. Pakai: loadtest.sh https://fqdn
BASE="${1:?URL dasar}"; N="${N:-300}"; C="${C:-5}"; REP="${REP:-3}"
for path in /health /; do
  for i in $(seq 1 "$REP"); do
    echo "== $path ulangan $i ($(date -u +%FT%TZ)) n=$N c=$C"
    ab -n "$N" -c "$C" -q -e "/tmp/ab-$i.csv" "$BASE$path" | grep -E "Complete requests|Failed requests|Non-2xx|Requests per second|95%"
    awk -F, '$1=="95"{print "p95 (ms): "$2}' "/tmp/ab-$i.csv"
  done
done
echo "Catat juga di VPS selama uji: vmstat 1 dan free -h (CPU/RAM puncak)."
