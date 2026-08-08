import 'package:sqflite/sqflite.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/rack.dart';
import '../../domain/repositories/rack_repository.dart';
import '../database/database_service.dart';
import '../database/qr_code_generator.dart';

const _racksTable = 'racks';

class RackRepositoryImpl implements RackRepository {
  RackRepositoryImpl(this._db, this._logger);

  final DatabaseService _db;
  final AppLogger _logger;

  @override
  Future<Result<Rack>> getById(String id) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_racksTable, where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) throw NotFoundException('Rack', id);
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getById failed for rack $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Rack>>> getAll() async {
    try {
      final db = await _db.open();
      final rows = await db.query(_racksTable, orderBy: 'name ASC');
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getAll failed for racks',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Rack>>> getByWarehouse(String warehouseId) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_racksTable,
          where: 'warehouse_id = ?', whereArgs: [warehouseId], orderBy: 'name ASC');
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getByWarehouse failed for $warehouseId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Rack>> getByQrCode(String qrCode) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_racksTable, where: 'qr_code = ?', whereArgs: [qrCode]);
      if (rows.isEmpty) throw NotFoundException('Rack (by QR)', qrCode);
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getByQrCode failed for "$qrCode"',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Rack>> create(Rack entity) async {
    try {
      final createdRack = entity.copyWith(qrCode: qrCodeFromEntityId(QrTypeLetters.rack, entity.id));
      await _db.transaction((txn) async {
        await txn.insert(_racksTable, _toRow(createdRack),
            conflictAlgorithm: ConflictAlgorithm.abort);
      }, label: 'create rack ${entity.id}');
      return Result.success(createdRack);
    } catch (e, st) {
      _logger.error('create failed for rack ${entity.id}',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Rack>> update(Rack entity) async {
    try {
      final count = await _db.transaction((txn) async {
        return txn.update(_racksTable, _toRow(entity),
            where: 'id = ?', whereArgs: [entity.id]);
      }, label: 'update rack ${entity.id}');
      if (count == 0) throw NotFoundException('Rack', entity.id);
      return Result.success(entity);
    } catch (e, st) {
      _logger.error('update failed for rack ${entity.id}',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// ⚠️ Brak wymuszenia uprawnień — patrz docs/QR_CODES.md.
  @override
  Future<Result<Rack>> regenerateQrCode(String id) async {
    final current = await getById(id);
    if (current.isFailure) return Result.failure(current.failure);

    try {
      final updated = current.data.copyWith(qrCode: randomQrCode(QrTypeLetters.rack));
      await _db.transaction((txn) async {
        final count = await txn.update(_racksTable, _toRow(updated),
            where: 'id = ?', whereArgs: [id]);
        if (count == 0) throw NotFoundException('Rack', id);
      }, label: 'regenerate QR for rack $id');

      _logger.info('Regenerated QR for rack $id', tag: 'REPOSITORY');
      return Result.success(updated);
    } catch (e, st) {
      _logger.error('regenerateQrCode failed for rack $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// Physical DELETE — matches the old app's behavior exactly
  /// ("Usunąć cały regał? Usunięte zostaną wszystkie sloty tego
  /// regału."). Racks/Slots have no ledger history of their own, so
  /// unlike Board/Offcut there's no append-only trail to protect.
  @override
  Future<Result<void>> delete(String id) async {
    try {
      final count = await _db.transaction((txn) async {
        return txn.delete(_racksTable, where: 'id = ?', whereArgs: [id]);
      }, label: 'delete rack $id');
      if (count == 0) throw NotFoundException('Rack', id);
      return Result.success(null);
    } catch (e, st) {
      _logger.error('delete failed for rack $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  Rack _fromRow(Map<String, Object?> row) => Rack(
        id: row['id'] as String,
        warehouseId: row['warehouse_id'] as String,
        name: row['name'] as String,
        qrCode: row['qr_code'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
      );

  Map<String, Object?> _toRow(Rack r) => {
        'id': r.id,
        'warehouse_id': r.warehouseId,
        'name': r.name,
        'qr_code': r.qrCode,
        'created_at': r.createdAt.millisecondsSinceEpoch,
        'updated_at': r.updatedAt.millisecondsSinceEpoch,
      };
}
