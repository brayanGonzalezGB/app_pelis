import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/tmdb_provider.dart';

class ActorsScreen extends ConsumerWidget {
  final String username;

  const ActorsScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorsAsync = ref.watch(popularActorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actores Populares'),
      ),
      body: actorsAsync.when(
        data: (List<dynamic> actors) => ListView.builder(
          itemCount: actors.length,
          itemBuilder: (context, index) {
            final Map<String, dynamic> actor = actors[index];
            final String imageUrl = ref
                .read(tmdbApiServiceProvider)
                .getImageUrl(actor['profile_path']);
            return ListTile(
              leading: Image.network(
                imageUrl,
                width: 50,
                errorBuilder: (_, __, ___) => const Icon(Icons.person),
              ),
              title: Text(actor['name'] ?? ''),
              subtitle:
                  Text('Popularidad: ${actor['popularity']?.toString() ?? ''}'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(actor['name'] ?? ''),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          imageUrl,
                          height: 120,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.person),
                        ),
                        const SizedBox(height: 12),
                        Text(
                            'Conocido por: ${actor['known_for_department'] ?? ''}'),
                        const SizedBox(height: 8),
                        Text(
                            'Popularidad: ${actor['popularity']?.toString() ?? ''}'),
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
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
