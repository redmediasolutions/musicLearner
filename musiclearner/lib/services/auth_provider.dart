import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Stores the logged-in student's record from the 'profile' table
  Map<String, dynamic>? _studentProfile;
  bool _isLoading = false;

  Map<String, dynamic>? get studentProfile => _studentProfile;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _studentProfile != null;

  /// LOGIN LOGIC
  /// Directly queries the 'profile' table for student_email or student_rollno
  Future<void> login(String identifier, String password) async {
    // 1. Validation
    if (identifier.trim().isEmpty || password.trim().isEmpty) {
      throw const AuthException("Email/Roll Number and password are required");
    }

    _isLoading = true;
    notifyListeners();

    try {
      final cleanId = identifier.trim();
      final cleanPass = password.trim();

      // 2. Direct Database Query 
      // We use the exact column names from your profile table screenshot
      final response = await _supabase
          .from('profile')
          .select()
          .or('student_email.eq.$cleanId,student_rollno.eq.$cleanId')
          .eq('student_password', cleanPass)
          .maybeSingle();

      // DEBUG: Check your console to see if the DB returned data or null
      debugPrint("Login Query Identifier: $cleanId");
      debugPrint("Login Query Result: $response");

      if (response == null) {
        // If this is null, the combination of ID and Password was not found
        throw const AuthException("Invalid Email/Roll Number or Password");
      }

      // 3. Set Session
      _studentProfile = response;
      notifyListeners();

    } catch (e) {
      debugPrint("Detailed Login Error: $e");
      rethrow; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    _studentProfile = null;
    notifyListeners();
  }

  /// Helper: Get the Roll Number for the currently logged-in user
  String? get currentRollNo => _studentProfile?['student_rollno'];
}