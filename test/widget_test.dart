import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_1/main.dart';

void main() {
  testWidgets('Pengujian tampilan utama Modul 06', (WidgetTester tester) async {
    // Bangun aplikasi dan jalankan frame.
    await tester.pumpWidget(const SiLogApp());

    // Verifikasi bahwa AppBar dengan judul 'Daftar Pengiriman' muncul
    expect(find.text('Daftar Pengiriman'), findsOneWidget);

    // Verifikasi TabBar dengan 3 tab
    expect(find.widgetWithText(Tab, 'Semua'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Dalam Perjalanan'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Diterima'), findsOneWidget);

    // Verifikasi Card Ringkasan muncul
    expect(find.text('Ringkasan Pengiriman'), findsOneWidget);

    // Verifikasi salah satu data pengiriman muncul
    expect(find.text('SLG-2026-0001'), findsOneWidget);
  });
}
