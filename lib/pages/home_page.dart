import 'package:flutter/material.dart';

import 'compute_page.dart';
import 'list_page.dart';
import 'rebuild_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab Performance Flutter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _MenuCard(
            title: 'Percobaan 1: Daftar Panjang',
            subtitle: 'Column vs ListView.builder',
            icon: Icons.list_alt,
            destination: ListExperimentPage(),
          ),
          _MenuCard(
            title: 'Percobaan 2: Komputasi Berat',
            subtitle: 'Main isolate vs Isolate.run',
            icon: Icons.memory,
            destination: ComputeExperimentPage(),
          ),
          _MenuCard(
            title: 'Percobaan 3: Rebuild Berlebihan',
            subtitle: 'setState luas vs ValueListenableBuilder + const',
            icon: Icons.sync,
            destination: RebuildExperimentPage(),
          ),
        ],
      ),
    );
  }
}

/// Kartu menu yang membuka halaman percobaan.
class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.destination,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget destination;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => destination));
        },
      ),
    );
  }
}
