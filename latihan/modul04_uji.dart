// ignore_for_file: avoid_print, avoid_relative_lib_imports
import '../lib/model/barang.dart';
import '../lib/model/gudang.dart';
import '../lib/model/pengiriman.dart';
import '../lib/model/pelanggan.dart';

void main() {
  print('=== PENGUJIAN MODUL 4: PEMROGRAMAN BERORIENTASI OBJEK DASAR ===\n');

  final sepatu = Barang(
    kode: 'B-1024',
    nama: 'Sepatu Lari Pria',
    hargaSatuan: 450000,
    beratKg: 0.9,
  );

  final kaos = Barang.dariPemindaian('B-2048;Kaos Katun;85000');

  final gudangBandung = Gudang(
    kode: 'GD-BDG',
    nama: 'Gudang Utama Bandung',
    kota: 'Bandung',
    kapasitas: 500,
  );

  gudangBandung.terimaBarang(sepatu, 120);
  gudangBandung.terimaBarang(kaos, 300);
  print(gudangBandung);
  print('Rincian stok: ${gudangBandung.stok}');

  final kirim = Pengiriman.baru(
    resi: 'SLG-2026-0007',
    asal: gudangBandung,
    kotaTujuan: 'Surabaya',
    barang: sepatu,
    jumlah: 10,
  );

  gudangBandung.keluarkanBarang(sepatu, kirim.jumlah);
  print(kirim);
  print('Nilai barang: Rp${kirim.nilaiBarang.toStringAsFixed(0)}');

  kirim.ubahStatus('Dalam Perjalanan');
  print('Status terbaru: ${kirim.status}');

  try {
    kirim.ubahStatus('Draft');
  } on StateError catch (e) {
    print('Ditolak: ${e.message}');
  }

  try {
    gudangBandung.keluarkanBarang(sepatu, 9999);
  } on StateError catch (e) {
    print('Ditolak: ${e.message}');
  }

  print('\n=== PENGUJIAN TUGAS PRAKTIKUM (KELAS PELANGGAN & PENGIRIMAN) ===');
  // Pengujian Tugas Praktikum: Kelas Pelanggan
  final pelanggan1 = Pelanggan(
    kode: 'PLG-001',
    nama: 'Wahyu Andika T',
    nomorTelepon: '081234567890',
    alamat: 'Jl. Sariasih No. 54, Sarijadi, Kec. Sukasari, Kota Bandung, Jawa Barat',
  );

  print('Pelanggan: $pelanggan1');
  print('Alamat Lengkap: ${pelanggan1.alamat}');
  print('Alamat Ringkas (<= 40 karakter): ${pelanggan1.alamatRingkas()}');
  print('Panjang Alamat Ringkas: ${pelanggan1.alamatRingkas().length}');

  // Pengujian Pengiriman dengan Pelanggan
  final kirimPelanggan = Pengiriman.baru(
    resi: 'SLG-2026-0008',
    asal: gudangBandung,
    kotaTujuan: 'Bandung',
    barang: kaos,
    jumlah: 5,
    pelanggan: pelanggan1,
  );

  gudangBandung.keluarkanBarang(kaos, kirimPelanggan.jumlah);
  print('\nPengiriman ke Pelanggan:');
  print(kirimPelanggan);
  print('Nilai barang kiriman: Rp${kirimPelanggan.nilaiBarang.toStringAsFixed(0)}');
  kirimPelanggan.ubahStatus('Dalam Perjalanan');
  kirimPelanggan.ubahStatus('Tiba di Kota Tujuan');
  kirimPelanggan.ubahStatus('Diterima');
  print('Status akhir pengiriman: ${kirimPelanggan.status}');
  print('Stok akhir gudang: ${gudangBandung.stok}');
}
