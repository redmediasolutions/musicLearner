import 'package:flutter/material.dart';
import 'package:musiclearner/services/nav.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Music());
}

class Music extends StatelessWidget {
  const Music({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      routerConfig:router, 
      
    );
  }
}
