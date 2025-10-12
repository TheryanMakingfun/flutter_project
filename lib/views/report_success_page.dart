// lib/pages/report_success_page.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReportSuccessPage extends StatelessWidget {
  const ReportSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 230, 246), // Warna latar belakang sesuai gambar
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie animation untuk ceklist sukses
              Lottie.asset(
                'assets/lottie/success.json', // Ganti dengan path file Lottie Anda
                width: 170,
                height: 170,
                repeat: false, // Animasi hanya berjalan sekali
              ),
              const SizedBox(height: 30),
              const Text(
                "Laporan telah dikirimkan!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Laporan Anda akan diproses sesuai prosedur dan tidak akan dibagikan tanpa persetujuan Anda",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman sebelumnya (misalnya, halaman utama atau dashboard)
                    Navigator.popUntil(context, (route) => route.isFirst);
                    // Atau jika ingin kembali ke halaman report:
                    // Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 14, 141, 156),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Kembali",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}