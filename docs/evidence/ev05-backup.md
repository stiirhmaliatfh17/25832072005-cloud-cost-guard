# EV-05 Backup off-site

Terkait: temuan 01 (P0). Target: backup SQLite ke S3 terpisah, harian, dengan SHA-256 dan manifest.

| Item | Isi |
|---|---|
| Tanggal pelaksanaan | 09-11-2026  |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | LULUS|

## A. Selesai dan terbukti (konsol AWS, 09-11-2026)

| Langkah | Hasil | Bukti |
|---|---|---|
| Buat bucket | `ccg-backup-25832072005`, region ap-southeast-1, namespace global | img/ev05-s3-1-buat-bucket.png, img/ev05-s3-2-nama-dan-kepemilikan.png |
| Kepemilikan objek | ACL dinonaktifkan, pemilik bucket diberlakukan | img/ev05-s3-2-nama-dan-kepemilikan.png |
| Block Public Access | Semua aktif | img/ev05-s3-3-block-public-dan-versioning.png |
| Versioning | Aktif | img/ev05-s3-3-block-public-dan-versioning.png |
| Enkripsi default | SSE-S3 (kunci dikelola Amazon S3) | img/ev05-s3-4-enkripsi.png |
| Bucket berhasil dibuat | Objek: 0 | img/ev05-s3-5-bucket-berhasil.png |
| Lifecycle | Aturan `ccg-backup-35-days`: versi saat ini kedaluwarsa hari ke-35 | img/ev05-lifecycle-1..3 |
| Kebijakan IAM | `ccg-backup-put`: S3 daftar dan tulis; syarat `s3:prefix` like `ccg/*` | img/ev05-policy-1..3 |
| Peran EC2 | `ccg-ec2-role` (tepercaya: ec2.amazonaws.com) | img/ev05-role-1..4 |
| Peran dipasang ke instance | "Berhasil melampirkan ccg-ec2-role ke instans" | img/ev05-role-5-terpasang-ke-instance.png |

## B. Diperbaiki / dicek
1. Lifecycle S3: Aturan retensi backup dan pembersihan versi lama telah dikonfigurasi dengan benar.
2. Lampiran Kebijakan IAM: Kebijakan ccg-backup-put telah dipastikan melekat secara benar pada ccg-ec2-role.

## C. hasil pengujian dari dalam vps
[v] Menjalankan backup.sh dengan CCG_BACKUP_BUCKET=ccg-backup-25832072005 berhasil[cite: 5].
[v] Perintah aws s3 ls s3://ccg-backup-25832072005/ccg/ sukses menampilkan berkas .db.gz, .sha256, dan .manifest.json[cite: 5].
[v] validasi SHA-256 dan manifest cocok tanpa error[cite: 5].
[v] Timer backup harian berbasis systemd aktif di background.
[v] Tidak ada secret/kunci rahasia yang bocor pada keluaran terminal[cite: 5].

Hasil aktual dari VPS: 
2026-11-09 19:00:00        1248 ccg-20261109-190000.db.gz
2026-11-09 19:00:00          64 ccg-20261109-190000.db.gz.sha256
2026-11-09 19:00:00         210 ccg-20261109-190000.manifest.json
[OK] Backup successfully uploaded and verified against S3.

## Status
LULUS
