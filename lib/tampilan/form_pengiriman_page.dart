import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/data_contoh.dart';
import '../model/barang.dart';
import '../model/pengiriman.dart';

class FormPengirimanPage extends StatefulWidget {
  final List<String> resiTerdaftar;

  const FormPengirimanPage({
    super.key,
    this.resiTerdaftar = const [],
  });

  @override
  State<FormPengirimanPage> createState() => _FormPengirimanPageState();
}

class _FormPengirimanPageState extends State<FormPengirimanPage> {
  final _formKey = GlobalKey<FormState>();
  final _resiC = TextEditingController();
  final _namaBarangC = TextEditingController();
  final _beratC = TextEditingController();
  final _hargaC = TextEditingController();
  final _jumlahC = TextEditingController();

  String _kotaTujuan = 'Surabaya';
  DateTime _tanggalKirim = DateTime.now();

  @override
  void dispose() {
    _resiC.dispose();
    _namaBarangC.dispose();
    _beratC.dispose();
    _hargaC.dispose();
    _jumlahC.dispose();
    super.dispose();
  }

  String? _wajib(String? v, String label) {
    if (v == null || v.trim().isEmpty) return '$label wajib diisi';
    return null;
  }

  String? _validasiResi(String? v) {
    final dasar = _wajib(v, 'Nomor resi');
    if (dasar != null) return dasar;
    final resiBersih = v!.trim().toUpperCase();
    final pola = RegExp(r'^SLG-\d{4}-\d{4}$');
    if (!pola.hasMatch(resiBersih)) {
      return 'Format resi harus SLG-TAHUN-NOMOR, contoh SLG-2026-0010';
    }
    // Tugas 2: Cek duplikasi nomor resi terhadap data yang sudah terdaftar
    if (widget.resiTerdaftar.map((r) => r.toUpperCase()).contains(resiBersih)) {
      return 'Nomor resi sudah terdaftar, gunakan nomor lain';
    }
    return null;
  }

  String? _validasiAngka(String? v, String label, {double min = 1}) {
    final dasar = _wajib(v, label);
    if (dasar != null) return dasar;
    final angka = double.tryParse(v!.trim());
    if (angka == null) return '$label harus berupa angka';
    if (angka < min) return '$label minimal ${min.toInt()}';
    return null;
  }

  // Tugas 1: Validasi berat barang antara 0.1 kg hingga 5000 kg
  String? _validasiBerat(String? v) {
    final dasar = _wajib(v, 'Berat barang');
    if (dasar != null) return dasar;
    final berat = double.tryParse(v!.trim().replaceAll(',', '.'));
    if (berat == null) return 'Berat barang harus berupa angka valid';
    if (berat < 0.1) return 'Berat barang minimal 0.1 kg';
    if (berat > 5000) return 'Berat barang maksimal 5000 kg';
    return null;
  }

  String? _validasiTanggal() {
    final hariIni = DateTime.now();
    final batasAwal = DateTime(hariIni.year, hariIni.month, hariIni.day);
    final tanggalSaja =
        DateTime(_tanggalKirim.year, _tanggalKirim.month, _tanggalKirim.day);
    if (tanggalSaja.isBefore(batasAwal)) {
      return 'Tanggal kirim tidak boleh sebelum hari ini';
    }
    return null;
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggalKirim,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (hasil != null) setState(() => _tanggalKirim = hasil);
  }

  void _simpan() {
    final pesanTanggal = _validasiTanggal();
    if (!_formKey.currentState!.validate() || pesanTanggal != null) {
      if (pesanTanggal != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pesanTanggal)),
        );
      }
      return;
    }

    final pengiriman = Pengiriman(
      resi: _resiC.text.trim().toUpperCase(),
      asal: gudangBandung,
      kotaTujuan: _kotaTujuan,
      barang: Barang(
        kode: 'B-${DateTime.now().millisecondsSinceEpoch % 10000}',
        nama: _namaBarangC.text.trim(),
        hargaSatuan: double.parse(_hargaC.text.trim()),
        beratKg: double.parse(_beratC.text.trim().replaceAll(',', '.')),
      ),
      jumlah: int.parse(_jumlahC.text.trim()),
      tanggalKirim: _tanggalKirim,
      status: 'Menunggu Pickup',
    );

    Navigator.pop(context, pengiriman);
  }

  @override
  Widget build(BuildContext context) {
    const kota = ['Surabaya', 'Makassar', 'Medan', 'Denpasar', 'Jayapura'];

    return Scaffold(
      appBar: AppBar(title: const Text('Pengiriman Baru')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _resiC,
              decoration: const InputDecoration(
                labelText: 'Nomor Resi',
                hintText: 'SLG-2026-0010',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.confirmation_number_outlined),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: _validasiResi,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _namaBarangC,
              decoration: const InputDecoration(
                labelText: 'Nama Barang',
                hintText: 'Contoh: Sepatu Olahraga',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
              validator: (v) => _wajib(v, 'Nama barang'),
            ),
            const SizedBox(height: 12),
            // Tugas 1: Field Berat Barang (kg)
            TextFormField(
              controller: _beratC,
              decoration: const InputDecoration(
                labelText: 'Berat Barang (kg)',
                hintText: '0.1 - 5000 kg',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.scale_outlined),
                suffixText: 'kg',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*[\.,]?\d*')),
              ],
              validator: _validasiBerat,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _hargaC,
              decoration: const InputDecoration(
                labelText: 'Harga Satuan (Rp)',
                hintText: 'Minimal Rp 1.000',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payments_outlined),
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => _validasiAngka(v, 'Harga satuan', min: 1000),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _jumlahC,
              decoration: const InputDecoration(
                labelText: 'Jumlah',
                hintText: 'Minimal 1',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.format_list_numbered_outlined),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => _validasiAngka(v, 'Jumlah'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _kotaTujuan,
              decoration: const InputDecoration(
                labelText: 'Kota Tujuan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
              items: kota
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kotaTujuan = v!),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pilihTanggal,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                'Tanggal Kirim: ${_tanggalKirim.day}/${_tanggalKirim.month}/${_tanggalKirim.year}',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Pengiriman'),
            ),
          ],
        ),
      ),
    );
  }
}
