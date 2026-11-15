import 'package:flutter/material.dart';
import '../model/pengiriman.dart';

class WidgetRingkasan extends StatelessWidget {
  final List<Pengiriman> daftar;

  const WidgetRingkasan({super.key, required this.daftar});

  int get totalPengiriman => daftar.length;

  double get totalNilai =>
      daftar.fold(0.0, (acc, item) => acc + item.nilaiBarang);

  String _formatRupiah(double nilai) {
    final str = nilai.toStringAsFixed(0);
    final buffer = StringBuffer();
    int hitung = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      hitung++;
      if (hitung % 3 == 0 && i > 0) {
        buffer.write('.');
      }
    }
    return 'Rp${buffer.toString().split('').reversed.join('')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final warnaUtama = theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_outlined, size: 20, color: warnaUtama),
                const SizedBox(width: 8),
                Text(
                  'Ringkasan Pengiriman',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: warnaUtama,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: warnaUtama.withValues(alpha: 0.12),
                        child: Icon(
                          Icons.local_shipping_outlined,
                          color: warnaUtama,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Kiriman',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$totalPengiriman Paket',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 36,
                  width: 1,
                  color: theme.colorScheme.outlineVariant,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.teal.withValues(alpha: 0.12),
                        child: const Icon(
                          Icons.payments_outlined,
                          color: Colors.teal,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Nilai',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 2),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _formatRupiah(totalNilai),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
