import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: const Text(
          "MUSIC MASTERY",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 1.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Image.network(
                'https://img.icons8.com/fluency/96/music.png',
                height: 70,
              ),
            ),
            const SizedBox(height: 30),

            // Title
            const Text(
              "Breakthrough\nAcademy",
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
              "Unlock your sound with affordable music\ncourses.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.4,
              ),
            ),
                 const SizedBox(height: 20),
             const Text(
              "Email or Username",
              style: TextStyle(color: Color.fromARGB(240, 255, 255, 255), 
              fontSize: 14,
               fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E2140),
                borderRadius: BorderRadius.circular(12),
                
              ),
              
              child: const TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  border: InputBorder.none,
                  hintText: "Enter your Email or Username",
                  prefixIcon: Icon(
                    Icons.mail_outline_rounded,
                    color: Colors.white38,
                  ),
                  
                  hintStyle: TextStyle(color: Colors.white38),
                ),
                
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Password",
                  style: TextStyle(
                      color: Color.fromARGB(240, 255, 255, 255),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                context.pushNamed('forgotpassword');

                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Color(0xFF1437EF),
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E2140),
                borderRadius: BorderRadius.circular(12),
                
              ),
              
              child: const TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  border: InputBorder.none,
                  hintText: "Enter your password",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white38,
                  ),
                  suffixIcon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white38,
                  ),
                  
                  hintStyle: TextStyle(color: Colors.white38),
                ),
                
              ),
            ),
            const  SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    context.pushNamed('homelanding');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1437EF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // OR CONTINUE WITH
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
  child: Row(
    children: [
      Expanded(child: Container(height: 1, color: Colors.white12)),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          "OR CONTINUE WITH",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Expanded(child: Container(height: 1, color: Colors.white12)),
    ],
  ),
),


Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Row(
    children: [

      // APPLE BUTTON
      Expanded(
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
            color: const Color(0xFF1E2140),
          ),
          child: const Center(
            child: Icon(
              Icons.apple,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),

      const SizedBox(width: 14),

      // GOOGLE BUTTON
      Expanded(
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white12),
            color: const Color(0xFF1E2140),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // Icon(
                //   Icons.circle_outlined,  
                //   color: Colors.white,
                //   size: 14,
                // ),
                SizedBox(width: 10),
                Text(
                  "GOOGLE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    ],
  ),
),
const SizedBox(height: 20),
  Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Dont have an account? ",
                    style: TextStyle(
                      color: Color(0xFF8A93BE),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                     context.pushNamed('signuppage');

                    }, // Geos  to Login
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFF1437EF),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),


          ]
        ),
      ),
    );
  }
}
