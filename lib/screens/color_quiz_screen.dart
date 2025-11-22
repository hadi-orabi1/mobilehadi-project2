import 'package:flutter/material.dart';

class ColorQuizScreen extends StatefulWidget {
  const ColorQuizScreen({super.key});

  @override
  State<ColorQuizScreen> createState() => _ColorQuizScreenState();
}

class _ColorQuizScreenState extends State<ColorQuizScreen> {
  int currentQuestion = 0;
  int score = 0;

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

  void checkAnswer(String selected) {
    final String correct = questions[currentQuestion]["answer"] as String;
    if (selected == correct) {
      score++;
    }
    setState(() {
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Quiz Finished!"),
            content: Text("Your score: $score / ${questions.length}"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    });
  }

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
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> q = questions[currentQuestion];
    final String questionText = q["question"] as String;
    final List<String> options = List<String>.from(q["options"] as List);

    return Scaffold(
      appBar: AppBar(title: const Text("Color Quiz")),
      body: Center( 
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  children: questionText.split(" ").map((word) {
                    final color = _getColor(word);
                    return TextSpan(
                      text: "$word ",
                      style: TextStyle(color: color == Colors.black ? Colors.deepOrange.shade700 : color),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 40),
              
              ...options.map((opt) {
                final color = _getColor(opt);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () => checkAnswer(opt),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      opt,
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
