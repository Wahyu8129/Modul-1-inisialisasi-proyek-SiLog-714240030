// ignore_for_file: avoid_print

void main() {
  print(
    '======================================================================',
  );
  print(
    '       MODUL 07: PENGELOLAAN STATE DAN VALIDASI INPUT (FLUTTER)       ',
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

  // 1. Simulasi Logika Validasi Input Sesuai FormPengirimanPage
  print('=== 1. Pengujian Logika Validasi Input ===');

  final List<String> resiTerdaftar = [
    'SLG-2026-0001',
    'SLG-2026-0002',
    'SLG-2026-0003',
  ];

  String? validasiResi(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nomor resi wajib diisi';
    final resiBersih = v.trim().toUpperCase();
    final pola = RegExp(r'^SLG-\d{4}-\d{4}$');
    if (!pola.hasMatch(resiBersih)) {
      return 'Format resi harus SLG-TAHUN-NOMOR, contoh SLG-2026-0010';
    }
    if (resiTerdaftar.contains(resiBersih)) {
      return 'Nomor resi sudah terdaftar, gunakan nomor lain';
    }
    return null;
  }

  String? validasiBerat(String? v) {
    if (v == null || v.trim().isEmpty) return 'Berat barang wajib diisi';
    final berat = double.tryParse(v.trim().replaceAll(',', '.'));
    if (berat == null) return 'Berat barang harus berupa angka valid';
    if (berat < 0.1) return 'Berat barang minimal 0.1 kg';
    if (berat > 5000) return 'Berat barang maksimal 5000 kg';
    return null;
  }

  String? validasiAngka(String? v, String label, {double min = 1}) {
    if (v == null || v.trim().isEmpty) return '$label wajib diisi';
    final angka = double.tryParse(v.trim());
    if (angka == null) return '$label harus berupa angka';
    if (angka < min) return '$label minimal ${min.toInt()}';
    return null;
  }

  // Kasus Uji Validasi
  final kasusUji = [
    {
      'field': 'Nomor Resi (Kosong)',
      'input': '""',
      'hasil': validasiResi(''),
      'diharapkan': 'Nomor resi wajib diisi',
    },
    {
      'field': 'Nomor Resi (Format Salah)',
      'input': '"ABC-1"',
      'hasil': validasiResi('ABC-1'),
      'diharapkan': 'Format resi harus SLG-TAHUN-NOMOR, contoh SLG-2026-0010',
    },
    {
      'field': 'Nomor Resi (Duplikat)',
      'input': '"SLG-2026-0001"',
      'hasil': validasiResi('SLG-2026-0001'),
      'diharapkan': 'Nomor resi sudah terdaftar, gunakan nomor lain',
    },
    {
      'field': 'Nomor Resi (Sah)',
      'input': '"SLG-2026-0099"',
      'hasil': validasiResi('SLG-2026-0099') ?? 'VALID',
      'diharapkan': 'VALID',
    },
    {
      'field': 'Berat Barang (< 0.1 kg)',
      'input': '"0.05"',
      'hasil': validasiBerat('0.05'),
      'diharapkan': 'Berat barang minimal 0.1 kg',
    },
    {
      'field': 'Berat Barang (> 5000 kg)',
      'input': '"6000"',
      'hasil': validasiBerat('6000'),
      'diharapkan': 'Berat barang maksimal 5000 kg',
    },
    {
      'field': 'Berat Barang (Sah)',
      'input': '"2.5"',
      'hasil': validasiBerat('2.5') ?? 'VALID',
      'diharapkan': 'VALID',
    },
    {
      'field': 'Harga Satuan (< 1000)',
      'input': '"500"',
      'hasil': validasiAngka('500', 'Harga satuan', min: 1000),
      'diharapkan': 'Harga satuan minimal 1000',
    },
    {
      'field': 'Harga Satuan (Sah)',
      'input': '"150000"',
      'hasil': validasiAngka('150000', 'Harga satuan', min: 1000) ?? 'VALID',
      'diharapkan': 'VALID',
    },
  ];

  print(
    '| %-25s | %-16s | %-10s |'.replaceFirst('%-25s', 'Field / Skenario')
        .replaceFirst('%-16s', 'Input Uji')
        .replaceFirst('%-10s', 'Status'),
  );
  print('|---------------------------|------------------|------------|');

  for (final k in kasusUji) {
    final pass = k['hasil'] == k['diharapkan'];
    print(
      '| ${k['field']!.padRight(25)} | ${k['input']!.padRight(16)} | ${(pass ? '[PASS]' : '[FAIL]').padRight(10)} |',
    );
  }

  // 2. Pembahasan Analisis Jurnal (Tugas Mandiri 4)
  print('\n=== 2. Analisis Pertanyaan Tugas Mandiri 4 ===');
  print('Pertanyaan: Mengapa TextEditingController wajib dilepas pada dispose()');
  print('            dan apa dampaknya bila dilewatkan?');
  print('Jawaban   :');
  print('1. Alasan Kewajiban:');
  print('   TextEditingController merupakan turunan dari ChangeNotifier.');
  print('   Objek ini mendaftarkan listener ke framework Flutter dan engine teks');
  print('   platform untuk memantau perubahan teks serta posisi kursor.');
  print('2. Dampak jika Tidak Dilepas (Memory Leak):');
  print('   Ketika widget Form dihancurkan (misal pengguna menekan kembali/pop),');
  print('   jika dispose() tidak dipanggil, referensi listener controller tetap');
  print('   tersimpan di memori. Objek State tidak dapat dibersihkan oleh Garbage');
  print('   Collector (GC), menyebabkan kebocoran memori (memory leak), peningkatan');
  print('   konsumsi RAM, dan potensi error "setState called after dispose".');
  print(
    '======================================================================',
  );
}

