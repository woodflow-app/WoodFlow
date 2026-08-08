import 'package:path/path.dart' as p;
// sqflite exports its own DatabaseException — hidden here because it
// collides with our core/errors/exceptions.dart DatabaseException.
// Without this, `throw DatabaseException(...)` below is ambiguous
// and fails to compile ("defined in libraries ... and ...").
import 'package:sqflite/sqflite.dart' hide DatabaseException;

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/logging/app_logger.dart';
import 'migrations/migration_runner.dart';

/// One class, one job: manage the SQLite connection's lifecycle.
/// It knows nothing about Warehouse, Board, or any domain concept —
/// that belongs to the migrations/ folder and the repositories built
/// on top.
///
/// No internal singleton here — get_it owns the single instance
/// (registered as a lazy singleton in service_locator.dart). Two
/// mechanisms managing the same lifecycle was the earlier mistake;
/// DI is now the only one.
class DatabaseService {
  /// [inMemory] is for tests only — keeps each test run isolated with
  /// zero disk state, never used by the real app.
  DatabaseService(this._logger, {bool inMemory = false})
      : _inMemory = inMemory;

  final AppLogger _logger;
  final bool _inMemory;
  Database? _db;

  Future<Database> open() async {
    if (_db != null) return _db!;

    try {
      final path = _inMemory
          ? inMemoryDatabasePath
          : p.join(await getDatabasesPath(), AppConstants.dbName);

      _logger.info('Opening database at $path',
          tag: AppConstants.logTagDatabase);

      _db = await openDatabase(
        path,
        version: AppConstants.dbVersion,
        onCreate: (db, version) async {
          _logger.info('Creating database v$version',
              tag: AppConstants.logTagMigration);
          await MigrationRunner.run(db, 0, version);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          _logger.info('Upgrading database v$oldVersion → v$newVersion',
              tag: AppConstants.logTagMigration);
          await MigrationRunner.run(db, oldVersion, newVersion);
        },
      );

      return _db!;
    } catch (e, st) {
      _logger.error('Failed to open database',
          tag: AppConstants.logTagDatabase, error: e, stackTrace: st);
      throw DatabaseException('Could not open database', cause: e);
    }
  }

  Future<void> close() async {
    if (_db == null) return;
    await _db!.close();
    _db = null;
    _logger.info('Database closed', tag: AppConstants.logTagDatabase);
  }

  /// Runs a block of work inside a single SQLite transaction.
  /// Repositories should wrap every multi-step write in this —
  /// e.g. an inventory transaction that also writes a ledger entry.
  ///
  /// IMPORTANT: if [action] throws one of our own domain exceptions
  /// (NotFoundException, ValidationException, MigrationException),
  /// it is rethrown UNCHANGED — not wrapped into a generic
  /// DatabaseException. Repositories currently guard against missing
  /// rows before ever entering a transaction, so this rarely fires,
  /// but if a `count == 0` check ever runs inside the callback (e.g.
  /// a race condition), the caller must still get back the correct,
  /// specific exception type — otherwise mapExceptionToFailure()
  /// would produce a misleading DatabaseFailure instead of
  /// NotFoundFailure.
  Future<T> transaction<T>(
    Future<T> Function(Transaction txn) action, {
    String? label,
  }) async {
    final db = await open();
    try {
      _logger.debug('Starting transaction${label != null ? ': $label' : ''}',
          tag: AppConstants.logTagDatabase);
      return await db.transaction(action);
    } on NotFoundException {
      rethrow;
    } on ValidationException {
      rethrow;
    } on MigrationException {
      rethrow;
    } catch (e, st) {
      _logger.error('Transaction failed${label != null ? ': $label' : ''}',
          tag: AppConstants.logTagDatabase, error: e, stackTrace: st);
      throw DatabaseException('Transaction failed', cause: e);
    }
  }
}
