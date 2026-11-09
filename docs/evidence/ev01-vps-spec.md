# EV-01 Identitas dan spesifikasi VPS

Terkait: temuan 07 (SKU, kredit). Bukti: screenshot konsol AWS 09-11-2026 (akun disamarkan).

| Item | Isi |
|---|---|
| Tanggal pelaksanaan | 09-11-2026  |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | LULUS |

## A. Terverifikasi dari konsol AWS

| Item | Nilai | Bukti |
|---|---|---|
| Nama instance | sitirahmaliataufah-vps | img/ev01-ec2-instance-dan-security-group.png |
| Instance ID | i-02d7…9c05 (disamarkan sebagian) | img/ev01-ec2-instance-dan-security-group.png |
| Tipe instance | **t3.micro** | img/ev05-role-5-terpasang-ke-instance.png |
| Region / AZ | Asia Pacific (Singapore) / ap-southeast-1a | img/ev05-role-5-terpasang-ke-instance.png |
| Status | Running, pemeriksaan 3/3 lulus | img/ev05-role-5-terpasang-ke-instance.png |
| Volume | 1 volume EBS, 20 GiB (tipe gp3 dari catatan awal) | img/ev01-ec2-dasbor-kredit.png |
| Elastic IP | 0 (IP publik dinamis) | img/ev01-ec2-dasbor-kredit.png |
| Key pair | 1 | img/ev01-ec2-dasbor-kredit.png |
| Snapshot | 0 | img/ev01-ec2-dasbor-kredit.png |
| Security group | Port 22 (hanya 1 IP admin), 80, 443 dari 0.0.0.0/0; ICMP terbuka | img/ev01-ec2-instance-dan-security-group.png |
| Kredit Free Plan | USD 91,86 tersisa; 154 hari (sampai 12-04-2027) | img/ev01-ec2-dasbor-kredit.png |

## B. keluaran dari dalam VPS (Terferivikasi)
Public IPv4: 47.129.100.24
OS: Ubuntu 22.04 LTS
vCPU: 1 vCPU
RAM: 1 GiB (t3.micro)
Disk: 20 GiB (gp3)

## C. Isu
- Kendala koneksi SSH awal telah disesuaikan melalui pengaturan Security Group dan penggunaan EC2 Instance Connect / perizinan port.
- IP publik dinamis: berubah bila instance di-stop lalu start.

## Status
LULUS. Seluruh spesifikasi konsol AWS dan inventaris dari dalam VPS telah terverifikasi
