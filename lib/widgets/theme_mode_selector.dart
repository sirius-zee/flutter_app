// lib/widgets/theme_mode_selector.dart
import 'package:flutter/material.dart';
import 'package:my_app/core/theme/theme_controller.dart';

enum ThemeSelectorType { segmented, loopButton }

class ThemeModeSelector extends StatelessWidget {
  final bool showLabels;
  final ThemeSelectorType type;

  const ThemeModeSelector({
    super.key,
    this.showLabels = false,
    this.type = ThemeSelectorType.loopButton,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, currentMode, child) {
        if (type == ThemeSelectorType.loopButton) {
          return _LoopThemeButton(
            currentMode: currentMode,
            showLabels: showLabels,
          );
        }

        return _SegmentedThemeSelector(
          currentMode: currentMode,
          showLabels: showLabels,
        );
      },
    );
  }
}

/// Varian 1: Single Button dengan Animasi UX Berputar & Transisi Halus (Looping)
class _LoopThemeButton extends StatelessWidget {
  final ThemeMode currentMode;
  final bool showLabels;

  const _LoopThemeButton({required this.currentMode, required this.showLabels});

  // Urutan Siklus Mode: System -> Light -> Dark -> System
  ThemeMode _getNextMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return ThemeMode.light;
      case ThemeMode.light:
        return ThemeMode.dark;
      case ThemeMode.dark:
        return ThemeMode.system;
    }
  }

  IconData _getIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.brightness_auto_rounded;
    }
  }

  String _getLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System';
    }
  }

  String _getTooltip(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Theme: Light';
      case ThemeMode.dark:
        return 'Theme: Dark';
      case ThemeMode.system:
        return 'Theme: System';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: _getTooltip(currentMode),
      child: Material(
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            final nextMode = _getNextMode(currentMode);
            ThemeController.instance.setThemeMode(nextMode);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            // AnimatedSwitcher memberikan efek Fade & Rotate saat ikon berganti
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final rotateAnimation = Tween<double>(begin: 0.75, end: 1.0)
                    .animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                    );

                return ScaleTransition(
                  scale: animation,
                  child: RotationTransition(
                    turns: rotateAnimation,
                    child: child,
                  ),
                );
              },
              child: showLabels
                  ? Row(
                      spacing: 4.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_getLabel(currentMode)),
                        Icon(
                          _getIcon(currentMode),
                          // Key unik penting agar AnimatedSwitcher mendeteksi perubahan ikon
                          key: ValueKey<ThemeMode>(currentMode),
                          color: theme.colorScheme.primary,
                          size: 22,
                        ),
                      ],
                    )
                  : Icon(
                      _getIcon(currentMode),
                      // Key unik penting agar AnimatedSwitcher mendeteksi perubahan ikon
                      key: ValueKey<ThemeMode>(currentMode),
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Varian 2: Material 3 Segmented Button Standard
class _SegmentedThemeSelector extends StatelessWidget {
  final ThemeMode currentMode;
  final bool showLabels;

  const _SegmentedThemeSelector({
    required this.currentMode,
    required this.showLabels,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment<ThemeMode>(
          value: ThemeMode.light,
          icon: const Icon(Icons.light_mode_outlined),
          label: showLabels ? const Text('Light') : null,
          tooltip: 'Light Mode',
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.dark,
          icon: const Icon(Icons.dark_mode_outlined),
          label: showLabels ? const Text('Dark') : null,
          tooltip: 'Dark Mode',
        ),
        ButtonSegment<ThemeMode>(
          value: ThemeMode.system,
          icon: const Icon(Icons.brightness_auto_outlined),
          label: showLabels ? const Text('Auto') : null,
          tooltip: 'System Default',
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (Set<ThemeMode> newSelection) {
        ThemeController.instance.setThemeMode(newSelection.first);
      },
      style: const ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
