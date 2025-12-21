// lib/views/main_menu.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_5a/core/providers/auth_provider.dart' as local_auth;
import 'package:flutter_5a/views/tips.dart';
import 'package:flutter_5a/views/chatbot.dart';
import 'package:flutter_5a/views/report.dart';
import 'package:flutter_5a/views/history.dart';
import 'package:flutter_5a/views/scan_information.dart';
import 'package:flutter_5a/core/providers/chat_provider.dart';
import 'package:flutter_5a/core/widgets/show_loading_dialog.dart';
import 'package:flutter_5a/views/feature_button.dart';
import 'package:flutter_5a/views/article_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  static const Color darkTeal = Color.fromARGB(255, 14, 141, 156);

  // 🔥 Sudah ditambahkan Scan Informasi
  static const List<Map<String, dynamic>> features = [
    {
      'title': 'Chatbot Edukatif',
      'icon': FontAwesomeIcons.robot,
      'bgColor': Color.fromARGB(255, 220, 245, 235)
    },
    {
      'title': 'Laporan Cepat',
      'icon': FontAwesomeIcons.bullhorn,
      'bgColor': Color.fromARGB(255, 255, 240, 230)
    },
    {
      'title': 'Tips Harian',
      'icon': FontAwesomeIcons.lightbulb,
      'bgColor': Color.fromARGB(255, 255, 248, 220)
    },
    {
      'title': 'Riwayat Deteksi',
      'icon': FontAwesomeIcons.book,
      'bgColor': Color.fromARGB(255, 230, 245, 250)
    },
    {
      'title': 'Scan Informasi',
      'icon': FontAwesomeIcons.camera,
      'bgColor': Color.fromARGB(255, 240, 255, 240)
    },
  ];

  static const List<Map<String, String>> articles = [
    {
      'title': 'Bully Verbal',
      'subtitle': 'Lorem ipsum dolor sit amet consectetur adipiscing elit.'
    },
    {
      'title': 'Cara Melaporkan Perundungan',
      'subtitle': 'Lorem ipsum dolor sit amet consectetur adipiscing elit.'
    },
  ];

  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    final authProvider =
        Provider.of<local_auth.AuthProvider>(context, listen: false);

    final user = FirebaseAuth.instance.currentUser;

    setState(() {
      _userData = {
        'name': user?.displayName ?? 'Pengguna',
        'email': user?.email ?? '',
        'photo': user?.photoURL,
      };
      _isLoading = false;
    });

    try {
      final profile = await authProvider.getCurrentUserProfile();
      if (profile != null && mounted) {
        setState(() {
          _userData = {
            'name': profile.name,
            'email': profile.email,
            'photo': profile.photo,
          };
        });

        final user = FirebaseAuth.instance.currentUser;
        if (user != null && profile.photo != null) {
          await user.updatePhotoURL(profile.photo);
        }
      }
    } catch (e) {
      debugPrint("Gagal sinkronisasi Firestore: $e");
    }
  }

  Widget _buildShimmerContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 100, height: 20, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 150, height: 24, color: Colors.white),
                    const SizedBox(height: 8),
                    Container(width: 200, height: 14, color: Colors.white),
                  ],
                ),
                const CircleAvatar(
                    radius: 30, backgroundColor: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16))),
          ),
          const SizedBox(height: 30),
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 80, height: 18, color: Colors.white),
                const SizedBox(height: 12),
               Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    features.length,
                    (index) => Container(
                      width: 75,
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 230, 246),
      body: SafeArea(
        child: _isLoading
            ? _buildShimmerContent()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= Header =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Hallo,",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                            Text(
                              _userData?['name'] ?? 'Pengguna',
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
                          backgroundImage: _userData?['photo'] != null
                              ? NetworkImage(_userData!['photo'])
                              : null,
                          child: _userData?['photo'] == null
                              ? const Icon(Icons.person, size: 30)
                              : null,
                        )
                      ],
                    ),

                    const SizedBox(height: 25),

                    // ================= Banner =================
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: darkTeal,
                          borderRadius: BorderRadius.circular(16)),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      child: Row(
                        children: [
                          const Icon(FontAwesomeIcons.shieldHeart,
                              size: 45, color: Colors.white),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Hari ini: Tidak ada",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700)),
                                Text("Perundungan Terdeteksi",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ================= Fitur =================
                    const Text("Fitur",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkTeal)),
                    const SizedBox(height: 12),

                    // 🔥 RESPONSIVE FEATURE LIST
                    Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final availableWidth = constraints.maxWidth;
                          final itemWidth = availableWidth / 5.5;
                          final clampedWidth = itemWidth.clamp(65, 90).toDouble();

                          return SizedBox(
                            height: 120,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: features.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final feature = features[index];
                                return SizedBox(
                                  width: clampedWidth,
                                  child: FeatureButton(
                                    title: feature['title'],
                                    icon: feature['icon'],
                                    bgColor: feature['bgColor'],
                                    iconTextColor: darkTeal,
                                    onTap: () async {
                                      final title = feature['title'];

                                      if (title == 'Scan Informasi') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const ScanInformation()),);
                                        return;
                                      }

                                      if (title == 'Chatbot Edukatif') {
                                        showLoadingDialog(context);
                                        final chatProvider =
                                            Provider.of<ChatProvider>(context,
                                                listen: false);
                                        final success =
                                            await chatProvider.initChat();
                                        if (!context.mounted) return;
                                        Navigator.pop(context);
                                        if (success) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Chatbot()));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(chatProvider
                                                      .errorMessage ??
                                                  'Gagal terhubung ke chatbot'),
                                              backgroundColor:
                                                  Colors.redAccent,
                                            ),
                                          );
                                        }
                                      } else if (title == 'Laporan Cepat') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Report()));
                                      } else if (title == 'Tips Harian') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Tips()));
                                      } else if (title == 'Riwayat Deteksi') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const History()));
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ================= Articles =================
                    const Text("Articles",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkTeal)),
                    const SizedBox(height: 12),

                    ...articles.map(
                      (article) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ArticleCard(
                          title: article['title']!,
                          subtitle: article['subtitle']!,
                          onTap: () {
                            debugPrint(
                                "Artikel '${article['title']}' dibuka");
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),
                  ],
                ),
              ),
      ),
    );
  }
}
