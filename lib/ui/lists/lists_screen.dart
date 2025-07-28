import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';

class ListsScreen extends ConsumerStatefulWidget {
  const ListsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  int _selectedListIndex = 0;
  final List<String> _listTabs = ['List 1', 'List 2', 'List 3'];
  final List<MovieGridItem> _movies = [
    MovieGridItem(name: 'Name', rating: '8.5'),
    MovieGridItem(name: 'Name', rating: '7.8'),
    MovieGridItem(name: 'Name', rating: '9.1'),
    MovieGridItem(name: 'Name', rating: '8.2'),
    MovieGridItem(name: 'Name', rating: '7.6'),
    MovieGridItem(name: 'Name', rating: '8.9'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
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
        backgroundColor: Colors.grey[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
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
          const Spacer(),
          Text(
            'Hi User!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
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

  Widget _buildListTabs(bool isDark) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: _listTabs.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isSelected = index == _selectedListIndex;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedListIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Colors.grey[600] 
                    : (isDark ? Colors.grey[800] : Colors.grey[300]),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
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
    );
  }

  Widget _buildListTitle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text(
            'Title ipsum Lorem ipsum',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.grey[800],
            ),
          ),
          const Spacer(),
          Icon(
            Icons.menu,
            color: isDark ? Colors.white : Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesGrid(bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        return _buildMovieGridItem(_movies[index], isDark);
      },
    );
  }

  Widget _buildMovieGridItem(MovieGridItem movie, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.movie,
                    size: 40,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                ),
                if (movie.name == 'Name' && movie.rating == '8.2')
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[600] : Colors.grey[500],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          movie.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.grey[800],
          ),
        ),
        Text(
          'rating',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showCreateListModal(BuildContext context) {
    final isDark = ref.read(themeProvider) == ThemeMode.dark;
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final publicController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Create new list',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey[800],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: isDark ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildModalField('Name', nameController, isDark),
                const SizedBox(height: 16),
                _buildModalField('Description', descriptionController, isDark),
                const SizedBox(height: 16),
                _buildModalField('Public list?', publicController, isDark),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lista creada exitosamente')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      nameController.dispose();
      descriptionController.dispose();
      publicController.dispose();
    });
  }

  Widget _buildModalField(String label, TextEditingController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.deepPurple),
            ),
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
          ),
        ),
      ],
    );
  }
}

class MovieGridItem {
  final String name;
  final String rating;

  MovieGridItem({required this.name, required this.rating});
}
