import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_5a/core/models/user_model.dart'; // 🔹 sesuaikan path

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
);

  // ======================================================
  // 🔹 REGISTER DENGAN EMAIL
  // ======================================================
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await _saveUserToFirestore(user);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') throw 'Kata sandi terlalu lemah.';
      if (e.code == 'email-already-in-use') throw 'Email sudah terdaftar.';
      throw e.message ?? 'Terjadi kesalahan.';
    }
  }

  // ======================================================
  // 🔹 LOGIN DENGAN EMAIL
  // ======================================================
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') throw 'Pengguna tidak ditemukan.';
      if (e.code == 'wrong-password') throw 'Kata sandi salah.';
      throw e.message ?? 'Terjadi kesalahan.';
    }
  }

  // ======================================================
  // 🔹 LOGIN DENGAN GOOGLE
  // ======================================================
  Future<User?> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // ✅ Login popup untuk web
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        // ✅ Android/iOS
        final GoogleSignInAccount? googleUser =
            await _googleSignIn.signInSilently() ?? await _googleSignIn.signIn();

        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        userCredential = await _auth.signInWithCredential(credential);
      }

      final user = userCredential.user;
      if (user != null) {
        await _saveUserToFirestore(user);
      }

      return user;
    } catch (e) {
      throw 'Gagal login dengan Google: $e';
    }
  }

  // ======================================================
  // 🔹 LOGOUT
  // ======================================================
  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
  }

  // ======================================================
  // 🔹 STREAM USER AKTIF
  // ======================================================
  Stream<User?> get user => _auth.authStateChanges();

  // ======================================================
  // 🔹 SIMPAN DATA USER KE FIRESTORE (PAKAI MODEL)
  // ======================================================
  Future<void> _saveUserToFirestore(User user) async {
  try {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final snapshot = await userDoc.get();

    if (!snapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? 'Pengguna',
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  } catch (e) {
    debugPrint("Firestore write error: $e");
    // Biarkan login tetap lanjut walau gagal simpan Firestore
  }
}

  // ======================================================
  // 🔹 AMBIL DATA PROFIL USER DALAM BENTUK MODEL
  // ======================================================
  Future<UserModel?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists || doc.data() == null) return null;

    return UserModel.fromMap(doc.data()!, doc.id);
  }
}
