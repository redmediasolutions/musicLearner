// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class Documentscard extends StatelessWidget {
  final String title;
  final String subTitle; 
  final IconData leadingIcon;
  final VoidCallback? onDownload;

  const Documentscard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.leadingIcon,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFFB7BDF7);
    final Color containerGrey =  const Color(0xFFB7BDF7).withOpacity(0.2);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent, 
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Leading Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: containerGrey,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(leadingIcon, color: accentColor, size: 24),
          ),
          const SizedBox(width: 16),
          
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Download Action
          IconButton(
            onPressed: onDownload,
            icon: const Icon(
              Icons.file_download_outlined,
              color: Colors.white38,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}