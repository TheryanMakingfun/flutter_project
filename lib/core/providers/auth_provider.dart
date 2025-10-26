import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_5a/core/models/user_model.dart';
import 'dart:io'; 

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Google Sign-In setup
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Variabel pending credential DIBERSIHKAN karena tidak digunakan lagi
  AuthCredential? _pendingGoogleCredential; 
  String? _conflictingEmail;

  AuthCredential? get pendingGoogleCredential => _pendingGoogleCredential;
  String? get conflictingEmail => _conflictingEmail;

  void clearPendingCredential() {
    // Fungsi ini tidak memengaruhi logic blocking, tetapi tetap dipertahankan
    // untuk membersihkan state jika Anda menggunakannya di tempat lain.
    _pendingGoogleCredential = null;
    _conflictingEmail = null;
    notifyListeners();
  }

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
      throw e.message ?? 'Terjadi kesalahan saat pendaftaran.';
    }
  }

  // ======================================================
  // 🔹 LOGIN DENGAN EMAIL (HANYA LOGIN NORMAL)
  // ======================================================
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // *Logic linking yang rumit DIHAPUS*.
      // Ini hanya menjalankan alur Login normal Email/Password.
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') throw 'Pengguna tidak ditemukan.';
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') throw 'Kata sandi salah.';
      throw e.message ?? 'Terjadi kesalahan saat login.';
    }
  }

  // ======================================================
  // 🔹 LOGIN DENGAN GOOGLE (MEMBLOKIR JIKA ADA PROVIDER LAIN)
  // ======================================================
  Future<User?> signInWithGoogle() async {
    // 🔴 PERBAIKAN: Mencegah MissingPluginException di platform Desktop.
    // Jika bukan Web dan terdeteksi sebagai desktop (Windows, Linux, macOS),
    // langsung lempar error atau kembalikan null untuk menghindari crash.
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      throw 'Login Google tidak didukung di platform desktop (Windows).';
    }
    
    UserCredential userCredential;
    AuthCredential? credential; 

    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        userCredential = await _auth.signInWithPopup(googleProvider);
        credential = userCredential.credential; 
      } else {
        // BLOK INI HANYA AKAN BERJALAN DI MOBILE KARENA PENGECEKAN DI ATAS
        await _googleSignIn.signOut();
        // MissingPluginException terjadi di sini jika dijalankan di Windows
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn(); 
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        
        userCredential = await _auth.signInWithCredential(credential);
      }

      // Jika berhasil login atau register baru:
      final user = userCredential.user;
      if (user != null) {
        await _saveUserToFirestore(user);
      }
      return user;

    } on FirebaseAuthException catch (e) {
      // 💥 KODE KRUSIAL UNTUK KONFLIK PROVIDER (MEMBLOKIR): 
      if (e.code == 'account-exists-with-different-credential' && e.email != null) {
        
        // Langsung blokir dan beri pesan instruksi
        throw 'Akun dengan email ini sudah terdaftar menggunakan Email/Password. Silakan gunakan tombol Login Email.';
      }

      throw e.message ?? 'Terjadi kesalahan saat login Google.';

    } catch (e) {
      // Catch ini akan menangkap error yang kita lempar di awal fungsi (seperti "Login Google tidak didukung...")
      throw 'Gagal login dengan Google: $e';
    }
  }

  // ======================================================
  // 🔹 LOGOUT
  // ======================================================
  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      // Hanya coba sign out Google di platform yang mendukungnya
      await _googleSignIn.signOut();
    }
    clearPendingCredential();
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
