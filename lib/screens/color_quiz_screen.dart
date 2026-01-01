// Import the Flutter Material library (provides widgets, themes, colors, etc.)
import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Define a StatefulWidget called ColorQuizScreen (because quiz state changes)
class ColorQuizScreen extends StatefulWidget {
  // Constructor with optional key (super.key passes it to the parent class)
  const ColorQuizScreen({super.key, required this.userId});

  final int userId;

  // Create the state object for this widget
  @override
  State<ColorQuizScreen> createState() => _ColorQuizScreenState();
}

// Define the State class that holds the mutable data for ColorQuizScreen
class _ColorQuizScreenState extends State<ColorQuizScreen> {
  // Track the current question index
  int currentQuestion = 0;

  // Track the user's score
  int score = 0;

  // List of quiz questions, each with text, options, and the correct answer
  final List<Map<String, dynamic>> questions = [
    {
      "question": "What color do you get when you mix Red and Blue?",
      "options": <String>["Green", "Purple", "Orange", "Yellow"],
      "answer": "Purple",
    },
    {
      "question": "What color do you get when you mix Red and Yellow?",
      "options": <String>["Orange", "Pink", "Brown", "Grey"],
      "answer": "Orange",
    },
    {
      "question": "What color do you get when you mix Blue and Yellow?",
      "options": <String>["Green", "Purple", "Cyan", "Brown"],
      "answer": "Green",
    },
  ];

  // Function to check if the selected answer is correct
  void checkAnswer(String selected) {
    // Get the correct answer for the current question
    final String correct = questions[currentQuestion]["answer"] as String;

    // If selected answer matches, increase score
    if (selected == correct) {
      score++;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
      });
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    try {
      await submitQuizResult(widget.userId, score);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save quiz result: $e')),
        );
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quiz submitted!')),
    );
    Navigator.pop(context);
  }

  // Helper function to convert a color name string into a Flutter Color
  Color _getColor(String name) {
    switch (name.toLowerCase()) {
      case "red":
        return Colors.red;
      case "blue":
        return Colors.blue;
      case "yellow":
        return Colors.yellow;
      case "green":
        return Colors.green;
      case "purple":
        return Colors.purple;
      case "orange":
        return Colors.orange;
      case "pink":
        return Colors.pink;
      case "brown":
        return Colors.brown;
      case "grey":
        return Colors.grey;
      case "cyan":
        return Colors.cyan;
      default:
        return Colors.black; // Default if no match
    }
  }

  // Build method: describes how the UI should look
  @override
  Widget build(BuildContext context) {
    // Get the current question map
    final Map<String, dynamic> q = questions[currentQuestion];

    // Extract question text
    final String questionText = q["question"] as String;

    // Extract options list
    final List<String> options = List<String>.from(q["options"] as List);

    // Return the main screen layout
    return Scaffold(
      // App bar with title
      appBar: AppBar(title: const Text("Color Quiz")),

      // Body of the screen
      body: Center( 
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              // Display the question text, coloring words if they match color names
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  children: questionText.split(" ").map((word) {
                    final color = _getColor(word);
                    return TextSpan(
                      text: "$word ",
                      style: TextStyle(
                        color: color == Colors.black 
                          ? Colors.deepOrange.shade700 // fallback color
                          : color,
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Add spacing between question and options
              const SizedBox(height: 40),
              
              // Generate a button for each option
              ...options.map((opt) {
                final color = _getColor(opt);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    // When pressed, check the answer
                    onPressed: () => checkAnswer(opt),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color, // button background color
                      foregroundColor: color.computeLuminance() > 0.5 
                        ? Colors.black // text color for light backgrounds
                        : Colors.white, // text color for dark backgrounds
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // rounded corners
                      ),
                    ),
                    child: Text(
                      opt, // option text
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
