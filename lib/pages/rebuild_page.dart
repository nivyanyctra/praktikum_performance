import 'package:flutter/material.dart';

import '../widgets/rebuild_tracker.dart';

class RebuildExperimentPage extends StatelessWidget {
  const RebuildExperimentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Percobaan 3: Rebuild Berlebihan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Tekan tombol pada tiap bagian beberapa kali, lalu perhatikan '
            'angka "build" pada setiap widget di dalamnya.',
          ),
          SizedBox(height: 16),
          _NaiveSection(),
          SizedBox(height: 16),
          _OptimizedSection(),
        ],
      ),
    );
  }
}

// =============================================================
// VERSI TIDAK OPTIMAL
// setState dipanggil pada widget yang membungkus SELURUH bagian,
// dan widget anak dibuat TANPA const.
// =============================================================
class _NaiveSection extends StatefulWidget {
  const _NaiveSection();
  @override
  State<_NaiveSection> createState() => _NaiveSectionState();
}

class _NaiveSectionState extends State<_NaiveSection> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'A. TIDAK OPTIMAL (setState luas, tanpa const)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Nilai counter: $_counter',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            // Sengaja TANPA const agar objek baru dibuat pada setiap build().
            // ignore: prefer_const_constructors
            RebuildTracker(label: 'Widget A1'),
            // ignore: prefer_const_constructors
            RebuildTracker(label: 'Widget A2'),
            // ignore: prefer_const_constructors
            RebuildTracker(label: 'Widget A3'),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => setState(() => _counter++),
              child: const Text('Tambah (versi A)'),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// VERSI OPTIMAL
// Hanya angka counter yang dibungkus ValueListenableBuilder.
// Widget lain dibuat dengan const sehingga tidak dibangun ulang.
// =============================================================
class _OptimizedSection extends StatefulWidget {
  const _OptimizedSection();
  @override
  State<_OptimizedSection> createState() => _OptimizedSectionState();
}

class _OptimizedSectionState extends State<_OptimizedSection> {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  @override
  void dispose() {
    // Resource yang dibuat di State wajib dibuang.
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'B. OPTIMAL (ValueListenableBuilder + const)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Hanya bagian ini yang dibangun ulang ketika nilai berubah.
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              builder: (context, value, child) {
                return Text(
                  'Nilai counter: $value',
                  style: Theme.of(context).textTheme.headlineSmall,
                );
              },
            ),
            const RebuildTracker(label: 'Widget B1'),
            const RebuildTracker(label: 'Widget B2'),
            const RebuildTracker(label: 'Widget B3'),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => _counter.value++,
              child: const Text('Tambah (versi B)'),
            ),
          ],
        ),
      ),
    );
  }
}
