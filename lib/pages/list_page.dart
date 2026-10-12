import 'package:flutter/material.dart';

class ListExperimentPage extends StatefulWidget {
  const ListExperimentPage({super.key});
  @override
  State<ListExperimentPage> createState() => _ListExperimentPageState();
}

class _ListExperimentPageState extends State<ListExperimentPage> {
  // Jumlah item yang akan ditampilkan.
  static const int itemCount = 5000;
  // false = versi tidak optimal, true = versi optimal.
  bool _optimized = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Percobaan 1: Daftar Panjang')),
      body: Column(
        children: [
          SwitchListTile(
            title: Text(
              _optimized
                  ? 'Mode: ListView.builder (OPTIMAL)'
                  : 'Mode: Column (TIDAK OPTIMAL)',
            ),
            subtitle: const Text('Geser saklar, lalu scroll daftar di bawah'),
            value: _optimized,
            onChanged: (value) => setState(() => _optimized = value),
          ),
          const Divider(height: 1),
          Expanded(
            child: _optimized ? _buildOptimized() : _buildNotOptimized(),
          ),
        ],
      ),
    );
  }

  /// VERSI TIDAK OPTIMAL
  /// Seluruh 5000 item dibuat sekaligus, walaupun layar hanya
  /// mampu menampilkan sekitar 10 item.
  Widget _buildNotOptimized() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(itemCount, (index) => _ItemTile(index: index)),
      ),
    );
  }

  /// VERSI OPTIMAL
  /// Item hanya dibuat ketika akan tampil di layar (lazy).
  Widget _buildOptimized() {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => _ItemTile(index: index),
    );
  }
}

/// Satu baris item pada daftar.
class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('${index + 1}')),
      title: Text('Item ke-${index + 1}'),
      subtitle: const Text('Contoh data untuk percobaan performa'),
    );
  }
}
