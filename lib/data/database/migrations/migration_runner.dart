import 'package:sqflite/sqflite.dart';

import 'v1_initial.dart';
import 'v2_add_racks_and_slots.dart';
import 'v3_add_organizations.dart';
import 'v4_add_decors.dart';
import 'v5_add_boards.dart';
import 'v6_add_offcuts.dart';
import 'v7_seed_egger_decors.dart';
import 'v8_add_decor_minimum_stock.dart';
import 'v10_full_migration_fixed.dart';

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
    V7SeedEggerDecorsMigration(),
    V8AddDecorMinimumStockMigration(),
    // V9 is reserved for Krok 15's v9_add_cutting_jobs.dart (Cut
    // Optimizer, docs/specs/Krok15_CutOptimizer_Specification.md
    // lines 295, 445-446) — not implemented yet, do not use v9 here.
    V10RestructureAndSeedDecorsMigration(),
  ];

  static Future<void> run(Database db, int fromVersion, int toVersion) async {
    for (final migration in _migrations) {
      if (migration.version > fromVersion && migration.version <= toVersion) {
        await migration.up(db);
      }
    }
  }
}
