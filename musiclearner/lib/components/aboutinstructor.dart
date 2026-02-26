import 'package:flutter/material.dart';

class Aboutinstructor extends StatelessWidget {
  final String name;
  final String subtitle;
  final String img;
  // final double rating;
  // final String students;

  const Aboutinstructor({
    super.key,
    required this.name,
    required this.subtitle,
    required this.img,
    // required this.rating,
    // required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // PHOTO
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            img,
            width: 55,
            height: 55,
            fit: BoxFit.cover,
          ),
        ),
    
        const SizedBox(width: 12),
    
        // NAME & SUBTITLE
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
    
              const SizedBox(height: 4),
    
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
    
        // RATING & STUDENTS
      
                ],
    );
              
  }
}
