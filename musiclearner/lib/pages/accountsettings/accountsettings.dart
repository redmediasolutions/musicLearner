// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/auth_provider.dart';

class Accountsettings extends StatefulWidget {
  const Accountsettings({super.key});

  @override
  State<Accountsettings> createState() => _AccountsettingsState();
}

class _AccountsettingsState extends State<Accountsettings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  bool _isNameEditable = false;
  bool _isPhoneEditable = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fillInitialData();
  }

  // Use the data already available in the Provider
  void _fillInitialData() {
    final studentData = context.read<AuthProvider>().studentData;
    if (studentData != null) {
      _nameController.text = studentData['student_name'] ?? studentData['student_name'] ?? "";
      _phoneController.text = studentData['student_Phoneno'] ?? studentData['contact_number'] ?? "";
    }
  }

  void _confirmSave() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1E36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Confirm Changes", style: TextStyle(color: Colors.white)),
          content: const Text("Are you sure you want to update your profile details?", style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.white38)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _saveToDatabase();
              },
              child: const Text("OK", style: TextStyle(color: Color(0xFFB7BDF7), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveToDatabase() async {
    final authProvider = context.read<AuthProvider>();
    final rollNo = authProvider.studentData?['student_rollno'] ?? authProvider.studentData?['student_rollno'];

    if (rollNo == null) return;

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      // Update the single 'students' table based on your new schema
      await supabase.from('student').update({
        'student_name': _nameController.text,
        'student_Phoneno': _phoneController.text,
      }).eq('student_rollno', rollNo);

      // CRITICAL: Refresh the provider data so the Home page name updates too
      await authProvider.loadStudentProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account Settings Updated Successfully"), backgroundColor: Color(0xFF38B982)),
        );
        context.pop();
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
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
          "Account Settings",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _confirmSave,
            child: const Text(
              "Save",
              style: TextStyle(color: Color(0xFFB7BDF7), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFB7BDF7)))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, bottom: 12),
                child: Text(
                  "PERSONAL INFORMATION",
                  style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1E36),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildInlineEditTile(
                    label: "FULL NAME",
                    controller: _nameController,
                    isEditable: _isNameEditable,
                    focusNode: _nameFocus,
                    onIconPressed: () {
                      setState(() {
                        _isNameEditable = !_isNameEditable;
                        if (_isNameEditable) _nameFocus.requestFocus();
                      });
                    },
                  ),
                  const Divider(color: Colors.white12, height: 1, indent: 16, endIndent: 16),
                  _buildInlineEditTile(
                    label: "PHONE NUMBER",
                    controller: _phoneController,
                    isEditable: _isPhoneEditable,
                    focusNode: _phoneFocus,
                    onIconPressed: () {
                      setState(() {
                        _isPhoneEditable = !_isPhoneEditable;
                        if (_isPhoneEditable) _phoneFocus.requestFocus();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineEditTile({
    required String label,
    required TextEditingController controller,
    required bool isEditable,
    required FocusNode focusNode,
    required VoidCallback onIconPressed,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      title: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1)),
      subtitle: isEditable
          ? TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.only(top: 8),
              ),
              onSubmitted: (_) => onIconPressed(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                controller.text.isEmpty ? "Not set" : controller.text,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
      trailing: IconButton(
        icon: Icon(
          isEditable ? Icons.check_circle_rounded : Icons.edit_rounded,
          color: isEditable ? const Color(0xFF38B982) : Colors.white30,
          size: 20,
        ),
        onPressed: onIconPressed,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle, 
              border: Border.all(width: 2, color: const Color(0xFFB7BDF7).withOpacity(0.5))
            ),
          ),
          const CircleAvatar(
            radius: 54,
            backgroundImage: NetworkImage("https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500"),
          ),
        ],
      ),
    );
  }
}