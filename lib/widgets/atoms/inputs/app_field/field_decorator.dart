import 'package:flutter/material.dart';
import 'field_variant.dart';

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
  final EdgeInsetsGeometry? contentPadding;
  final FieldVariant variant; // <-- Tambahkan varian di sini
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
    this.contentPadding,
    FieldVariant? variant,
    required this.child,
  }) : variant = variant ?? FieldVariant.underlined;

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

    // --- Dynamic Color & Style Logic berdasarkan Variant ---
    Color getFillColor() {
      if (!widget.enabled) {
        return colors.surfaceContainerHighest.withValues(alpha: 0.4);
      }

      switch (widget.variant) {
        case FieldVariant.filled:
          if (hasError) {
            // Saat error: Background agak kemerahan/soft error
            return colors.errorContainer.withValues(alpha: 0.3);
          }
          if (_isFocused) {
            // Saat focus: Background sedikit lebih terang/jelas
            return colors.primaryContainer.withValues(alpha: 0.25);
          }
          // Idle / Normal State
          return colors.surfaceContainerHighest.withValues(alpha: 0.6);

        case FieldVariant.outlined:
          return Colors.transparent;

        case FieldVariant.underlined:
          return Colors.transparent;
      }
    }

    Color getBorderColor() {
      if (!widget.enabled) {
        return colors.outline.withValues(alpha: 0.15);
      }
      if (hasError) return colors.error;
      if (_isFocused) return colors.primary;
      return colors.outline;
    }

    final double borderWidth = (_isFocused || hasError) ? 1.8 : 1.0;
    final Color activeBorderColor = getBorderColor();

    BoxBorder? getBorder() {
      switch (widget.variant) {
        case FieldVariant.outlined:
          return Border.all(color: activeBorderColor, width: borderWidth);

        case FieldVariant.filled:
          // Murni tanpa border di kondisi apapun (idle, focus, maupun error)
          return null;

        case FieldVariant.underlined:
          return Border(
            bottom: BorderSide(color: activeBorderColor, width: borderWidth),
          );
      }
    }

    BorderRadius getBorderRadius() {
      switch (widget.variant) {
        case FieldVariant.outlined:
        case FieldVariant.filled:
          return BorderRadius.circular(
            12,
          ); // Penuh 12px untuk Outlined dan Filled
        case FieldVariant.underlined:
          return BorderRadius.zero;
      }
    }

    final Color iconColor = !widget.enabled
        ? colors.onSurface.withValues(alpha: 0.38)
        : hasError
        ? colors.error
        : _isFocused
        ? colors.primary
        : colors.onSurfaceVariant;

    final effectivePadding =
        widget.contentPadding ??
        (widget.variant == FieldVariant.underlined
            ? const EdgeInsets.symmetric(horizontal: 0, vertical: 2)
            : const EdgeInsets.symmetric(horizontal: 14, vertical: 2));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- 1. Label Section ---
        if (widget.label != null) ...[
          Row(
            children: [
              if (widget.variant != FieldVariant.underlined)
                const SizedBox(width: 8.0),
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
          borderRadius: getBorderRadius(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: effectivePadding,
            decoration: BoxDecoration(
              color: getFillColor(),
              borderRadius: getBorderRadius(),
              border: getBorder(),
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
            padding: EdgeInsets.only(
              left: widget.variant == FieldVariant.underlined ? 0 : 4,
            ),
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
