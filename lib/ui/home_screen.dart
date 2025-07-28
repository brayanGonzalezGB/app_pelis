import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/tmdb_provider.dart';
import 'profile/profile_screen.dart';
import 'main_navigation.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/movie_grid_card.dart';
import 'content/series_screen.dart';
import 'content/actors_screen.dart';

class HomeTabScreen extends ConsumerWidget {
  final String username;

  const HomeTabScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, ref),
              const SizedBox(height: 20),
              _buildHeroBanner(ref),
              const SizedBox(height: 24),
              _buildCategories(context, ref),
              const SizedBox(height: 32),
              _buildMoviesSection(ref),
              const SizedBox(height: 32),
              _buildTrailersSection(ref),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

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
            '¡Hola, ${username.toUpperCase()}!',
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
                  builder: (context) => ProfileScreen(username: username),
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

  Widget _buildHeroBanner(WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final nowPlayingAsync = ref.watch(nowPlayingMoviesProvider);

    return nowPlayingAsync.when(
      data: (movies) {
        if (movies.isEmpty) return _buildPlaceholderBanner(isDark);

        final featuredMovie = movies[0];
        final imageUrl = ref
            .read(tmdbApiServiceProvider)
            .getImageUrl(featuredMovie['backdrop_path']);

        return Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _buildPlaceholderBanner(isDark),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildPlaceholderBanner(isDark);
                    },
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      featuredMovie['title'] ?? 'Película Destacada',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'En cartelera • ⭐ ${featuredMovie['vote_average']?.toString() ?? 'N/A'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _buildPlaceholderBanner(isDark),
      error: (_, __) => _buildPlaceholderBanner(isDark),
    );
  }

  Widget _buildPlaceholderBanner(bool isDark) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: isDark ? Colors.grey[700] : Colors.grey[400],
              child: Center(
                child: Icon(
                  Icons.movie,
                  size: 60,
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Cargando películas...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildCategoryChip('Películas', true, ref, null),
          const SizedBox(width: 12),
          _buildCategoryChip('Series', false, ref, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeriesScreen(username: username),
              ),
            );
          }),
          const SizedBox(width: 12),
          _buildCategoryChip('Actores Populares', false, ref, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActorsScreen(username: username),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      String label, bool isSelected, WidgetRef ref, VoidCallback? onTap) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.deepPurple
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey[300] : Colors.grey[700]),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesSection(WidgetRef ref) {
    final moviesAsync = ref.watch(popularMoviesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Películas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ref.watch(themeProvider) == ThemeMode.dark
                      ? Colors.white
                      : Colors.grey[800],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: moviesAsync.when(
            data: (movies) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final imageUrl = ref
                    .read(tmdbApiServiceProvider)
                    .getImageUrl(movie['poster_path']);
                return _buildMovieCard(
                  movie['title'] ?? '',
                  imageUrl,
                  ref,
                  overview: movie['overview'] ?? '',
                  releaseDate: movie['release_date'] ?? '',
                  rating: movie['vote_average']?.toString() ?? '',
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailersSection(WidgetRef ref) {
    final upcomingMoviesAsync = ref.watch(upcomingMoviesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Próximas Películas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ref.watch(themeProvider) == ThemeMode.dark
                      ? Colors.white
                      : Colors.grey[800],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: upcomingMoviesAsync.when(
            data: (movies) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: movies.length > 10 ? 10 : movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final imageUrl = ref
                    .read(tmdbApiServiceProvider)
                    .getImageUrl(movie['poster_path']);
                return _buildMovieCard(
                  movie['title'] ?? '',
                  imageUrl,
                  ref,
                  overview: movie['overview'] ?? '',
                  releaseDate: movie['release_date'] ?? '',
                  rating: movie['vote_average']?.toString() ?? '',
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(
    String movieName,
    String imagePath,
    WidgetRef ref, {
    String overview = '',
    String releaseDate = '',
    String rating = '',
  }) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: ref.context,
            builder: (context) => AlertDialog(
              title: Text(movieName),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(imagePath,
                      height: 120,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image)),
                  const SizedBox(height: 12),
                  Text('Descripción: $overview'),
                  const SizedBox(height: 8),
                  Text('Fecha de estreno: $releaseDate'),
                  const SizedBox(height: 8),
                  Text('Calificación: $rating'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          );
        },
        child: MovieGridCard(
          title: movieName,
          imagePath: imagePath,
          onTap: null,
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  final String username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigation(username: username),
        ),
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
