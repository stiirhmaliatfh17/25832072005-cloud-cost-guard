# EV-02 FQDN, DNS, dan HTTPS

Terkait: Temuan 05

| Item | Isi |
|---|---|
| Tanggal/waktu pelaksanaan | (isi saat dijalankan) |
| Commit hash / path berkas | (isi) |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | **BELUM DIJALANKAN** (ubah menjadi LULUS atau GAGAL setelah uji) |

## Prosedur
1. FQDN: `47-129-100-24.sslip.io` (atau domain berbayar bila sudah dibeli).
2. Jalankan `scripts/check_https.sh 47-129-100-24.sslip.io 47.129.100.24` dari luar VPS.
3. Screenshot sertifikat di browser dan potongan Caddyfile (tanpa secret).

## Hasil yang diharapkan
DNS resolve ke 47.129.100.24; sertifikat valid; HTTP dialihkan ke HTTPS; /health 200.

## Hasil aktual (tempel keluaran tersanitasi; jangan menyertakan password, access key, private key, token, atau identitas siswa)
_Belum ada._

## Status lulus/gagal dan isu tersisa
BELUM DIJALANKAN.
