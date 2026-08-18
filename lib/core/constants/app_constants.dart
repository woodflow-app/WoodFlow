/// Central place for app-wide constants.
/// Keep this file small — only truly global values belong here.
/// Module-specific constants (e.g. Warehouse limits) should live
/// next to that module, not here.
class AppConstants {
  AppConstants._();

  // --- Database ---
  static const String dbName = 'woodflow.db';
  static const int dbVersion = 10;

  // --- Logging ---
  static const String logTagDatabase = 'DATABASE';
  static const String logTagRepository = 'REPOSITORY';
  static const String logTagMigration = 'MIGRATION';

  /// If false, debug/info/warning logs are suppressed in release builds.
  /// Errors always log regardless — see AppLogger.error().
  static const bool verboseLoggingInRelease = false;
}
