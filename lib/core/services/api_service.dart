import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class ApiService {
  final logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Login User with Email & Password
  Future<User?> loginUser(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      logger.e("Login failed: ${e.message}");
      rethrow;
    } catch (e) {
      logger.e("Unknown login error: $e");
      rethrow;
    }
  }

  // 🔹 Register User + save to Firestore
  Future<User?> registerUser(String email, String password, String displayName) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        await _db.collection('users').doc(user.uid).set({
          'email': email,
          'displayName': displayName,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      logger.e("Registration failed: ${e.message}");
      rethrow;
    } catch (e) {
      logger.e("Unknown registration error: $e");
      rethrow;
    }
  }

  // 🔹 Get user profile from Firestore
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      logger.e("Failed to get user profile: $e");
      rethrow;
    }
  }

  // 🔹 Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).update(data);
    } catch (e) {
      logger.e("Failed to update profile: $e");
      rethrow;
    }
  }

  // 🔹 Ensure user exists in Firestore (used for Google Sign-In)
  Future<void> ensureUserExists(User user) async {
    try {
      final docRef = _db.collection('users').doc(user.uid);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        await docRef.set({
          'email': user.email,
          'displayName': user.displayName ?? '',
          'photoURL': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        logger.i("User ${user.email} created in Firestore");
      } else {
        logger.i("User ${user.email} already exists in Firestore");
      }
    } catch (e) {
      logger.e("Failed to ensure user exists: $e");
      rethrow;
    }
  }

  // 🔹 Delete user
  Future<void> deleteUser(String uid) async {
    try {
      await _auth.currentUser?.delete();
      await _db.collection('users').doc(uid).delete();
    } catch (e) {
      logger.e("Failed to delete user: $e");
      rethrow;
    }
  }

  // 🔹 Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
