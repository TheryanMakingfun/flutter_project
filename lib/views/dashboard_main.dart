/// lib/views/dashboard_main.dart
library;

import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 

import 'package:flutter_5a/views/account_information.dart';
import 'package:flutter_5a/views/main_menu.dart';
import 'package:flutter_5a/views/chatbot.dart';
import 'package:flutter_5a/core/widgets/show_loading_dialog.dart';
import 'package:flutter_5a/core/providers/chat_provider.dart';
import 'package:provider/provider.dart';

class DashboardMain extends StatefulWidget {
  const DashboardMain({super.key});

  @override
  State<DashboardMain> createState() => _DashboardMainState();
}

class _DashboardMainState extends State<DashboardMain> {
  int _selectedIndex = 0;

  // List widget yang akan ditampilkan di body
  List<Widget> get _widgetOptions {
    // Gunakan Consumer di sini untuk mendengarkan perubahan data pengguna
    return [
      const MainMenu(), // Index 0: MainMenu
      const SizedBox(), // Index 1: Kosong untuk tab Chatbot
      const AccountInformation(), // Index 2: AccountInformation
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Definisi warna aktif untuk kemudahan
    const Color activeIconColor = Color.fromARGB(255, 14, 141, 156);
    const Color inactiveIconColor = Colors.grey;

    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.white,
        color: inactiveIconColor, // Warna default untuk ikon non-aktif
        activeColor: activeIconColor, // Warna lingkaran aktif di tengah
        
        // Hapus 'const' karena properti 'items' sekarang dinamis (kondisional)
        items: [
          // Index 0: Ikon Home (Warna berubah berdasarkan _selectedIndex)
          TabItem(
            icon: Icon(
              FontAwesomeIcons.solidHouse, 
              size: 20, 
              // Warna ikon ditentukan secara kondisional
              color: _selectedIndex == 0 ? activeIconColor : inactiveIconColor,
            )
          ),
          
          // Index 1: Ikon Robot (Warna hardcoded menjadi putih)
          // Catatan: Ikon di dalam TabItem ini harus menggunakan 'Icon'
          const TabItem(icon: Icon(FontAwesomeIcons.robot, size: 28, color: Colors.white)),
          
          // Index 2: Ikon User (Warna berubah berdasarkan _selectedIndex)
          TabItem(
            icon: Icon(
              FontAwesomeIcons.solidUser, 
              size: 20,
              // Warna ikon ditentukan secara kondisional
              color: _selectedIndex == 2 ? activeIconColor : inactiveIconColor,
            )
          ),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: (int index) async {
          if (index == 1) {
            // Logika untuk tab Chatbot (Index 1)
            showLoadingDialog(context);

            final chatProvider = Provider.of<ChatProvider>(context, listen: false);
            final success = await chatProvider.initChat();

            if (!context.mounted) return;
            Navigator.pop(context); // Tutup loading dialog

            if (success) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Chatbot()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    chatProvider.errorMessage ?? 'Gagal terhubung ke chatbot',
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          } else { 
            // Logika untuk tab Home (0) atau User (2)
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}