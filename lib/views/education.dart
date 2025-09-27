import 'package:flutter/material.dart';

class Education extends StatelessWidget {
  const Education({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 233, 220, 245),
      appBar: AppBar(
        title: const Text(
          'Edukasi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEducationCard(
                title: 'Apa itu bullying?',
                description: 'Bullying adalah perilaku menyakiti orang lain secara sengaja dan berulang, baik fisik, verbal, maupun melalui dunia maya (cyber).',
              ),
              const SizedBox(height: 16),
              _buildEducationCard(
                title: 'Dampak bullying?',
                description: 
                'Bullying berdampak pada banyak pihak. Korban bisa mengalami trauma, ketakutan, rendah diri, dan gangguan mental. Pelaku akan terbiasa melakukan kekerasan dan berisiko menghadapi masalah hukum atau sosial. Lingkungan pun menjadi tidak aman dan hubungan antarindividu ikut rusak.',
              ),
              const SizedBox(height: 16),
              _buildEducationCard(
                title: 'Cara mengenali?',
                description: 'Menarik diri, perubahan emosi drastis, nilai sekolah turun, sering sakit tanpa sebab jelas, atau enggan ke tempat tertentu.',
              ),
              const SizedBox(height: 16),
              _buildEducationCard(
                title: 'Cara menjadi teman pendukung?',
                description: 'Dengarkan tanpa menghakimi, beri semangat, ajak bicara orang dewasa/ahli, dan jangan diam jika melihat perundungan.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationCard({required String title, required String description}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}