import 'package:flutter/material.dart';

import 'wf_spacing.dart';

/// The standard create/edit-form pattern — `WoodFlowDesignSystem.md`
/// §8: bottom sheets, not `AlertDialog`, for multi-field forms (more
/// room for the keyboard, more thumb-reachable). Top corners at
/// `WFRadius.large`, keyboard-aware bottom padding, scrollable content
/// area so a taller form on a small screen never gets clipped.
Future<T?> showWFBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(WFRadius.large)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: WFSpacing.lg,
        right: WFSpacing.lg,
        top: WFSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + WFSpacing.lg,
      ),
      child: builder(context),
    ),
  );
}
