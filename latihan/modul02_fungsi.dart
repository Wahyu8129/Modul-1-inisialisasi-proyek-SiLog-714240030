// ignore_for_file: avoid_print

double beratVolumetrik(double p, double l, double t, {double faktor = 6000}) =>
    (p * l * t) / faktor;

double beratTertagih({required double aktual, required double volumetrik}) =>
    aktual > volumetrik ? aktual : volumetrik;

double hitungOngkir({
  required double berat,
  required double tarifPerKg,
  bool asuransi = false,
  double persenAsuransi = 0.005,
  double nilaiBarang = 0,
}) {
  double biaya = berat * tarifPerKg;
  if (asuransi) {
    biaya += nilaiBarang * persenAsuransi;
  }
  return biaya;
}

String rupiah(double nilai) => 'Rp${nilai.toStringAsFixed(0)}';

// Fungsi baru sesuai penugasan langkah D.3
int estimasiHariSampai(String kota) {
  switch (kota.toLowerCase()) {
    case 'bandung':
      return 1;
    case 'surabaya':
      return 2;
    case 'makassar':
      return 3;
    case 'jayapura':
      return 5;
    default:
      return 3;
  }
}

void main() {
  const kotaTujuan = 'Surabaya';
  final volumetrik = beratVolumetrik(45, 30, 25);
  final tertagih = beratTertagih(aktual: 12.4, volumetrik: volumetrik);

  // Perhitungan dengan asuransi = true
  final ongkirDenganAsuransi = hitungOngkir(
    berat: tertagih,
    tarifPerKg: 8500,
    asuransi: true,
    nilaiBarang: 2500000,
  );

  // Perhitungan dengan asuransi = false (sesuai langkah D.2)
  final ongkirTanpaAsuransi = hitungOngkir(
    berat: tertagih,
    tarifPerKg: 8500,
    asuransi: false,
    nilaiBarang: 2500000,
  );

  final estimasi = estimasiHariSampai(kotaTujuan);

  print('Kota tujuan            : $kotaTujuan');
  print('Estimasi sampai        : $estimasi hari');
  print('Berat volumetrik       : ${volumetrik.toStringAsFixed(2)} kg');
  print('Berat tertagih         : ${tertagih.toStringAsFixed(2)} kg');
  print('Ongkos kirim (asuransi): ${rupiah(ongkirDenganAsuransi)}');
  print('Ongkos kirim (tanpa asuransi): ${rupiah(ongkirTanpaAsuransi)}');
  print(
    'Selisih premi asuransi : ${rupiah(ongkirDenganAsuransi - ongkirTanpaAsuransi)}',
  );
}
