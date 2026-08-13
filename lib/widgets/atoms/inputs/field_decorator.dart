// lib/widgets/atoms/inputs/field_decorator.dart
import 'package:flutter/material.dart';

class FieldDecorator extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isRequired;
  final bool enabled;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding; // <-- Tambah parameter ini
  final Widget child;

  const FieldDecorator({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.isRequired = false,
    this.enabled = true,
    this.onTap,
    this.focusNode,
    this.contentPadding, // <-- Default null, nanti dipfallback di build
    required this.child,
  });

  @override
  State<FieldDecorator> createState() => _FieldDecoratorState();
}

class _FieldDecoratorState extends State<FieldDecorator> {
  late FocusNode _internalFocusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant FieldDecorator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_onFocusChange);
      _internalFocusNode = widget.focusNode ?? FocusNode();
      _internalFocusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    } else {
      _internalFocusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _internalFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    final Color fillColor = !widget.enabled
        ? colors.surfaceContainerHighest.withValues(alpha: 0.4)
        : colors.surfaceContainerLow;

    final Color borderColor = !widget.enabled
        ? colors.outline.withValues(alpha: 0.15)
        : hasError
        ? colors.error
        : _isFocused
        ? colors.primary
        : colors.outline;

    final double borderWidth = (_isFocused || hasError) ? 1.8 : 1.0;

    final Color iconColor = !widget.enabled
        ? colors.onSurface.withValues(alpha: 0.38)
        : hasError
        ? colors.error
        : _isFocused
        ? colors.primary
        : colors.onSurfaceVariant;

    // Gunakan contentPadding kustom jika disediakan, jika tidak gunakan default
    final effectivePadding =
        widget.contentPadding ??
        const EdgeInsets.symmetric(horizontal: 14, vertical: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- 1. Label Section ---
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.enabled
                      ? colors.onSurface
                      : colors.onSurface.withValues(alpha: 0.38),
                ),
              ),
              if (widget.isRequired)
                Text(
                  ' *',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: widget.enabled
                        ? colors.error
                        : colors.error.withValues(alpha: 0.38),
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
        ],

        // --- 2. Container Input Utama ---
        InkWell(
          onTap: widget.enabled ? widget.onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: effectivePadding, // <-- Gunakan effectivePadding
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  IconTheme(
                    data: IconThemeData(color: iconColor, size: 22),
                    child: widget.prefixIcon!,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(child: widget.child),
                if (widget.suffixIcon != null) ...[
                  const SizedBox(width: 10),
                  IconTheme(
                    data: IconThemeData(color: iconColor, size: 22),
                    child: widget.suffixIcon!,
                  ),
                ],
              ],
            ),
          ),
        ),

        // --- 3. Helper / Error Text ---
        if (hasError || widget.helperText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              hasError ? widget.errorText! : widget.helperText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasError ? colors.error : colors.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
