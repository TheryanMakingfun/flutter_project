import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String username;
  final String email;
  final String imageUrl; // tambahan untuk foto profil

  const Profile({
    super.key,
    required this.username,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Controller isi dummy dari login
    TextEditingController emailController =
        TextEditingController(text: email);
    TextEditingController usernameController =
        TextEditingController(text: username);

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Detail Profil",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 10),
            Text(
              username,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal, // Ini akan langsung terlihat
                    width: 1.0,
                  ),
                ),
                // Border saat fokus
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal, // Warna yang Anda inginkan saat fokus
                    width: 1.0,
                  ),
                ),   
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                prefixIcon: const Icon(Icons.person_outline),
                // Border default (saat tidak fokus)
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal, // Ini akan langsung terlihat
                    width: 1.0,
                  ),
                ),
                // Border saat fokus
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal, // Warna yang Anda inginkan saat fokus
                    width: 1.0,
                  ),
                ),
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profil berhasil disimpan")),
                  );
                },
                child: const Text(
                  "SIMPAN",
                  style: TextStyle(fontSize: 20,
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
