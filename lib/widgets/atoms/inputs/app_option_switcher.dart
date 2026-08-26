import 'package:flutter/material.dart';
import 'app_field/field_decorator.dart';
import 'app_field/field_variant.dart';

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
  final FieldVariant?
  variant; // <-- Dibuat nullable agar fallback ke FieldDecorator

  AppOptionSwitcher({
    super.key,
    this.label,
    this.helperText,
    required this.options,
    this.selectedValue,
    this.onChanged,
    this.isRequired = false,
    this.variant,
    super.enabled = true,
    super.validator,
    super.onSaved,
  }) : super(
         initialValue: selectedValue,
         builder: (FormFieldState<T> field) {
           final activeValue = selectedValue ?? field.value;

           return FieldDecorator(
             label: label,
             errorText: field.errorText,
             helperText: helperText,
             isRequired: isRequired,
             enabled: enabled,
             variant: variant, // <-- Teruskan variant ke FieldDecorator
             contentPadding: const EdgeInsets.all(4),
             child: _OptionSwitcherContent<T>(
               field: field,
               options: options,
               selectedValue: activeValue,
               onChanged: onChanged,
               enabled: enabled,
             ),
           );
         },
       );

  @override
  FormFieldState<T> createState() => _AppOptionSwitcherState<T>();
}

class _AppOptionSwitcherState<T> extends FormFieldState<T> {
  @override
  void didUpdateWidget(covariant AppOptionSwitcher<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Cast ke AppOptionSwitcher<T> agar property selectedValue terbaca
    final newWidget = widget as AppOptionSwitcher<T>;
    if (oldWidget.selectedValue != newWidget.selectedValue) {
      setValue(newWidget.selectedValue);
    }
  }
}

class _OptionSwitcherContent<T> extends StatelessWidget {
  final FormFieldState<T> field;
  final List<OptionItem<T>> options;
  final T? selectedValue;
  final ValueChanged<T>? onChanged;
  final bool enabled;

  const _OptionSwitcherContent({
    required this.field,
    required this.options,
    this.selectedValue,
    this.onChanged,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: options.map((option) {
        final isSelected = option.value == selectedValue;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Material(
              color: Colors.transparent,
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
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (enabled
                              ? colors.primary
                              : colors.onSurface.withValues(alpha: 0.12))
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected && enabled
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
                                ? (enabled
                                      ? colors.onPrimary
                                      : colors.onSurface.withValues(
                                          alpha: 0.38,
                                        ))
                                : (enabled
                                      ? colors.onSurfaceVariant
                                      : colors.onSurface.withValues(
                                          alpha: 0.38,
                                        )),
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
                                ? (enabled
                                      ? colors.onPrimary
                                      : colors.onSurface.withValues(
                                          alpha: 0.38,
                                        ))
                                : (enabled
                                      ? colors.onSurface
                                      : colors.onSurface.withValues(
                                          alpha: 0.38,
                                        )),
                          ),
                        ),
                      ),
                      if (option.suffixIcon != null) ...[
                        const SizedBox(width: 6),
                        IconTheme(
                          data: IconThemeData(
                            size: 18,
                            color: isSelected
                                ? (enabled
                                      ? colors.onPrimary
                                      : colors.onSurface.withValues(
                                          alpha: 0.38,
                                        ))
                                : (enabled
                                      ? colors.onSurfaceVariant
                                      : colors.onSurface.withValues(
                                          alpha: 0.38,
                                        )),
                          ),
                          child: option.suffixIcon!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
