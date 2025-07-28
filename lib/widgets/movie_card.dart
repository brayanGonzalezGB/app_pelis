import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final VoidCallback? onTap;

  const MovieCard({
    Key? key,
    required this.title,
    this.imageUrl,
    this.onTap,
  }) : super(key: key);

  ImageProvider _getImageProvider() {
    if (imageUrl != null) {
      return NetworkImage(imageUrl!);
    } else {
      return const AssetImage('assets/images/placeholder.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                image: DecorationImage(
                  image: _getImageProvider(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
