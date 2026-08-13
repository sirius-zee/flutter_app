import 'package:flutter/material.dart';
import 'package:my_app/config/splash_config.dart';
import 'package:my_app/core/theme/app_theme.dart';
import 'package:my_app/core/services/notification_service.dart';
import 'package:my_app/core/theme/theme_controller.dart';
import 'package:my_app/screens/splash_screen.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/register_screen.dart';
import 'package:my_app/screens/home_screen.dart';
import 'package:my_app/screens/profile_screen.dart';
import 'package:my_app/widgets/layout/main_scaffold.dart';
import 'package:my_app/widgets/atoms/navigation/nav_animation_type.dart';

void main() async {
  // Memastikan binding Flutter siap sebelum membaca SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  // Muat tema yang tersimpan dari lokal HP
  await ThemeController.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
          title: 'Flutter App',
          debugShowCheckedModeBanner: false,
          // Gunakan navigatorKey untuk Overlay Toast
          navigatorKey: NotificationService.navigatorKey,
          // Konfigurasi Tema
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentThemeMode,

          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (context) => const SplashScreen(
                    config: SplashConfig(
                      svgAssetPath: 'assets/logo1.svg',
                      animationDuration: Duration(milliseconds: 2500),
                      navigateDelay: Duration(milliseconds: 3000),
                      title: 'Welcome Good Team',
                      strokeWidth: 3.5,
                      strokeInterval: Interval(
                        0.0,
                        0.5,
                        curve: Curves.slowMiddle,
                      ),
                    ),
                  ),
                );

              case '/login':
                // Custom PageRoute dengan animasi Fade halus khusus untuk Hero Transition
                return PageRouteBuilder(
                  settings: settings,
                  transitionDuration: const Duration(milliseconds: 800),
                  reverseTransitionDuration: const Duration(milliseconds: 600),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LoginScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                          child: child,
                        );
                      },
                );

              case '/register':
                return PageRouteBuilder(
                  settings: settings,
                  transitionDuration: const Duration(milliseconds: 600),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const RegisterScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                          child: child,
                        );
                      },
                );

              case '/home':
                return MaterialPageRoute(
                  builder: (context) => const MainScaffold(
                    animationType: NavAnimationType.slidingPill,
                    pages: [
                      HomeScreen(),
                      Center(child: Text('Halaman Analistik')),
                      Center(child: Text('Halaman Riwayat')),
                      ProfileScreen(),
                    ],
                  ),
                );

              default:
                return null;
            }
          },
        );
      },
    );
  }
}
