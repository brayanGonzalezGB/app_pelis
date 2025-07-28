import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBApiService {
  static const String _apiKey = '929c6319b2f797e5936691fbf840194b';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  Future<List<dynamic>> fetchPopularMovies() async {
    final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=es-ES'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    }
    throw Exception('Error al cargar películas populares');
  }

  Future<List<dynamic>> fetchPopularSeries() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/tv/popular?api_key=$_apiKey&language=es-ES'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    }
    throw Exception('Error al cargar series populares');
  }

  Future<List<dynamic>> fetchPopularActors() async {
    final response = await http.get(
        Uri.parse('$_baseUrl/person/popular?api_key=$_apiKey&language=es-ES'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    }
    throw Exception('Error al cargar actores populares');
  }

  Future<List<dynamic>> searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&language=es-ES&query=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    }
    throw Exception('Error al buscar películas');
  }

  Future<List<dynamic>> searchSeries(String query) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/search/tv?api_key=$_apiKey&language=es-ES&query=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    }
    throw Exception('Error al buscar series');
  }

  Future<List<dynamic>> searchPeople(String query) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/search/person?api_key=$_apiKey&language=es-ES&query=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    }
    throw Exception('Error al buscar personas');
  }

  Future<List<dynamic>> fetchMoviesByGenre(int genreId) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/discover/movie?api_key=$_apiKey&language=es-ES&with_genres=$genreId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    }
    throw Exception('Error al cargar películas por género');
  }

  Future<List<dynamic>> fetchTopRatedMovies() async {
    final response = await http.get(
        Uri.parse('$_baseUrl/movie/top_rated?api_key=$_apiKey&language=es-ES'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    }
    throw Exception('Error al cargar películas mejor calificadas');
  }

  Future<List<dynamic>> fetchNowPlayingMovies() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=es-ES'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    }
    throw Exception('Error al cargar películas en cartelera');
  }

  Future<List<dynamic>> fetchUpcomingMovies() async {
    final response = await http.get(
        Uri.parse('$_baseUrl/movie/upcoming?api_key=$_apiKey&language=es-ES'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    }
    throw Exception('Error al cargar próximas películas');
  }

  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return 'images/avengers.png'; // Ruta por defecto si no hay imagen
    }
    final imageUrl = '$_imageBaseUrl$path';
    return imageUrl;
  }
}
