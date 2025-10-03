import 'package:flutter/material.dart';
import 'package:flutter_5a/services/api_service.dart';
import 'package:flutter_5a/models/login_request_model.dart';
import 'package:flutter_5a/models/login_response_model.dart';
import 'package:flutter_5a/views/dashboard_main.dart';
//import 'package:flutter_5a/views/main_menu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  final ApiService _apiService = ApiService();

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final request = LoginRequestModel(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      LoginResponseModel user = await _apiService.loginUser(request);

      // Jika berhasil login → navigasi ke MainMenu
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardMain(user: user),
        ),
      );
    } catch (e) {
      // Tampilkan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.lightBlue[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder
              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  //border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset("assets/img/sabda.png",fit: BoxFit.cover,),
                ),
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

              // Email field
              _buildTextField(
                controller: _usernameController,
                hintText: 'Username',
                icon: Icons.person,
              ),
              const SizedBox(height: 15),

              // Password field
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 20),

              // Tombol login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.teal[600],
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

              // Garis pemisah "atau"
              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1, color: Colors.teal)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("atau", style: TextStyle(color: Colors.black54)),
                  ),
                  Expanded(child: Divider(thickness: 1, color: Colors.teal)),
                ],
              ),
              const SizedBox(height: 20),

              // Tombol Google
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Tambahkan login Google
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.teal),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 28),
                  label: const Text(
                    "Sign with Google",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Link daftar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () {
                      // TODO: pindah ke halaman register
                    },
                    child: const Text(
                      "Daftar",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        //obscureText: isPassword,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
