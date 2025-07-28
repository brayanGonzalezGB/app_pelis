import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../providers/tmdb_provider.dart';
import '../profile/profile_screen.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/movie_list_card.dart';
import '../content/movie_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String username;

  const SearchScreen({Key? key, required this.username}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Películas';
  final List<String> _searchCategories = ['Películas', 'Series', 'Personas'];
  final List<String> _genreCategories = [
    'Accion',
    'Caricatura',
    'Terror',
    'Superheroes',
    'Suspenso',
    'Aventura'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        ref.read(searchQueryProvider.notifier).state = _searchController.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            _buildSearchBar(isDark),
            _buildSearchCategories(isDark),
            _buildGenreCategories(isDark),
            Expanded(
              child: _buildSearchResults(isDark),
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

  Widget _buildSearchBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar películas, series, personas...',
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                )
              : Icon(Icons.tune, color: Colors.grey[600]),
          filled: true,
          fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            ref.read(searchQueryProvider.notifier).state = value;
          }
        },
      ),
    );
  }

  Widget _buildSearchCategories(bool isDark) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _searchCategories.length,
        itemBuilder: (context, index) {
          final category = _searchCategories[index];
          final isSelected = _selectedCategory == category;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.deepPurple
                      : (isDark ? Colors.grey[800] : Colors.grey[300]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.grey[800]),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenreCategories(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            'Categorías por Género',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
        ),
        Container(
          height: 80,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.4,
            ),
            itemCount: _genreCategories.length,
            itemBuilder: (context, index) {
              final genre = _genreCategories[index];
              return GestureDetector(
                onTap: () {
                  _searchByGenre(genre);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      genre,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _searchByGenre(String genre) {
    final genreId = GenreMap.genres[genre];
    if (genreId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenreResultsScreen(
            genre: genre,
            genreId: genreId,
            username: widget.username,
          ),
        ),
      );
    }
  }

  Widget _buildSearchResults(bool isDark) {
    final searchQuery = ref.watch(searchQueryProvider);

    if (searchQuery.isEmpty) {
      return _buildPopularContent(isDark);
    }

    return _buildSearchResultsByCategory(isDark);
  }

  Widget _buildPopularContent(bool isDark) {
    final popularMovies = ref.watch(popularMoviesProvider);

    return popularMovies.when(
      data: (movies) => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          final imageUrl = ref
              .read(tmdbApiServiceProvider)
              .getImageUrl(movie['poster_path']);
          return MovieListCard(
            title: movie['title'] ?? '',
            subtitle: 'Rating: ${movie['vote_average']?.toString() ?? 'N/A'}',
            description: movie['overview'] ?? '',
            imagePath: imageUrl,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(
                    title: movie['title'] ?? '',
                    imagePath: imageUrl,
                    username: widget.username,
                  ),
                ),
              );
            },
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error al cargar contenido: $error',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildSearchResultsByCategory(bool isDark) {
    late AsyncValue<List<dynamic>> searchResults;

    switch (_selectedCategory) {
      case 'Películas':
        searchResults = ref.watch(searchMoviesProvider);
        break;
      case 'Series':
        searchResults = ref.watch(searchSeriesProvider);
        break;
      case 'Personas':
        searchResults = ref.watch(searchPeopleProvider);
        break;
      default:
        searchResults = ref.watch(searchMoviesProvider);
    }

    return searchResults.when(
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Text(
              'No se encontraron resultados',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return _buildSearchResultItem(item, isDark);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error en búsqueda: $error',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> item, bool isDark) {
    String title = '';
    String subtitle = '';
    String description = '';
    String? imagePath;

    switch (_selectedCategory) {
      case 'Películas':
        title = item['title'] ?? '';
        subtitle = 'Rating: ${item['vote_average']?.toString() ?? 'N/A'}';
        description = item['overview'] ?? '';
        imagePath =
            ref.read(tmdbApiServiceProvider).getImageUrl(item['poster_path']);
        break;
      case 'Series':
        title = item['name'] ?? '';
        subtitle = 'Rating: ${item['vote_average']?.toString() ?? 'N/A'}';
        description = item['overview'] ?? '';
        imagePath =
            ref.read(tmdbApiServiceProvider).getImageUrl(item['poster_path']);
        break;
      case 'Personas':
        title = item['name'] ?? '';
        subtitle = 'Popularidad: ${item['popularity']?.toString() ?? 'N/A'}';
        description = 'Conocido por: ${item['known_for_department'] ?? ''}';
        imagePath =
            ref.read(tmdbApiServiceProvider).getImageUrl(item['profile_path']);
        break;
    }

    return MovieListCard(
      title: title,
      subtitle: subtitle,
      description: description,
      imagePath: imagePath ?? '',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(
              title: title,
              imagePath: imagePath ?? '',
              username: widget.username,
            ),
          ),
        );
      },
    );
  }
}

class GenreResultsScreen extends ConsumerWidget {
  final String genre;
  final int genreId;
  final String username;

  const GenreResultsScreen({
    Key? key,
    required this.genre,
    required this.genreId,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final moviesAsync = ref.watch(moviesByGenreProvider(genreId));

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('Películas de $genre'),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: moviesAsync.when(
        data: (movies) => ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            final imageUrl = ref
                .read(tmdbApiServiceProvider)
                .getImageUrl(movie['poster_path']);
            return MovieListCard(
              title: movie['title'] ?? '',
              subtitle: 'Rating: ${movie['vote_average']?.toString() ?? 'N/A'}',
              description: movie['overview'] ?? '',
              imagePath: imageUrl,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(
                      title: movie['title'] ?? '',
                      imagePath: imageUrl,
                      username: username,
                    ),
                  ),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error al cargar películas: $error',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
