import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_1/data/preferensi.dart';
import 'package:project_1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'gudang_terakhir': 'GD-BDG',
      'mode_gelap': false,
    });
  });

  testWidgets('Pengujian tampilan utama Modul 07 dan Filter ChoiceChip',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SiLogApp());
    await tester.pumpAndSettle();

    // Verifikasi AppBar
    expect(find.text('Daftar Pengiriman'), findsOneWidget);

    // Verifikasi ChoiceChip
    expect(find.widgetWithText(ChoiceChip, 'Semua'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Menunggu Pickup'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Dalam Perjalanan'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'Diterima'), findsOneWidget);

    // Verifikasi data awal (3 item)
    expect(find.text('Menampilkan 3 dari 3 data'), findsOneWidget);
    expect(find.text('SLG-2026-0001'), findsOneWidget);
    expect(find.text('SLG-2026-0002'), findsOneWidget);
    expect(find.text('SLG-2026-0003'), findsOneWidget);

    // Filter status 'Dalam Perjalanan'
    await tester.tap(find.widgetWithText(ChoiceChip, 'Dalam Perjalanan'));
    await tester.pumpAndSettle();
    expect(find.text('Menampilkan 1 dari 3 data'), findsOneWidget);
    expect(find.text('SLG-2026-0001'), findsOneWidget);
    expect(find.text('SLG-2026-0002'), findsNothing);

    // Kembalikan ke 'Semua'
    await tester.tap(find.widgetWithText(ChoiceChip, 'Semua'));
    await tester.pumpAndSettle();
    expect(find.text('Menampilkan 3 dari 3 data'), findsOneWidget);
  });

  testWidgets('Pengujian Validasi Form Pengiriman Baru (Modul 07)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SiLogApp());
    await tester.pumpAndSettle();

    // Buka formulir pengiriman baru
    await tester.tap(find.text('Pengiriman Baru'));
    await tester.pumpAndSettle();

    expect(find.text('Pengiriman Baru'), findsOneWidget);

    // 1. Uji Validasi Form Kosong: Langsung tekan tombol Simpan
    await tester.tap(find.text('Simpan Pengiriman'));
    await tester.pumpAndSettle();

    expect(find.text('Nomor resi wajib diisi'), findsOneWidget);
    expect(find.text('Nama barang wajib diisi'), findsOneWidget);
    expect(find.text('Berat barang wajib diisi'), findsOneWidget);
    expect(find.text('Harga satuan wajib diisi'), findsOneWidget);
    expect(find.text('Jumlah wajib diisi'), findsOneWidget);

    // 2. Uji Format Resi Salah (misal: ABC-1)
    final resiField = find.widgetWithText(TextFormField, 'Nomor Resi');
    await tester.enterText(resiField, 'ABC-1');
    await tester.pumpAndSettle();
    expect(
      find.text('Format resi harus SLG-TAHUN-NOMOR, contoh SLG-2026-0010'),
      findsOneWidget,
    );

    // 3. Uji Duplikasi Resi (Nomor resi sudah ada di daftar: SLG-2026-0001)
    await tester.enterText(resiField, 'SLG-2026-0001');
    await tester.pumpAndSettle();
    expect(
      find.text('Nomor resi sudah terdaftar, gunakan nomor lain'),
      findsOneWidget,
    );

    // 4. Uji Validasi Berat Barang (minimal 0.1 kg, maksimal 5000 kg)
    final beratField = find.widgetWithText(TextFormField, 'Berat Barang (kg)');
    await tester.enterText(beratField, '0.05');
    await tester.pumpAndSettle();
    expect(find.text('Berat barang minimal 0.1 kg'), findsOneWidget);

    // 5. Uji Validasi Harga Satuan minimal Rp 1.000
    final hargaField = find.widgetWithText(TextFormField, 'Harga Satuan (Rp)');
    await tester.enterText(hargaField, '500');
    await tester.pumpAndSettle();
    expect(find.text('Harga satuan minimal 1000'), findsOneWidget);

    // 6. Isi dengan Data Sah dan Simpan
    await tester.enterText(resiField, 'SLG-2026-0099');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Barang'), 'Laptop Ultrabook');
    await tester.enterText(beratField, '1.5');
    await tester.enterText(hargaField, '15000000');
    await tester.enterText(find.widgetWithText(TextFormField, 'Jumlah'), '2');
    await tester.pumpAndSettle();

    // Tekan simpan
    await tester.tap(find.text('Simpan Pengiriman'));
    await tester.pumpAndSettle();

    // Verifikasi kembali ke Daftar dan data baru muncul di posisi teratas
    expect(find.text('Daftar Pengiriman'), findsOneWidget);
    expect(find.text('Menampilkan 4 dari 4 data'), findsOneWidget);
    expect(find.text('SLG-2026-0099'), findsOneWidget);
    expect(find.text('Laptop Ultrabook x 2'), findsOneWidget);
  });

  testWidgets('Pengujian Mode Gelap dan SharedPreferences (Modul 08 Tugas 3)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SiLogApp());
    await tester.pumpAndSettle();

    // Verifikasi ikon tema tersedia di AppBar
    final iconTema = find.byTooltip('Ubah Mode Tema');
    expect(iconTema, findsOneWidget);

    // Tekan tombol ubah tema
    await tester.tap(iconTema);
    await tester.pumpAndSettle();

    // Cek apakah preferensi mode gelap tersimpan
    final pref = Preferensi();
    expect(await pref.modeGelap(), isTrue);

    // Tekan lagi untuk mengembalikan ke mode terang
    await tester.tap(iconTema);
    await tester.pumpAndSettle();
    expect(await pref.modeGelap(), isFalse);
  });
}
