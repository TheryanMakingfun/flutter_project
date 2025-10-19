import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../core/providers/onboarding_provider.dart';
import '../core/widgets/onboarding_page.dart';
// Ganti import ini jika Anda tidak menggunakan named routes atau jika path Anda berbeda
// Di sini saya asumsikan Anda ingin menavigasi ke '/login' seperti di provider Anda.
// import 'login.dart'; 

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  // Widget terpisah untuk Tombol 'LANJUTKAN'
  Widget _buildNextButton(BuildContext context, OnboardingProvider provider) {
    // Warna tombol yang mirip dengan gambar kedua (Hijau Kebiruan)
    const Color buttonColor = Color.fromARGB(255, 14, 141, 156); 

    return Container(
      width: double.infinity, // Membuat tombol full width
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white, // Teks putih
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        onPressed: () {
          if (provider.isLastPage) {
            // Logika halaman terakhir (memanggil provider.skip, yang akan menavigasi ke '/login')
            provider.skip(context);
          } else {
            // Logika untuk halaman berikutnya
            provider.nextPage();
          }
        },
        child: Text(
          // Teks diubah menjadi 'LANJUTKAN' atau 'Mulai'
          provider.isLastPage ? "Mulai" : "LANJUTKAN", 
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk mengakses provider dan merebuild widget yang membutuhkan
    return Consumer<OnboardingProvider>(
      builder: (context, provider, child) {
        // Warna latar belakang biru muda lembut
        // Saya menggunakan warna abu-abu muda di gambar pertama untuk latar belakang yang lebih umum,
        // atau Anda bisa menggunakan softBlueBackground jika ingin persis gambar kedua.
        const Color backgroundColor = Color.fromARGB(255, 201, 230, 246); 

        return Scaffold(
          backgroundColor: backgroundColor, 
          body: SafeArea(
            child: Column(
              children: [
                // 🔹 Header/AppBar Kustom (Prev dan Skip)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol PREV (Panah kiri)
                      // Tampilkan hanya jika BUKAN halaman pertama (currentPage > 0)
                      if (provider.currentPage > 0)
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.arrowLeft, size: 25),
                          color: Color.fromARGB(255, 14, 141, 156),
                          onPressed: provider.prevPage, // Memanggil metode prevPage dari provider
                        )
                      else 
                        // Placeholder agar tombol SKIP tetap di kanan
                        const SizedBox(width: 48), 
                      
                      // Tombol SKIP
                      TextButton(
                        onPressed: () => provider.skip(context), // Memanggil metode skip dari provider
                        child: const Text(
                          "SKIP",
                          style: TextStyle(
                            color: Color.fromARGB(255, 14, 141, 156), // Warna teks SKIP 
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 Bagian halaman onboarding (PageView)
                Expanded(
                  child: PageView.builder(
                    controller: provider.pageController,
                    onPageChanged: provider.setPage,
                    itemCount: provider.pages.length,
                    itemBuilder: (context, index) {
                      final page = provider.pages[index];
                      // Pastikan OnboardingPage dapat menerima Map<String, String>
                      return OnboardingPage(
                        title: page['title']!,
                        description: page['description']!,
                        image: page['image']!,
                      );
                    },
                  ),
                ),

                // 🔹 Tombol LANJUTKAN di bagian bawah
                _buildNextButton(context, provider),
              ],
            ),
          ),
        );
      },
    );
  }
}