# Cloud Cost Guard (CCG)

Dokumen ini berisi ringkasan implementasi, konfigurasi infrastruktur, serta laporan pengujian untuk proyek **Cloud Cost Guard** yang dikelola oleh **Siti Rahmalia Taufah**.

## 🚀 Ringkasan Proyek
Cloud Cost Guard dirancang untuk membantu memantau, mengamankan, dan mengoptimalkan biaya infrastruktur cloud (AWS EC2), mencegah pembengkakan biaya (cost overrun) akibat instance yang lupa dimatikan, serta memastikan otomatisasi backup off-site yang handal.

## 📋 Spesifikasi Lingkungan & Infrastruktur (EV-01)
* **Cloud Provider:** AWS (Amazon Web Services) - Region: Asia Pacific (Singapore / ap-southeast-1)
* **Instance Type:** `t3.micro` (Ubuntu 22.04 LTS)[cite: 1]
* **Public IPv4:** `47.129.100.24` (Dinamis / Sesuai Instans Berjalan)[cite: 1]
* **Domain / FQDN:** `47-129-100-24.sslip.io`[cite: 1]
* **Web Server & SSL:** Caddy (Automated HTTPS via Let's Encrypt)
* **Backend:** Python (Flask) dengan Gunicorn Server di balik reverse proxy Caddy
* **Storage & Database:** SQLite (`/var/lib/ccg/ccg.db`) dengan penyimpanan backup off-site ke AWS S3.

---

## 📑 Indeks Bukti Pengujian (Evidence `docs/evidence/`)
Seluruh proses pengujian dan validasi sistem terdokumentasi secara lengkap dalam folder `docs/evidence/`:

1. **[EV-01 Identitas & Spesifikasi VPS](docs/evidence/ev01-vps-spec.md)** - Spesifikasi perangkat, AWS Free Tier, dan kuota kredit.
2. **[EV-02 FQDN, DNS, & HTTPS](docs/evidence/ev02-https.md)** - Pengujian resolusi DNS, sertifikat SSL/TLS, dan redirect HTTPS.
3. **[EV-03 Riset Pengguna](docs/evidence/ev03-riset-pengguna.md)** - Wawancara 5 responden terkait masalah kelupaan mematikan instance cloud.
4. **[EV-05 Backup Off-Site S3](docs/evidence/ev05-backup.md)** - Konfigurasi S3 Bucket, lifecycle, IAM policy, dan backup harian otomatis.
5. **[EV-06 Restore Drill](docs/evidence/ev06-restore.md)** - Simulasi pemulihan database dari S3, integritas (`PRAGMA integrity_check`), RTO, dan RPO.
6. **[EV-07 TCO 12 Bulan & Biaya](docs/evidence/ev07-tco-12bulan.md)** - Analisis biaya total kepemilikan 12 bulan dan setup AWS Budgets.
7. **[EV-08 Uji Beban (Load Test)](docs/evidence/ev08-load-test.md)** - Pengujian performa menggunakan Apache Bench (`ab`), error rate 0%, dan stabilitas resource.
8. **[EV-09 Uji Fungsi, IDOR, & IAM](docs/evidence/ev09-uji-domain.md)** - Validasi fungsionalitas, pengamanan IDOR, restriksi IAM, dan audit zero credential leak.

---

## 📊 Status Temuan Proyek
Ringkasan status perbaikan dan pengujian dapat dilihat pada dokumen [Status Temuan](docs/status-temuan.md). Seluruh item prioritas **P0** dan **P1** saat ini telah dinyatakan **LULUS**.

## 🛠️ Panduan Singkat Deployment & Backup
* **Menjalankan Setup VPS:**
  ```bash
  bash scripts/bootstrap_vps.sh
