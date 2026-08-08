import 'package:sqflite/sqflite.dart';

import 'migration_runner.dart';

/// v5: Board. `slot_id` is the ONLY location column, REQUIRED
/// (NOT NULL), with a real FK to `slots` from this very first
/// CREATE TABLE — Warehouse/Rack are always derived by joining
/// slots → racks → warehouses, never stored redundantly (Piotr's
/// correction).
///
/// `decor_id` (not `decor_code`) references the `decors` catalog
/// from v4 — per ADR-002, decor is a shared reference, not text
/// copied onto every board. This is the earlier draft's mistake,
/// caught by the Pre-Build Audit before Board shipped anywhere.
class V5AddBoardsMigration implements Migration {
  @override
  int get version => 5;

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE boards (
        id TEXT PRIMARY KEY,
        slot_id TEXT NOT NULL,
        decor_id TEXT NOT NULL,
        length REAL NOT NULL,
        width REAL NOT NULL,
        thickness REAL NOT NULL,
        qr_code TEXT NOT NULL UNIQUE,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (slot_id) REFERENCES slots (id),
        FOREIGN KEY (decor_id) REFERENCES decors (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE board_transactions (
        id TEXT PRIMARY KEY,
        board_id TEXT NOT NULL,
        type TEXT NOT NULL,
        from_slot_id TEXT,
        to_slot_id TEXT,
        occurred_at INTEGER NOT NULL,
        user_id TEXT,
        note TEXT,
        FOREIGN KEY (board_id) REFERENCES boards (id)
      )
    ''');

    // Generic on purpose (entity_type/entity_id) — Offcut and future
    // entities log into this same table without a schema change.
    // transaction_id is intentionally NOT a strict FK: it will point
    // to board_transactions.id for Board events and to a future
    // offcut_transactions.id for Offcut events — resolved by
    // entity_type, not by a single physical FK to one table.
    await db.execute('''
      CREATE TABLE ledger_entries (
        id TEXT PRIMARY KEY,
        transaction_id TEXT NOT NULL,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        event_type TEXT NOT NULL,
        occurred_at INTEGER NOT NULL,
        user_id TEXT,
        payload TEXT NOT NULL
      )
    ''');

    await db.execute('CREATE INDEX idx_boards_slot ON boards (slot_id)');
    await db.execute('CREATE INDEX idx_boards_decor ON boards (decor_id)');
    await db.execute(
      'CREATE INDEX idx_ledger_entity ON ledger_entries (entity_type, entity_id)',
    );
  }
}
