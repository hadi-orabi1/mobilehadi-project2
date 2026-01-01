// Import Flutter Material library (provides widgets, themes, colors, etc.)
import 'package:flutter/material.dart';

// Import your custom WelcomePage screen (the first screen shown when app starts)
import 'screens/welcome_page.dart'; 

// Entry point of the Flutter app
void main() {
  // runApp launches the root widget of the app
  runApp(const ColorTheoryApp());
}

// Define the root widget of the app (stateless because it doesn’t hold state)
class ColorTheoryApp extends StatelessWidget {
  const ColorTheoryApp({super.key});

  // Build method: describes how the app should look
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Title of the app (used by OS/task manager)
      title: 'Kids Colors Game',

      // Define the global theme of the app
      theme: ThemeData(
        primarySwatch: Colors.deepOrange, // main color theme
        scaffoldBackgroundColor: Colors.grey[100], // background color for screens
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepOrange, // app bar background
          foregroundColor: Colors.white,      // app bar text/icons color
        ),
      ),

      // Set the first screen to show when app starts
      home: const WelcomePage(), 
    );
  }
}
