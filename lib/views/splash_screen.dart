import 'dart:async';
import 'package:flutter/material.dart';
import 'start_view.dart'; // pastikan nanti kamu buat file ini ya

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer 2 detik sebelum pindah ke halaman Start
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 230, 246), // biru muda lembut
      body: Center(
        child: Image.asset(
          'assets/img/logo_sabda.png', // ganti sesuai path logo kamu
          width: 180,
        ),
      ),
    );
  }
}
