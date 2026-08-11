import 'package:flutter/material.dart';

/// Base dialog shell — `WoodFlowDesignSystem.md` §8. Most screens
/// want `WFConfirmationDialog` (destructive confirmations) or
/// `showWFBottomSheet` (create/edit forms) instead of this directly;
/// this exists for the rare custom-content dialog that's neither.
class WFDialog extends StatelessWidget {
  const WFDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
    );
  }
}
