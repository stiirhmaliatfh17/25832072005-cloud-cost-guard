# EV-05 Backup off-site

Terkait: temuan 01 (P0). Target: backup SQLite ke S3 terpisah, harian, dengan SHA-256 dan manifest.

| Item | Isi |
|---|---|
| Tanggal pelaksanaan | 09-11-2026 (konsol); backup di VPS belum dijalankan |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | **SEBAGIAN** |

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

## B. Perlu diperbaiki / dicek
1. **Lifecycle belum lengkap.** Versioning aktif, jadi aturan "versi saat ini kedaluwarsa" hanya membuat delete marker. Tambahkan: hapus permanen versi tidak terkini (1 hari) dan hapus delete marker kedaluwarsa. Setelah diperbaiki, tambahkan screenshot baru.
2. **Lampiran kebijakan ke peran belum terlihat.** Screenshot ringkasan izin peran terpotong. Buktikan bahwa `ccg-backup-put` terlampir ke `ccg-ec2-role` (screenshot tab Permissions peran).

## C. Belum dijalankan (butuh akses VPS)
- [ ] Jalankan `backup.sh` dengan `CCG_BACKUP_BUCKET=ccg-backup-25832072005`; simpan keluaran.
- [ ] `aws s3 ls s3://ccg-backup-25832072005/ccg/` menampilkan file `.db.gz`, `.sha256`, `.manifest.json`.
- [ ] SHA-256 dan manifest cocok.
- [ ] Timer harian 02:00 WIB aktif dan menghasilkan objek baru 3 hari berturut-turut.
- [ ] Tidak ada secret di keluaran.

Hasil aktual dari VPS: _belum ada._

## Status
SEBAGIAN. LULUS hanya bila bagian B tuntas dan seluruh bagian C terisi.
