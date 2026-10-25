// ignore_for_file: avoid_print

/// Mixin untuk melacak riwayat perjalanan pengiriman logistik
mixin Terlacak {
  final List<String> _riwayat = [];

  List<String> get riwayat => List.unmodifiable(_riwayat);

  void catatPosisi(String lokasi) {
    final waktu = DateTime.now().toIso8601String().substring(11, 16);
    _riwayat.add('[$waktu] $lokasi');
  }

  String posisiTerakhir() =>
      _riwayat.isEmpty ? 'Belum ada data posisi' : _riwayat.last;
}

/// Mixin untuk layanan pengiriman yang memiliki fasilitas asuransi (Tugas Praktikum F)
mixin Terasuransi {
  /// Persentase premi asuransi (default 0.5% = 0.005 sesuai Modul 2)
  double persentasePremi = 0.005;

  /// Menghitung premi asuransi berdasarkan nilai pertanggungan barang
  double hitungPremi(double nilaiBarang) {
    return nilaiBarang * persentasePremi;
  }
}

/// Kelas abstrak sebagai kerangka kontrak bagi seluruh moda layanan pengiriman
abstract class LayananPengiriman {
  final String kodeLayanan;
  final double jarakKm;
  final double beratKg;

  LayananPengiriman({
    required this.kodeLayanan,
    required this.jarakKm,
    required this.beratKg,
  });

  /// Wajib diimplementasikan oleh setiap moda pengiriman.
  double hitungTarif();

  /// Wajib diimplementasikan oleh setiap moda pengiriman.
  int estimasiHari();

  /// Implementasi umum yang diwarisi oleh seluruh turunan.
  String ringkasan() {
    final tarif = hitungTarif().toStringAsFixed(0);
    return '$kodeLayanan | ${jarakKm.toStringAsFixed(0)} km | '
        '${beratKg.toStringAsFixed(1)} kg | Rp$tarif | ${estimasiHari()} hari';
  }
}
