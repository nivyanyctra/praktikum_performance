import 'dart:isolate';

import 'package:flutter/material.dart';

/// Fungsi top-level yang menghitung bilangan Fibonacci secara rekursif.
/// Cara ini SENGAJA dipilih karena sangat berat untuk nilai n yang besar.
/// Dibuat top-level agar dapat dijalankan di isolate lain.
int fibonacci(int n) {
  if (n < 2) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

class ComputeExperimentPage extends StatefulWidget {
  const ComputeExperimentPage({super.key});
  @override
  State<ComputeExperimentPage> createState() => _ComputeExperimentPageState();
}

class _ComputeExperimentPageState extends State<ComputeExperimentPage> {
  // Nilai input. Naikkan (misal 40) bila perangkat Anda cepat,
  // turunkan (misal 35) bila terlalu lama.
  static const int n = 38;
  String _status = 'Belum ada proses dijalankan';
  bool _isRunning = false;

  /// VERSI TIDAK OPTIMAL: komputasi dijalankan langsung di main isolate.
  void _runOnMainIsolate() {
    setState(() => _status = 'Menghitung di main isolate...');
    final stopwatch = Stopwatch()..start();
    final result = fibonacci(n); // <- UI membeku selama baris ini berjalan
    stopwatch.stop();
    setState(() {
      _status =
          'Main isolate: fibonacci($n) = $result\n'
          'Waktu: ${stopwatch.elapsedMilliseconds} ms';
    });
  }

  /// VERSI OPTIMAL: komputasi dijalankan di isolate terpisah.
  Future<void> _runOnBackgroundIsolate() async {
    setState(() {
      _isRunning = true;
      _status = 'Menghitung di isolate terpisah...';
    });
    final input = n; // salin ke variabel lokal agar closure hanya membawa angka
    final stopwatch = Stopwatch()..start();
    final result = await Isolate.run(() => fibonacci(input));
    stopwatch.stop();
    // Halaman mungkin sudah ditutup selama proses berjalan.
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _status =
          'Isolate terpisah: fibonacci($n) = $result\n'
          'Waktu: ${stopwatch.elapsedMilliseconds} ms';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Percobaan 2: Komputasi Berat')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Indikator animasi di bawah berputar terus-menerus. '
              'Jika indikator BERHENTI atau TERSENDAT, berarti main isolate '
              'sedang terblokir.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isRunning ? null : _runOnMainIsolate,
              child: const Text('Jalankan di Main Isolate (Tidak Optimal)'),
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: _isRunning ? null : _runOnBackgroundIsolate,
              child: const Text('Jalankan dengan Isolate.run (Optimal)'),
            ),
            const SizedBox(height: 24),
            Text(
              _status,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
