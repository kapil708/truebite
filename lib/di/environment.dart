import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  // API
  static String get apiUrl => dotenv.get('API_URL');
  static String get baseUrl => dotenv.get('BASE_URL');

  // Gemini
  static String get geminiApiKey => dotenv.get('GEMINI_API_KEY');
}
