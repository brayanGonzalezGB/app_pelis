import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../providers/tmdb_provider.dart';
import '../profile/profile_screen.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../widgets/movie_grid_card.dart';
import '../content/movie_detail_screen.dart';

class MyMoviesScreen extends ConsumerStatefulWidget {
  final String username;

  const MyMoviesScreen({Key? key, required this.username}) : super(key: key);

  @override
  ConsumerState<MyMoviesScreen> createState() => _MyMoviesScreenState();
}

class _MyMoviesScreenState extends ConsumerState<MyMoviesScreen> {
  int _selectedListIndex = 0;
  final List<String> _listTabs = [
    'Populares',
    'Mejor Calificadas',
    'En Cartelera',
    'Próximas'
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            _buildListTabs(isDark),
            _buildListTitle(isDark),
            Expanded(
              child: _buildMoviesGrid(isDark),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateListModal(context),
        backgroundColor: Colors.deepPurple[600],
        child: const Icon(Icons.add, color: Colors.white),
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

  Widget _buildListTabs(bool isDark) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _listTabs.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedListIndex == index;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedListIndex = index;
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
                    _listTabs[index],
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

  Widget _buildListTitle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text(
            _listTabs[_selectedListIndex],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          const Spacer(),
          Icon(
            Icons.more_horiz,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesGrid(bool isDark) {
    late AsyncValue<List<dynamic>> moviesAsync;

    switch (_selectedListIndex) {
      case 0:
        moviesAsync = ref.watch(popularMoviesProvider);
        break;
      case 1:
        moviesAsync = ref.watch(topRatedMoviesProvider);
        break;
      case 2:
        moviesAsync = ref.watch(nowPlayingMoviesProvider);
        break;
      case 3:
        moviesAsync = ref.watch(upcomingMoviesProvider);
        break;
      default:
        moviesAsync = ref.watch(popularMoviesProvider);
    }

    return moviesAsync.when(
      data: (movies) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            final imageUrl = ref
                .read(tmdbApiServiceProvider)
                .getImageUrl(movie['poster_path']);
            return MovieGridCard(
              title: movie['title'] ?? '',
              subtitle: movie['vote_average']?.toString() ?? 'N/A',
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
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
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
              'Error al cargar películas',
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
                ref.invalidate(popularMoviesProvider);
                ref.invalidate(topRatedMoviesProvider);
                ref.invalidate(nowPlayingMoviesProvider);
                ref.invalidate(upcomingMoviesProvider);
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateListModal(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[800] : Colors.white,
        title: Text(
          'Crear nueva lista',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'Nombre de la lista',
            hintStyle: TextStyle(color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lista "${nameController.text}" creada'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: const Text(
              'Crear',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
