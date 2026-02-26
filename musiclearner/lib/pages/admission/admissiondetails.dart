import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_provider.dart';
import 'package:musiclearner/components/eachdetails.dart';
import 'package:musiclearner/components/quickstatcard.dart';

class Admissiondetails extends StatelessWidget {
  const Admissiondetails({super.key});

  Future<Map<String, dynamic>?> _fetchFullAdmissionData(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    final rollNo = authProvider.studentProfile?['student_rollno'];

    if (rollNo == null) return null;

    final supabase = Supabase.instance.client;
    return await supabase
        .from('student')
        .select()
        .eq('student_rollno', rollNo)
        .maybeSingle();
  }

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFFB7BDF7);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101322),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        ),
        title: const Text(
          "My Admission Details",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchFullAdmissionData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: accentColor));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data not found", style: TextStyle(color: Colors.white)));
          }

          final d = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Highlight Stats
                Row(
                  children: [
                    Expanded(
                      child: Quickstatcard(
                        label: "Grade",
                        value: d['grade'] ?? "N/A",
                        icon: Icons.school_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Quickstatcard(
                        label: "Roll No",
                        value: d['student_rollno'] ?? "N/A",
                        icon: Icons.badge_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // 01. Personal Details
                _sectionHeader("01. Personal Details", accentColor),
                Eachdetail(label: "Full Name", value: d['student_name'] ?? "N/A"),
                Eachdetail(label: "Date of Birth", value: d['date_of_birth'] ?? "N/A"),
                Eachdetail(label: "Gender", value: d['gender'] ?? "N/A"),
                Eachdetail(label: "Aadhaar Number", value: d['aadhar_number'] ?? "N/A"),
                Eachdetail(label: "Email", value: d['email'] ?? "N/A"),
                Eachdetail(label: "Contact", value: d['contact_number'] ?? "N/A"),

                const SizedBox(height: 24),

                // 02. Academic Details
                _sectionHeader("02. Academic Details", accentColor),
                Eachdetail(label: "Previous School", value: d['school_name'] ?? "N/A"),
                Eachdetail(label: "Last CGPA / %", value: d['cgpa'] ?? "N/A"),

                const SizedBox(height: 24),

                // 03. Family Details
                _sectionHeader("03. Family Details", accentColor),
                Eachdetail(label: "Father's Name", value: d['fathers_name'] ?? "N/A"),
                Eachdetail(label: "Father's Job", value: d['fathers_occupation'] ?? "N/A"),
                Eachdetail(label: "Mother's Name", value: d['mothers_name'] ?? "N/A"),
                Eachdetail(label: "Mother's Job", value: d['mothers_occupation'] ?? "N/A"),

                const SizedBox(height: 24),

                // 04. Background & Address
                _sectionHeader("04. Background & Address", accentColor),
                Eachdetail(label: "Category", value: d['caste_category'] ?? "N/A"),
                Eachdetail(label: "Religion", value: d['religion'] ?? "N/A"),
                Eachdetail(label: "Address", value: d['home_address'] ?? "N/A"),
                Eachdetail(label: "City", value: "${d['city'] ?? ''}, ${d['state'] ?? ''}"),
                Eachdetail(label: "Pincode", value: d['pincode'] ?? "N/A"),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        const Divider(color: Colors.white24, thickness: 1, height: 20),
      ],
    );
  }
}