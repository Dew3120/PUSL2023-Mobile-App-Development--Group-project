import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const CartierApp());
}

class CartierApp extends StatelessWidget {
  const CartierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Basis',
      ),
      home: const SplashScreen(),
    );
  }
}
