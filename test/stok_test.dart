import 'package:flutter_test/flutter_test.dart' hide Finder;
import 'package:project_1/data/preferensi.dart';
import 'package:project_1/model/stok.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pengujian Model Stok & Serialisasi', () {
    test('toMap dan fromMap bekerja dengan tepat', () {
      final tgl = DateTime(2026, 11, 15, 10, 0);
      final stok = Stok(
        kodeBarang: 'B-1024',
        namaBarang: 'Sepatu Lari Pria',
        kodeGudang: 'GD-BDG',
        jumlah: 25,
        diperbaruiPada: tgl,
      );

      final map = stok.toMap();
      expect(map['kodeBarang'], 'B-1024');
      expect(map['namaBarang'], 'Sepatu Lari Pria');
      expect(map['kodeGudang'], 'GD-BDG');
      expect(map['jumlah'], 25);
      expect(map['diperbaruiPada'], tgl.toIso8601String());

      final dariMap = Stok.fromMap(1, map);
      expect(dariMap.id, 1);
      expect(dariMap.kodeBarang, 'B-1024');
      expect(dariMap.namaBarang, 'Sepatu Lari Pria');
      expect(dariMap.kodeGudang, 'GD-BDG');
      expect(dariMap.jumlah, 25);
      expect(dariMap.diperbaruiPada, tgl);
    });

    test('salinDengan memperbarui jumlah dan waktu', () {
      final stok = Stok(
        id: 1,
        kodeBarang: 'B-1024',
        namaBarang: 'Sepatu Lari Pria',
        kodeGudang: 'GD-BDG',
        jumlah: 25,
        diperbaruiPada: DateTime(2026, 1, 1),
      );

      final update = stok.salinDengan(jumlah: 30);
      expect(update.id, 1);
      expect(update.jumlah, 30);
      expect(update.namaBarang, 'Sepatu Lari Pria');
      expect(update.diperbaruiPada.isAfter(DateTime(2026, 1, 1)), isTrue);
    });
  });

  group('Pengujian Sembast CRUD & Filter RegExp (Modul 08 Tugas 2)', () {
    late Database db;
    final store = intMapStoreFactory.store('stok');

    setUp(() async {
      db = await newDatabaseFactoryMemory().openDatabase('test_silog.db');
    });

    tearDown(() async {
      await db.close();
    });

    test('CREATE: Menambah data stok baru', () async {
      final s = Stok(
        kodeBarang: 'B-101',
        namaBarang: 'Sepatu Olahraga',
        kodeGudang: 'GD-BDG',
        jumlah: 15,
        diperbaruiPada: DateTime.now(),
      );
      final id = await store.add(db, s.toMap());
      expect(id, isPositive);

      final hasil = await store.record(id).get(db);
      expect(hasil, isNotNull);
      expect(hasil!['namaBarang'], 'Sepatu Olahraga');
    });

    test('READ & SEARCH: Pencarian namaBarang dengan Filter.matchesRegExp',
        () async {
      await store.add(db, {
        'kodeBarang': 'B-1',
        'namaBarang': 'Sepatu Lari Pria',
        'kodeGudang': 'GD-BDG',
        'jumlah': 10,
        'diperbaruiPada': DateTime.now().toIso8601String(),
      });
      await store.add(db, {
        'kodeBarang': 'B-2',
        'namaBarang': 'Kaos Katun Polos',
        'kodeGudang': 'GD-BDG',
        'jumlah': 50,
        'diperbaruiPada': DateTime.now().toIso8601String(),
      });
      await store.add(db, {
        'kodeBarang': 'B-3',
        'namaBarang': 'Jaket Sepatu Outdoor',
        'kodeGudang': 'GD-BDG',
        'jumlah': 20,
        'diperbaruiPada': DateTime.now().toIso8601String(),
      });

      // Uji cari kata 'sepatu' (case-insensitive)
      const kataKunci = 'sepatu';
      final filter = Filter.matchesRegExp(
        'namaBarang',
        RegExp(kataKunci, caseSensitive: false),
      );
      final finder = Finder(filter: filter);
      final records = await store.find(db, finder: finder);

      expect(records.length, 2);
      final daftarNama = records.map((r) => r.value['namaBarang']).toList();
      expect(daftarNama, contains('Sepatu Lari Pria'));
      expect(daftarNama, contains('Jaket Sepatu Outdoor'));
      expect(daftarNama, isNot(contains('Kaos Katun Polos')));
    });

    test('UPDATE: Mengubah jumlah stok', () async {
      final id = await store.add(db, {
        'kodeBarang': 'B-10',
        'namaBarang': 'Topi Rimba',
        'kodeGudang': 'GD-BDG',
        'jumlah': 10,
        'diperbaruiPada': DateTime.now().toIso8601String(),
      });

      // Update jumlah menjadi 25
      await store.record(id).update(db, {'jumlah': 25});
      final updated = await store.record(id).get(db);
      expect(updated!['jumlah'], 25);
    });

    test('DELETE: Menghapus data stok', () async {
      final id = await store.add(db, {
        'kodeBarang': 'B-99',
        'namaBarang': 'Barang Rusak',
        'kodeGudang': 'GD-BDG',
        'jumlah': 1,
        'diperbaruiPada': DateTime.now().toIso8601String(),
      });

      await store.record(id).delete(db);
      final cek = await store.record(id).get(db);
      expect(cek, isNull);
    });
  });

  group('Pengujian SharedPreferences (Preferensi)', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Menyimpan dan mengambil preferensi gudang dan petugas', () async {
      final pref = Preferensi();
      expect(await pref.ambilGudangTerakhir(), 'GD-BDG'); // Nilai default

      await pref.simpanGudangTerakhir('GD-SBY');
      expect(await pref.ambilGudangTerakhir(), 'GD-SBY');

      await pref.simpanPetugas('Wahyu Andika');
      expect(await pref.ambilPetugas(), 'Wahyu Andika');

      await pref.setModeGelap(true);
      expect(await pref.modeGelap(), isTrue);

      await pref.bersihkan();
      expect(await pref.ambilPetugas(), isNull);
      expect(await pref.modeGelap(), isFalse);
    });
  });
}
