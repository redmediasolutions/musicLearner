import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? user;
  Map<String, dynamic>? profile;
  bool isLoading = false;

  AuthProvider() {
    user = _authService.currentUser;

    if (user != null) {
      loadUserProfile();
    }

    _authService.authStateChanges.listen((data) async {
      user = data.session?.user;

      if (user != null) {
        await loadUserProfile();
      } else {
        profile = null;
      }

      notifyListeners();
    });
  }

  Future<void> loadUserProfile() async {
    if (user == null) return;

    profile = await _authService.getUserProfile(user!.id);
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    await _authService.signIn(email: email, password: password);
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    // authStateChanges listener will clear user automatically
  }

  bool get isLoggedIn => user != null;
}
