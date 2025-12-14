import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_5a/core/helpers/auth_wrapper.dart'; // 🔥 ganti StartView → AuthWrapper

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Timer 2 detik → masuk ke AuthWrapper (biometrik)
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 230, 246), // warna kamu tetap
      body: Center(
        child: Image.asset(
          'assets/img/logo_sabda.png', // logo kamu tetap
          width: 180,
        ),
      ),
    );
  }
}