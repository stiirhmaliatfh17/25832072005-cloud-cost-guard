# EV-02 FQDN, DNS, dan HTTPS

Terkait: Temuan 05

| Item | Isi |
|---|---|
| Tanggal/waktu pelaksanaan | 09-11-2026 |
| Commit hash / path berkas | docs/evidence/ev02-https.md |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | LULUS |

## Prosedur
1. FQDN: 47-129-100-24.sslip.io.
2. Jalankan scripts/check_https.sh 47-129-100-24.sslip.io 47.129.100.24 dari luar VPS.

## Hasil yang diharapkan
DNS resolve ke 47.129.100.24; sertifikat valid; HTTP dialihkan ke HTTPS; /health 200.
## Hasil aktual (tempel keluaran tersanitasi; jangan menyertakan password, access key, private key, token, atau identitas siswa)
[OK] DNS Resolution: 47-129-100-24.sslip.io -> 47.129.100.24 
[OK] HTTP to HTTPS Redirect: HTTP 301/302 Redirect active 
[OK] SSL/TLS Certificate: Valid (Issued by Let's Encrypt / ZeroSSL via Caddy) 
[OK] Endpoint /health: HTTP status 200 OK Content: {"status":"ok"}

## Status lulus/gagal dan isu tersisa
LULUS
