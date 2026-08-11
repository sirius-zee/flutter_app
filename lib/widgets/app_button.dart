// lib/widgets/app_button.dart
import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined, ghost, tonal }

enum AppIconPosition { left, right }

class AppButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final AppIconPosition iconPosition;
  final bool isLoading;
  final bool isFullWidth;
  final Color? customColor;
  final Color? textColor;
  final double height;
  final double borderRadius;

  const AppButton({
    super.key,
    this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.icon,
    this.iconPosition = AppIconPosition.left,
    this.isLoading = false,
    this.isFullWidth = true,
    this.customColor,
    this.textColor,
    this.height = 50,
    this.borderRadius = 12,
  }) : assert(
         text != null || icon != null,
         'At setidaknya teks atau ikon harus diisi.',
       );

  // Helper Constructor untuk Icon Only
  factory AppButton.iconOnly({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    AppButtonVariant variant = AppButtonVariant.filled,
    bool isLoading = false,
    Color? customColor,
    Color? textColor,
    double size = 48,
    double borderRadius = 12,
  }) {
    return AppButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      variant: variant,
      isLoading: isLoading,
      isFullWidth: false,
      customColor: customColor,
      textColor: textColor,
      height: size,
      borderRadius: borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = customColor ?? theme.colorScheme.primary;

    // Menentukan style dasar sesuai varian
    Widget buttonWidget;

    final childContent = _buildChildContent(context, primaryColor);

    switch (variant) {
      case AppButtonVariant.filled:
        buttonWidget = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: textColor ?? Colors.white,
            elevation: 0,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: childContent,
        );
        break;

      case AppButtonVariant.outlined:
        buttonWidget = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? primaryColor,
            side: BorderSide(color: primaryColor, width: 1.5),
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: childContent,
        );
        break;

      case AppButtonVariant.ghost:
        buttonWidget = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? primaryColor,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: childContent,
        );
        break;

      case AppButtonVariant.tonal:
        buttonWidget = FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: primaryColor.withValues(alpha: 0.15),
            foregroundColor: textColor ?? primaryColor,
            minimumSize: Size(isFullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: childContent,
        );
        break;
    }

    if (!isFullWidth && text == null) {
      // Menjaga rasio persegi untuk Icon Only
      return SizedBox(width: height, height: height, child: buttonWidget);
    }

    return buttonWidget;
  }

  Widget _buildChildContent(BuildContext context, Color activeColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.filled ? Colors.white : activeColor,
          ),
        ),
      );
    }

    final isIconOnly = text == null && icon != null;

    if (isIconOnly) {
      return Icon(icon, size: 22);
    }

    final iconWidget = icon != null ? Icon(icon, size: 20) : null;

    return Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconWidget != null && iconPosition == AppIconPosition.left) ...[
          iconWidget,
          const SizedBox(width: 8),
        ],
        Text(
          text!,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        if (iconWidget != null && iconPosition == AppIconPosition.right) ...[
          const SizedBox(width: 8),
          iconWidget,
        ],
      ],
    );
  }
}
