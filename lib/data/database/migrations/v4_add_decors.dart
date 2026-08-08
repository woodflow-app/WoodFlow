import 'package:sqflite/sqflite.dart';

import 'migration_runner.dart';

/// v4: Decor — global catalog per ADR-002. Inserted BEFORE Board
/// (v5) so Board can reference `decor_id` from its very first
/// CREATE TABLE, instead of copying a free-text code the way the
/// old app (and our own first draft of Board) did.
///
/// Seeded with a handful of common codes for development/testing —
/// NOT the full 421 EGGER+Kronospan+Pfleiderer catalog. That's a
/// data-import task (the old app already has `egger_decors_seed.dart`
/// to reuse), not a schema decision — deliberately not done here.
class V4AddDecorsMigration implements Migration {
  @override
  int get version => 4;

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE decors (
        id TEXT PRIMARY KEY,
        code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        manufacturer TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_decors_code ON decors (code)');

    final now = DateTime.now().millisecondsSinceEpoch;
    const seed = [
      ('decor-h3303', 'H3303', 'Natural Hamilton Oak', 'EGGER'),
      ('decor-u702', 'U702', 'Alpine White', 'EGGER'),
      ('decor-h1180', 'H1180', 'Denver Wenge', 'EGGER'),
      ('decor-u708', 'U708', 'Light Grey', 'EGGER'),
    ];
    for (final (id, code, name, manufacturer) in seed) {
      await db.insert('decors', {
        'id': id,
        'code': code,
        'name': name,
        'manufacturer': manufacturer,
        'created_at': now,
        'updated_at': now,
      });
    }
  }
}
