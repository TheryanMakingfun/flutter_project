import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_5a/core/providers/user_provider.dart'; // 💡 Import UserProvider
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // 💡 Import package shimmer

class Profile extends StatefulWidget {
  final String username;
  final String email;
  final String imageUrl;

  const Profile({
    super.key,
    required this.username,
    required this.email,
    required this.imageUrl,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Controller isi dummy dari login
  late TextEditingController emailController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
    usernameController = TextEditingController(text: widget.username);
  }

  // 💡 Panggil fetchUsers() di didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  // --- Widget shimmer untuk Profile ---
  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Shimmer untuk CircleAvatar
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 10),

            // Shimmer untuk teks username dan email
            Container(
              width: 150,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 5),
            Container(
              width: 200,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 20),

            // Shimmer untuk TextField Email
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 15),

            // Shimmer untuk TextField Username
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 20),

            // Shimmer untuk tombol "SIMPAN"
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 230, 246),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 14, 141, 156)),
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
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Tentukan apakah kita menampilkan shimmer atau konten asli
          final bool isLoading = userProvider.isLoading;

          if (isLoading) {
            return _buildShimmerContent();
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromARGB(255, 14, 141, 156),
                    backgroundImage: widget.imageUrl.isNotEmpty
                        ? NetworkImage(widget.imageUrl)
                        : null,
                    child: widget.imageUrl.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.username,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.email,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(CupertinoIcons.mail),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 14, 141, 156),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 14, 141, 156),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(CupertinoIcons.person),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 14, 141, 156),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 14, 141, 156),
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
                        backgroundColor: const Color.fromARGB(255, 14, 141, 156),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
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