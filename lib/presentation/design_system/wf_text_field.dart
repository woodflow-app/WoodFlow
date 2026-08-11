import 'package:flutter/material.dart';

/// Standard text input — consistent `OutlineInputBorder` decoration
/// everywhere a form field appears. Thin wrapper on purpose: it exists
/// to stop each screen from re-deciding border style, not to hide
/// `TextField`'s real API.
class WFTextField extends StatelessWidget {
  const WFTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.keyboardType,
    this.autofocus = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final String labelText;
  final TextInputType? keyboardType;
  final bool autofocus;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      labelText: labelText,
      border: const OutlineInputBorder(),
    );

    if (validator != null) {
      return TextFormField(
        controller: controller,
        autofocus: autofocus,
        keyboardType: keyboardType,
        decoration: decoration,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
      );
    }

    return TextField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: keyboardType,
      decoration: decoration,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
