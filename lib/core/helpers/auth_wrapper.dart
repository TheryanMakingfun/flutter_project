import 'package:flutter/material.dart';
import 'package:flutter_5a/core/services/auth_service.dart';
import 'package:flutter_5a/views/start_view.dart';
import 'package:flutter_5a/views/dashboard_main.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
  final hasLoggedIn = await _authService.isUserLoggedIn();

  if (!hasLoggedIn) {
    _navigateTo(const StartView());
    return;
  }

  final allowed = await _authService.checkBiometricIfNeeded();

  if (!allowed) {
    _navigateTo(const StartView());
    return;
  }

  _navigateTo(const DashboardMain());
}


  void _navigateTo(Widget page) {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan loading saat cek biometrik / status login
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
