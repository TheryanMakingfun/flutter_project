import 'package:flutter/material.dart';
import 'package:flutter_5a/views/login.dart';
import 'profile.dart';

class AccountInformation extends StatelessWidget {
  final String username;
  final String email;
  final String imageUrl; // tambahin foto user

  const AccountInformation({
    super.key,
    required this.username,
    required this.email,
    required this.imageUrl,
  });

  void _logout(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()), // Navigasi ke LoginPage
    (Route<dynamic> route) => false, // Hapus semua rute sebelumnya dari stack
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Profile",
              style: TextStyle(color: Colors.teal[700],fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl), // foto user API
                  backgroundColor: Colors.teal,
                ),
                title: Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(email),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.teal,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Profile(username: username, email: email, imageUrl: imageUrl,),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Settings",
              style: TextStyle(color: Colors.teal[600],fontWeight: FontWeight.bold, fontSize: 16),
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
                      color: Colors.teal,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Profile(username: username, email: email, imageUrl: imageUrl,),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text("Dark Mode" ,style: TextStyle(fontWeight: FontWeight.bold)),
                    value: false,
                    onChanged: (value) {
                      // TODO: tambahin state management dark mode
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text("Tentang Aplikasi",style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.teal,
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
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Ubah nilainya menjadi lebih kecil
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
      ),
    );
  }
}
