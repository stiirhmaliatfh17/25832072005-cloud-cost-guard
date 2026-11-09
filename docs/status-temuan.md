# Tabel status temuan (arahan revisi 06-11-2026; pembaruan 09-11-2026)

| No | Prioritas | Tindakan | Bukti | Status |
|---|---|---|---|---|
| 01 | P0 | Backup off-site ke S3 terpisah | ev05-backup.md | **LULUS**: Bucket, lifecycle, kebijakan IAM, dan backup harian otomatis telah teruji |
| 02 | P0 | Restore drill | ev06-restore.md | **LULUS**: Simulasi pemulihan database berhasil, integritas OK, RTO dan RPO terpenuhi |
| 03 | P0 | Pisahkan sumber angka biaya; rekonsiliasi | ev07, ev09 | **LULUS**: Sumber angka biaya dan estimasi TCO telah direkonsiliasi |
| 04 | P0 | IAM baca-saja dan uji | iam/*.json, ev09 | **LULUS**: Kebijakan IAM, restriksi izin, dan uji coba skrip IAM tuntas |
| 05 | P1 | FQDN, DNS, HTTPS | ev02-https.md | **LULUS**: FQDN sslip.io aktif, DNS resolve, sertifikat SSL/TLS valid |
| 06 | P1 | Uji beban | ev08-load-test.md | **LULUS**: Apache Bench sukses, error rate 0%, performa stabil di bawah batas |
| 07 | P1 | Verifikasi SKU, kredit, biaya | ev01, ev07 | **LULUS**: SKU t3.micro, sisa kredit, EBS, dan AWS Budgets terverifikasi penuh |

Ubah menjadi LULUS atau GAGAL hanya setelah bukti terisi.
