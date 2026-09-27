// ignore_for_file: avoid_print

// ============================================================================
// Program: modul02_tugas.dart
// Tugas Praktikum 2 - Pemrograman Berorientasi Objek / Pemrograman IV
// Nama   : Wahyu Andika T
// NIM    : 714240030
// ============================================================================

/// Fungsi untuk menghitung total berat dari seluruh kiriman.
double hitungTotalBerat(List<Map<String, dynamic>> kiriman) {
  return kiriman.fold<double>(
    0.0,
    (total, item) => total + (item['berat'] as num).toDouble(),
  );
}

/// Fungsi untuk menghitung rata-rata berat kiriman.
double hitungRataRataBerat(List<Map<String, dynamic>> kiriman) {
  if (kiriman.isEmpty) return 0.0;
  return hitungTotalBerat(kiriman) / kiriman.length;
}

/// Fungsi untuk mencari data kiriman dengan bobot terberat.
Map<String, dynamic> cariKirimanTerberat(List<Map<String, dynamic>> kiriman) {
  if (kiriman.isEmpty) return {};
  return kiriman.reduce(
    (terberat, item) =>
        (item['berat'] as num).toDouble() >
            (terberat['berat'] as num).toDouble()
        ? item
        : terberat,
  );
}

/// Fungsi untuk mencari data kiriman dengan bobot teringan.
Map<String, dynamic> cariKirimanTeringan(List<Map<String, dynamic>> kiriman) {
  if (kiriman.isEmpty) return {};
  return kiriman.reduce(
    (teringan, item) =>
        (item['berat'] as num).toDouble() <
            (teringan['berat'] as num).toDouble()
        ? item
        : teringan,
  );
}

/// Fungsi untuk menentukan kategori kiriman berdasarkan berat tertagih:
/// - Paket Kecil  : berat <= 5 kg
/// - Paket Sedang : 5 kg < berat <= 20 kg
/// - Kargo        : berat > 20 kg
String tentukanKategori(double berat) {
  if (berat <= 5) {
    return 'Paket Kecil';
  } else if (berat <= 20) {
    return 'Paket Sedang';
  } else {
    return 'Kargo';
  }
}

/// Fungsi untuk menghitung rekapitulasi jumlah kiriman per kategori.
Map<String, int> hitungKategoriKiriman(List<Map<String, dynamic>> kiriman) {
  final Map<String, int> rekap = {
    'Paket Kecil': 0,
    'Paket Sedang': 0,
    'Kargo': 0,
  };

  for (final item in kiriman) {
    final berat = (item['berat'] as num).toDouble();
    final kategori = tentukanKategori(berat);
    rekap[kategori] = (rekap[kategori] ?? 0) + 1;
  }

  return rekap;
}

/// Fungsi utama: memanggil fungsi-fungsi modular dan menampilkan hasil ringkasan.
void main() {
  // Daftar 10 data kiriman (memenuhi syarat minimal 8 kiriman)
  final List<Map<String, dynamic>> daftarKiriman = [
    {'resi': 'SLG-2026-001', 'kota': 'Bandung', 'berat': 2.5},
    {'resi': 'SLG-2026-002', 'kota': 'Jakarta', 'berat': 15.0},
    {'resi': 'SLG-2026-003', 'kota': 'Surabaya', 'berat': 4.2},
    {'resi': 'SLG-2026-004', 'kota': 'Makassar', 'berat': 28.5},
    {'resi': 'SLG-2026-005', 'kota': 'Jayapura', 'berat': 1.2},
    {'resi': 'SLG-2026-006', 'kota': 'Medan', 'berat': 18.0},
    {'resi': 'SLG-2026-007', 'kota': 'Semarang', 'berat': 32.0},
    {'resi': 'SLG-2026-008', 'kota': 'Denpasar', 'berat': 8.6},
    {'resi': 'SLG-2026-009', 'kota': 'Palembang', 'berat': 0.75},
    {'resi': 'SLG-2026-010', 'kota': 'Balikpapan', 'berat': 45.0},
  ];

  print('=================================================================');
  print('          LAPORAN DATA PENGIRIMAN LOGISTIK (SiLog)              ');
  print('=================================================================');
  print('No. | Resi         | Kota Tujuan  | Berat (kg) | Kategori        ');
  print('----+--------------+--------------+------------+-----------------');

  int no = 1;
  for (final item in daftarKiriman) {
    final resi = (item['resi'] as String).padRight(12);
    final kota = (item['kota'] as String).padRight(12);
    final berat = (item['berat'] as num).toDouble();
    final beratStr = berat.toStringAsFixed(2).padLeft(8);
    final kategori = tentukanKategori(berat).padRight(15);
    print(
      '${no.toString().padLeft(2)}  | $resi | $kota | $beratStr kg | $kategori',
    );
    no++;
  }

  // Pemanggilan fungsi terpisah
  final totalBerat = hitungTotalBerat(daftarKiriman);
  final rataRataBerat = hitungRataRataBerat(daftarKiriman);
  final terberat = cariKirimanTerberat(daftarKiriman);
  final teringan = cariKirimanTeringan(daftarKiriman);
  final rekapKategori = hitungKategoriKiriman(daftarKiriman);

  print('=================================================================');
  print('                     RINGKASAN STATISTIK                         ');
  print('=================================================================');
  print('Jumlah Kiriman            : ${daftarKiriman.length} paket');
  print('Total Berat Kiriman       : ${totalBerat.toStringAsFixed(2)} kg');
  print('Rata-rata Berat Kiriman   : ${rataRataBerat.toStringAsFixed(2)} kg');
  print(
    'Kiriman Terberat          : ${terberat['resi']} (${terberat['kota']}) - ${(terberat['berat'] as num).toDouble().toStringAsFixed(2)} kg',
  );
  print(
    'Kiriman Teringan          : ${teringan['resi']} (${teringan['kota']}) - ${(teringan['berat'] as num).toDouble().toStringAsFixed(2)} kg',
  );
  print('-----------------------------------------------------------------');
  print('Distribusi Kategori Kiriman:');
  rekapKategori.forEach((kategori, jumlah) {
    print('  - ${kategori.padRight(14)} : $jumlah kiriman');
  });
  print('=================================================================');
}
