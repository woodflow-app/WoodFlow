import 'package:flutter/material.dart';

/// Button hierarchy — `WoodFlowDesignSystem.md` §11. Every button in
/// the app maps onto exactly one of these four roles; `ElevatedButton`
/// is retired from the palette (every prior use maps cleanly onto one
/// of these).
enum WFButtonRole { primary, secondary, tertiary, destructive }

/// The one button widget every screen uses. Picking the wrong role is
/// now a one-word mistake to catch in review, not a choice between
/// four raw Material widgets with no stated rule between them.
class WFButton extends StatelessWidget {
  const WFButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.role = WFButtonRole.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final WFButtonRole role;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final child = icon == null
        ? Text(label)
        : Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label),
          ]);

    return switch (role) {
      WFButtonRole.primary => FilledButton(onPressed: onPressed, child: child),
      WFButtonRole.secondary => OutlinedButton(onPressed: onPressed, child: child),
      WFButtonRole.tertiary => TextButton(onPressed: onPressed, child: child),
      WFButtonRole.destructive => TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
          child: child,
        ),
    };
  }
}
