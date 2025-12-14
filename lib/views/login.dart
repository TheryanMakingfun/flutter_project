import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart';

import 'package:flutter_5a/views/dashboard_main.dart';
import 'package:flutter_5a/views/register.dart';
import 'package:flutter_5a/core/providers/auth_provider.dart';
import 'package:flutter_5a/core/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🔥 LOGIN EMAIL/PASSWORD + SIMPAN SESI LOKAL
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // 1️⃣ LOGIN Firebase
      await authProvider.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // 2️⃣ SIMPAN STATUS LOGIN DI SharedPreferences
      await _authService.loginUser(_emailController.text.trim());

      if (!mounted) return;

      // 3️⃣ Masuk dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardMain()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🔥 LOGIN GOOGLE + SIMPAN SESI LOKAL
  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // 1️⃣ LOGIN melalui Google
      await authProvider.signInWithGoogle();

      // 2️⃣ SIMPAN status login lokal (ambil email dari FirebaseAuth langsung)
      final email = FirebaseAuth.instance.currentUser?.email;

      if (email != null) {
        await _authService.loginUser(email);
      }

      if (!mounted) return;

      // 3️⃣ Masuk dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardMain()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login Google gagal: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 230, 246),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Logo
                SizedBox(
                  width: 170,
                  height: 170,
                  child: Image.asset("assets/img/logo_sabda.png",
                      fit: BoxFit.cover),
                ),
                const SizedBox(height: 10),

                // Judul
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Masuk ke akun anda!',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 30),

                // Email
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                  isEmail: true,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 15),

                // Password
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: 20),

                // Tombol login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color.fromARGB(255, 14, 141, 156),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'MASUK',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Divider
                Row(
                  children: const [
                    Expanded(
                        child: Divider(
                            thickness: 1,
                            color: Color.fromARGB(255, 14, 141, 156))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("atau", style: TextStyle(color: Colors.black54)),
                    ),
                    Expanded(
                        child: Divider(
                            thickness: 1,
                            color: Color.fromARGB(255, 14, 141, 156))),
                  ],
                ),
                const SizedBox(height: 20),

                // Login Google
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _handleGoogleLogin,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 14, 141, 156)),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Image.asset('assets/img/google.png', height: 20.0),
                    label: const Text(
                      "Sign with Google",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Daftar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text(
                        "Daftar",
                        style: TextStyle(
                          color: Color.fromARGB(255, 14, 141, 156),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isEmail = false,
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmitted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: const TextStyle(fontSize: 16),
        textInputAction: textInputAction,
        onFieldSubmitted: onSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bidang ini tidak boleh kosong';
          }
          if (isEmail && !value.contains('@')) {
            return 'Masukkan email yang valid';
          }
          return null;
        },
      ),
    );
  }
}
