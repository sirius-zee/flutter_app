import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'app_field/field_decorator.dart';
import 'app_field/field_variant.dart';

class AppDatePickerField extends StatefulWidget {
  final String? label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat? dateFormat;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final String? Function(DateTime?)? validator;
  final FormFieldSetter<DateTime>? onSaved;
  final FieldVariant? variant;
  final EdgeInsetsGeometry? contentPadding;

  const AppDatePickerField({
    super.key,
    this.label,
    this.selectedDate,
    this.onDateSelected,
    this.hintText = 'Pilih tanggal',
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.prefixIcon = const Icon(Icons.calendar_today_outlined),
    this.focusNode,
    this.validator,
    this.onSaved,
    this.variant,
    this.contentPadding,
  });

  @override
  State<AppDatePickerField> createState() => _AppDatePickerFieldState();
}

class _AppDatePickerFieldState extends State<AppDatePickerField> {
  Future<void> _selectDate(
    BuildContext context,
    FormFieldState<DateTime> field,
  ) async {
    if (!widget.enabled) return;

    final now = DateTime.now();
    final initial = widget.selectedDate ?? field.value ?? now;
    final first = widget.firstDate ?? DateTime(1900);
    final last = widget.lastDate ?? DateTime(2100);

    // Pastikan initialDate berada di dalam range firstDate dan lastDate
    final effectiveInitial = initial.isBefore(first)
        ? first
        : (initial.isAfter(last) ? last : initial);

    final picked = await showDatePicker(
      context: context,
      initialDate: effectiveInitial,
      firstDate: first,
      lastDate: last,
    );

    if (picked != null) {
      field.didChange(picked);
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveDateFormat = widget.dateFormat ?? DateFormat('dd MMMM yyyy');

    return FormField<DateTime>(
      initialValue: widget.selectedDate,
      validator: widget.validator,
      onSaved: widget.onSaved,
      enabled: widget.enabled,
      builder: (FormFieldState<DateTime> field) {
        final activeDate = widget.selectedDate ?? field.value;
        final effectiveErrorText = widget.errorText ?? field.errorText;

        return FieldDecorator(
          label: widget.label,
          hintText: widget.hintText,
          errorText: effectiveErrorText,
          helperText: widget.helperText,
          isRequired: widget.isRequired,
          enabled: widget.enabled,
          prefixIcon: widget.prefixIcon,
          focusNode: widget.focusNode,
          variant: widget.variant,
          contentPadding: widget.contentPadding,
          onTap: () => _selectDate(context, field),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            width: double.infinity,
            child: Text(
              activeDate != null
                  ? effectiveDateFormat.format(activeDate)
                  : (widget.hintText ?? ''),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: !widget.enabled
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                    : activeDate != null
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
