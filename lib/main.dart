import 'package:flutter/material.dart';

void main() {
  runApp(const SiLogApp());
}

class SiLogApp extends StatelessWidget {
  const SiLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiLog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const BerandaPage(),
    );
  }
}

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SiLog - Modul 1'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_shipping_rounded, size: 80, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text('Sistem Informasi Logistik',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              const SizedBox(height: 8),
              Text('Lingkungan pengembangan siap digunakan',
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              const SizedBox(height: 32),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: Column(children: [
                    Row(mainAxisSize: MainAxisSize.min, children: const [
                      Icon(Icons.person, color: Colors.indigo), SizedBox(width: 8),
                      Text('Wahyu Andika T', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 8),
                    Row(mainAxisSize: MainAxisSize.min, children: const [
                      Icon(Icons.badge, color: Colors.indigo), SizedBox(width: 8),
                      Text('NIM: 714240030', style: TextStyle(fontSize: 16, color: Colors.black87)),
                    ]),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
