import 'dart:developer' as developer;
import 'package:flutter/foundation.dart' show kReleaseMode;

import '../constants/app_constants.dart';

enum LogLevel { debug, info, warning, error }

/// Single logging surface for WoodFlow. Every migration, query, and
/// exception goes through here — nothing gets logged with a bare
/// `print()` anywhere else in the codebase.
///
/// Swap the implementation later (e.g. write to file, send to a
/// remote service) without touching a single call site.
class AppLogger {
  const AppLogger();

  bool get _mutedInRelease =>
      kReleaseMode && !AppConstants.verboseLoggingInRelease;

  void debug(String message, {String tag = 'APP'}) {
    if (_mutedInRelease) return;
    _log(LogLevel.debug, tag, message);
  }

  void info(String message, {String tag = 'APP'}) {
    if (_mutedInRelease) return;
    _log(LogLevel.info, tag, message);
  }

  void warning(String message, {String tag = 'APP'}) {
    if (_mutedInRelease) return;
    _log(LogLevel.warning, tag, message);
  }

  /// Errors always log, even in release — this is what a future
  /// Crashlytics/Sentry hook plugs into.
  void error(
    String message, {
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, tag, message);
    if (error != null) {
      developer.log(
        message,
        name: tag,
        error: error,
        stackTrace: stackTrace,
        level: 1000,
      );
    }
  }

  void _log(LogLevel level, String tag, String message) {
    developer.log(
      message,
      name: tag,
      level: _levelToInt(level),
      time: DateTime.now(),
    );
  }

  int _levelToInt(LogLevel level) => switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      };
}
