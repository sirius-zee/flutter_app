import 'package:flutter/material.dart';
import 'app_field/field_decorator.dart';
import 'app_field/field_variant.dart';

class AppTextAreaField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int minLines;
  final int maxLines;
  final bool isRequired;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final String? Function(String?)? validator;
  final String? initialValue;
  final FieldVariant? variant;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextAreaField({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.minLines = 3,
    this.maxLines = 5,
    this.isRequired = false,
    this.enabled = true,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.variant,
    this.contentPadding,
  });

  @override
  State<AppTextAreaField> createState() => _AppTextAreaFieldState();
}

class _AppTextAreaFieldState extends State<AppTextAreaField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<String>(
      initialValue: widget.controller?.text ?? widget.initialValue ?? '',
      validator: widget.validator != null
          ? (value) => widget.validator!(
              widget.controller != null ? widget.controller!.text : value,
            )
          : null,
      onSaved: widget.onSaved,
      enabled: widget.enabled,
      builder: (FormFieldState<String> field) {
        final effectiveErrorText = widget.errorText ?? field.errorText;

        return FieldDecorator(
          label: widget.label,
          hintText: widget.hintText,
          errorText: effectiveErrorText,
          helperText: widget.helperText,
          isRequired: widget.isRequired,
          enabled: widget.enabled,
          focusNode: widget.focusNode,
          variant: widget.variant,
          // Text area butuh padding vertikal sedikit lebih lega
          contentPadding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            onChanged: (value) {
              field.didChange(value);
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.enabled
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.38),
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding:
                  EdgeInsets.zero, // Padding diatur oleh FieldDecorator
              hintText: widget.hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
