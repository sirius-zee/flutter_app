import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_field/field_decorator.dart';
import 'app_field/field_variant.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isRequired;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool isPassword;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final String? Function(String?)? validator;
  final FormFieldSetter<String>? onSaved;
  final String? initialValue;
  final FieldVariant? variant;
  final EdgeInsetsGeometry?
  contentPadding; // <-- Added contentPadding parameter

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.isRequired = false,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.isPassword = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.validator,
    this.onSaved,
    this.initialValue,
    this.variant,
    this.contentPadding,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword ? true : widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    Widget? effectiveSuffixIcon = widget.suffixIcon;

    if (widget.isPassword) {
      effectiveSuffixIcon = IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
        onPressed: widget.enabled
            ? () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              }
            : null,
      );
    }

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
        return FieldDecorator(
          label: widget.label,
          hintText: widget.hintText,
          errorText: field.errorText,
          helperText: widget.helperText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: effectiveSuffixIcon,
          isRequired: widget.isRequired,
          enabled: widget.enabled,
          focusNode: widget.focusNode,
          variant: widget.variant, // <-- Teruskan variant ke FieldDecorator
          contentPadding: widget.contentPadding, // <-- Teruskan contentPadding
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onChanged: (value) {
              field.didChange(value);
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            onSubmitted: widget.onFieldSubmitted,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            minLines: widget.minLines,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ),
        );
      },
    );
  }
}
