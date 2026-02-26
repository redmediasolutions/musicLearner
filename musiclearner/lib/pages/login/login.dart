// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/auth_provider.dart'; 

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final authProvider = context.read<AuthProvider>();
    
    if (authProvider.isLoading) return;

    FocusScope.of(context).unfocus();
    final identifier = emailcontroller.text.trim();
    final password = passwordcontroller.text.trim();
    final messenger = ScaffoldMessenger.of(context);

    if (identifier.isEmpty || password.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Email/Roll Number and password are required')),
      );
      return;
    }

    try {
      await authProvider.login(identifier, password);

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: const Text('Login successful'), backgroundColor: Colors.white),
        );
        context.go('/home'); 
      }
    } catch (e) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials or network error'),
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    const Color accentColor = Color(0xFFB7BDF7);

    return Scaffold(
      backgroundColor: const Color(0xFF101322),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Image.network(
                  'https://img.icons8.com/fluency/96/music.png',
                  height: 70,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Academy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Unlock your musical potential",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              _buildInputLabel("Email or Roll Number"),
              const SizedBox(height: 6),
              _buildTextField(
                controller: emailcontroller,
                hintText: "Enter Your Details",
                icon: Icons.person_outline,
                accentColor: accentColor,
              ),
              
              const SizedBox(height: 20),

              _buildInputLabel("Password"),
              const SizedBox(height: 6),
              _buildTextField(
                controller: passwordcontroller,
                hintText: "Enter Your Password",
                icon: Icons.lock_outline,
                isPassword: true,
                accentColor: accentColor,
              ),

              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pushNamed('signuppage'),
                    child: const Text(
                      "Register Now",
                      style: TextStyle(color: accentColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed('forgotpassword'),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: accentColor, fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),

              SizedBox(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: isLoading ? null : _login,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 100),
              const Text(
                "Developed by Red Media Solutions",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Container(
      width: 400,
      alignment: Alignment.centerLeft,
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required Color accentColor,
    bool isPassword = false,
  }) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2140),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              )
            : null,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accentColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}