import 'package:flutter/material.dart';

/// The one FAB shape for the whole app — `WoodFlowDesignSystem.md`'s
/// FAB-behaviour finding: `WarehouseListScreen`/`ShoppingListScreen`
/// used a plain icon-only FAB while `RackListScreen`/`SlotGridScreen`/
/// `SlotDetailScreen` used `FloatingActionButton.extended`, for the
/// same "add the next thing" action. Standardized on the extended
/// (icon + label) shape everywhere — a labeled affordance is clearer
/// for a warehouse worker than an icon-only guess, and it's already
/// what a majority of screens used.
class WFFloatingActionButton extends StatelessWidget {
  const WFFloatingActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.add,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
