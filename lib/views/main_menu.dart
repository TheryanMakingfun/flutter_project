import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color.fromARGB(255, 210, 208, 249),
     body: SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
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
                    Text("Hallo,", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
                    Text("Dwi Gitayana", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
                    SizedBox(height: 4,),
                    Text("Selamat datang di SABDA!", style: TextStyle(fontSize: 12,color: Color.fromARGB(255, 99, 99, 99)),),
                  ],
                ),
                CircleAvatar(
                  radius: 24, // ukuran lingkaran
                  backgroundImage: AssetImage("assets/img/image1.jpeg"),
                  backgroundColor: Colors.grey[200], // fallback warna kalo gambar gagal load
                )
              ],
            ),
            const SizedBox(height: 20),
            
            //card ke1-INFO
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.shield, size: 35, color: Colors.blue),
                    SizedBox(height: 12),
                    Text(
                      "Jangan Takut bercerita, karena SABDA ruang amanmu untuk berbagi cerita",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              //  New Chat
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.chat, size: 30, color: Colors.blue),
                    SizedBox(height: 12),
                    Text(
                      "New Chat",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text("Lorem Ipsum...", style: TextStyle(fontSize: 12, color: Colors.blueGrey),)
                  ],
                ),
              ),
            
              const SizedBox(height: 120),

              //row laporkan dan edukasi
              Row(
                children: [
                  Expanded(child: Card(
                    color: Colors.red.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                    child: const Padding(padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.send, size: 25, color: Colors.red),
                        SizedBox(height: 8),
                        Text("Laporkan", textAlign: TextAlign.start ,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        SizedBox(height: 8),
                        Text("Lorem Ipsum...", textAlign: TextAlign.start ,style: TextStyle(fontSize: 10, color: Colors.blueGrey),)
                      ],
                    )),
                  ),),

                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      color: Colors.green.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.menu_book, size: 25, color: Colors.green),
                            SizedBox(height: 8),
                            Text("Edukasi", textAlign: TextAlign.start, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            SizedBox(height: 8),
                        Text("Lorem Ipsum...", textAlign: TextAlign.start ,style: TextStyle(fontSize: 10, color: Colors.blueGrey),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      )), 
    );
  }
}