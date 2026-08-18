import '../../core/errors/failures.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/decor_catalog_entry.dart';
import '../../domain/repositories/decor_catalog_repository.dart';
import '../database/database_service.dart';

const _table = 'decor_catalog_entries';

class DecorCatalogRepositoryImpl implements DecorCatalogRepository {
  DecorCatalogRepositoryImpl(this._db, this._logger);

  final DatabaseService _db;
  final AppLogger _logger;

  /// For the 4 legacy-linked rows, `decors.name`/`decors.manufacturer`
  /// are the sole authoritative source — `decor_catalog_entries`
  /// stores no independent copy for them (both columns are NULL on
  /// those rows). `COALESCE` resolves the one real value regardless
  /// of which table actually holds it, so the UI never needs to know.
  @override
  Future<Result<List<DecorCatalogEntry>>> getAll() async {
    try {
      final db = await _db.open();
      final rows = await db.rawQuery('''
        SELECT
          dce.id, dce.code, dce.texture, dce.product_type,
          dce.image_url, dce.swatch_color, dce.decor_id,
          dce.created_at, dce.updated_at,
          COALESCE(dce.name, d.name) AS name,
          COALESCE(dce.manufacturer, d.manufacturer) AS manufacturer
        FROM $_table dce
        LEFT JOIN decors d ON dce.decor_id = d.id
        ORDER BY dce.code ASC
      ''');
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getAll failed for decor catalog entries',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  DecorCatalogEntry _fromRow(Map<String, Object?> row) => DecorCatalogEntry(
        id: row['id'] as String,
        code: row['code'] as String,
        texture: row['texture'] as String?,
        productType: row['product_type'] as String? ?? 'Board',
        name: row['name'] as String,
        manufacturer: row['manufacturer'] as String,
        imageUrl: row['image_url'] as String?,
        swatchColor: row['swatch_color'] as String?,
        decorId: row['decor_id'] as String?,
        createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
      );
}
