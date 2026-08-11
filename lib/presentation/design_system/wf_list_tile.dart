import 'package:flutter/material.dart';

/// Standard entity list row — `WoodFlowDesignSystem.md` §2/§9:
/// title uses `titleMedium`, subtitle uses `bodyMedium`, both from
/// the theme instead of an inline `TextStyle`. `dense` matches the
/// existing convention (standard density for top-level entity lists,
/// dense for nested sub-lists like Boards/Offcuts inside a Slot).
class WFListTile extends StatelessWidget {
  const WFListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.dense = false,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      dense: dense,
      leading: leading,
      title: Text(title, style: textTheme.titleMedium),
      subtitle: subtitle == null ? null : Text(subtitle!, style: textTheme.bodyMedium),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
