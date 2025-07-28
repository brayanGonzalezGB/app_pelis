import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get tmdbApiKey => dotenv.env['TMDB_API_KEY'] ?? '';

  // Método para cargar las variables de entorno
  static Future<void> load() async {
    await dotenv.load(fileName: ".env");
  }
}
