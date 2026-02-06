import 'package:flutter/material.dart';
import 'package:musiclearner/services/nav.dart';


void main() {
  runApp(const Music());
}

class Music extends StatelessWidget {
  const Music({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig:router, 
      
    );
  }
}
