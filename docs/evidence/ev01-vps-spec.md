# EV-01 Identitas dan spesifikasi VPS

Terkait: temuan 07 (SKU, kredit). Bukti: screenshot konsol AWS 09-11-2026 (akun disamarkan).

| Item | Isi |
|---|---|
| Tanggal pelaksanaan | 09-11-2026  |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | **SEBAGIAN** |

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

## B. Belum ada: keluaran dari dalam VPS
OS, vCPU, RAM, disk, port yang listen, dan IP dari metadata baru bisa diisi setelah SSH berhasil (jalankan `scripts/bootstrap_vps.sh` atau `scripts/collect_vps_info.sh`).

Public IPv4: dicatat 13.212.10.27. Catatan lama menulis nilai berbeda, jadi **wajib diverifikasi ulang lewat metadata** (`curl` IMDSv2) saat SSH.

## C. Isu
- SSH ke port 22 timeout pada 09-11-2026. Penyebab dugaan: sumber SG port 22 terkunci ke satu IP lama (140.213.99.238/32). Belum terkonfirmasi.
- IP publik dinamis: berubah bila instance di-stop lalu start.

## Status
SEBAGIAN. Menjadi LULUS setelah bagian B terisi dari keluaran server.
