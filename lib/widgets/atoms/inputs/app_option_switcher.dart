// lib/widgets/atoms/inputs/app_option_switcher.dart
import 'package:flutter/material.dart';
import 'field_decorator.dart';

/// Model Item untuk Opsi Switcher
class OptionItem<T> {
  final T value;
  final String label;
  final Widget? icon; // Ikon Depan (Prefix)
  final Widget? suffixIcon; // Ikon Belakang (Suffix)

  const OptionItem({
    required this.value,
    required this.label,
    this.icon,
    this.suffixIcon,
  });
}

class AppOptionSwitcher<T> extends FormField<T> {
  final String? label;
  final String? helperText;
  final List<OptionItem<T>> options;
  final T? selectedValue;
  final ValueChanged<T>? onChanged;
  final bool isRequired;

  AppOptionSwitcher({
    super.key,
    this.label,
    this.helperText,
    required this.options,
    this.selectedValue,
    this.onChanged,
    this.isRequired = false,
    super.enabled = true, // <-- Menggunakan super parameter
    super.validator,
    super.onSaved,
  }) : super(
         initialValue: selectedValue,
         builder: (FormFieldState<T> field) {
           return _OptionSwitcherContent<T>(
             field: field,
             label: label,
             helperText: helperText,
             options: options,
             selectedValue: selectedValue ?? field.value,
             onChanged: onChanged,
             isRequired: isRequired,
             enabled: field.widget.enabled,
           );
         },
       );
}

class _OptionSwitcherContent<T> extends StatelessWidget {
  final FormFieldState<T> field;
  final String? label;
  final String? helperText;
  final List<OptionItem<T>> options;
  final T? selectedValue;
  final ValueChanged<T>? onChanged;
  final bool isRequired;
  final bool enabled;

  const _OptionSwitcherContent({
    required this.field,
    this.label,
    this.helperText,
    required this.options,
    this.selectedValue,
    this.onChanged,
    required this.isRequired,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return FieldDecorator(
      label: label,
      errorText: field.errorText,
      helperText: helperText,
      isRequired: isRequired,
      enabled: enabled,
      contentPadding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: options.map((option) {
              final isSelected = option.value == selectedValue;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    onTap: enabled
                        ? () {
                            field.didChange(option.value);
                            if (onChanged != null) {
                              onChanged!(option.value);
                            }
                          }
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: colors.primary.withValues(alpha: 0.25),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (option.icon != null) ...[
                            IconTheme(
                              data: IconThemeData(
                                size: 18,
                                color: isSelected
                                    ? colors.onPrimary
                                    : enabled
                                    ? colors.onSurfaceVariant
                                    : colors.onSurface.withValues(alpha: 0.38),
                              ),
                              child: option.icon!,
                            ),
                            const SizedBox(width: 6),
                          ],
                          Flexible(
                            child: Text(
                              option.label,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? colors.onPrimary
                                    : enabled
                                    ? colors.onSurface
                                    : colors.onSurface.withValues(alpha: 0.38),
                              ),
                            ),
                          ),
                          if (option.suffixIcon != null) ...[
                            const SizedBox(width: 6),
                            IconTheme(
                              data: IconThemeData(
                                size: 18,
                                color: isSelected
                                    ? colors.onPrimary
                                    : enabled
                                    ? colors.onSurfaceVariant
                                    : colors.onSurface.withValues(alpha: 0.38),
                              ),
                              child: option.suffixIcon!,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
