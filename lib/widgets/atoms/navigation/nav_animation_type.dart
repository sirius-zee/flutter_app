import 'package:flutter/material.dart';

// Model Data Navigasi
class NavigationItemData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NavigationItemData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

// Enum Jenis Animasi Navigasi
enum NavAnimationType {
  slidingPill, // Animasi kapsul meluncur (yang sekarang)
  animatedPill, // Animasi kapsul muncul per-item (yang terisolasi)
  bottomLine, // Animasi garis indikator di bawah
  // Tambahkan variasi animasi baru di sini di masa depan
}
