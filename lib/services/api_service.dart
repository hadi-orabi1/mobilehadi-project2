import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiRoot = 'http://localhost:5000/api';

Future<Map<String, dynamic>> createUser(String name) async {
  final trimmed = name.trim();
  if (trimmed.isEmpty) {
    throw ArgumentError('Name cannot be empty');
  }

  final response = await http.post(
    Uri.parse('$apiRoot/users'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'name': trimmed}),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to create user: ${response.body}');
  }

  return jsonDecode(response.body) as Map<String, dynamic>;
}

Future<void> submitQuizResult(int userId, int score) async {
  final response = await http.post(
    Uri.parse('$apiRoot/quiz_results'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'score': score}),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to submit quiz result: ${response.body}');
  }
}

Future<List<Map<String, dynamic>>> fetchQuizResults() async {
  final response = await http.get(Uri.parse('$apiRoot/quiz_results'));
  if (response.statusCode != 200) {
    throw Exception('Failed to load quiz results: ${response.body}');
  }

  final data = jsonDecode(response.body) as List<dynamic>;
  return data.cast<Map<String, dynamic>>();
}
