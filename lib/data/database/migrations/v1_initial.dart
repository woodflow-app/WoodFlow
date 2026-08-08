import 'package:sqflite/sqflite.dart';

import 'migration_runner.dart';

/// v1: introduces the `warehouses` table.
/// Keep migrations append-only — never edit this file once it has
/// shipped to a real device. Corrections go in a new v2+ migration.
class V1InitialMigration implements Migration {
  @override
  int get version => 1;

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE warehouses (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT,
        qr_code TEXT NOT NULL UNIQUE,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }
}
