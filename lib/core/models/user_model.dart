import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? name;
  final String? email;
  final String? photo;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    this.name,
    this.email,
    this.photo,
    this.createdAt,
  });

  // 🔹 Konversi dari Firestore Document ke Object
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      name: map['name'] ?? map['displayName'] ?? 'Pengguna',
      email: map['email'],
      photo: map['photo'] ?? map['photoURL'] ?? map['imageUrl'],
      createdAt: (map['createdAt'] != null)
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // 🔹 Konversi ke Map untuk disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photo': photo,
      'createdAt': createdAt,
    };
  }
}
