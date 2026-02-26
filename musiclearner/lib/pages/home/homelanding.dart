// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_provider.dart';
import 'package:musiclearner/components/quickaccess.dart';

class Homelanding extends StatelessWidget {
  const Homelanding({super.key});

  Future<String?> _getStudentName(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final rollNo = authProvider.studentProfile?['student_rollno'];

    if (rollNo == null) return "STUDENT";

    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('student')
          .select('student_name')
          .eq('student_rollno', rollNo)
          .maybeSingle();

      return response?['student_name'];
    } catch (e) {
      return "STUDENT";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pushNamed('profile'),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500&auto=format&fit=crop&q=60",
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "WELCOME BACK",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          FutureBuilder<String?>(
                            future: _getStudentName(context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFB7BDF7),
                                  ),
                                );
                              }
                              // Displays fetched name or fallback to "KEERTHAN"
                              final displayName = snapshot.data ?? "KEERTHAN"; 
                              return Text(
                                displayName.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  letterSpacing: 1.6,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(
                        "https://t3.ftcdn.net/jpg/04/91/76/62/360_F_491766294_h4j7LbW2YgfbNHhq7F8GboIc1XyBSEY5.jpg",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2140),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.white54),
                    hintText: "Search for anything...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Quick Access",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xFFB7BDF7),
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  HomeIconButton(
                    icon: Icons.description,
                    title: "Admission\ndetails",
                    backgroundColor: const Color(0xFFB7BDF7).withOpacity(0.2),
                    iconcolor: const Color(0xFFB7BDF7),
                    onTap: () => context.pushNamed('admissiondetails'),
                  ),
                  const SizedBox(height: 20),
                  HomeIconButton(
                    icon: Icons.money,
                    title: "Pending\nfees",
                    iconcolor: const Color(0xFFB7BDF7),
                    backgroundColor: const Color(0xFFB7BDF7).withOpacity(0.2),
                    onTap: () => context.go('/fees'),
                  ),
                  const SizedBox(height: 20),
                  HomeIconButton(
                    icon: Icons.article,
                    iconcolor: const Color(0xFFB7BDF7),
                    title: "Admission\nfee",
                    backgroundColor: const Color(0xFFB7BDF7).withOpacity(0.2),
                    onTap: () => context.go('/fees'),
                  ),
                  const SizedBox(height: 20),
                  HomeIconButton(
                    icon: Icons.upload,
                    iconcolor: const Color(0xFFB7BDF7),
                    title: "Upload\nDocuments",
                    backgroundColor: const Color(0xFFB7BDF7).withOpacity(0.2),
                    onTap: () => context.pushNamed('documents'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
            const Center(
              child: Text(
                "Developed by Red Media Solutions",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}