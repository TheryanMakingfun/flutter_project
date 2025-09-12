import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color.fromARGB(255, 250, 201, 250),
     body: SafeArea(
      child: SingleChildScrollView(
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.person, size: 30, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            //Card ke1
            Card(
              color: Colors.blue.shade100,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),),
              child: const Padding(padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.shield, size: 32, color: Colors.blue,),
                  SizedBox(width: 10,),
                  Expanded(child: Text("Jangan takut bercerita, karena SABDA ruang amanmu berbagi cerita", style: TextStyle(fontSize: 12),))
                ],
              ),),
            ),

            const SizedBox(height: 16,),
          ],
        ),
      )), 
    );
  }
}