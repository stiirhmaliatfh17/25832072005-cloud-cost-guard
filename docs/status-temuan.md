# Tabel status temuan (arahan revisi 06-11-2026)

| No | Prioritas | Tindakan | Bukti | Tanggal | Status |
|---|---|---|---|---|---|
| 01 | P0 | Backup off-site: S3 terpisah, peran put/list, SSE-S3, retensi 35 hari, manifest dan SHA-256 | docs/evidence/ev05-backup.md | 08-11-2026 | BELUM LULUS (skrip siap, belum dijalankan di VPS) |
| 02 | P0 | Restore drill dan laporan | docs/evidence/ev06-restore.md | 08-11-2026 | BELUM LULUS |
| 03 | P0 | Pisahkan sumber angka biaya (manual / API / Billing); rekonsiliasi | docs/evidence/ev07-tco-12bulan.md, ev09-uji-domain.md | 08-11-2026 | BELUM LULUS |
| 04 | P0 | IAM baca-saja dan uji positif/negatif | iam/*.json, scripts/test_iam.sh, ev09 | 08-11-2026 | BELUM LULUS |
| 05 | P1 | FQDN sslip.io, DNS, TLS, redirect | docs/evidence/ev02-https.md | 08-11-2026 | BELUM LULUS |
| 06 | P1 | Skenario dan uji beban | docs/evidence/ev08-load-test.md | 08-11-2026 | BELUM LULUS |
| 07 | P1 | Verifikasi SKU, Free Tier, kredit, EBS/IPv4/egress/CPU credits, budget alert | ev01-vps-spec.md, ev07 | 08-11-2026 | BELUM LULUS |

Ubah kolom Status menjadi LULUS atau GAGAL hanya setelah bukti di kolom Bukti terisi.
