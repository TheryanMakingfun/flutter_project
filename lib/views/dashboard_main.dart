import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_5a/core/models/login_response_model.dart';
import 'package:flutter_5a/views/account_information.dart';
import 'package:flutter_5a/views/main_menu.dart';
import 'package:flutter_5a/views/chatbot.dart';

class DashboardMain extends StatefulWidget {
  final LoginResponseModel user;
  const DashboardMain({super.key, required this.user});

  @override
  State<DashboardMain> createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  int _selectedIndex = 0; // Default tab = Home

  // Widget yang akan ditampilkan di body
  List<Widget> get _widgetOptions {
    return [
      // Index 0: MainMenu (Home)
      MainMenu(user: widget.user),

      // Index 1: Kosong, karena Chatbot akan di-push secara terpisah
      const SizedBox(),

      // Index 2: AccountInformation (Profile)
      AccountInformation(
        username: widget.user.username,
        email: widget.user.email,
        imageUrl: widget.user.image,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.white,
        color: Colors.grey,
        activeColor: const Color.fromARGB(255, 14, 141, 156),
        items: const [
          TabItem(icon: Icons.home),
          TabItem(icon: Icon(Icons.smart_toy, size: 28, color: Colors.white)),
          TabItem(icon: Icons.person),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          if (index == 1) { // Jika ikon Chatbot diklik (indeks 1)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Chatbot()),
            );
          } else { // Jika ikon Home atau Profile diklik
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}