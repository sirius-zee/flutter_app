import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'field_decorator.dart';

class AppDatePickerField extends StatelessWidget {
  final String? label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? hintText;
  final bool isRequired;
  final bool enabled;
  final String? errorText;

  const AppDatePickerField({
    super.key,
    this.label,
    this.selectedDate,
    required this.onDateSelected,
    this.hintText = 'Pilih tanggal',
    this.isRequired = false,
    this.enabled = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FieldDecorator(
      label: label,
      isRequired: isRequired,
      enabled: enabled,
      errorText: errorText,
      prefixIcon: const Icon(Icons.calendar_today_outlined),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          selectedDate != null
              ? DateFormat('dd MMMM yyyy').format(selectedDate!)
              : hintText ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: selectedDate != null
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
