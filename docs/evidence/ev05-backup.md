# EV-05 Backup off-site

Terkait: Temuan 01 (P0)

| Item | Isi |
|---|---|
| Tanggal/waktu pelaksanaan | (isi saat dijalankan) |
| Commit hash / path berkas | (isi) |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | **BELUM DIJALANKAN** (ubah menjadi LULUS atau GAGAL setelah uji) |

## Prosedur
1. Buat bucket S3 `ccg-backup-25832072005` (ap-southeast-1): Block Public Access aktif, versioning aktif, SSE-S3, lifecycle kedaluwarsa 35 hari.
2. Pasang `iam/ccg-backup-put-policy.json` pada peran EC2; tanpa access key statis.
3. Jalankan `CCG_BACKUP_BUCKET=ccg-backup-25832072005 scripts/backup.sh`; pasang systemd timer harian 02:00 WIB (tempel unit timer tersanitasi).
4. Bukti: `aws s3 ls s3://ccg-backup-25832072005/ccg/`, isi manifest.json, SHA-256, dan bukti berkas ada di luar VPS.

## Hasil yang diharapkan
Backup ada di S3, manifest dan SHA-256 cocok, jadwal berjalan 3 hari berturut-turut, tidak ada secret di keluaran.

## Hasil aktual (tempel keluaran tersanitasi; jangan menyertakan password, access key, private key, token, atau identitas siswa)
_Belum ada._

## Status lulus/gagal dan isu tersisa
BELUM DIJALANKAN.
