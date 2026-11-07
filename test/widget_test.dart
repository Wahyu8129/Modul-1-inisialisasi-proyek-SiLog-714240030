import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_1/main.dart';

void main() {
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

  testWidgets('Pengujian Validasi Form Pengiriman Baru (Modul 07 & Tugas Mandiri)',
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

    // 3. Uji Duplikasi Resi (Tugas 2: Nomor resi sudah ada di daftar: SLG-2026-0001)
    await tester.enterText(resiField, 'SLG-2026-0001');
    await tester.pumpAndSettle();
    expect(
      find.text('Nomor resi sudah terdaftar, gunakan nomor lain'),
      findsOneWidget,
    );

    // 4. Uji Validasi Berat Barang (Tugas 1: minimal 0.1 kg, maksimal 5000 kg)
    final beratField = find.widgetWithText(TextFormField, 'Berat Barang (kg)');
    await tester.enterText(beratField, '0.05');
    await tester.pumpAndSettle();
    expect(find.text('Berat barang minimal 0.1 kg'), findsOneWidget);

    await tester.enterText(beratField, '6000');
    await tester.pumpAndSettle();
    expect(find.text('Berat barang maksimal 5000 kg'), findsOneWidget);

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
    expect(find.text('Pengiriman SLG-2026-0099 berhasil ditambahkan'),
        findsOneWidget);
  });

  testWidgets(
      'Pengujian Detail Pengiriman & Fitur Hapus Data dengan Konfirmasi (Tugas 3)',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SiLogApp());
    await tester.pumpAndSettle();

    // Klik item pertama 'SLG-2026-0001'
    await tester.tap(find.text('SLG-2026-0001'));
    await tester.pumpAndSettle();

    // Verifikasi masuk ke halaman detail
    expect(find.text('Informasi Pengiriman'), findsOneWidget);
    expect(find.text('Rincian Barang'), findsOneWidget);
    expect(find.text('Sepatu Lari Pria'), findsOneWidget);
    expect(find.text('1.2 kg'), findsOneWidget);

    // Verifikasi ikon delete di AppBar
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);

    // Uji 1: Buka konfirmasi hapus via icon AppBar, lalu Batal
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    // Verifikasi AlertDialog muncul
    expect(find.text('Konfirmasi Hapus'), findsOneWidget);
    expect(
      find.text(
          'Apakah Anda yakin ingin menghapus data pengiriman SLG-2026-0001?'),
      findsOneWidget,
    );

    // Klik Batal
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi Hapus'), findsNothing);
    expect(find.text('Informasi Pengiriman'), findsOneWidget);

    // Uji 2: Scroll ke tombol Hapus Pengiriman di bagian bawah, lalu konfirmasi Hapus
    final tombolHapusBawah =
        find.widgetWithText(OutlinedButton, 'Hapus Pengiriman');
    await tester.ensureVisible(tombolHapusBawah);
    await tester.pumpAndSettle();

    await tester.tap(tombolHapusBawah);
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi Hapus'), findsOneWidget);

    // Klik Hapus
    await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
    await tester.pumpAndSettle();

    // Verifikasi kembali ke halaman daftar dan data SLG-2026-0001 sudah terhapus
    expect(find.text('Daftar Pengiriman'), findsOneWidget);
    expect(find.text('Menampilkan 2 dari 2 data'), findsOneWidget);
    expect(find.text('SLG-2026-0001'), findsNothing);
    expect(
        find.text('Pengiriman SLG-2026-0001 berhasil dihapus'), findsOneWidget);
  });
}
