import 'package:flutter/material.dart';

import 'wf_spacing.dart';

/// Semantic status levels — `WoodFlowDesignSystem.md` §3: mapped to
/// theme `colorScheme` roles, never a raw `Colors.*` value, so dark
/// mode and any future rebrand propagate automatically.
enum WFStatusLevel { success, warning, error, neutral }

/// A status indicator that is never color-only — the Accessibility
/// finding in `WoodFlowDesignSystem.md` flagged `SlotGridScreen`'s
/// fill-level chips for exactly this gap. `label` is required, not
/// optional, so a color-blind operator (or anyone glancing quickly in
/// bad light) always has a text fallback, by construction.
class WFStatusChip extends StatelessWidget {
  const WFStatusChip({super.key, required this.label, required this.level, this.icon});

  final String label;
  final WFStatusLevel level;
  final IconData? icon;

  Color _color(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (level) {
      WFStatusLevel.success => scheme.primary,
      WFStatusLevel.warning => scheme.tertiary,
      WFStatusLevel.error => scheme.error,
      WFStatusLevel.neutral => scheme.onSurfaceVariant,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: WFSpacing.sm, vertical: WFSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(WFRadius.small),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: WFSpacing.xs),
          ],
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
