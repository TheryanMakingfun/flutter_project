import 'package:flutter/material.dart';
import 'package:flutter_5a/models/login_response_model.dart';
import 'package:flutter_5a/views/tips.dart';
import 'package:flutter_5a/views/new_chat.dart';
import 'package:flutter_5a/views/report.dart';
import 'package:flutter_5a/views/history.dart';

class MainMenu extends StatelessWidget {
  final LoginResponseModel user; // ambil data user dari API
  const MainMenu({super.key, required this.user});

  // Warna Teal Kustom
  static const Color darkTeal = Color.fromARGB(255, 30, 150, 160);

  // Data tombol fitur
  static const List<Map<String, dynamic>> features = [
    {
      'title': 'Chatbot Edukatif',
      'icon': Icons.smart_toy_outlined,
      'bgColor': Color.fromARGB(255, 220, 245, 235),
    },
    {
      'title': 'Laporan Cepat',
      'icon': Icons.campaign_outlined,
      'bgColor': Color.fromARGB(255, 255, 240, 230),
    },
    {
      'title': 'Tips Harian',
      'icon': Icons.lightbulb_outline,
      'bgColor': Color.fromARGB(255, 255, 248, 220),
    },
    {
      'title': 'Riwayat Deteksi',
      'icon': Icons.library_books_outlined,
      'bgColor': Color.fromARGB(255, 230, 245, 250),
    },
  ];

  // Data artikel
  static const List<Map<String, String>> articles = [
    {
      'title': 'Bully Verbal',
      'subtitle': 'Lorem ipsum dolor sit amet consectetur adipiscing elit.',
    },
    {
      'title': 'Cara Melaporkan Perundungan',
      'subtitle': 'Lorem ipsum dolor sit amet consectetur adipiscing elit.',
    },
  ];

  static const double featureButtonWidth = 75;
  static const double featureSpacing = 12;

  @override
  Widget build(BuildContext context) {
    final double totalFeatureWidth =
        (featureButtonWidth * features.length) +
        (featureSpacing * (features.length - 1));

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hallo,",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        user.firstName, // ganti dummy username → API
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        /*user.email, // ambil email user dari API untuk email di main menu
                         style: const TextStyle(
                             fontSize: 14,
                             color: Color.fromARGB(255, 99, 99, 99)),*/
                        "Selamat datang di SABDA!",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 99, 99, 99)),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(user.image), // pakai foto user
                  )
                ],
              ),

              const SizedBox(height: 25),

              // --- Info Perundungan ---
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: darkTeal,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    const Icon(Icons.shield_rounded,
                        size: 45, color: Colors.white),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Hari ini: Tidak ada",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "Perundungan Terdeteksi",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- Fitur ---
              const Text(
                "Fitur",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkTeal),
              ),
              const SizedBox(height: 12),
              Center(
                child: SizedBox(
                  width: totalFeatureWidth,
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: features.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: featureSpacing),
                    itemBuilder: (context, index) {
                      final feature = features[index];
                      return FeatureButton(
                        title: feature['title'],
                        icon: feature['icon'],
                        bgColor: feature['bgColor'],
                        iconTextColor: darkTeal,
                        onTap: () {
                          // Navigasi ke NewChat hanya jika tombol Chatbot Edukatif diklik
                          if (feature['title'] == 'Chatbot Edukatif') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewChat(),
                              ),
                            );
                          } else if (feature['title'] == 'Laporan Cepat') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Report(), // Navigasi ke ReportPage
                              ),
                            );
                          } else if (feature['title'] == 'Tips Harian') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Education(), // Navigasi ke Education
                              ),
                            );
                          } 
                           else if (feature['title'] == 'Riwayat Deteksi') { // Navigasi ke History
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const History(), 
                              ),
                            );
                          } else {
                            // Untuk tombol fitur lainnya
                            debugPrint("Fitur '${feature['title']}' diklik");
                          }
                        },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- Articles ---
              const Text(
                "Articles",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkTeal),
              ),
              const SizedBox(height: 12),
              ...articles.map((article) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ArticleCard(
                      title: article['title']!,
                      subtitle: article['subtitle']!,
                      onTap: () {
                        debugPrint("Artikel '${article['title']}' dibuka");
                      },
                    ),
                  )),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Tombol Fitur ---
class FeatureButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color iconTextColor;
  final VoidCallback onTap;

  const FeatureButton({
    super.key,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.iconTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MainMenu.featureButtonWidth,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: iconTextColor),
            const SizedBox(height: 8),
            Text(
              title.replaceAll(' ', '\n'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: iconTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Card Artikel ---
class ArticleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: MainMenu.darkTeal.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.image_outlined,
                size: 30,
                color: MainMenu.darkTeal,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 99, 99, 99)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}