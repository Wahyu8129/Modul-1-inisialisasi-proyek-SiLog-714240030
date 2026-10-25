# SiLog - Sistem Informasi Logistik

Repositori Praktikum Pemrograman IV  
D4 Teknik Informatika — Universitas Logistik dan Bisnis Internasional (ULBI)

- **Nama**: Wahyu Andika T  
- **NIM**: 714240030  
- **Mata Kuliah**: Pemrograman IV  

---

## Panduan Menjalankan Proyek

### 1. Menjalankan Aplikasi Flutter (UI)

Pastikan dependensi telah terpasang:
```bash
flutter pub get
```

Jalankan aplikasi pada target browser atau desktop:

```bash
# Menjalankan di Google Chrome
flutter run -d chrome

# Menjalankan di Microsoft Edge
flutter run -d edge

# Menjalankan di Windows Desktop
flutter run -d windows
```

---

### 2. Menjalankan Skrip Praktikum & Pengujian Model (Dart)

Skrip pengujian logika dan model OOP dapat dijalankan langsung menggunakan Dart SDK melalui terminal:

#### Modul 05 — Pemrograman Berorientasi Objek Lanjut
Menguji abstraksi `LayananPengiriman`, mixin `Terlacak` & `Terasuransi`, polimorfisme moda transportasi (`PengirimanTruk`, `PengirimanKeretaApi`, `PengirimanKapal`, `PengirimanUdara`):
```bash
dart run latihan/modul05_uji.dart
```

#### Modul 04 — Pemrograman Berorientasi Objek Dasar
Menguji model `Barang`, `Gudang`, `Pengiriman`, dan `Pelanggan` (termasuk validasi status dan kapasitas):
```bash
dart run latihan/modul04_uji.dart
```

#### Modul 02 — Dasar Pemrograman Dart
```bash
# Latihan dasar (variabel & volumetrik)
dart run latihan/modul02_dasar.dart

# Latihan fungsi
dart run latihan/modul02_fungsi.dart

# Latihan koleksi (list, map, set)
dart run latihan/modul02_koleksi.dart

# Tugas modul 02
dart run latihan/modul02_tugas.dart
```

---

### 3. Pengujian Otomatis & Analisis Kode

Untuk memverifikasi kebersihan kode dan widget test:

```bash
# Menjalankan analisis kode (linting)
flutter analyze

# Menjalankan widget test
flutter test
```
