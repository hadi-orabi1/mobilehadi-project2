import 'package:flutter/material.dart';
import 'screens/welcome_page.dart'; 

void main() {
  runApp(const ColorTheoryApp());
}

class ColorTheoryApp extends StatelessWidget {
  const ColorTheoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kids Colors Game',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
        ),
      ),
      home: const WelcomePage(), 
    );
  }
}
