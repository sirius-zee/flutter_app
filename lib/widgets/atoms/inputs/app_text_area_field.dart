import 'package:flutter/material.dart';
import 'field_decorator.dart';

class AppTextAreaField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final int minLines;
  final int maxLines;
  final bool isRequired;
  final String? errorText;

  const AppTextAreaField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.minLines = 3,
    this.maxLines = 5,
    this.isRequired = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return FieldDecorator(
      label: label,
      isRequired: isRequired,
      errorText: errorText,
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
