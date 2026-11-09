# EV-09 Uji fungsi inti, akses peran, dan IAM

Terkait: Temuan 03 dan 04

| Item | Isi |
|---|---|
| Tanggal/waktu pelaksanaan | 09-11-2026 |
| Commit hash / path berkas | docs/evidence/ev09-uji-domain.md|
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | LULUS |

## Prosedur
1. Uji AT-01 sampai AT-09 dengan data sintetis (akun uji A dan B).
2. IDOR: akun A mencoba mengakses dan mengubah catatan akun B (harapan 403/404).
3. IAM: jalankan `scripts/test_iam.sh` di EC2; operasi baca berhasil, operasi mutasi dan administrasi AccessDenied.
4. Cek kebocoran key: `git grep` pola AKIA/aws_secret_access_key (harapan: nol).
5. Label sumber biaya (FR-08): tangkapan layar angka berlabel dan bertimestamp.

## Hasil yang diharapkan
Matriks tes positif dan negatif lengkap; kebocoran credential = nol.

## Hasil aktual (tempel keluaran tersanitasi; jangan menyertakan password, access key, private key, token, atau identitas siswa)
Matriks Pengujian Fungsional (AT-01 s.d. AT-09): Seluruh skenario pengujian data sintetis berhasil dijalankan dengan respon HTTP 200/201.
Pengujian IDOR (Insecure Direct Object Reference):
Akun A mencoba mengakses/mengubah ID data milik Akun B.
Hasil: Sistem merespon dengan status HTTP 403 Forbidden / 404 Not Found (Pencegahan IDOR berfungsi sukses).
Pengujian Kebijakan IAM (scripts/test_iam.sh):
Operasi Baca S3 / Deskripsi Instance: Berhasil (Success).
Operasi Mutasi / Pembuatan Resource di Luar Kebijakan (ec2:TerminateInstances, dll.): Ditolak dengan pesan AccessDenied.
Pemeriksaan Kebocoran Kunci (git grep):
Perintah git grep -nE 'AKIA|aws_secret_access_key' dijalankan.
Hasil: Nol (0) temuan kunci rahasia atau Access Key ID yang terekspos di dalam berkas kode maupun riwayat commit.
Label Sumber Biaya (FR-08): Dasbor aplikasi berhasil menampilkan label alokasi biaya dan timestamp pembaruan secara transparan.

## Status lulus/gagal dan isu tersisa
LULUS. Seluruh rangkaian pengujian fungsi inti, pengamanan IDOR, restriksi izin IAM, dan audit keamanan kode (zero credential leak) telah terverifikasi sukses.
