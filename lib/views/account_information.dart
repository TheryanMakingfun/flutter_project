import 'package:flutter/material.dart';
import 'package:flutter_5a/views/login.dart';
import 'package:flutter_5a/views/profile.dart';
import 'package:flutter_5a/core/providers/user_provider.dart'; // 💡 Import UserProvider
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // 💡 Import package shimmer

class AccountInformation extends StatefulWidget {
  final String username;
  final String email;
  final String imageUrl;

  const AccountInformation({
    super.key,
    required this.username,
    required this.email,
    required this.imageUrl,
  });

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  // Metode untuk logout
  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  // 💡 Panggil fetchUsers() di didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  // --- Widget shimmer untuk AccountInformation ---
  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer untuk "Profile" text
            Container(
              width: 80,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 10),

            // Shimmer untuk Card Profile
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                ),
                title: Container(
                  width: 120,
                  height: 16,
                  color: Colors.white,
                ),
                subtitle: Container(
                  width: 150,
                  height: 12,
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 4),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Shimmer untuk "Settings" text
            Container(
              width: 80,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 10),

            // Shimmer untuk Card Settings
            Card(
              child: Column(
                children: [
                  Container(
                    height: 56, // Tinggi default ListTile
                    color: Colors.white,
                  ),
                  const Divider(height: 1),
                  Container(
                    height: 56, // Tinggi default SwitchListTile
                    color: Colors.white,
                  ),
                  const Divider(height: 1),
                  Container(
                    height: 56, // Tinggi default ListTile
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Shimmer untuk tombol "KELUAR"
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 💡 Gunakan Consumer untuk mendengarkan perubahan pada UserProvider
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 230, 246),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Informasi Akun",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Tentukan apakah kita menampilkan shimmer atau konten asli
          final bool isLoading = userProvider.isLoading;

          if (isLoading) {
            return _buildShimmerContent();
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile",
                    style: TextStyle(
                        color: Color.fromARGB(255, 14, 141, 156),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(widget.imageUrl),
                        backgroundColor: Colors.teal,
                      ),
                      title: Text(
                        widget.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(widget.email),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromARGB(255, 14, 141, 156),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(
                                username: widget.username,
                                email: widget.email,
                                imageUrl: widget.imageUrl),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
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
                          title: const Text(
                            "Detail Profil",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromARGB(255, 14, 141, 156),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(
                                    username: widget.username,
                                    email: widget.email,
                                    imageUrl: widget.imageUrl),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: const Text("Dark Mode",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          value: false,
                          onChanged: (value) {
                            // TODO: tambahin state management dark mode
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text("Tentang Aplikasi",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color.fromARGB(255, 14, 141, 156),
                          ),
                          onTap: () {
                            // TODO: arahkan ke halaman tentang aplikasi
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 14, 141, 156),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: const Size(100, 50),
                      ),
                      onPressed: () => _logout(context),
                      child: const Text(
                        "KELUAR",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}