import 'package:flutter/material.dart';
import '../nav_animation_type.dart';
import 'nav_item_content.dart';

class BottomLineNav extends StatelessWidget {
  final int selectedIndex;
  final List<NavigationItemData> items;
  final ValueChanged<int> onItemTapped;

  const BottomLineNav({
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
              left: selectedIndex * itemWidth + (itemWidth * 0.25),
              bottom: 2,
              width: itemWidth * 0.5,
              height: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
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
