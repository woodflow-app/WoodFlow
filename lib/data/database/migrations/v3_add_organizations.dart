import 'package:sqflite/sqflite.dart';

import 'migration_runner.dart';

/// v3: Organization — root of the hierarchy per Domain Model Audit
/// and ADR-003. Inserted BEFORE Board/Offcut on purpose, per the
/// Pre-Build Audit: adding this now is one migration; adding it
/// after Board/Offcut/Reservation exist would touch every table.
///
/// Every install gets exactly one default Organization row today —
/// multi-org is a v2.5 feature, not built now, but the seam exists
/// so v2.5 doesn't require a schema rebuild (ADR-003's whole point).
class V3AddOrganizationsMigration implements Migration {
  @override
  int get version => 3;

  @override
  Future<void> up(Database db) async {
    await db.execute('''
      CREATE TABLE organizations (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    final now = DateTime.now().millisecondsSinceEpoch;
    await db.insert('organizations', {
      'id': 'org-default',
      'name': 'Default Organization',
      'created_at': now,
      'updated_at': now,
    });

    // DEFAULT lets this be NOT NULL even though `warehouses` may
    // already have rows by the time this migration runs — every
    // existing warehouse is backfilled onto the default org.
    //
    // NOTE (found in full codebase audit): `PRAGMA foreign_keys` is
    // never enabled anywhere in this project (see
    // database_service.dart), so this REFERENCES clause — like every
    // other FK declared in every migration — is documentation, not
    // an enforced constraint. Deliberate: validation happens at the
    // repository layer (getById() checks before every insert), not
    // at the SQLite layer. Stated here explicitly so it's a known
    // characteristic, not an accidentally-missing safety net.
    await db.execute(
      "ALTER TABLE warehouses ADD COLUMN organization_id TEXT NOT NULL "
      "DEFAULT 'org-default' REFERENCES organizations (id)",
    );
    await db.execute(
      'CREATE INDEX idx_warehouses_org ON warehouses (organization_id)',
    );
  }
}
