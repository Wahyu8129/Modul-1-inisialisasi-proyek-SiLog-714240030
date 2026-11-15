import 'package:flutter/material.dart';
import 'data/preferensi.dart';
import 'tampilan/daftar_pengiriman_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = Preferensi();
  final isDark = await pref.modeGelap();
  runApp(SiLogApp(initialDarkMode: isDark));
}

class SiLogApp extends StatefulWidget {
  final bool initialDarkMode;

  const SiLogApp({super.key, this.initialDarkMode = false});

  static SiLogAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<SiLogAppState>();

  @override
  State<SiLogApp> createState() => SiLogAppState();
}

class SiLogAppState extends State<SiLogApp> {
  late ThemeMode _themeMode;
  final _pref = Preferensi();

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() async {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    await _pref.setModeGelap(_themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF1B5E20);

    return MaterialApp(
      title: 'SiLog',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const DaftarPengirimanPage(),
    );
  }
}
