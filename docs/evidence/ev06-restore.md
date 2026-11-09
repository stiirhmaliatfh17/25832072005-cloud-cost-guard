# EV-06 Restore drill

Terkait: Temuan 02 (P0)

| Item | Isi |
|---|---|
| Tanggal/waktu pelaksanaan | (isi saat dijalankan) |
| Commit hash / path berkas | (isi) |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | **BELUM DIJALANKAN** (ubah menjadi LULUS atau GAGAL setelah uji) |

## Prosedur
1. Simulasi: hentikan service, ganti nama ccg.db (simulasi hilang), catat waktu mulai.
2. Unduh backup dari S3 (dengan kredensial admin terpisah), jalankan `scripts/restore.sh <file.db.gz> /tmp/ccg-staging.db`.
3. Catat: tanggal, nama berkas, SHA-256, `PRAGMA integrity_check`, row count sebelum dan sesudah, durasi (RTO), umur backup terakhir (RPO).

## Hasil yang diharapkan
integrity_check = ok, row count sama dengan manifest, RTO maksimum 2 jam (restore) dan RPO maksimum 24 jam.

## Hasil aktual (tempel keluaran tersanitasi; jangan menyertakan password, access key, private key, token, atau identitas siswa)
_Belum ada._

## Status lulus/gagal dan isu tersisa
BELUM DIJALANKAN.
