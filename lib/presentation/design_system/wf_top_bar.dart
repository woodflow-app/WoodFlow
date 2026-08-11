import 'package:flutter/material.dart';

/// Standard app bar — `WoodFlowDesignSystem.md` §4/§10: flat
/// (elevation 0, the Material 3 default already in effect — this
/// widget doesn't override it, just gives every screen one call site
/// instead of constructing `AppBar` fresh each time), back navigation
/// automatic, actions ordered by the caller (most-frequent action
/// closest to the leading edge, per the design system's navigation
/// rule).
class WFTopBar extends StatelessWidget implements PreferredSizeWidget {
  const WFTopBar({super.key, required this.title, this.actions, this.bottom});

  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), actions: actions, bottom: bottom);
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
