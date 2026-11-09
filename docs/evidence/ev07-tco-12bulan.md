# EV-07 TCO 12 bulan dan verifikasi biaya

Terkait: Temuan 03 dan 07

| Item | Isi |
|---|---|
| Tanggal/waktu pelaksanaan | (isi saat dijalankan) |
| Commit hash / path berkas | (isi) |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | **BELUM DIJALANKAN** (ubah menjadi LULUS atau GAGAL setelah uji) |

## Prosedur
1. Tabel TCO: harga bruto sebelum kredit, biaya kas dan nonkas: compute, EBS, IPv4 publik, transfer keluar, backup S3, DNS/domain, Cost Explorer API, kontingensi.
2. Sumber tarif bertanggal (halaman harga AWS atau Pricing Calculator), region, kurs, dan waktu verifikasi.
3. Screenshot Billing tersanitasi dan Budget alert (50%, 80%, 100%).
4. Rekonsiliasi: pilih satu periode dan satu instance uji; bandingkan estimasi aplikasi dengan Cost Explorer/Billing; catat toleransi selisih dan sebab jeda pelaporan.

## Hasil yang diharapkan
Setiap angka dapat ditelusuri ke sumber; selisih berada dalam toleransi yang dinyatakan; alert tidak diklaim mencegah tagihan otomatis.

## Hasil aktual (tempel keluaran tersanitasi; jangan menyertakan password, access key, private key, token, atau identitas siswa)
_Belum ada._

## Status lulus/gagal dan isu tersisa
BELUM DIJALANKAN.
