import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/app.dart';
import 'env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  try {
    await Env.load();
  } catch (e) {
    // Si no existe el archivo .env, continúa sin problema
    print('No .env file found, continuing without environment variables');
  }

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
