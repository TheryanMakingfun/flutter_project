import 'package:flutter/material.dart';

class FeatureButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color iconTextColor;
  final VoidCallback onTap;

  const FeatureButton({
    super.key,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.iconTextColor,
    required this.onTap,
  });

  static const double featureButtonWidth = 75;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: featureButtonWidth,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: iconTextColor),
            const SizedBox(height: 8),
            Text(
              title.replaceAll(' ', '\n'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: iconTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}