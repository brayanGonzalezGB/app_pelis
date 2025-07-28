import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/tmdb_api_service.dart';

final tmdbApiServiceProvider =
    Provider<TMDBApiService>((ref) => TMDBApiService());

final popularMoviesProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.read(tmdbApiServiceProvider).fetchPopularMovies();
});

final popularSeriesProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.read(tmdbApiServiceProvider).fetchPopularSeries();
});

final popularActorsProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.read(tmdbApiServiceProvider).fetchPopularActors();
});

final topRatedMoviesProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.read(tmdbApiServiceProvider).fetchTopRatedMovies();
});

final nowPlayingMoviesProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.read(tmdbApiServiceProvider).fetchNowPlayingMovies();
});

final upcomingMoviesProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.read(tmdbApiServiceProvider).fetchUpcomingMovies();
});

// Provider for search functionality
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchMoviesProvider = FutureProvider<List<dynamic>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.read(tmdbApiServiceProvider).searchMovies(query);
});

final searchSeriesProvider = FutureProvider<List<dynamic>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.read(tmdbApiServiceProvider).searchSeries(query);
});

final searchPeopleProvider = FutureProvider<List<dynamic>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return ref.read(tmdbApiServiceProvider).searchPeople(query);
});

// Provider for movies by genre
final moviesByGenreProvider =
    FutureProvider.family<List<dynamic>, int>((ref, genreId) async {
  return ref.read(tmdbApiServiceProvider).fetchMoviesByGenre(genreId);
});

// Genre mapping for categories
class GenreMap {
  static const Map<String, int> genres = {
    'Accion': 28,
    'Aventura': 12,
    'Caricatura': 16, // Animation
    'Terror': 27,
    'Superheroes': 878, // Science Fiction (closest to superheroes)
    'Suspenso': 53, // Thriller
    'Comedia': 35,
    'Drama': 18,
    'Romance': 10749,
    'Crimen': 80,
  };
}
