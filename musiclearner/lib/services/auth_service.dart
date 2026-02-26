import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> loginWithProfile({
    required String identifier,
    required String password,
  }) async {
    // We must use these exact column names from your screenshot
    final response = await supabase
        .from('profile')
        .select()
        .or('student_email.eq.$identifier,student_rollno.eq.$identifier')
        .eq('student_password', password)
        .maybeSingle();

    if (response == null) {
      // If this triggers, either the identifier or password doesn't match the row
      throw const AuthException("Invalid Email/Roll Number or Password");
    }

    return response;
  }
}