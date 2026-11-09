# EV-09 Uji fungsi inti, akses peran, dan IAM

Terkait: Temuan 03 dan 04

| Item | Isi |
|---|---|
| Tanggal/waktu pelaksanaan | (isi saat dijalankan) |
| Commit hash / path berkas | (isi) |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | **BELUM DIJALANKAN** (ubah menjadi LULUS atau GAGAL setelah uji) |

## Prosedur
1. Uji AT-01 sampai AT-09 dengan data sintetis (akun uji A dan B).
2. IDOR: akun A mencoba mengakses dan mengubah catatan akun B (harapan 403/404).
3. IAM: jalankan `scripts/test_iam.sh` di EC2; operasi baca berhasil, operasi mutasi dan administrasi AccessDenied.
4. Cek kebocoran key: `git grep` pola AKIA/aws_secret_access_key (harapan: nol).
5. Label sumber biaya (FR-08): tangkapan layar angka berlabel dan bertimestamp.

## Hasil yang diharapkan
Matriks tes positif dan negatif lengkap; kebocoran credential = nol.

## Hasil aktual (tempel keluaran tersanitasi; jangan menyertakan password, access key, private key, token, atau identitas siswa)
_Belum ada._

## Status lulus/gagal dan isu tersisa
BELUM DIJALANKAN.
