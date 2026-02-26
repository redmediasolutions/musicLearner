// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class Feescard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const Feescard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Defining the specific accent color from your request
    const Color accentColor = Color(0xFFB7BDF7);
    final Color cardBackground = const Color(0xFFB7BDF7).withOpacity(0.2);
    const Color borderColor = Color(0xFF2C2C2C);   

    return Container(
      width: 500, 
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(24), 
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: accentColor,
            size: 28,
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
        
      ),
    );
  }
}