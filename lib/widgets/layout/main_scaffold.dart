import 'package:flutter/material.dart';
import 'package:my_app/widgets/atoms/navigation/custom_bottom_navigation_bar.dart';
import 'package:my_app/widgets/atoms/navigation/nav_animation_type.dart';

class MainScaffold extends StatefulWidget {
  final List<Widget> pages;
  final NavAnimationType animationType;

  const MainScaffold({
    super.key,
    required this.pages,
    this.animationType = NavAnimationType.slidingPill,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  static const List<NavigationItemData> _navItems = [
    NavigationItemData(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Beranda',
    ),
    NavigationItemData(
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics_rounded,
      label: 'Analitik',
    ),
    NavigationItemData(
      icon: Icons.history_outlined,
      selectedIcon: Icons.history_rounded,
      label: 'Riwayat',
    ),
    NavigationItemData(
      icon: Icons.person_outline,
      selectedIcon: Icons.person_rounded,
      label: 'Profil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: widget.pages),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        items: _navItems,
        animationType: widget.animationType,
        onItemTapped: (index) {
          if (_selectedIndex != index) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
