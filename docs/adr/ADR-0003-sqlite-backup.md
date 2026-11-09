# ADR-0003: Penyimpanan SQLite dan backup off-site

Status: Proposed (08-11-2026)

## Konteks
Data aplikasi kecil (alias, hash password, catatan instance). Single VPS 1 vCPU/1 GB/20 GB. Target RPO maksimum 24 jam dan RTO maksimum 2 jam (restore) atau 4 jam (rebuild).

## Keputusan
SQLite dengan backup harian memakai Online Backup API (`sqlite3 .backup`), bukan `cp` pada berkas yang sedang ditulis. Hasil dikompres, dihitung SHA-256, dilengkapi manifest (jumlah baris per tabel), lalu diunggah ke bucket S3 terpisah (`ccg-backup-25832072005`, ap-southeast-1) dengan SSE-S3, versioning, Block Public Access, dan lifecycle 35 hari. Peran EC2 hanya boleh `s3:PutObject` dan `s3:ListBucket` pada prefix `ccg/`; restore memakai kredensial admin terpisah. Salinan lokal disimpan 7 buah.

## Alternatif ditolak
RDS/DB terkelola (biaya dan RAM tidak sebanding untuk skala pilot); backup ke Google Drive dengan token pribadi (secret sulit dikelola).

## Konsekuensi
Bergantung pada AWS untuk backup; biaya kecil (dialokasikan di TCO). Perlu uji restore berkala (M05, M08, M12, M15).
