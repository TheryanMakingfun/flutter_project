import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final data = await userProvider.getUserData();
    if (mounted) {
      setState(() {
        _userData = data;
        _isLoading = false;
      });
    }
  }

  void _logout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 80, height: 16, color: Colors.white),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(radius: 24, backgroundColor: Colors.white),
                title: Container(width: 120, height: 16, color: Colors.white),
                subtitle: Container(width: 150, height: 12, color: Colors.white, margin: const EdgeInsets.only(top: 4)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Container(width: 80, height: 16, color: Colors.white),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  Container(height: 56, color: Colors.white),
                  const Divider(height: 1),
                  Container(height: 56, color: Colors.white),
                  const Divider(height: 1),
                  Container(height: 56, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(width: double.infinity, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5))),
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
        automaticallyImplyLeading: false, // 🔥 hilangkan panah back otomatis
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Profile", style: TextStyle(color: Color.fromARGB(255, 14, 141, 156), fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: _userData?['photo'] != null ? NetworkImage(_userData!['photo']) : null,
                        backgroundColor: Colors.teal,
                        child: _userData?['photo'] == null ? const Icon(Icons.person, color: Colors.white) : null,
                      ),
                      title: Text(_userData?['name'] ?? 'Pengguna', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(_userData?['email'] ?? 'Tidak ada email'),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 14, 141, 156)),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Profile()),
                        );
                        _loadUserData();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Settings", style: TextStyle(color: Color.fromARGB(255, 14, 141, 156), fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text("Detail Profil", style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 14, 141, 156)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Profile()),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.bold)),
                          value: false,
                          onChanged: (value) {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text("Tentang Aplikasi", style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 14, 141, 156)),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 14, 141, 156),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        minimumSize: const Size(100, 50),
                      ),
                      onPressed: () => _logout(context),
                      child: const Text("KELUAR", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}