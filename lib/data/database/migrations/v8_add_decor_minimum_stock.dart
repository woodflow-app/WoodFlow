import 'package:sqflite/sqflite.dart';

import 'migration_runner.dart';

/// v8: Krok 13 — adds the per-decor low-stock threshold
/// (`Decor.minimumStockQuantity`). Nullable column, no default beyond
/// SQLite's implicit NULL — every existing row (the 4 v4 fixtures and
/// the 421 v7 EGGER decors) gets no threshold, meaning "never alert,"
/// which is the only safe default: this migration must not invent
/// reorder points nobody has actually decided on.
class V8AddDecorMinimumStockMigration implements Migration {
  @override
  int get version => 8;

  @override
  Future<void> up(Database db) async {
    await db.execute('ALTER TABLE decors ADD COLUMN minimum_stock_quantity INTEGER');
  }
}
