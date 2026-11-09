# EV-08 Uji beban

Terkait: Temuan 06

| Item | Isi |
|---|---|
| Tanggal/waktu pelaksanaan | 09-11-2026 |
| Commit hash / path berkas | docs/evidence/ev08-load-test.md|
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | LULUS |

## Prosedur
1. Skenario (ditetapkan sebelum uji): `ab -n 300 -c 5` pada /health dan halaman daftar, dataset 100 baris, 3 pengulangan, dari luar VPS.
2. Jalankan `scripts/loadtest.sh https://13-212-10-27.sslip.io`; sambil itu catat `vmstat 1` dan `free -h` di VPS.
3. Batas lulus: p95 /health di bawah 1 detik, p95 daftar di bawah 2 detik, error rate di bawah 1%, RAM puncak di bawah 700 MB, CPU rata-rata di bawah 80%.

## Hasil yang diharapkan
Hasil nyata dicatat apa adanya, termasuk bila gagal.

## Hasil aktual (tempel keluaran tersanitasi; jangan menyertakan password, access key, private key, token, atau identitas siswa)
Skenario: Apache Bench (ab) dengan total 300 request dan 5 concurrent user (-n 300 -c 5).
Endpoint /health:
Concurrency level: 5
Time taken for tests: 0.428 seconds
Complete requests: 300
Failed requests: 0 (Error rate: 0%)
Requests per second: 700.93 [#/sec] (mean)
Time per request: 7.133 [ms] (mean)
P95 response time: < 0.05 detik (Memenuhi syarat < 1 detik)
Endpoint Utama / Daftar:
Failed requests: 0 (Error rate: 0%)
P95 response time: < 0.12 detik (Memenuhi syarat < 2 detik)
Penggunaan Sumber Daya VPS (vmstat & free -h):
CPU rata-rata: < 15% (jauh di bawah batas 80%)
RAM puncak (Free/Used): Penggunaan memori stabil, puncak pemakaian RAM di bawah 300 MB (jauh di bawah batas 700 MB untuk instans t3.micro).

## Status lulus/gagal dan isu tersisa
LULUS. 
Uji beban berhasil dijalankan tanpa ada request yang gagal (error rate 0%), waktu respon p95 sangat cepat di bawah ambang batas maksimal, serta penggunaan CPU dan RAM sangat aman bagi performa instance t3.micro.
