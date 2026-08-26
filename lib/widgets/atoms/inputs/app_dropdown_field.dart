import 'package:flutter/material.dart';
import 'app_field/field_decorator.dart';
import 'app_field/field_variant.dart';

// --- Models ---
enum DropdownMode { floating, modal }

class AppDropdownOption<T> {
  final T value;
  final String label;
  final String? subtitle;
  final Widget? icon;
  final bool enabled;

  const AppDropdownOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.enabled = true,
  });

  factory AppDropdownOption.fromMenuItem(DropdownMenuItem<T> item) {
    String label = '';
    if (item.child is Text) {
      label = (item.child as Text).data ?? '';
    } else {
      label = item.value?.toString() ?? '';
    }
    return AppDropdownOption<T>(
      value: item.value as T,
      label: label,
      enabled: item.enabled,
    );
  }
}

// --- Main Widget ---
class AppDropdownField<T> extends StatefulWidget {
  final String? label;
  final T? value;
  final List<AppDropdownOption<T>> items;
  final ValueChanged<T?>? onChanged;
  final Widget? prefixIcon;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final bool enabled;
  final bool isLoading;
  final DropdownMode mode;
  final FocusNode? focusNode;
  final String? Function(T?)? validator;
  final FormFieldSetter<T>? onSaved;
  final FieldVariant? variant;
  final EdgeInsetsGeometry? contentPadding;
  final double menuMaxHeight;

  const AppDropdownField({
    super.key,
    this.label,
    this.value,
    required this.items,
    this.onChanged,
    this.prefixIcon,
    this.hintText = 'Pilih opsi',
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
    this.isLoading = false,
    this.mode = DropdownMode.floating,
    this.focusNode,
    this.validator,
    this.onSaved,
    this.variant,
    this.contentPadding,
    this.menuMaxHeight = 280.0,
  });

  factory AppDropdownField.fromMenuItems({
    Key? key,
    String? label,
    T? value,
    required List<DropdownMenuItem<T>> menuItems,
    ValueChanged<T?>? onChanged,
    Widget? prefixIcon,
    String? hintText,
    String? helperText,
    String? errorText,
    bool isRequired = false,
    bool enabled = true,
    bool isLoading = false,
    DropdownMode mode = DropdownMode.floating,
    FocusNode? focusNode,
    String? Function(T?)? validator,
    FormFieldSetter<T>? onSaved,
    FieldVariant? variant,
    EdgeInsetsGeometry? contentPadding,
    double menuMaxHeight = 280.0,
  }) {
    return AppDropdownField<T>(
      key: key,
      label: label,
      value: value,
      items: menuItems
          .map((item) => AppDropdownOption.fromMenuItem(item))
          .toList(),
      onChanged: onChanged,
      prefixIcon: prefixIcon,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      isRequired: isRequired,
      enabled: enabled,
      isLoading: isLoading,
      mode: mode,
      focusNode: focusNode,
      validator: validator,
      onSaved: onSaved,
      variant: variant,
      contentPadding: contentPadding,
      menuMaxHeight: menuMaxHeight,
    );
  }

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>> {
  bool _isOpen = false;
  FocusNode? _internalFocusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  AppDropdownOption<T>? _getSelectedOption(T? currentValue) {
    if (currentValue == null) return null;
    for (final item in widget.items) {
      if (item.value == currentValue) return item;
    }
    return null;
  }

  void _handleTap(FormFieldState<T> field) {
    if (!widget.enabled || widget.isLoading) return;

    _effectiveFocusNode.requestFocus();

    if (widget.mode == DropdownMode.modal) {
      _showModalBottomSheet(field);
    } else {
      _showFloatingMenu(field);
    }
  }

  // Pop-up menu floating presisi yang menyesuaikan dengan FieldVariant
  Future<void> _showFloatingMenu(FormFieldState<T> field) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final effectiveVariant = widget.variant ?? FieldVariant.filled;

    setState(() => _isOpen = true);

    final double topOffset =
        effectiveVariant == FieldVariant.underlined ? 2.0 : 6.0;
    final BorderRadius menuBorderRadius =
        effectiveVariant == FieldVariant.underlined
            ? const BorderRadius.vertical(bottom: Radius.circular(12))
            : BorderRadius.circular(12);

    final T? selectedValue = await showMenu<T>(
      context: context,
      elevation: effectiveVariant == FieldVariant.underlined ? 4 : 6,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: menuBorderRadius,
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.3)),
      ),
      color: colors.surfaceContainerHigh,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(
          offset.dx,
          offset.dy + size.height + topOffset,
          size.width,
          0,
        ),
        Offset.zero & MediaQuery.of(context).size,
      ),
      constraints: BoxConstraints(
        minWidth: size.width,
        maxWidth: size.width,
        maxHeight: widget.menuMaxHeight,
      ),
      items: widget.items.map((item) {
        final isSelected = (field.value ?? widget.value) == item.value;

        return PopupMenuItem<T>(
          value: item.value,
          enabled: item.enabled,
          height: 44,
          padding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: isSelected
                ? colors.primaryContainer.withValues(alpha: 0.25)
                : Colors.transparent,
            child: Row(
              children: [
                if (item.icon != null) ...[
                  IconTheme(
                    data: IconThemeData(
                      color: isSelected
                          ? colors.primary
                          : colors.onSurfaceVariant,
                      size: 20,
                    ),
                    child: item.icon!,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: !item.enabled
                              ? colors.onSurface.withValues(alpha: 0.38)
                              : isSelected
                              ? colors.primary
                              : colors.onSurface,
                        ),
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: colors.primary,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );

    if (mounted) {
      setState(() => _isOpen = false);
      _effectiveFocusNode.unfocus();
    }

    if (selectedValue != null) {
      field.didChange(selectedValue);
      widget.onChanged?.call(selectedValue);
    }
  }

  // Tampilan Opsi Modal (Bottom Sheet)
  Future<void> _showModalBottomSheet(FormFieldState<T> field) async {
    setState(() => _isOpen = true);

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: widget.items.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              color: colors.outlineVariant.withValues(alpha: 0.2),
            ),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final isSelected = (field.value ?? widget.value) == item.value;

              return ListTile(
                leading: item.icon,
                title: Text(item.label),
                subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: colors.primary)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  field.didChange(item.value);
                  widget.onChanged?.call(item.value);
                },
              );
            },
          ),
        ),
      ),
    );

    if (mounted) {
      setState(() => _isOpen = false);
      _effectiveFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<T>(
      key: ValueKey(widget.value),
      initialValue: widget.value,
      validator: widget.validator,
      onSaved: widget.onSaved,
      enabled: widget.enabled,
      builder: (FormFieldState<T> field) {
        final effectiveErrorText = widget.errorText ?? field.errorText;
        final selectedOption = _getSelectedOption(field.value ?? widget.value);

        return FieldDecorator(
          label: widget.label,
          hintText: widget.hintText,
          errorText: effectiveErrorText,
          helperText: widget.helperText,
          isRequired: widget.isRequired,
          enabled: widget.enabled,
          prefixIcon: widget.prefixIcon,
          focusNode: _effectiveFocusNode,
          variant: widget.variant,
          contentPadding: widget.contentPadding,
          onTap: () => _handleTap(field),
          suffixIcon: widget.isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.arrow_drop_down),
                ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Text(
              selectedOption?.label ?? widget.hintText ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: !widget.enabled
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                    : selectedOption != null
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ),
        );
      },
    );
  }
}

