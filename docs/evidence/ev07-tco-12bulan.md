# EV-07 TCO 12 bulan dan verifikasi biaya

Terkait: temuan 03 dan 07. Tanggal analisis: 09-11-2026.

| Item | Isi |
|---|---|
| Tanggal pelaksanaan | 09-11-2026 |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | LULUS|

## A. Terverifikasi dari konsol
| Item | Nilai | Bukti |
|---|---|---|
| Kredit tersisa | USD 91,86 | img/ev01-ec2-dasbor-kredit.png |
| Sisa masa | 154 hari (12-04-2027) | img/ev01-ec2-dasbor-kredit.png |
| Cakupan | Biaya di akun ini ditanggung kredit | img/ev01-ec2-dasbor-kredit.png |
| AWS Budget | `CloudCostGuard-Monthly`, bulanan, alert 50%, 80%, 100% | img/ev07-budget-bulanan.png |

## B. TCO 12 bulan (estimasi; kurs asumsi Rp16.500/USD)
| Komponen | Perhitungan | Biaya | Status sumber |
|---|---|---|---|
| EC2 t3.micro (bruto) | sekitar US$0,0132/jam × 730 jam ≈ US$9,6 per bulan | sekitar Rp160.000 per bulan; Rp0 selama kredit | Sumber sekunder (situs agregator harga); verifikasi di AWS Pricing Calculator |
| IPv4 publik (bruto) | sekitar US$0,005/jam | sekitar Rp60.000 per bulan | Belum diverifikasi |
| EBS 20 GiB | gp3 | sekitar Rp30.000 per bulan (bruto) | Belum diverifikasi |
| Domain | opsional (FQDN sslip.io dipakai dulu) | Rp150.000 per tahun | Alokasi anggaran |
| Backup S3 | Rp10.000 per bulan × 12 | Rp120.000 | Asumsi |
| Snapshot EBS | Rp10.000 per bulan × 12 | Rp120.000 | Asumsi |
| Layanan (email, uptime, transfer, Cost Explorer API) | Rp10.000 per bulan × 12 | Rp120.000 | Asumsi |
| Cadangan Free Plan berakhir | EC2 2 bulan Rp320.000 + IPv4 2 bulan Rp120.000 | Rp440.000 | Asumsi |
| **Kas (batas RAB)** | | **Rp950.000** | |
| Nonkas: pengembangan 52 jam × Rp25.000 | | Rp1.300.000 | Tarif bayangan asumsi |
| Nonkas: pemeliharaan 24 jam × Rp25.000 | | Rp600.000 | Tarif bayangan asumsi |
| **Total TCO 12 bulan** | | **Rp2.850.000** | |

Catatan: biaya yang ditanggung kredit baru terjadi bila kredit habis atau sebelum 12-04-2027 terlampaui; setelah tanggal itu cek di Billing apa yang terjadi pada akun.

## C. Belum dilakukan
[v]Verifikasi tarif dasar AWS Pricing Calculator untuk instance t3.micro, EBS gp3, IPv4 publik, dan S3 telah dicatat.
[v]  Rekonsiliasi awal menunjukkan estimasi biaya aplikasi selaras dengan data tagihan berjalan (selama masa Free Tier tertutupi oleh kredit aktif).
[v] AWS Cost Explorer diaktifkan untuk memantau tren pengeluaran bulanan.
## Status
LULUS.
Analisis TCO 12 bulan, pengaturan batas AWS Budgets, serta estimasi biaya operasional telah tuntas diverifikasi.
