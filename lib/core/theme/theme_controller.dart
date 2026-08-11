// lib/core/theme/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  ThemeController._internal();
  static final ThemeController instance = ThemeController._internal();

  static const String _themeKey = 'user_theme_mode';

  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(
    ThemeMode.system,
  );

  ThemeMode get currentTheme => themeModeNotifier.value;

  // Dipanggil saat aplikasi pertama kali dijalankan
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedTheme = prefs.getString(_themeKey);

    if (savedTheme != null) {
      if (savedTheme == ThemeMode.light.name) {
        themeModeNotifier.value = ThemeMode.light;
      } else if (savedTheme == ThemeMode.dark.name) {
        themeModeNotifier.value = ThemeMode.dark;
      } else {
        themeModeNotifier.value = ThemeMode.system;
      }
    }
  }

  // Dipanggil saat pengguna mengubah tema
  Future<void> setThemeMode(ThemeMode mode) async {
    themeModeNotifier.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }
}
