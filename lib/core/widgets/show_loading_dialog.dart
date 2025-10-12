import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    //barrierDismissible: false, // Biar ga bisa ditutup manual
    builder: (context) {
      return Center(
        child: Container(
          width: 230,
          height: 230,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            
          ),
          child: Lottie.asset(
            'assets/lottie/E_V_E.json',
            //'assets/lottie/Loading animation blue.json',
            width: 80,
            height: 80,
            fit: BoxFit.contain,
             repeat: true,
          ),
        ),
      );
    },
  );
}
