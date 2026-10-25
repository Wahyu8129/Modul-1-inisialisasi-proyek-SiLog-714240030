// ignore_for_file: avoid_print, avoid_relative_lib_imports
import '../lib/layanan/layanan_pengiriman.dart';
import '../lib/layanan/moda.dart';

void main() {
  print(
    '======================================================================',
  );
  print(
    '       MODUL 5: PEMROGRAMAN BERORIENTASI OBJEK LANJUT (DART)          ',
  );
  print(
    '======================================================================',
  );
  print('Nama   : Wahyu Andika T');
  print('NIM    : 714240030');
  print('Proyek : SiLog (Sistem Informasi Logistik) - D4 TI ULBI');
  print(
    '======================================================================\n',
  );

  // 1. Polimorfisme: Koleksi bertipe kelas abstrak LayananPengiriman
  //    dapat menampung berbagai objek kelas turunan (Truk, Kereta Api, Kapal, Udara).
  final List<LayananPengiriman> daftarLayanan = [
    PengirimanTruk(kodeLayanan: 'TRK-REG', jarakKm: 780, beratKg: 1200),
    PengirimanTruk(
      kodeLayanan: 'TRK-EXP',
      jarakKm: 780,
      beratKg: 1200,
      ekspres: true,
    ),
    PengirimanKeretaApi(
      kodeLayanan: 'KA-CARGO',
      jarakKm: 780,
      beratKg: 1200,
      stasiunAsal: 'Kiaracondong',
      stasiunTujuan: 'Pasar Turi',
    ),
    PengirimanKapal(
      kodeLayanan: 'KPL-PETI',
      jarakKm: 1450,
      beratKg: 1200,
      volumeM3: 8.5,
    ),
    // Moda baru hasil Latihan E & Tugas F
    PengirimanUdara(
      kodeLayanan: 'UDR-CARGO',
      jarakKm: 1200,
      beratKg: 1200,
      bandara: 'CGK - SUB',
      panjangCm: 200,
      lebarCm: 150,
      tinggiCm: 100,
    ),
  ];

  // 2. Menampilkan ringkasan masing-masing layanan pengiriman
  print('=== Perbandingan Layanan Pengiriman ===');
  for (final layanan in daftarLayanan) {
    print(layanan.ringkasan());
  }

  // 3. Menentukan Layanan Termurah & Tercepat
  daftarLayanan.sort((a, b) => a.hitungTarif().compareTo(b.hitungTarif()));
  print(
    '\nLayanan termurah : ${daftarLayanan.first.kodeLayanan} (Rp${daftarLayanan.first.hitungTarif().toStringAsFixed(0)})',
  );

  final tercepat = daftarLayanan.reduce(
    (a, b) => a.estimasiHari() <= b.estimasiHari() ? a : b,
  );
  print(
    'Layanan tercepat : ${tercepat.kodeLayanan} (${tercepat.estimasiHari()} hari)',
  );

  // 4. Pemanfaatan Mixin Terlacak
  print('\n=== Pemanfaatan Mixin Terlacak ===');
  final truk = daftarLayanan.whereType<PengirimanTruk>().first;
  truk.catatPosisi('Gudang Utama Bandung');
  truk.catatPosisi('Rest Area KM 207');
  truk.catatPosisi('Gudang Transit Semarang');

  print('Riwayat posisi ${truk.kodeLayanan}:');
  for (final r in truk.riwayat) {
    print('  $r');
  }
  print('Posisi terakhir: ${truk.posisiTerakhir()}');

  // 5. Pemanfaatan Mixin Terasuransi (Tugas Praktikum F)
  print('\n=== Pemanfaatan Mixin Terasuransi (Tugas Praktikum F) ===');
  const double nilaiBarang = 50000000; // Rp 50.000.000
  print('Nilai Barang yang diasuransikan: Rp${nilaiBarang.toStringAsFixed(0)}');

  final kapal = daftarLayanan.whereType<PengirimanKapal>().first;
  final udara = daftarLayanan.whereType<PengirimanUdara>().first;

  print(
    '1. Premi ${kapal.kodeLayanan} (Kapal, ${(kapal.persentasePremi * 100).toStringAsFixed(1)}%): '
    'Rp${kapal.hitungPremi(nilaiBarang).toStringAsFixed(0)}',
  );
  print(
    '2. Premi ${udara.kodeLayanan} (Udara, ${(udara.persentasePremi * 100).toStringAsFixed(1)}%): '
    'Rp${udara.hitungPremi(nilaiBarang).toStringAsFixed(0)}',
  );

  // Pembuktian bahwa PengirimanTruk TIDAK memiliki method hitungPremi
  print('3. Pengecekan kapabilitas asuransi pada PengirimanTruk:');
  print(
    '   - Apakah Truk mengimplementasikan Terasuransi? ${truk is Terasuransi}',
  );
  print(
    '   - Karena Truk tidak dipasang mixin Terasuransi, maka compiler akan menolak',
  );
  print(
    '     pemanggilan method "truk.hitungPremi(...)" jika dipanggil secara langsung.',
  );

  // 6. Uji Coba Error Instansiasi Kelas Abstrak (Langkah D.4)
  // Sesuai modul: "Cobalah membentuk objek LayananPengiriman(...) secara langsung,
  // amati pesan error dari compiler, lalu jelaskan sifat kelas abstrak berdasarkan pesan tersebut."
  /*
  final ujiErrorAbstrak = LayananPengiriman(
    kodeLayanan: 'ERR-ABS',
    jarakKm: 100,
    beratKg: 50,
  );
  // Pesan error dari Dart Compiler:
  // "The class 'LayananPengiriman' is abstract and can't be instantiated."
  */
  print('\n=== Pembuktian Sifat Kelas Abstrak (Langkah D.4) ===');
  print(
    "Instansiasi langsung 'LayananPengiriman(...)' tidak diizinkan oleh compiler Dart:",
  );
  print(
    "Error: The class 'LayananPengiriman' is abstract and can't be instantiated.",
  );
  print(
    'Kelas abstrak hanya bertindak sebagai blueprint/kontrak bagi kelas turunannya.',
  );
  print(
    '======================================================================',
  );
}
