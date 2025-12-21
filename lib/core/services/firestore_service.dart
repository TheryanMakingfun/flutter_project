import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // ==============================
  // Inisialisasi Firestore
  // ==============================
  final CollectionReference _pengaduanCollection =
      FirebaseFirestore.instance.collection('pengaduan_masyarakat2');

  // ==============================
  // R - READ (Realtime)
  // ==============================
  Stream<QuerySnapshot> getDaftarPengaduan() {
    return _pengaduanCollection
        .orderBy('tgl_pengaduan', descending: true)
        .snapshots();
  }

  // ==============================
  // C - CREATE
  // ==============================
  Future<void> tambahPengaduan({
    required String idUser,
    required String jenisPerundungan,
    required DateTime tglKejadian,
    required String tempat,
    required String longLat, // Diubah menjadi String
    required String detailKejadian,
  }) async {
    try {
      await _pengaduanCollection.add({
        'id_user': idUser,
        'jenis_perundungan': jenisPerundungan,
        'tgl_kejadian': Timestamp.fromDate(tglKejadian),
        'tempat': tempat,
        'long_lat': longLat, // Disimpan sebagai String
        'detail_kejadian': detailKejadian,

        // Otomatis oleh sistem
        'tgl_pengaduan': FieldValue.serverTimestamp(),
      });

      print('Pengaduan berhasil dikirim');
    } catch (e) {
      print('Gagal mengirim pengaduan: $e');
      rethrow;
    }
  }

  // ==============================
  // U - UPDATE
  // ==============================
  Future<void> updatePengaduan({
    required String docId,
    required String jenisPerundungan,
    required DateTime tglKejadian,
    required String tempat,
    required String longLat, // Diubah menjadi String
    required String detailKejadian,
  }) async {
    try {
      await _pengaduanCollection.doc(docId).update({
        'jenis_perundungan': jenisPerundungan,
        'tgl_kejadian': Timestamp.fromDate(tglKejadian),
        'tempat': tempat,
        'long_lat': longLat, // Diperbarui sebagai String
        'detail_kejadian': detailKejadian,
      });

      print('Pengaduan berhasil diperbarui');
    } catch (e) {
      print('Gagal update pengaduan: $e');
    }
  }

  // ==============================
  // D - DELETE
  // ==============================
  Future<void> hapusPengaduan(String docId) async {
    try {
      await _pengaduanCollection.doc(docId).delete();
      print('Pengaduan berhasil dihapus');
    } catch (e) {
      print('Gagal menghapus pengaduan: $e');
    }
  }
}