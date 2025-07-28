import 'package:flutter/material.dart';
import 'lib/ui/auth/register_screen.dart';
import 'lib/ui/auth/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Movie App Test',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: RegisterScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
