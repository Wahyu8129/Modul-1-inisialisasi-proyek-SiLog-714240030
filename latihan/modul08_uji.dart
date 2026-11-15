// ignore_for_file: avoid_print

import 'package:sembast/sembast_memory.dart';

void main() async {
  print(
    '======================================================================',
  );
  print(
    '       MODUL 08: PENYIMPANAN DATA LOKAL (SEMBAST & PREFERENSI)        ',
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

  print('=== 1. Pengujian Operasi CRUD Sembast Database ===');
  final factory = newDatabaseFactoryMemory();
  final db = await factory.openDatabase('silog_latihan.db');
  final store = intMapStoreFactory.store('stok');

  // 1. CREATE
  final id1 = await store.add(db, {
    'kodeBarang': 'B-101',
    'namaBarang': 'Sepatu Olahraga Pria',
    'kodeGudang': 'GD-BDG',
    'jumlah': 25,
    'diperbaruiPada': DateTime.now().toIso8601String(),
  });
  final id2 = await store.add(db, {
    'kodeBarang': 'B-102',
    'namaBarang': 'Kaos Katun Premium',
    'kodeGudang': 'GD-BDG',
    'jumlah': 50,
    'diperbaruiPada': DateTime.now().toIso8601String(),
  });
  final id3 = await store.add(db, {
    'kodeBarang': 'B-103',
    'namaBarang': 'Tas Ransel Laptop Outdoor',
    'kodeGudang': 'GD-BDG',
    'jumlah': 30,
    'diperbaruiPada': DateTime.now().toIso8601String(),
  });
  print('[CREATE] Berhasil menambahkan 3 data stok (ID: $id1, $id2, $id3)');

  // 2. READ & SEARCH (Tugas 2: RegExp Filter)
  print('\n=== 2. Pengujian Filter RegExp Pencarian Nama Barang (Tugas 2) ===');
  const kataKunci = 'sepatu';
  final filterCari = Filter.matchesRegExp(
    'namaBarang',
    RegExp(kataKunci, caseSensitive: false),
  );
  final hasilCari = await store.find(db, finder: Finder(filter: filterCari));
  print('Hasil pencarian dengan kata kunci "$kataKunci": ${hasilCari.length} item');
  for (final r in hasilCari) {
    print('  - [${r.value['kodeBarang']}] ${r.value['namaBarang']} = ${r.value['jumlah']} unit');
  }

  // 3. UPDATE
  print('\n=== 3. Pengujian Operasi Update Stok ===');
  final dataLama = await store.record(id1).get(db);
  final jumlahLama = dataLama!['jumlah'] as int;
  await store.record(id1).update(db, {'jumlah': jumlahLama + 5});
  final dataBaru = await store.record(id1).get(db);
  print('[UPDATE] ID $id1: Jumlah stok berubah dari $jumlahLama -> ${dataBaru!['jumlah']}');

  // 4. DELETE
  print('\n=== 4. Pengujian Operasi Delete Stok ===');
  await store.record(id3).delete(db);
  final cekHapus = await store.record(id3).get(db);
  print('[DELETE] ID $id3 dihapus. Status data: ${cekHapus == null ? "NULL (Terhapus)" : "Masih Ada"}');

  final totalSemua = await store.count(db);
  print('\nTotal data stok tersisa di database: $totalSemua item.');
  await db.close();

  // 5. Pembahasan Rumusan Calon Topik Proyek Akhir (Tugas Mandiri 4)
  print('\n======================================================================');
  print('=== 5. Rumusan Topik Calon Proyek Akhir (Tugas Mandiri 4) ===');
  print('======================================================================');
  print('1. Judul Proyek:');
  print('   "SiTrackLog: Sistem Manajemen Pengiriman dan Pelacakan Armada Logistik');
  print('    Berbasis Multi-Gudang Terintegrasi Flutter & Local Offline Storage"');
  print('\n2. Latar Belakang Masalah:');
  print('   Banyak kurir dan petugas gudang logistik mengalami kendala pencatatan');
  print('   ketika berada di area minim sinyal (dead zone), sehingga status paket');
  print('   dan stok gudang tidak dapat diperbarui secara realtime. Diperlukan');
  print('   aplikasi mobile dengan kapabilitas offline-first lokal cache.');
  print('\n3. Pengguna Sasaran:');
  print('   - Staf Gudang (Warehouse Officer)');
  print('   - Pengemudi Armada / Kurir Logistik');
  print('   - Manajer Operasional Logistik');
  print('\n4. Tiga Fitur Utama:');
  print('   a. Offline-First Inventory & Dispatch Synchronization:');
  print('      Pencatatan keluar-masuk barang dan muat armada ke basis data lokal');
  print('      (Sembast) yang otomatis tersinkronisasi saat sinyal pulih.');
  print('   b. Validated Multi-Modal Delivery Route & Resi Tracking:');
  print('      Pemeriksaan format nomor resi standar industri, alokasi moda');
  print('      transportasi (Truk, Kereta, Kapal, Pesawat), dan riwayat checkpoint.');
  print('   c. Persistent Role-Based Preference & Dynamic Dark Theme:');
  print('      Penyimpanan profil petugas gudang, preferensi gudang aktif, serta mode');
  print('      tampilan malam/siang untuk pengemudi rute jarak jauh.');
  print('\n5. Bagian Spesifik yang Dikerjakan Sendiri (Wahyu Andika T - 714240030):');
  print('   - Perancangan arsitektur penyimpanan lokal (Sembast & SharedPreferences)');
  print('   - Implementasi modul manajemen stok gudang (CRUD + RegExp Search)');
  print('   - Sistem validasi formulir pemesanan pengiriman dan verifikasi resi');
  print('======================================================================');
}
