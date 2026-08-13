import 'package:flutter/material.dart';
import '../nav_animation_type.dart';
import 'nav_item_content.dart';

class SlidingPillNav extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationItemData> items;
  final ValueChanged<int> onItemTapped;

  const SlidingPillNav({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = constraints.maxWidth / items.length;

        return Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              left: selectedIndex * itemWidth,
              top: 0,
              bottom: 0,
              width: itemWidth,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            Row(
              children: List.generate(items.length, (index) {
                final isSelected = selectedIndex == index;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onItemTapped(index),
                    child: NavItemContent(
                      item: items[index],
                      isSelected: isSelected,
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
