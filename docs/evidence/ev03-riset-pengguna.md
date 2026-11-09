# EV-03 Riset pengguna

Terkait: Dasar bukti masalah (bab 3.1)

| Item | Isi |
|---|---|
| Tanggal/waktu pelaksanaan | 09-11-2026) |
| Commit hash / path berkas | docs/evidence/ev03-riset-pengguna.md |
| Dijalankan oleh | Siti Rahmalia Taufah |
| Status | LULUS |

## Prosedur
1. Gunakan pertanyaan di Lampiran A; catat jawaban asli responden tanpa nama (R1, R2, ...).
2. Ringkas: jumlah responden, berapa yang pernah lupa mematikan instance, cara mencatat saat ini.

## Hasil yang diharapkan
Minimal 5 responden; data tanpa identitas.

## Hasil aktual (tempel keluaran tersanitasi; jangan menyertakan password, access key, private key, token, atau identitas siswa)
Jumlah Responden: 5 orang (R1 s.d. R5) tanpa identitas pribadi.
Pengalaman Lupa Mematikan Instance: 4 dari 5 responden pernah mengalami lupa mematikan instance EC2/cloud server setelah selesai uji coba, yang berakibat pada pembengkakan biaya atau habisnya kredit gratis.
Cara Mencatat/Memantau Saat Ini:
R1: Mengandalkan memori pribadi dan alarm manual di HP.
R2: Menggunakan spreadsheet manual untuk mencatat daftar server aktif.
R3: Tidak ada pencatatan khusus, baru tahu saat tagihan/notifikasi billing muncul.
R4: Menggunakan AWS Budgets dasar tapi sering mengabaikan email peringatan.
R5: Membuat skrip cron job sederhana untuk mematikan instance otomatis di malam hari.

## Status lulus/gagal dan isu tersisa
LULUS
