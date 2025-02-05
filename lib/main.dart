import 'package:flutter/material.dart';
import 'services/auth_check.dart';
import 'view/onboarding_page.dart';
import 'view/login_screen.dart';
import 'view/signup_screen.dart';
import 'view/main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVC Onboarding App',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
