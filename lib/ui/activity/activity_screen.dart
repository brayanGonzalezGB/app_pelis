import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../providers/tmdb_provider.dart';
import '../profile/profile_screen.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/movie_list_card.dart';
import '../content/movie_detail_screen.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  final String username;

  const ActivityScreen({Key? key, required this.username}) : super(key: key);

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Recientes', 'Populares', 'Mejor Calificadas'];

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            _buildTabBar(isDark),
            Expanded(
              child: _buildContent(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: isDark ? Colors.white : Colors.grey[600],
              size: 24,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          const ThemeToggleButton(),
          const Spacer(),
          Text(
            '¡Hola, ${widget.username.toUpperCase()}!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileScreen(username: widget.username),
                ),
              );
            },
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.deepPurple,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actividad',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _tabs.asMap().entries.map((entry) {
                int index = entry.key;
                String tab = entry.value;
                bool isSelected = _selectedTab == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Colors.deepPurple : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tab,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.grey[300] : Colors.grey[700]),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    late AsyncValue<List<dynamic>> contentAsync;

    switch (_selectedTab) {
      case 0: // Recientes
        contentAsync = ref.watch(nowPlayingMoviesProvider);
        break;
      case 1: // Populares
        contentAsync = ref.watch(popularMoviesProvider);
        break;
      case 2: // Mejor Calificadas
        contentAsync = ref.watch(topRatedMoviesProvider);
        break;
      default:
        contentAsync = ref.watch(popularMoviesProvider);
    }

    return contentAsync.when(
      data: (movies) => _buildMoviesList(movies, isDark),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error, isDark),
    );
  }

  Widget _buildMoviesList(List<dynamic> movies, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        final imageUrl =
            ref.read(tmdbApiServiceProvider).getImageUrl(movie['poster_path']);

        return _buildActivityItem(
          movie['id'] ?? 0,
          movie['title'] ?? '',
          _getGenreText(movie['genre_ids']),
          movie['overview'] ?? '',
          _getTimeAgo(movie['release_date']),
          imageUrl,
          isDark,
        );
      },
    );
  }

  Widget _buildActivityItem(
    int movieId,
    String title,
    String subtitle,
    String description,
    String time,
    String imagePath,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: MovieListCard(
        title: title,
        subtitle: subtitle,
        description: description.length > 100
            ? '${description.substring(0, 100)}...'
            : description,
        time: time,
        imagePath: imagePath,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(
                movieId: movieId,
                title: title,
                imagePath: imagePath,
                username: widget.username,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(Object error, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar actividad',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(nowPlayingMoviesProvider);
              ref.invalidate(popularMoviesProvider);
              ref.invalidate(topRatedMoviesProvider);
            },
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  String _getGenreText(List<dynamic>? genreIds) {
    if (genreIds == null || genreIds.isEmpty) return 'Película';

    final genreMap = {
      28: 'Acción',
      12: 'Aventura',
      16: 'Animación',
      35: 'Comedia',
      80: 'Crimen',
      99: 'Documental',
      18: 'Drama',
      10751: 'Familiar',
      14: 'Fantasía',
      36: 'Historia',
      27: 'Terror',
      10402: 'Música',
      9648: 'Misterio',
      10749: 'Romance',
      878: 'Ciencia Ficción',
      10770: 'TV Movie',
      53: 'Thriller',
      10752: 'Guerra',
      37: 'Western',
    };

    final firstGenreId = genreIds[0] as int?;
    return genreMap[firstGenreId] ?? 'Película';
  }

  String _getTimeAgo(String? releaseDate) {
    if (releaseDate == null || releaseDate.isEmpty) return 'Hace tiempo';

    try {
      final date = DateTime.parse(releaseDate);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'Hace ${years} año${years > 1 ? 's' : ''}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'Hace ${months} mes${months > 1 ? 'es' : ''}';
      } else if (difference.inDays > 0) {
        return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
      } else {
        return 'Hoy';
      }
    } catch (e) {
      return 'Hace tiempo';
    }
  }
}

class ActivityItem {
  final String title;
  final String subtitle;
  final String description;
  final String time;
  final String? imagePath;

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.time,
    this.imagePath,
  });
}
