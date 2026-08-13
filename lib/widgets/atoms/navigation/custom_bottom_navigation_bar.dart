import 'package:flutter/material.dart';
import 'animations/animations.dart';
import 'nav_animation_type.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationItemData> items;
  final ValueChanged<int> onItemTapped;
  final NavAnimationType animationType;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemTapped,
    this.animationType = NavAnimationType.slidingPill,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Container(
        height: 68,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: switch (animationType) {
          NavAnimationType.slidingPill => SlidingPillNav(
            selectedIndex: selectedIndex,
            items: items,
            onItemTapped: onItemTapped,
          ),
          NavAnimationType.animatedPill => AnimatedPillNav(
            selectedIndex: selectedIndex,
            items: items,
            onItemTapped: onItemTapped,
          ),
          NavAnimationType.bottomLine => BottomLineNav(
            selectedIndex: selectedIndex,
            items: items,
            onItemTapped: onItemTapped,
          ),
        },
      ),
    );
  }
}
