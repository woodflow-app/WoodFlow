import 'package:sqflite/sqflite.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/repositories/warehouse_repository.dart';
import '../database/database_service.dart';
import '../database/qr_code_generator.dart';

const _table = 'warehouses';

class WarehouseRepositoryImpl implements WarehouseRepository {
  WarehouseRepositoryImpl(this._db, this._logger);

  final DatabaseService _db;
  final AppLogger _logger;

  @override
  Future<Result<Warehouse>> getById(String id) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_table, where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) {
        throw NotFoundException('Warehouse', id);
      }
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getById failed for warehouse $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Warehouse>>> getAll() async {
    try {
      final db = await _db.open();
      final rows = await db.query(_table, orderBy: 'name ASC');
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getAll failed for warehouses',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Warehouse>> getByQrCode(String qrCode) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_table, where: 'qr_code = ?', whereArgs: [qrCode]);
      if (rows.isEmpty) throw NotFoundException('Warehouse (by QR)', qrCode);
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getByQrCode failed for "$qrCode"',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// Generates the QR code INSIDE the same transaction as the insert
  /// — whatever qrCode was on [entity] (should always be the default
  /// `''`) is overwritten here. See qr_code_generator.dart and
  /// Warehouse.qrCode doc comment.
  @override
  Future<Result<Warehouse>> create(Warehouse entity) async {
    try {
      final createdWarehouse =
          entity.copyWith(qrCode: qrCodeFromEntityId(QrTypeLetters.warehouse, entity.id));
      await _db.transaction((txn) async {
        await txn.insert(_table, _toRow(createdWarehouse),
            conflictAlgorithm: ConflictAlgorithm.abort);
      }, label: 'create warehouse ${entity.id}');
      _logger.info('Created warehouse ${entity.id}', tag: 'REPOSITORY');
      return Result.success(createdWarehouse);
    } catch (e, st) {
      _logger.error('create failed for warehouse ${entity.id}',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Warehouse>> update(Warehouse entity) async {
    try {
      final count = await _db.transaction((txn) async {
        return txn.update(_table, _toRow(entity),
            where: 'id = ?', whereArgs: [entity.id]);
      }, label: 'update warehouse ${entity.id}');

      if (count == 0) {
        throw NotFoundException('Warehouse', entity.id);
      }
      return Result.success(entity);
    } catch (e, st) {
      _logger.error('update failed for warehouse ${entity.id}',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// ⚠️ Brak wymuszenia uprawnień — patrz docs/QR_CODES.md i doc
  /// comment w WarehouseRepository.regenerateQrCode.
  @override
  Future<Result<Warehouse>> regenerateQrCode(String id) async {
    final current = await getById(id);
    if (current.isFailure) return Result.failure(current.failure);

    try {
      final updated = current.data.copyWith(qrCode: randomQrCode(QrTypeLetters.warehouse));
      await _db.transaction((txn) async {
        final count = await txn.update(_table, _toRow(updated),
            where: 'id = ?', whereArgs: [id]);
        if (count == 0) throw NotFoundException('Warehouse', id);
      }, label: 'regenerate QR for warehouse $id');

      _logger.info('Regenerated QR for warehouse $id', tag: 'REPOSITORY');
      return Result.success(updated);
    } catch (e, st) {
      _logger.error('regenerateQrCode failed for warehouse $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      final count = await _db.transaction((txn) async {
        return txn.delete(_table, where: 'id = ?', whereArgs: [id]);
      }, label: 'delete warehouse $id');

      if (count == 0) {
        throw NotFoundException('Warehouse', id);
      }
      return Result.success(null);
    } catch (e, st) {
      _logger.error('delete failed for warehouse $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Warehouse>>> searchByName(String query) async {
    try {
      final db = await _db.open();
      final rows = await db.query(
        _table,
        where: 'name LIKE ?',
        whereArgs: ['%$query%'],
        orderBy: 'name ASC',
      );
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('searchByName failed for "$query"',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  // --- Row <-> Entity mapping. Only this class knows these column names. ---

  Warehouse _fromRow(Map<String, Object?> row) => Warehouse(
        id: row['id'] as String,
        organizationId: row['organization_id'] as String,
        name: row['name'] as String,
        address: row['address'] as String?,
        qrCode: row['qr_code'] as String,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
        updatedAt:
            DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
      );

  Map<String, Object?> _toRow(Warehouse w) => {
        'id': w.id,
        'organization_id': w.organizationId,
        'name': w.name,
        'address': w.address,
        'qr_code': w.qrCode,
        'created_at': w.createdAt.millisecondsSinceEpoch,
        'updated_at': w.updatedAt.millisecondsSinceEpoch,
      };
}
