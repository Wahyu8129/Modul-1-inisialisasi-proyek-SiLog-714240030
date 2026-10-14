// ignore_for_file: avoid_print

void main() {
  const double faktorVolumetrik = 6000;

  double beratAktual = 12.4; // kilogram
  // Dimensi awal: panjang = 45, lebar = 30, tinggi = 25
  // Dimensi baru sesuai langkah 3: panjang = 90, lebar = 60, tinggi = 50
  double panjang = 90, lebar = 60, tinggi = 50; // sentimeter

  double beratVolumetrik = (panjang * lebar * tinggi) / faktorVolumetrik;
  double beratTertagih = beratAktual > beratVolumetrik
      ? beratAktual
      : beratVolumetrik;

  String kategori;
  if (beratTertagih <= 5) {
    kategori = 'Paket Kecil';
  } else if (beratTertagih <= 20) {
    kategori = 'Paket Sedang';
  } else {
    kategori = 'Kargo';
  }

  print('Berat aktual     : ${beratAktual.toStringAsFixed(2)} kg');
  print('Berat volumetrik : ${beratVolumetrik.toStringAsFixed(2)} kg');
  print('Berat tertagih   : ${beratTertagih.toStringAsFixed(2)} kg');
  print('Kategori kiriman : $kategori');
}
