import 'package:flutter/material.dart';
import '../data/data_contoh.dart';
import '../model/pengiriman.dart';
import '../widget/kartu_pengiriman.dart';
import '../widget/widget_ringkasan.dart';
import 'detail_pengiriman_page.dart';

class DaftarPengirimanPage extends StatelessWidget {
  const DaftarPengirimanPage({super.key});

  Widget _buildDaftar(BuildContext context, List<Pengiriman> daftar) {
    if (daftar.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Tidak ada data pengiriman',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: daftar.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return WidgetRingkasan(daftar: daftar);
        }
        final item = daftar[index - 1];
        return KartuPengiriman(
          pengiriman: item,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPengirimanPage(pengiriman: item),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listDalamPerjalanan =
        dataPengiriman.where((p) => p.status == 'Dalam Perjalanan').toList();
    final listDiterima =
        dataPengiriman.where((p) => p.status == 'Diterima').toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Pengiriman'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
              tooltip: 'Cari resi',
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Dalam Perjalanan'),
              Tab(text: 'Diterima'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDaftar(context, dataPengiriman),
            _buildDaftar(context, listDalamPerjalanan),
            _buildDaftar(context, listDiterima),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Pengiriman Baru'),
        ),
      ),
    );
  }
}
