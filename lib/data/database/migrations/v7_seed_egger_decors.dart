import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../decor_seeds/egger_decor_seed.dart';
import 'migration_runner.dart';

/// v7: Krok 12 — imports the full, verified EGGER decor catalog (421
/// entries) that v4 deliberately left for later. Row-only migration,
/// no schema change — `decors` already has everything it needs
/// (`code UNIQUE`, `name`, `manufacturer`).
///
/// Doesn't touch v4's 4 test rows — their bare codes ('H3303' etc.,
/// no texture suffix) never collide with this file's full
/// "CODE TEXTURE" codes (e.g. 'H3303 ST10'), and deleting rows an
/// already-created Board/Offcut might reference by `decor_id` would
/// orphan a foreign key. They just stay as harmless leftover fixtures.
///
/// EXTENDING WITH A NEW MANUFACTURER (the whole point of Krok 12's
/// architecture): add two files, never touch this one or any earlier
/// migration —
///   1. `lib/data/decor_seeds/<manufacturer>_decor_seed.dart` — a
///      `<manufacturer>Manufacturer` name constant + a
///      `List<(String code, String name)>` of verified entries, same
///      shape as `egger_decor_seed.dart`.
///   2. `lib/data/database/migrations/v8_seed_<manufacturer>_decors.dart`
///      — copy this file, swap the import and the two identifiers
///      below, bump `version` to 8.
/// Then register the new migration in `migration_runner.dart` (one
/// import + one line in `_migrations`) and bump
/// `AppConstants.dbVersion` — the same two-line registration every
/// migration from v1 onward has always required.
class V7SeedEggerDecorsMigration implements Migration {
  @override
  int get version => 7;

  @override
  Future<void> up(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    const uuid = Uuid();

    final batch = db.batch();
    for (final (code, name) in eggerDecorSeed) {
      batch.insert('decors', {
        'id': uuid.v4(),
        'code': code,
        'name': name,
        'manufacturer': eggerManufacturer,
        'created_at': now,
        'updated_at': now,
      });
    }
    await batch.commit(noResult: true);
  }
}
