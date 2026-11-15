import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/preferensi.dart';
import '../data/stok_repository.dart';
import '../main.dart';
import '../model/stok.dart';

class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  final _repo = StokRepository.instance;
  final _pref = Preferensi();
  final _cariC = TextEditingController();

  List<Stok> _daftar = [];
  String _gudang = 'GD-BDG';
  bool _memuat = true;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  @override
  void dispose() {
    _cariC.dispose();
    super.dispose();
  }

  Future<void> _muat() async {
    setState(() => _memuat = true);
    _gudang = await _pref.ambilGudangTerakhir();
    final kataKunci = _cariC.text.trim();
    final data = await _repo.ambilSemua(
      kodeGudang: _gudang,
      kataKunci: kataKunci.isEmpty ? null : kataKunci,
    );
    if (!mounted) return;
    setState(() {
      _daftar = data;
      _memuat = false;
    });
  }

  Future<void> _gantiGudang(String kodeBaru) async {
    await _pref.simpanGudangTerakhir(kodeBaru);
    _muat();
  }

  // Tugas Praktikum 1: Formulir Penambahan Stok dengan Validasi GlobalKey<FormState>
  Future<void> _tampilkanFormTambah() async {
    final formKey = GlobalKey<FormState>();
    final kodeC = TextEditingController(
      text: 'B-${DateTime.now().millisecondsSinceEpoch % 10000}',
    );
    final namaC = TextEditingController();
    final jumlahC = TextEditingController(text: '10');

    await showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Tambah Stok Barang'),
        content: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: kodeC,
                  decoration: const InputDecoration(
                    labelText: 'Kode Barang *',
                    hintText: 'Contoh: B-1024',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.qr_code_2),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Kode barang wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: namaC,
                  decoration: const InputDecoration(
                    labelText: 'Nama Barang *',
                    hintText: 'Contoh: Sepatu Lari Pria',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Nama barang wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: jumlahC,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah Stok *',
                    hintText: 'Minimal 0',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Jumlah stok wajib diisi';
                    }
                    final n = int.tryParse(v.trim());
                    if (n == null) return 'Harus berupa angka bulat';
                    if (n < 0) return 'Jumlah tidak boleh negatif';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Batal'),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Simpan'),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final baru = Stok(
                  kodeBarang: kodeC.text.trim().toUpperCase(),
                  namaBarang: namaC.text.trim(),
                  kodeGudang: _gudang,
                  jumlah: int.parse(jumlahC.text.trim()),
                  diperbaruiPada: DateTime.now(),
                );
                await _repo.simpan(baru);
                if (!dialogCtx.mounted) return;
                Navigator.pop(dialogCtx);
                await _muat();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Stok ${baru.namaBarang} (${baru.kodeBarang}) berhasil disimpan',
                    ),
                    backgroundColor: Colors.green.shade700,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Bantuan untuk pengujian Langkah F.2 (isi data contoh sekaligus 5 data)
  Future<void> _tambahDataContohBatch() async {
    final contohBarang = [
      {'kode': 'B-101', 'nama': 'Sepatu Olahraga', 'jumlah': 25},
      {'kode': 'B-102', 'nama': 'Kaos Katun Premium', 'jumlah': 50},
      {'kode': 'B-103', 'nama': 'Tas Ransel Laptop', 'jumlah': 30},
      {'kode': 'B-104', 'nama': 'Jaket Parasut Windbreaker', 'jumlah': 15},
      {'kode': 'B-105', 'nama': 'Topi Baseball SiLog', 'jumlah': 40},
    ];

    for (final c in contohBarang) {
      await _repo.simpan(Stok(
        kodeBarang: c['kode'] as String,
        namaBarang: c['nama'] as String,
        kodeGudang: _gudang,
        jumlah: c['jumlah'] as int,
        diperbaruiPada: DateTime.now(),
      ));
    }

    await _muat();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('5 data stok contoh berhasil ditambahkan')),
    );
  }

  Future<void> _ubahJumlah(Stok stok, int delta) async {
    final baru = stok.jumlah + delta;
    if (baru < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah stok tidak boleh negatif')),
      );
      return;
    }
    await _repo.perbarui(stok.salinDengan(jumlah: baru));
    await _muat();
  }

  Future<void> _hapus(Stok stok) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus data stok'),
        content: Text('Hapus ${stok.namaBarang} dari gudang $_gudang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ya == true && stok.id != null) {
      await _repo.hapus(stok.id!);
      await _muat();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stok ${stok.namaBarang} berhasil dihapus'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _daftar.fold<int>(0, (a, s) => a + s.jumlah);
    const daftarGudang = ['GD-BDG', 'GD-JKT', 'GD-SBY'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Stok Gudang $_gudang'),
        actions: [
          // Dropdown pemilih gudang
          PopupMenuButton<String>(
            tooltip: 'Pilih Gudang',
            icon: const Icon(Icons.warehouse_outlined),
            onSelected: _gantiGudang,
            itemBuilder: (_) => daftarGudang.map((g) {
              return PopupMenuItem(
                value: g,
                child: Row(
                  children: [
                    Icon(
                      g == _gudang ? Icons.check_circle : Icons.circle_outlined,
                      size: 18,
                      color: g == _gudang ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(g),
                  ],
                ),
              );
            }).toList(),
          ),
          // Tombol tambah data contoh batch untuk pengujian cepat
          IconButton(
            icon: const Icon(Icons.playlist_add),
            tooltip: 'Tambah 5 Data Contoh',
            onPressed: _tambahDataContohBatch,
          ),
          // Tombol Mode Gelap (Tugas Praktikum 3)
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode_outlined,
            ),
            tooltip: 'Ubah Mode Tema',
            onPressed: () => SiLogApp.of(context)?.toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tugas Praktikum 2: Kolom Pencarian Nama Barang
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _cariC,
              decoration: InputDecoration(
                hintText: 'Cari nama barang...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _cariC.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _cariC.clear();
                          _muat();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (_) => _muat(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total stok: $total unit',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${_daftar.length} jenis barang',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _memuat
                ? const Center(child: CircularProgressIndicator())
                : _daftar.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _cariC.text.isNotEmpty
                                  ? 'Tidak ada barang dengan kata kunci "${_cariC.text}"'
                                  : 'Belum ada data stok di gudang $_gudang',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _daftar.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final s = _daftar[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.15),
                              child: Text(
                                s.namaBarang.isNotEmpty
                                    ? s.namaBarang[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              s.namaBarang,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '${s.kodeBarang} • ${s.jumlah} unit',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.orange,
                                  ),
                                  tooltip: 'Kurangi 1',
                                  onPressed: () => _ubahJumlah(s, -1),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green,
                                  ),
                                  tooltip: 'Tambah 1',
                                  onPressed: () => _ubahJumlah(s, 1),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Hapus',
                                  onPressed: () => _hapus(s),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tampilkanFormTambah,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Stok'),
      ),
    );
  }
}
