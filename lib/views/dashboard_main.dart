import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_5a/models/login_response_model.dart';
import 'package:flutter_5a/views/account_information.dart';
import 'package:flutter_5a/views/main_menu.dart';
import 'package:flutter_5a/views/new_chat.dart';

class DashboardMain extends StatefulWidget {
  final LoginResponseModel user; // terima data user API
  const DashboardMain({super.key, required this.user});

  @override
  State<DashboardMain> createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  int _selectedIndex = 0; // Default tab = Home

  List<Widget> get _widgetOptions {
    return [
      // Home → MainMenu, kirim data user
      MainMenu(user: widget.user),

      // Chat
      const NewChat(),

      // Profile → AccountInformation, kirim data user
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
        activeColor: const Color(0xFF397B86),
        items: [
          const TabItem(icon: Icons.home, title: 'Home'),
          TabItem(
            icon: Icon(Icons.smart_toy, color: Colors.white),
            title: 'Chat',
          ),
          const TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
