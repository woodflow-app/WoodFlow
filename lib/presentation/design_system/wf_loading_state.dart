import 'package:flutter/material.dart';

/// Standard loading state — `WoodFlowDesignSystem.md` §13. Already
/// consistent across the app before this widget existed (centered
/// `CircularProgressIndicator`, no size/color override) — this just
/// gives it one call site instead of N identical inline copies.
class WFLoadingState extends StatelessWidget {
  const WFLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
