import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const PerformanceLabApp());
}

class PerformanceLabApp extends StatelessWidget {
  const PerformanceLabApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Performance Flutter',
      debugShowCheckedModeBanner: false,
      // Ubah menjadi true untuk menampilkan grafik performa langsung di layar.
      // Gunakan hanya saat mode profile, lalu kembalikan ke false.
      showPerformanceOverlay: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}
