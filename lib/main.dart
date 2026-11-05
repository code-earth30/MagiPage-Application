import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Connects to home screen file

void main() {
  runApp(const MagiPageApp());
}

class MagiPageApp extends StatelessWidget {
  const MagiPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MagiPage',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(), // Loads our screen YAYAYAYAY
    );
  }
}