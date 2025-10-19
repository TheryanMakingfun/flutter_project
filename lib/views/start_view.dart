import 'package:flutter/material.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna yang digunakan di gambar pertama
    const Color buttonColor = Color.fromARGB(255, 14, 141, 156); // Hijau Kebiruan
    const Color backgroundColor = Color.fromARGB(255, 201, 230, 246); // Biru muda yang lebih terang

    return Scaffold(
      backgroundColor: backgroundColor, 
      body: SafeArea(
        child: Column(
          children: [
            // Konten utama (Logo) dipusatkan secara vertikal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bagian Logo
                    Image.asset(
                      'assets/img/logo_sabda.png', // logo sabda
                      width: 180, 
                    ),
                  ],
                ),
              ),
            ),
            
            // Bagian bawah (dua tombol)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // ✅ Arahkan ke onboarding
                        Navigator.pushNamed(context, '/onboarding');
                      },
                      style: ElevatedButton.styleFrom(
                        // Warna tombol MULAI
                        backgroundColor: buttonColor, 
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0, 
                      ),
                      child: const Text(
                        'MULAI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: OutlinedButton.styleFrom(
                        // Warna border OutlinedButton
                        side: const BorderSide(color: buttonColor), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'SUDAH PUNYA AKUN',
                        style: TextStyle(
                          // Warna teks OutlinedButton
                          color: buttonColor, 
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}