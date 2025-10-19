import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  // Controller untuk PageView
  final PageController pageController = PageController();

  // Index halaman saat ini
  int currentPage = 0;

  // Data halaman onboarding
  final List<Map<String, String>> pages = [
    {
      'title': 'Selamat Datang di SABDA',
      'description': 'Aplikasi yang membantu kamu belajar dan bertumbuh secara rohani setiap hari.',
      'image': 'assets/img/logo_sabda.png',
    },
    {
      'title': 'Belajar Cara Sehat Berbahasa',
      'description': 'SABDA memberi contoh kalimat yang lebih empatik biar obrolan tetap hangat.',
      'image': 'assets/img/logo_sabda.png',
    },
    {
      'title': 'Laporkan dengan Aman',
      'description': 'Kirim laporan aman dengan SABDA agar guru BK/orang tua bisa membantu lebih cepat.',
      'image': 'assets/img/logo_sabda.png',
    },
    {
      'title': 'Pengingat dan Tips Ringkas',
      'description': 'Kami akan mengirimkan tips singkat dan pengingat saat dibutuhkan.',
      'image': 'assets/img/logo_sabda.png',
    },
    {
      'title': 'Misi Kita',
      'description': 'SABDA membantumu mengenali kata-kata yang menyakitkan dan memilih respon yang lebih baik.',
      'image': 'assets/img/logo_sabda.png',
    },
    {
      'title': 'Ruang Aman',
      'description': 'Chatbot SABDA siap mendengarkan dan memberi dukungan tanpa menghakimi.',
      'image': 'assets/img/logo_sabda.png',
    },
    {
      'title': 'Privasi dan Kendali',
      'description': 'Kamu bisa melihat Ketentuan dan Kebijakan, mengatur data, dan keluar kapan saja.',
      'image': 'assets/img/logo_sabda.png',
    },
    {
      'title': 'Komitmen Harmoni',
      'description': 'Aku berjanji memilih kata yang menghargai teman.',
      'image': 'assets/img/logo_sabda.png',
    },
    {
      'title': 'Siap Mulai?',
      'description': 'Yuk jelajahi SABDA dan ciptakan lingkungan belajar yang lebih hangat.',
      'image': 'assets/img/logo_sabda.png',
    },
  ];

  // Setter ketika halaman berubah
  void setPage(int index) {
    currentPage = index;
    notifyListeners();
  }

  // Apakah ini halaman terakhir?
  bool get isLastPage => currentPage == pages.length - 1;

  // Pindah ke halaman berikutnya
  void nextPage() {
    if (currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Pindah ke halaman sebelumnya
  void prevPage() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Skip langsung ke login
  void skip(BuildContext context) {
    saveOnboardingStatus();
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Simpan status bahwa user sudah pernah melihat onboarding
  Future<void> saveOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }

  // Cek apakah user sudah pernah lihat onboarding
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }
}
