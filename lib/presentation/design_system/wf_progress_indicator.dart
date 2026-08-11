import 'package:flutter/material.dart';

/// Fill/occupancy bar — used today by `SlotGridScreen`'s occupancy
/// chips. Wraps `LinearProgressIndicator` with the app's standard
/// rounded-end styling so every fill-ratio bar in the app looks the
/// same. Pair with `WFStatusChip` (not color alone) when the ratio
/// also needs a pass/warn/full reading — see `WoodFlowDesignSystem.md`
/// Accessibility section.
class WFProgressIndicator extends StatelessWidget {
  const WFProgressIndicator({super.key, required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 6,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        color: color,
      ),
    );
  }
}
