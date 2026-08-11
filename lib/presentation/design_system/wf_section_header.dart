import 'package:flutter/material.dart';

import 'wf_spacing.dart';

/// The "PŁYTY" / "ŚCINKI" style section label — `WoodFlowDesignSystem.md`
/// §2: `labelMedium` from the theme, muted color, instead of each
/// screen picking its own inline `TextStyle(fontSize: 11, ...)`.
class WFSectionHeader extends StatelessWidget {
  const WFSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: WFSpacing.xs),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
