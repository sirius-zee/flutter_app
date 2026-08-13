import 'package:flutter/material.dart';
import '../nav_animation_type.dart';
import 'nav_item_content.dart';

class AnimatedPillNav extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationItemData> items;
  final ValueChanged<int> onItemTapped;

  const AnimatedPillNav({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(items.length, (index) {
        final isSelected = selectedIndex == index;
        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onItemTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primaryContainer.withValues(alpha: 0.7)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: NavItemContent(item: items[index], isSelected: isSelected),
            ),
          ),
        );
      }),
    );
  }
}
