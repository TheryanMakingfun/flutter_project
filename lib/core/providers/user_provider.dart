import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_5a/core/models/upload_response_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserProvider extends ChangeNotifier {
  final logger = Logger();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();

  // Ambil kredensial dari file .env
  final String _cloudinaryCloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
  final String _cloudinaryApiKey = dotenv.env['CLOUDINARY_API_KEY']!;
  final String _cloudinaryApiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;

  /// Membuat signature sesuai aturan Cloudinary
  String _generateSignature(Map<String, dynamic> params) {
    // Sortir key
    final sortedKeys = params.keys.toList()..sort();

    // Hanya gabungkan parameter yang bukan null dan bukan api_key
    final toSign = sortedKeys
        .where((k) => params[k] != null && k != 'api_key')
        .map((k) => '$k=${params[k]}')
        .join('&');

    // Tambahkan secret di akhir lalu hash dengan SHA1
    final signatureBase = '$toSign$_cloudinaryApiSecret';
    return sha1.convert(utf8.encode(signatureBase)).toString();
  }

  /// Mendapatkan data pengguna dari Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await _db.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }

  /// Menyimpan data pengguna baru
  Future<void> saveNewUser(User user, Map<String, dynamic> additionalData) async {
    await _db.collection('users').doc(user.uid).set({
      'email': user.email,
      ...additionalData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Memperbarui data pengguna
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).update(data);
  }

  /// Menghapus data pengguna
  Future<void> deleteUser(String userId) async {
    await _db.collection('users').doc(userId).delete();
  }

  /// Upload foto profil ke Cloudinary dan simpan URL ke Firestore + FirebaseAuth
Future<String?> uploadProfilePicture() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("Pengguna belum login.");
  }

  try {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    final String uploadUrl =
        'https://api.cloudinary.com/v1_1/$_cloudinaryCloudName/image/upload';
    final String fileExtension = image.name.split('.').last;

    // 🔹 Ganti folder jadi sesuai preset SABDAapp
    final Map<String, dynamic> params = {
      'timestamp': (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      'folder': 'pictures_by_profile',
      'upload_preset': 'SABDAapp',
      'overwrite': true,
      'use_filename': false,
      'unique_filename': false,
    };

    // 🔹 Generate signature karena preset-mu mode Signed
    final String signature = _generateSignature(params);

    // 🔹 Siapkan FormData untuk upload
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        await image.readAsBytes(),
        filename: image.name,
        contentType: MediaType('image', fileExtension),
      ),
      'api_key': _cloudinaryApiKey,
      'timestamp': params['timestamp'],
      'folder': params['folder'],
      'upload_preset': params['upload_preset'],
      'overwrite': params['overwrite'],
      'use_filename': params['use_filename'],
      'unique_filename': params['unique_filename'],
      'signature': signature,
    });

    final response = await _dio.post(uploadUrl, data: formData);

    if (response.statusCode != 200) {
      throw Exception("Gagal upload ke Cloudinary: ${response.data}");
    }

    final result = UploadResponseModel.fromMap(response.data);
    final String downloadUrl = result.secureUrl;

    // 🔹 Simpan URL ke Firestore
    await _db.collection('users').doc(user.uid).update({
      'photo': downloadUrl,
    });

    // 🔹 Update juga FirebaseAuth agar sinkron di seluruh app
    await user.updatePhotoURL(downloadUrl);
    await user.reload();

    return downloadUrl;
  } catch (e) {
    logger.e("Gagal mengunggah foto profil: $e");
    rethrow;
  }
}
}
