import 'package:flutter/material.dart';

class HomeIconButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;
  final Color iconcolor;
  final VoidCallback onTap;

  const HomeIconButton({
    super.key,
    required this.icon,
    required this.title,
    this.backgroundColor = const Color(0xFFB7BDF7),
    required this.iconcolor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconcolor, size: 80),
            const SizedBox(width: 16),
            Text(
            title,
            style: const TextStyle(
              color: Color(0xFFB7BDF7),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          ],
        ),
      ),
    );
  }
}