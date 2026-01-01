import 'package:flutter/material.dart';
import '../services/api_service.dart';

class QuizResultsPage extends StatefulWidget {
  const QuizResultsPage({super.key});

  @override
  State<QuizResultsPage> createState() => _QuizResultsPageState();
}

class _QuizResultsPageState extends State<QuizResultsPage> {
  final List<Map<String, dynamic>> _quizResults = [];
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  Future<void> _fetchQuizResults() async {
    final results = await fetchQuizResults();
    setState(() {
      _quizResults
        ..clear()
        ..addAll(results);
    });
  }

  Future<void> _addQuizResult() async {
    final userId = int.tryParse(_userIdController.text.trim());
    final score = int.tryParse(_scoreController.text.trim());
    if (userId == null || score == null) {
      return;
    }

    await submitQuizResult(userId, score);
    _userIdController.clear();
    _scoreController.clear();
    await _fetchQuizResults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchQuizResults,
              child: const Text('Load Quiz Results'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _quizResults.length,
                itemBuilder: (context, index) {
                  final result = _quizResults[index];
                  return ListTile(
                    title: Text('User ID: ${result['user_id']}'),
                    subtitle: Text('Score: ${result['score']}'),
                  );
                },
              ),
            ),
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _scoreController,
              decoration: const InputDecoration(labelText: 'Score'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addQuizResult,
              child: const Text('Add Quiz Result'),
            ),
          ],
        ),
      ),
    );
  }
}
