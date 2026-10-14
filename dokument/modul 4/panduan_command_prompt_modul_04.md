# Panduan Perintah Terminal (Command Prompt / Git) — Modul 4 Praktikum

Dokumen ini berisi urutan perintah terminal yang digunakan selama pengerjaan Modul 04 pada proyek `silog_app`.

---

## 1. Persiapan Proyek dan Branch Git

Buka terminal di dalam folder proyek `silog_app` di VS Code, lalu jalankan perintah berikut:

```bash
# Beralih ke branch modul 04
git checkout -b praktikum/modul-04

# Memastikan branch aktif adalah praktikum/modul-04
git branch
```

---

## 2. Membuat Struktur Folder dan Berkas

Buat direktori `lib/model` dan direktori `latihan` (jika belum ada), serta berkas-berkas Dart yang dibutuhkan:

### Linux / macOS / PowerShell (VS Code Integrated Terminal):
```bash
# Membuat folder
mkdir -p lib/model
mkdir -p latihan

# Membuat berkas kosong untuk model dan pengujian
touch lib/model/barang.dart
touch lib/model/gudang.dart
touch lib/model/pengiriman.dart
touch lib/model/pelanggan.dart
touch latihan/modul04_uji.dart
```

*(Catatan: Jika perintah `touch` tidak tersedia di CMD Windows biasa, Anda bisa membuat berkas secara langsung melalui Explorer di VS Code).*

---

## 3. Eksekusi Pengujian Kode

Setelah mengisi kode program pada seluruh berkas di `lib/model/` dan `latihan/modul04_uji.dart`, jalankan program uji menggunakan perintah Dart SDK:

```bash
# Jalankan skrip pengujian
dart run latihan/modul04_uji.dart
```

---

## 4. Menyimpan Perubahan ke Git & Push ke GitHub

Setelah seluruh tugas praktikum selesai dan program berjalan tanpa kendala, simpan riwayat commit dan unggah ke repositori GitHub pribadi Anda:

```bash
# Memeriksa status perubahan berkas
git status

# Menambahkan seluruh perubahan ke staging area
git add .

# Melakukan commit dengan pesan yang jelas
git commit -m "feat(modul-04): menyelesaikan implementasi kelas Barang, Gudang, Pengiriman, dan Pelanggan"

# Mengunggah branch ke repositori GitHub
git push -u origin praktikum/modul-04
```

---

## 5. Pemeriksaan Riwayat Commit (Untuk Tangkapan Layar Jurnal)

Untuk kebutuhan tangkapan layar (*screenshot*) riwayat commit pada jurnal praktikum:

```bash
# Menampilkan riwayat commit secara ringkas
git log --oneline --graph --all
```