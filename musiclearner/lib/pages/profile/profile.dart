// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the student data from the provider
    final studentData = context.watch<AuthProvider>().studentData;
    
    // Extract name or fallback to "USER"
    final displayName = studentData?['student_name'] ?? 
                        studentData?['student_name'] ?? 
                        "USER";

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0F24),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- PROFILE HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFB7BDF7),
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xFF0D0F24),
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=60",
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // No more FutureBuilder!
                  Text(
                    displayName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    studentData?['student_rollno'] ?? "",
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // --- MENU SECTION ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "GENERAL",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),

                _buildProfileMenuItem(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  title: "Account Settings",
                  routeName: 'accountsettings',
                ),
                _buildProfileMenuItem(
                  context: context,
                  icon: Icons.badge_outlined,
                  title: "Admission Details",
                  routeName: 'admissiondetails',
                ),
                _buildProfileMenuItem(
                  context: context,
                  icon: Icons.folder_open_rounded,
                  title: "Documents",
                  routeName: 'documents',
                ),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      context.read<AuthProvider>().logout();
                      // Navigation is usually handled by auth listener in main.dart
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D2F),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.logout_rounded, color: Colors.redAccent, size: 24),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.redAccent, 
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to keep code clean and scannable
  Widget _buildProfileMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String routeName,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.pushNamed(routeName),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D2F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFFB7BDF7), size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}