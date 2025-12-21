import 'package:local_auth/local_auth.dart';
import 'package:logger/logger.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:flutter/services.dart'; 
 
class AuthService { 
  final LocalAuthentication auth = LocalAuthentication();
  final logger = Logger(); 
 
  // 1. Simpan sesi login 
  Future<void> loginUser(String email) async {
    final prefs = await SharedPreferences.getInstance();

    final biometricEnabled =
        prefs.getBool('biometric_enabled') ?? false;

    await prefs.setString('email', email);

    // 🔥 hanya simpan login jika biometric ON
    await prefs.setBool('isLogin', biometricEnabled);
  }
 
  // 2. Cek status login 
  Future<bool> isUserLoggedIn() async { 
    final SharedPreferences prefs = await 
SharedPreferences.getInstance(); 
    // Default false jika belum ada data 
    return prefs.getBool('isLogin') ?? false; 
  } 
 
  // 3. Ambil email user 
  Future<String?> getUserEmail() async { 
    final SharedPreferences prefs = await 
SharedPreferences.getInstance(); 
    return prefs.getString('email'); 
  } 
 
  // 4. Hapus sesi (Logout) 
  Future<void> logoutUser() async { 
    final SharedPreferences prefs = await 
SharedPreferences.getInstance(); 
    await prefs.clear(); 
  } 
 
  // 5. EKSEKUSI BIOMETRIK 
  Future<bool> authenticate() async { 
    try { 
        // Cek ketersediaan hardware 
    bool canCheckBiometrics = await auth.canCheckBiometrics; 
    bool isDeviceSupported = await auth.isDeviceSupported(); 
    if (!canCheckBiometrics || !isDeviceSupported) { 
    logger.w("Hardware biometrik tidak tersedia atau tidak aktif"); 
    return false;  
    } 
    // Memunculkan Dialog 
    return await auth.authenticate( 
    localizedReason: 'Scan sidik jari untuk masuk kembali', 
    biometricOnly: true, 
    ); 
    } on PlatformException catch (e) { 
    logger.e("Error Platform: $e"); 
    return false; 
    } 
  }

  // 6. Simpan status biometric (ON / OFF)
  Future<void> setBiometricEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', value);
  }

  // 7. Ambil status biometric
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('biometric_enabled') ?? false;
  }

  // 8. Validasi biometric jika diperlukan
  Future<bool> checkBiometricIfNeeded() async {
    final isEnabled = await isBiometricEnabled();
    if (!isEnabled) return true; // 🔥 OFF → langsung lolos

    return await authenticate(); // 🔥 ON → wajib biometric
  }

}