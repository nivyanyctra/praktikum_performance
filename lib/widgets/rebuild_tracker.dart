import 'package:flutter/material.dart';

/// Widget alat bantu untuk menghitung dan menampilkan
/// berapa kali build() dijalankan pada widget ini.
class RebuildTracker extends StatefulWidget {
  const RebuildTracker({super.key, required this.label});
  final String label;
  @override
  State<RebuildTracker> createState() => _RebuildTrackerState();
}

class _RebuildTrackerState extends State<RebuildTracker> {
  // Disimpan di State agar nilainya bertahan selama widget hidup.
  int _buildCount = 0;
  @override
  Widget build(BuildContext context) {
    // Setiap kali build() dijalankan, hitungan bertambah satu.
    _buildCount++;
    return ListTile(
      dense: true,
      leading: const Icon(Icons.sync),
      title: Text(widget.label),
      trailing: Text(
        'build: $_buildCount x',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
