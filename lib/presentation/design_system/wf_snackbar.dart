import 'package:flutter/material.dart';

/// The one snackbar call site — replaces the
/// `ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(...)))`
/// pattern repeated across nearly every screen's error handler.
void showWFSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
