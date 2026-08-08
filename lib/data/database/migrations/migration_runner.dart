import 'package:sqflite/sqflite.dart';

import 'v1_initial.dart';
import 'v2_add_racks_and_slots.dart';
import 'v3_add_organizations.dart';
import 'v4_add_decors.dart';
import 'v5_add_boards.dart';
import 'v6_add_offcuts.dart';

/// A single migration step. Each version bump gets one implementation
/// of this in its own file.
abstract class Migration {
  int get version;
  Future<void> up(Database db);
}

/// Ordered registry of every migration WoodFlow has ever shipped.
/// DatabaseService never contains SQL directly — it just asks this
/// runner to bring the db from `fromVersion` to `toVersion`.
class MigrationRunner {
  static final List<Migration> _migrations = [
    V1InitialMigration(),
    V2AddRacksAndSlotsMigration(),
    V3AddOrganizationsMigration(),
    V4AddDecorsMigration(),
    V5AddBoardsMigration(),
    V6AddOffcutsMigration(),
    // V7... ← next migration goes here, in order
  ];

  static Future<void> run(Database db, int fromVersion, int toVersion) async {
    for (final migration in _migrations) {
      if (migration.version > fromVersion && migration.version <= toVersion) {
        await migration.up(db);
      }
    }
  }
}
