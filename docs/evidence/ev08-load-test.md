# EV-08 Uji beban

Terkait: Temuan 06

| Item | Isi |
|---|---|
| Tanggal/waktu pelaksanaan | (isi saat dijalankan) |
| Commit hash / path berkas | (isi) |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | **BELUM DIJALANKAN** (ubah menjadi LULUS atau GAGAL setelah uji) |

## Prosedur
1. Skenario (ditetapkan sebelum uji): `ab -n 300 -c 5` pada /health dan halaman daftar, dataset 100 baris, 3 pengulangan, dari luar VPS.
2. Jalankan `scripts/loadtest.sh https://13-212-10-27.sslip.io`; sambil itu catat `vmstat 1` dan `free -h` di VPS.
3. Batas lulus: p95 /health di bawah 1 detik, p95 daftar di bawah 2 detik, error rate di bawah 1%, RAM puncak di bawah 700 MB, CPU rata-rata di bawah 80%.

## Hasil yang diharapkan
Hasil nyata dicatat apa adanya, termasuk bila gagal.

## Hasil aktual (tempel keluaran tersanitasi; jangan menyertakan password, access key, private key, token, atau identitas siswa)
_Belum ada._

## Status lulus/gagal dan isu tersisa
BELUM DIJALANKAN.
