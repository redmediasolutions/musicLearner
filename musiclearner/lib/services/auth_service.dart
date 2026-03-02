import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Getters for current auth state
  User? get currentUser => _supabase.auth.currentUser;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// RESOLVE IDENTIFIER
  /// Determines if the input is an email or a roll number.
  /// If it's a roll number, it fetches the corresponding email from the 'student' table.
  Future<String> resolveEmail(String identifier) async {
    // If it contains '@', assume it is an email
    if (identifier.contains('@')) return identifier;

    // Otherwise, look up the email using student_rollno
    final data = await _supabase
        .from('student')
        .select('email')
        .eq('student_rollno', identifier)
        .maybeSingle();

    if (data == null) {
      throw Exception("Roll number '$identifier' not found.");
    }

    return data['email'] as String;
  }

  /// SIGN IN
  /// Validates credentials against Supabase Auth.
  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// FETCH STUDENT PROFILE
  /// Retrieves the full row from the 'student' table using the user's UID.
  Future<Map<String, dynamic>?> getStudentProfile(String userId) async {
    final data = await _supabase
        .from('student')
        .select()
        .eq('user_id', userId) 
        .maybeSingle();
    return data;
  }

  /// SIGN OUT
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}