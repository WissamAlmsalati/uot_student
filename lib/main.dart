import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/login_screen.dart';
import 'view/signup_screen.dart';
import 'view/main_screen.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized before using plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // Get the stored token (access token) from SharedPreferences.
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access');

  // Run the app and pass the token.
  runApp(MainApp(token: token));
}

class MainApp extends StatelessWidget {
  final String? token;
  const MainApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner.
      debugShowCheckedModeBanner: false,
      
      // Set the Arabic locale.
      locale: const Locale('ar', 'EG'),
      // Declare the supported locales.
      supportedLocales: const [
        Locale('ar', 'EG'),
      ],
      // Add the localization delegates.
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'MVC Onboarding App',
      // Use the token to decide the initial route.
      initialRoute: token == null ? '/' : '/main',
      routes: {
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
