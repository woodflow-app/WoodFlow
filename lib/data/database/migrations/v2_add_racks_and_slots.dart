import 'package:sqflite/sqflite.dart';

import 'migration_runner.dart';

/// v2: Rack and Slot — the second module built, right after
/// Warehouse, per the corrected hierarchy:
/// Warehouse → Rack → Slot → Board → Offcut.
///
/// This comes BEFORE Board on purpose. Board's own migration (built
/// later) will include `slot_id` as a normal column with a real FK
/// to `slots` from its very first CREATE TABLE — not retrofitted via
/// ALTER TABLE after the fact. Rack/Slot existing first is what
/// makes that possible.
class V2AddRacksAndSlotsMigration implements Migration {
  @override
  int get version => 2;

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE racks (
        id TEXT PRIMARY KEY,
        warehouse_id TEXT NOT NULL,
        name TEXT NOT NULL,
        qr_code TEXT NOT NULL UNIQUE,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (warehouse_id) REFERENCES warehouses (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE slots (
        id TEXT PRIMARY KEY,
        rack_id TEXT NOT NULL,
        name TEXT NOT NULL,
        capacity INTEGER NOT NULL DEFAULT 20,
        qr_code TEXT NOT NULL UNIQUE,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (rack_id) REFERENCES racks (id)
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_racks_warehouse ON racks (warehouse_id)',
    );
    await db.execute(
      'CREATE INDEX idx_slots_rack ON slots (rack_id)',
    );
  }
}
