import 'package:flutter/material.dart';
import 'package:flutter_5a/core/helpers/custom_toaster.dart';
import 'package:flutter_5a/core/services/auth_service.dart';
import 'package:flutter_5a/views/login.dart';
import 'package:flutter_5a/views/profile.dart';
import 'package:flutter_5a/core/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_5a/core/providers/auth_provider.dart';

class AccountInformation extends StatefulWidget {
  const AccountInformation({super.key});

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  bool _biometricEnabled = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadBiometricStatus();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final data = await userProvider.getUserData();

    if (mounted) {
      setState(() {
        _userData = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBiometricStatus() async {
    final value = await _authService.isBiometricEnabled();
    if (mounted) {
      setState(() {
        _biometricEnabled = value;
      });
    }
  }

  Future<void> _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await authProvider.signOut();
    await _authService.logoutUser();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 80, height: 16, color: Colors.white),
            const SizedBox(height: 10),
            Container(height: 80, color: Colors.white),
            const SizedBox(height: 20),
            Container(height: 200, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 230, 246),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Informasi Akun",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? _buildShimmerContent()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROFILE
                  const Text(
                    "Profile",
                    style: TextStyle(
                        color: Color.fromARGB(255, 14, 141, 156),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: _userData?['photo'] != null
                            ? NetworkImage(_userData!['photo'])
                            : null,
                        backgroundColor: Colors.teal,
                        child: _userData?['photo'] == null
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      title: Text(
                        _userData?['name'] ?? 'Pengguna',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text(_userData?['email'] ?? 'Tidak ada email'),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Color.fromARGB(255, 14, 141, 156)),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Profile()),
                        );
                        _loadUserData();
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SETTINGS
                  const Text(
                    "Settings",
                    style: TextStyle(
                        color: Color.fromARGB(255, 14, 141, 156),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("Detail Profil",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Color.fromARGB(255, 14, 141, 156)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const Profile()),
                            );
                          },
                        ),
                        const Divider(height: 1),

                        /// DARK MODE (dummy)
                        SwitchListTile(
                          title: const Text("Dark Mode",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          value: false,
                          onChanged: (value) {},
                        ),
                        const Divider(height: 1),

                        /// BIOMETRIC
                        SwitchListTile(
                          title: const Text(
                            "Biometric Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                              "Gunakan sidik jari saat membuka aplikasi"),
                          value: _biometricEnabled,
                          onChanged: (value) async {
                              await _authService.setBiometricEnabled(value);

                              if (value) {
                                // ON → simpan login
                                await _authService.loginUser(_userData?['email'] ?? '');
                                showThemedToast("Biometrik diaktifkan", AlertTypeToaster.success);
                              } else {
                                // OFF → hapus session
                                await _authService.logoutUser();
                                showThemedToast("Biometrik dinonaktifkan", AlertTypeToaster.success);
                              }

                              setState(() {
                                _biometricEnabled = value;
                              });
                            },

                        ),
                        const Divider(height: 1),

                        ListTile(
                          title: const Text("Tentang Aplikasi",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Color.fromARGB(255, 14, 141, 156)),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  /// LOGOUT
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 14, 141, 156),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: _logout,
                      child: const Text(
                        "KELUAR",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
