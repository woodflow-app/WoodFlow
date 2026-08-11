import 'package:flutter/material.dart';

/// The one destructive-confirmation shape used everywhere in the app
/// (`WoodFlowDesignSystem.md` §8) — title = question, content =
/// consequence, Cancel (tertiary) + destructive verb (red text
/// button, never a generic "OK"). Extracted from the warehouse- and
/// slot-deletion flows, which had each written this out inline.
///
/// Returns `true` if the user confirmed, `false`/`null` otherwise —
/// callers still own the actual delete/archive call and its
/// success/failure handling, this widget only owns the asking.
Future<bool> showWFConfirmationDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(foregroundColor: Theme.of(dialogContext).colorScheme.error),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
