import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../providers/tmdb_provider.dart';
import '../widgets/feedback_modal.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int movieId;
  final String title;
  final String? imagePath;
  final String username;

  const MovieDetailScreen({
    Key? key,
    required this.movieId,
    required this.title,
    this.imagePath,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final movieDetails = ref.watch(movieDetailsProvider(movieId));
    final movieCredits = ref.watch(movieCreditsProvider(movieId));
    final movieProviders = ref.watch(movieProvidersProvider(movieId));

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: movieDetails.when(
          data: (details) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isDark),
                _buildMovieImage(isDark, details),
                _buildMovieInfo(isDark, details),
                _buildCastSection(isDark, movieCredits),
                _buildWatchedBySection(isDark, movieProviders),
                _buildFeedbackButton(context, isDark),
                const SizedBox(height: 20),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: isDark ? Colors.white : Colors.grey[600],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar los detalles de la película',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Volver'),
                ),
              ],
            ),
          ),
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
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.grey[600],
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: isDark ? Colors.white : Colors.grey[600],
              size: 24,
            ),
            onPressed: () {},
          ),
          const Spacer(),
          Text(
            'Hola $username!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.deepPurple,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieImage(bool isDark, Map<String, dynamic> movieDetails) {
    final backdropPath = movieDetails['backdrop_path'];
    final posterPath = movieDetails['poster_path'];

    return Container(
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        image: backdropPath != null
            ? DecorationImage(
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500$backdropPath',
                ),
                fit: BoxFit.cover,
              )
            : posterPath != null
                ? DecorationImage(
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500$posterPath',
                    ),
                    fit: BoxFit.cover,
                  )
                : null,
      ),
      child: Stack(
        children: [
          if (backdropPath == null && posterPath == null)
            const Center(
              child: Icon(
                Icons.movie,
                size: 60,
                color: Colors.grey,
              ),
            ),
          Center(
            child: Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          const Positioned(
            bottom: 16,
            left: 16,
            child: Text(
              'Reproducir trailer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[400],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '${movieDetails['vote_average']?.toStringAsFixed(1) ?? 'N/A'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieInfo(bool isDark, Map<String, dynamic> movieDetails) {
    final releaseDate = movieDetails['release_date'];
    final runtime = movieDetails['runtime'];
    final genres = movieDetails['genres'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            movieDetails['title'] ?? title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (releaseDate != null) ...[
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  releaseDate.substring(0, 4), // Año
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
              ],
              if (runtime != null) ...[
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${runtime}min',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
          if (genres.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: genres.take(3).map((genre) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    genre['name'],
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.deepPurple[200]
                          : Colors.deepPurple[700],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'Descripción',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movieDetails['overview'] ?? 'No hay descripción disponible.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastSection(
      bool isDark, AsyncValue<List<dynamic>> movieCredits) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actores y Actrices',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: movieCredits.when(
              data: (cast) => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cast.length > 10 ? 10 : cast.length,
                itemBuilder: (context, index) {
                  final actor = cast[index];
                  final profilePath = actor['profile_path'];
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[700] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(6),
                            image: profilePath != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w200$profilePath',
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: profilePath == null
                              ? Icon(
                                  Icons.person,
                                  color: Colors.grey[500],
                                  size: 30,
                                )
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          actor['name'] ?? 'Desconocido',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Error al cargar reparto',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchedBySection(
      bool isDark, AsyncValue<Map<String, dynamic>> movieProviders) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disponible en',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: movieProviders.when(
              data: (providers) {
                final countryProviders = providers['MX'] ?? providers['US'];
                if (countryProviders == null) {
                  return Center(
                    child: Text(
                      'No hay información de proveedores disponible',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  );
                }

                final flatrate =
                    countryProviders['flatrate'] as List<dynamic>? ?? [];
                final buy = countryProviders['buy'] as List<dynamic>? ?? [];
                final rent = countryProviders['rent'] as List<dynamic>? ?? [];

                final allProviders = [...flatrate, ...buy, ...rent];

                if (allProviders.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay proveedores disponibles',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allProviders.length > 6 ? 6 : allProviders.length,
                  itemBuilder: (context, index) {
                    final provider = allProviders[index];
                    final logoPath = provider['logo_path'];
                    return Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(25),
                        image: logoPath != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w200$logoPath',
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: logoPath == null
                          ? Icon(
                              Icons.play_circle_fill,
                              color: Colors.grey[500],
                              size: 30,
                            )
                          : null,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Error al cargar proveedores',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackButton(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierColor: Colors.black.withValues(alpha: 0.7),
              builder: (context) => FeedbackModal(
                onClose: () {
                  Navigator.of(context).pop();
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Genera una reseña',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
