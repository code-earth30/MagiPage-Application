// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}