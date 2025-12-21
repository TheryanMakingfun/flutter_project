import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_5a/core/services/firestore_service.dart'; // Pastikan path benar

class ReportProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ======================================================
  // 🔹 FUNGSI UNTUK SIMULASI SHIMMER (DIBUTUHKAN OLEH report.dart)
  // ======================================================
  Future<void> loadReportData() async {
    _isLoading = true;
    notifyListeners();

    // Simulasi loading selama 1 detik untuk memunculkan efek shimmer
    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  /// Fungsi utama untuk mengirim laporan pengaduan ke Firestore
  Future<void> submitReport({
    required String jenisPerundungan,
    required DateTime tglKejadian,
    required String tempat,
    required String longLat, // Sekarang menggunakan String sesuai permintaan
    required String detailKejadian,
  }) async {
    try {
      _setLoading(true);

      // 1. Mengambil UID dari user yang sedang login melalui Firebase Auth
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw "Gagal mendapatkan data user. Silakan login kembali.";
      }

      // 2. Mengirim data ke FirestoreService
      await _firestoreService.tambahPengaduan(
        idUser: userId,
        jenisPerundungan: jenisPerundungan,
        tglKejadian: tglKejadian,
        tempat: tempat,
        longLat: longLat, // Langsung dikirim sebagai String
        detailKejadian: detailKejadian,
      );

      _setLoading(false);
    } catch (e) {
      _setLoading(false);
      // Melempar error agar bisa ditangkap oleh UI untuk menampilkan pesan error
      rethrow; 
    }
  }

  /// Helper untuk mengubah status loading dan memberitahu UI
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}