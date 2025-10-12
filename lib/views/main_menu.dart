import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_5a/core/models/login_response_model.dart';
import 'package:flutter_5a/views/tips.dart';
import 'package:flutter_5a/views/chatbot.dart';
import 'package:flutter_5a/views/report.dart';
import 'package:flutter_5a/views/history.dart';
import 'package:flutter_5a/core/providers/chat_provider.dart';
import 'package:flutter_5a/core/providers/user_provider.dart'; // 💡 Import UserProvider
import 'package:flutter_5a/core/widgets/show_loading_dialog.dart';
import 'package:flutter_5a/views/feature_button.dart';
import 'package:flutter_5a/views/article_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // 💡 Import package shimmer

class MainMenu extends StatefulWidget {
  final LoginResponseModel user;
  const MainMenu({super.key, required this.user});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // Warna Teal Kustom
  static const Color darkTeal = Color.fromARGB(255, 14, 141, 156);

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

  // 💡 Panggil fetchUsers() saat initState
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Panggil fetchUsers() di sini untuk menghindari error BuildContext
    Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  // --- Widget shimmer untuk MainMenu ---
  Widget _buildShimmerContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 💡 Shimmer untuk Header
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 150,
                      height: 24,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 200,
                      height: 14,
                      color: Colors.white,
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // 💡 Shimmer untuk Info Perundungan
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // 💡 Shimmer untuk Fitur
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 18,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    features.length,
                    (index) => Container(
                      width: featureButtonWidth,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // 💡 Shimmer untuk Articles
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 18,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 💡 Gunakan Consumer untuk mendengarkan perubahan pada UserProvider
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Tentukan apakah kita menampilkan shimmer atau konten asli
        final bool isLoading = userProvider.isLoading;

        if (isLoading) {
          // Tampilkan shimmer jika masih loading
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 201, 230, 246),
            body: SafeArea(
              child: _buildShimmerContent(),
            ),
          );
        } else {
          // Tampilkan konten asli jika loading selesai
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 201, 230, 246),
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
                              widget.user.firstName, // ganti dummy username → API
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            const Text(
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
                          backgroundImage: NetworkImage(widget.user.image),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.shield_lefthalf_fill,
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
                        width: (featureButtonWidth * features.length) +
                            (featureSpacing * (features.length - 1)),
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
                              onTap: () async {
                                final title = feature['title'];
                                if (title == 'Chatbot Edukatif') {
                                  showLoadingDialog(context);
                                  final chatProvider =
                                      Provider.of<ChatProvider>(context,
                                          listen: false);
                                  final success = await chatProvider.initChat();
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                  if (success) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Chatbot()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            chatProvider.errorMessage ??
                                                'Gagal terhubung ke chatbot'),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  }
                                } else if (title == 'Laporan Cepat') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Report()),
                                  );
                                } else if (title == 'Tips Harian') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Tips()),
                                  );
                                } else if (title == 'Riwayat Deteksi') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const History()),
                                  );
                                } else {
                                  debugPrint("Fitur '$title' diklik");
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
      },
    );
  }
}