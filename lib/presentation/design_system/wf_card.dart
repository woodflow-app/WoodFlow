import 'package:flutter/material.dart';

import 'wf_spacing.dart';

/// Standard list card — `WoodFlowDesignSystem.md` §7 "List card"
/// variant (elevation 1, radius `medium`). For the grid-chip variant
/// (`SlotGridScreen`'s occupancy tiles) see that screen directly — a
/// bordered, non-elevated container is a deliberate second pattern,
/// not a missed use of this widget.
class WFCard extends StatelessWidget {
  const WFCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(WFSpacing.lg),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(WFRadius.medium)),
      margin: const EdgeInsets.only(bottom: WFSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(WFRadius.medium),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
