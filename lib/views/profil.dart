import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Foto Profil Lingkaran
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.cyanAccent, // placeholder warna
              backgroundImage: null, // bisa ganti ke AssetImage/NetworkImage
            ),
            const SizedBox(height: 20),

            // Tombol Edit Foto
            ElevatedButton.icon(
              onPressed: () {
                // aksi edit foto
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text("Edit Foto"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 10),

            // Tombol Edit Info
            ElevatedButton.icon(
              onPressed: () {
                // aksi edit info
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Info"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}