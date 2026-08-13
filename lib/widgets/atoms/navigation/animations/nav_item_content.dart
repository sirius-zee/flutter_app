import 'package:flutter/material.dart';
import '../nav_animation_type.dart';

class NavItemContent extends StatelessWidget {
  final NavigationItemData item;
  final bool isSelected;

  const NavItemContent({
    super.key,
    required this.item,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedScale(
          scale: isSelected ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Icon(
            isSelected ? item.selectedIcon : item.icon,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            size: 22,
          ),
        ),
        const SizedBox(height: 3),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          style: theme.textTheme.labelSmall!.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            fontSize: 10.5,
          ),
          child: Text(item.label),
        ),
      ],
    );
  }
}
