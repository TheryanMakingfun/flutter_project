import 'package:flutter/material.dart';
import 'package:flutter_5a/core/models/tips_model.dart'; // Pastikan path benar

class TipsProvider with ChangeNotifier {
  bool isLoading = true;
  List<TipsModel> _tips = [];

  List<TipsModel> get tips => _tips;

  Future<void> fetchTips() async {
    isLoading = true;
    notifyListeners();

    // Simulasi delay loading dari API
    await Future.delayed(const Duration(seconds: 1));

    _tips = [
      TipsModel(
        title: 'Apa itu bullying?',
        description: 'Bullying adalah perilaku menyakiti orang lain secara sengaja dan berulang, baik fisik, verbal, maupun melalui dunia maya (cyber).',
      ),
      TipsModel(
        title: 'Dampak bullying?',
        description: 'Korban bisa mengalami trauma, ketakutan, rendah diri, dan gangguan mental. Pelaku bisa terbiasa melakukan kekerasan dan menghadapi masalah hukum.',
      ),
      TipsModel(
        title: 'Cara mengenali bullying?',
        description: 'Menarik diri, perubahan emosi drastis, nilai sekolah turun, sering sakit tanpa sebab jelas, atau enggan ke tempat tertentu.',
      ),
      TipsModel(
        title: 'Cara menjadi teman pendukung?',
        description: 'Dengarkan tanpa menghakimi, beri semangat, ajak bicara orang dewasa/ahli, dan jangan diam jika melihat perundungan.',
      ),
    ];

    isLoading = false;
    notifyListeners();
  }
}