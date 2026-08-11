import 'package:flutter/material.dart';

import 'wf_button.dart';
import 'wf_spacing.dart';

/// Standard empty-state — `WoodFlowDesignSystem.md` §12. Replaces the
/// independently-written icon-less centered `Text` blocks on every
/// list screen with one widget: icon + title + description + an
/// optional call-to-action. `actionLabel`/`onAction` are both-or-neither
/// — omit both for a screen with no obvious next action.
class WFEmptyState extends StatelessWidget {
  const WFEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(WFSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: WFSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (description != null) ...[
              const SizedBox(height: WFSpacing.sm),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: WFSpacing.lg),
              WFButton(label: actionLabel!, onPressed: onAction, icon: Icons.add),
            ],
          ],
        ),
      ),
    );
  }
}
