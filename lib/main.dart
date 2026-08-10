import 'package:flutter/material.dart';
import 'package:my_app/config/splash_config.dart';
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(
          config: SplashConfig(
            svgAssetPath: 'assets/logo1.svg',
            animationDuration: Duration(
              milliseconds: 2500,
            ), // Animasi lebih cepat
            navigateDelay: Duration(milliseconds: 5000),
            title: 'Welcome Good Team',
            strokeWidth: 3.5,
            strokeInterval: Interval(
              0.0,
              0.5,
              curve: Curves.slowMiddle,
            ), // Animasi beda
          ),
        ),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
