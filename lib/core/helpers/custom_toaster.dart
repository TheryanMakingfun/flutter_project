import 'package:flutter/material.dart'; 
import 'package:fluttertoast/fluttertoast.dart'; 
// Fungsi Helper untuk menampilkan Custom Fluttertoast 

enum AlertTypeToaster { success, danger, warning } 
void showThemedToast(String message, AlertTypeToaster type) { 
Color backgroundColor; 
  switch (type) { 
    case AlertTypeToaster.success: 
      backgroundColor = Colors.green[700]!; // Warna lebih gelap untuk Toast 
      break; 
    case AlertTypeToaster.danger: 
      backgroundColor = Colors.red[700]!; 
      break; 
    case AlertTypeToaster.warning: 
      backgroundColor = Colors.orange[700]!; 
      break; 
  } 
 
  Fluttertoast.showToast( 
    msg: message, 
    toastLength: Toast.LENGTH_LONG, // Durasi lebih lama untuk pesan penting 
    gravity: ToastGravity.TOP, // Posisi di atas 
    timeInSecForIosWeb: 2, 
    backgroundColor: backgroundColor, 
    textColor: Colors.white, 
    fontSize: 14.0, 
  ); 
} 
