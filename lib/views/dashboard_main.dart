import 'package:flutter/material.dart';
import 'package:flutter_5a/views/education.dart';
import 'package:flutter_5a/views/main_menu.dart';
import 'package:flutter_5a/views/new_chat.dart';
import 'package:flutter_5a/views/profile.dart';
import 'package:flutter_5a/views/report.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DashboardMain extends StatefulWidget {
  final int initialIndex;
  final String? username; // Tambahkan properti username
  const DashboardMain({super.key, this.initialIndex = 0, this.username});

  @override
  State<DashboardMain> createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // Perbaikan: Buat list widget di dalam build, atau sebagai getter dinamis
  List<Widget> get _widgetOptions {
    return [
      // Teruskan username ke MainMenu dan Profile
      MainMenu(username: widget.username),
      const Report(),
      const Education(),
      const NewChat(),
      Profile(username: widget.username),
    ];
  }

  int _getGNavIndex() {
    // Semua halaman kecuali Profile dianggap tab Home
    if (_selectedIndex == 4) {
      return 1; // Profile
    } else {
      return 0; // Home
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withValues(alpha: 0.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
            child: GNav(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.blue,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  iconColor: Colors.black,
                  iconActiveColor: Colors.white,
                ),
                GButton(
                  icon: Icons.person,
                  iconColor: Colors.black,
                  iconActiveColor: Colors.white,
                ),
              ],
              selectedIndex: _getGNavIndex(),
              onTabChange: (index) {
                setState(() {
                  if (index == 0) {
                    _selectedIndex = 0; // Home → MainMenu
                  } else if (index == 1) {
                    _selectedIndex = 4; // Profile → Profile
                  }
                });
              }
            ),
          ),
        ),
      ),
    );
  }
}