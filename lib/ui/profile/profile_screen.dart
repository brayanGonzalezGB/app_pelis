import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String username;

  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();

  @override
  void dispose() {
    _instagramController.dispose();
    _twitterController.dispose();
    _linkedinController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.grey[800],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: isDark ? Colors.white : Colors.grey[600],
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(isDark),
            const SizedBox(height: 24),
            _buildSocialNetworksSection(isDark),
            const SizedBox(height: 24),
            _buildSaveButton(),
            const SizedBox(height: 32),
            _buildOverviewSection(isDark),
            const SizedBox(height: 24),
            _buildReviewsSection(isDark),
            const SizedBox(height: 24),
            _buildRatingsSection(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDark) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: isDark ? Colors.grey[700] : Colors.grey[300],
          child: Icon(
            Icons.person,
            size: 35,
            color: isDark ? Colors.grey[500] : Colors.grey[600],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.username,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Correo:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Miembro desde\nMayo 15, 2023',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? const Color.fromARGB(255, 97, 97, 97)
                : const Color.fromARGB(255, 103, 58, 183),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Compartir\n mi perfil',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? Colors.white
                  : const Color.fromARGB(255, 255, 254, 254),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialNetworksSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Agrega tus redes sociales',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child:
                  _buildSocialField('Instagram', _instagramController, isDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSocialField('Facebook', _twitterController, isDark),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSocialField('WhatsApp', _linkedinController, isDark),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSocialField('Threads', _facebookController, isDark),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialField(
      String label, TextEditingController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil guardado')),
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
          'Guardar cambios',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción general',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildReviewsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Opiniones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.grey[800],
              ),
            ),
            Text(
              '3',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildReviewPlaceholder(isDark)),
            const SizedBox(width: 8),
            Expanded(child: _buildReviewPlaceholder(isDark)),
            const SizedBox(width: 8),
            Expanded(child: _buildReviewPlaceholder(isDark)),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewPlaceholder(bool isDark) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _buildRatingsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calificaciones',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildRatingBar(40, isDark)),
            const SizedBox(width: 4),
            Expanded(child: _buildRatingBar(80, isDark)),
            const SizedBox(width: 4),
            Expanded(child: _buildRatingBar(60, isDark)),
            const SizedBox(width: 4),
            Expanded(child: _buildRatingBar(90, isDark)),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingBar(double height, bool isDark) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : Colors.grey[400],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
