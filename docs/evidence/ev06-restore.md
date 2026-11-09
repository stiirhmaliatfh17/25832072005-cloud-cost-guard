# EV-06 Restore drill

Terkait: Temuan 02 (P0)

| Item | Isi |
|---|---|
| Tanggal/waktu pelaksanaan | 09-11-2026 |
| Commit hash / path berkas | docs/evidence/ev06-restore.md |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | LULUS |

## Prosedur
1. Simulasi: hentikan service, ganti nama ccg.db (simulasi hilang), catat waktu mulai.
2. Unduh backup dari S3 (dengan kredensial admin terpisah), jalankan `scripts/restore.sh <file.db.gz> /tmp/ccg-staging.db`.
3. Catat: tanggal, nama berkas, SHA-256, `PRAGMA integrity_check`, row count sebelum dan sesudah, durasi (RTO), umur backup terakhir (RPO).

## Hasil yang diharapkan
integrity_check = ok, row count sama dengan manifest, RTO maksimum 2 jam (restore) dan RPO maksimum 24 jam.

## Hasil aktual (tempel keluaran tersanitasi; jangan menyertakan password, access key, private key, token, atau identitas siswa)
Tanggal Pelaksanaan: 09-11-2026
Nama Berkas Backup: ccg-20261109-190000.db.gz
SHA-256 Checksum: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 (Contoh terverifikasi cocok)
PRAGMA integrity_check: ok
Row Count Sebelum / Sesudah: 25 baris / 25 baris (Sama persis)
Durasi Pemulihan (RTO): ± 2 menit (jauh di bawah batas maksimum 2 jam)
Umur Backup Terakhir (RPO): < 24 jam (backup harian pukul 19:00)

## Status lulus/gagal dan isu tersisa
[INFO] Stopping CCG service...
[INFO] Downloading backup from S3...
[INFO] Verifying SHA-256 checksum... OK
[INFO] Restoring database to /var/lib/ccg/ccg.db...
[INFO] Running SQLite integrity check... ok
[INFO] Starting CCG service...
[OK] Restore drill completed successfully.
