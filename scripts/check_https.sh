#!/usr/bin/env bash
# Pakai: check_https.sh 47-129-100-24.sslip.io 47.129.100.24
FQDN="${1:?FQDN}"; IP="${2:?IPv4 yang diharapkan}"
echo "# $(date -u +%FT%TZ)"
R="$(dig +short "$FQDN" | head -1)"; echo "dig: $R (harus $IP)"; [ "$R" = "$IP" ] && echo "DNS OK" || echo "DNS BEDA"
echo "--- HTTP harus redirect ke HTTPS"; curl -sI "http://$FQDN/" | head -5
echo "--- HTTPS"; curl -Iv "https://$FQDN/" 2>&1 | grep -Ei "HTTP/|subject:|issuer:|expire|SSL certificate verify" 
echo "--- masa berlaku sertifikat"; echo | openssl s_client -connect "$FQDN:443" -servername "$FQDN" 2>/dev/null | openssl x509 -noout -dates
echo "--- /health"; curl -s -o /dev/null -w "%{http_code} %{time_total}s\n" "https://$FQDN/health"
