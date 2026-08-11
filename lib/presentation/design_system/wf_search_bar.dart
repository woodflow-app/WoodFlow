import 'package:flutter/material.dart';

/// Standard search field — used today by `ShoppingListScreen`'s decor
/// search. Prefix search icon + consistent border, so any future
/// search field (decor, warehouse, etc.) looks the same on sight.
class WFSearchBar extends StatelessWidget {
  const WFSearchBar({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final void Function(String)? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
