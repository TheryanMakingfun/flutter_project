import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Riwayat Deteksi",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlue[100],
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          "Riwayat Kosong, Tidak ada laporan.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
