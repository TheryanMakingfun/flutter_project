import 'package:flutter/material.dart';
import 'package:flutter_5a/core/providers/user_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final data = await userProvider.getUserData();
    if (mounted) {
      setState(() {
        _userData = data;
        _emailController.text = _userData?['email'] ?? '';
        _nameController.text = _userData?['name'] ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSave() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final newName = _nameController.text.trim();

  try {
    // 🔹 Update ke FirebaseAuth
    await user.updateDisplayName(newName);

    // 🔹 Update juga ke Firestore (UserProvider kamu)
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.updateUserData(user.uid, {
      'name': newName,
    });

    // 🔹 Refresh tampilan lokal
    setState(() {
      _userData?['name'] = newName;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil disimpan")),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan profil: $e")),
      );
    }
  }
}


  // Fungsi baru untuk mengganti foto profil
  Future<void> _changeProfilePicture() async {
    setState(() {
      _isLoading = true; // Tampilkan loading
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    try {
      final String? newImageUrl = await userProvider.uploadProfilePicture();
      if (newImageUrl != null && mounted) {
        setState(() {
          _userData?['photo'] = newImageUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Foto profil berhasil diperbarui.")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui foto: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Sembunyikan loading
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: Colors.white),
            const SizedBox(height: 10),
            Container(width: 150, height: 20, color: Colors.white),
            const SizedBox(height: 5),
            Container(width: 200, height: 16, color: Colors.white),
            const SizedBox(height: 20),
            Container(height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5))),
            const SizedBox(height: 15),
            Container(height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5))),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Color.fromARGB(255, 14, 141, 156)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Detail Profil", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: _isLoading ? _buildShimmerContent() : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Tambahkan GestureDetector untuk ganti foto profil
            GestureDetector(
              onTap: _changeProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 14, 141, 156),
                backgroundImage: _userData?['photo'] != null ? NetworkImage(_userData!['photo']) : null,
                child: _userData?['photo'] == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
              ),
            ),
            const SizedBox(height: 10),
            Text(_userData?['name'] ?? 'Pengguna', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(_userData?['email'] ?? 'Tidak ada email', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(FontAwesomeIcons.envelope, size: 19,),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 14, 141, 156), width: 2.1)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 14, 141, 156), width: 2.1)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(FontAwesomeIcons.user, size: 19,),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 14, 141, 156), width: 2.1)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 14, 141, 156), width: 2.1)),
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
                onPressed: _handleSave,
                child: const Text("SIMPAN", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}