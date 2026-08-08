import 'package:sqflite/sqflite.dart';

import 'migration_runner.dart';

/// v6: Offcut — self-sufficient per ADR-022 ("nigdy nie jest małym
/// Board"). `slot_id` and `decor_id` are its own real columns (not
/// derived through parent_board_id for day-to-day reads), matching
/// exactly Board's location/decor model. `parent_board_id` is kept
/// purely for provenance.
class V6AddOffcutsMigration implements Migration {
  @override
  int get version => 6;

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE offcuts (
        id TEXT PRIMARY KEY,
        parent_board_id TEXT NOT NULL,
        slot_id TEXT NOT NULL,
        decor_id TEXT NOT NULL,
        length REAL NOT NULL,
        width REAL NOT NULL,
        thickness REAL NOT NULL,
        qr_code TEXT NOT NULL UNIQUE,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (parent_board_id) REFERENCES boards (id),
        FOREIGN KEY (slot_id) REFERENCES slots (id),
        FOREIGN KEY (decor_id) REFERENCES decors (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE offcut_transactions (
        id TEXT PRIMARY KEY,
        offcut_id TEXT NOT NULL,
        type TEXT NOT NULL,
        from_slot_id TEXT,
        to_slot_id TEXT,
        occurred_at INTEGER NOT NULL,
        user_id TEXT,
        note TEXT,
        FOREIGN KEY (offcut_id) REFERENCES offcuts (id)
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_offcuts_parent_board ON offcuts (parent_board_id)',
    );
    await db.execute('CREATE INDEX idx_offcuts_slot ON offcuts (slot_id)');
    await db.execute('CREATE INDEX idx_offcuts_decor ON offcuts (decor_id)');
  }
}
