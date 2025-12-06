import 'package:flutter/material.dart'; 
 
// Enum untuk membedakan jenis alert 
enum AlertType { success, danger, warning } 
 
// Fungsi Helper untuk menampilkan Custom SnackBar 
void showCustomSnackBar(BuildContext context, String message, 
AlertType type) { 
  // Menentukan warna dan ikon berdasarkan jenis (type) 
  Color backgroundColor; 
  IconData icon; 
  String title; 
 
  switch (type) { 
    case AlertType.success: 
      backgroundColor = Colors.green; 
      icon = Icons.check_circle; 
      title = 'Berhasil'; 
      break; 
    case AlertType.danger: 
      backgroundColor = Colors.red; 
      icon = Icons.error; 
      title = 'Error'; 
      break; 
    case AlertType.warning: 
      backgroundColor = Colors.orange; 
      icon = Icons.warning; 
      title = 'Peringatan'; 
      break; 
  } 

  
  final snackBar = SnackBar( 
    content: Row( 
      children: [ 
        Icon(icon, color: Colors.white), 
        const SizedBox(width: 10), 
        Expanded( 
          child: Column( 
            crossAxisAlignment: CrossAxisAlignment.start, 
            mainAxisSize: MainAxisSize.min, 
            children: [ 
              Text( 
                title, 
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white), 
              ), 
              Text( 
                message, 
                style: const TextStyle(color: Colors.white70), 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis, 
              ), 
            ], 
          ), 
        ), 
      ], 
    ), 
    backgroundColor: backgroundColor, 
    behavior: SnackBarBehavior.floating, // Tampil mengambang 
    duration: const Duration(seconds: 4), 
  ); 
 
  ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Sembunyikan yang sedang tampil 
  ScaffoldMessenger.of(context).showSnackBar(snackBar); 
} 