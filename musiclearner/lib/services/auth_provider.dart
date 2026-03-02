import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? user;
  Map<String, dynamic>? studentData;
  bool isLoading = false;

  AuthProvider() {
    _initialize();
  }

  /// Initialize state and listen for auth changes
  void _initialize() {
    user = _authService.currentUser;

    if (user != null) {
      loadStudentProfile();
    }

    // Auth listener handles automatic state updates for GoRouter
    _authService.authStateChanges.listen((data) async {
      user = data.session?.user;

      if (user != null) {
        await loadStudentProfile();
      } else {
        studentData = null;
        notifyListeners();
      }
    });
  }

  /// REQUIRED GETTER FOR GOROUTER
  bool get isLoggedIn => user != null;

  /// LOAD STUDENT PROFILE
  /// Populates studentData with info from the 'student' table.
  Future<void> loadStudentProfile() async {
    if (user == null) return;
    
    studentData = await _authService.getStudentProfile(user!.id);
    notifyListeners();
  }

  /// LOGIN LOGIC
  /// Handles both Roll Number and Email inputs.
  Future<void> login(String identifier, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      // 1. Resolve identifier to a valid email
      String resolvedEmail = await _authService.resolveEmail(identifier.trim());

      // 2. Perform Supabase Sign-in
      await _authService.signIn(email: resolvedEmail, password: password);

      // Note: loadStudentProfile is triggered automatically by the listener
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// LOGOUT LOGIC
  /// Clears user session and notifies listeners to trigger GoRouter redirect.
  Future<void> logout() async {
    try {
      await _authService.signOut();
      user = null;
      studentData = null;
      notifyListeners();
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }
}