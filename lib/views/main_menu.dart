import 'package:flutter/material.dart';
import 'package:flutter_5a/views/new_chat.dart';
import 'package:flutter_5a/views/report.dart';
import 'package:flutter_5a/views/education.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 208, 249, 232),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Untuk Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Hallo,",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "Dwi Gitayana",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Selamat datang di SABDA!",
                        style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 99, 99, 99)),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 24, // ukuran lingkaran
                    backgroundImage: AssetImage("assets/img/image1.jpeg"),
                    backgroundColor: Colors.grey,
                  )
                ],
              ),
              const SizedBox(height: 20),

              //card ke-1 INFO
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 172, 220, 255),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shield_rounded, size: 25, color: Colors.blue),
                    SizedBox(height: 12),
                    Text(
                      "Jangan takut bercerita, karena SABDA ruang amanmu untuk berbagi cerita.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // New Chat
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman NewChat saat Container diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewChat()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:const Color.fromARGB(255, 172, 220, 255),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.chat_rounded, size: 25, color: Colors.blue),
                      SizedBox(height: 12),
                      Text(
                        "New Chat",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Aku siap dengar kapan pun kamu mau cerita.",
                        style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 70, 91, 101)),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // row laporkan dan edukasi
              Row(
                children: [
                  Expanded(
                    // Bungkus dengan GestureDetector
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Report()),
                        );
                      },
                    child: Card(
                      color: Colors.red.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.send, size: 25, color: Colors.red),
                            SizedBox(height: 8),
                            Text(
                              "Laporkan",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Laporkan terkait masalah yang kamu alami!",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 68, 88, 98)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    // Bungkus dengan GestureDetector
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Education()),
                        );
                      },
                    child: Card(
                      color: const Color.fromARGB(255, 180, 255, 183),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.menu_book, size: 25, color: Color.fromARGB(255, 42, 169, 46)),
                            SizedBox(height: 8),
                            Text(
                              "Edukasi",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Kumpulan informasi mengenai tindakan bullying.",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 68, 88, 98)),
                            )
                          ],
                        ),
                      ),
                    ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tips Harian
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.lightbulb, size: 30, color: Color.fromARGB(255, 255, 230, 0)),
                        SizedBox(width: 12),
                        Text(
                          "Tips Harian",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '5 Tips Mengatasi Bullying:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "1. Tetap Tenang dan Percaya Diri: Jangan biarkan kata-kata mereka mempengaruhimu.",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "2. Beranikan Diri Berbicara: Ceritakan apa yang kamu alami kepada orang yang kamu percaya, seperti orang tua atau guru.",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "3. Jauhi Pelaku Bullying: Hindari tempat atau situasi di mana kamu mungkin akan bertemu mereka.",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "4. Jangan Membalas dengan Kekerasan: Balas dendam hanya akan membuat situasi lebih buruk.",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "5. Bangun Lingkaran Pertemanan Positif: Habiskan waktu dengan teman-teman yang mendukung dan menghargaimu.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}