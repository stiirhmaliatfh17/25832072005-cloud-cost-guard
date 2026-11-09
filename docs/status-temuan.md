# Tabel status temuan (arahan revisi 06-11-2026; pembaruan 09-11-2026)

| No | Prioritas | Tindakan | Bukti | Status |
|---|---|---|---|---|
| 01 | P0 | Backup off-site ke S3 terpisah | ev05-backup.md | SEBAGIAN: bucket, kebijakan, peran terpasang; backup belum dijalankan |
| 02 | P0 | Restore drill | ev06-restore.md | BELUM LULUS |
| 03 | P0 | Pisahkan sumber angka biaya; rekonsiliasi | ev07, ev09 | BELUM LULUS |
| 04 | P0 | IAM baca-saja dan uji | iam/*.json, ev09 | SEBAGIAN: kebijakan backup dibuat; baca-saja dan uji belum |
| 05 | P1 | FQDN, DNS, HTTPS | ev02-https.md | BELUM LULUS |
| 06 | P1 | Uji beban | ev08-load-test.md | BELUM LULUS |
| 07 | P1 | Verifikasi SKU, kredit, biaya | ev01, ev07 | SEBAGIAN: SKU, kredit, budget terverifikasi |

Ubah menjadi LULUS atau GAGAL hanya setelah bukti terisi.
