import 'package:flutter/material.dart';

class SplashConfig {
  // Path asset SVG
  final String svgAssetPath;

  // Durasi Total Animasi
  final Duration animationDuration;

  // Durasi Tunda sebelum Navigasi Halaman
  final Duration navigateDelay;

  // Rute Tujuan Navigasi
  final String nextRoute;

  // Interval Waktu untuk Garis (Stroke) & Isian (Fill)
  final Interval strokeInterval;
  final Interval fillInterval;

  // Ukuran Canvas Logo
  final double logoWidth;
  final double logoHeight;

  // Ketebalan Garis Animasi
  final double strokeWidth;

  // Warna default jika SVG tidak memiliki atribut warna
  final Color defaultFillColor;

  // Teks & Style Splash
  final String title;
  final String subtitle;

  // Tag identifikasi untuk animasi Hero
  final String heroTag;

  const SplashConfig({
    this.svgAssetPath = 'assets/logo1.svg',
    this.animationDuration = const Duration(milliseconds: 3000),
    this.navigateDelay = const Duration(milliseconds: 4000),
    this.nextRoute = '/login',
    this.strokeInterval = const Interval(0.0, 0.7, curve: Curves.easeInOut),
    this.fillInterval = const Interval(0.7, 1.0, curve: Curves.easeIn),
    this.logoWidth = 150.0,
    this.logoHeight = 150.0,
    this.strokeWidth = 2.0,
    this.defaultFillColor = Colors.black,
    this.title = 'My Awesome App',
    this.subtitle = 'Initializing...',
    this.heroTag = 'app_logo_hero',
  });
}
