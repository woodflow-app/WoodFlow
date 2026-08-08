import 'package:sqflite/sqflite.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/slot.dart';
import '../../domain/repositories/slot_repository.dart';
import '../database/database_service.dart';
import '../database/qr_code_generator.dart';

const _slotsTable = 'slots';

class SlotRepositoryImpl implements SlotRepository {
  SlotRepositoryImpl(this._db, this._logger);

  final DatabaseService _db;
  final AppLogger _logger;

  @override
  Future<Result<Slot>> getById(String id) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_slotsTable, where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) throw NotFoundException('Slot', id);
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getById failed for slot $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Slot>>> getAll() async {
    try {
      final db = await _db.open();
      final rows = await db.query(_slotsTable, orderBy: 'name ASC');
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getAll failed for slots',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Slot>>> getByRack(String rackId) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_slotsTable,
          where: 'rack_id = ?', whereArgs: [rackId], orderBy: 'name ASC');
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getByRack failed for $rackId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Slot>> getByQrCode(String qrCode) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_slotsTable, where: 'qr_code = ?', whereArgs: [qrCode]);
      if (rows.isEmpty) throw NotFoundException('Slot (by QR)', qrCode);
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getByQrCode failed for "$qrCode"',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// Both `boardCount` and `offcutCount` are real now — Board and
  /// Offcut both exist as of this iteration.
  @override
  Future<Result<List<SlotOccupancy>>> getOccupancyForRack(String rackId) async {
    try {
      final db = await _db.open();
      final slotRows = await db.query(_slotsTable,
          where: 'rack_id = ?', whereArgs: [rackId], orderBy: 'name ASC');

      final result = <SlotOccupancy>[];
      for (final row in slotRows) {
        final slot = _fromRow(row);
        final boardCount = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT COUNT(*) FROM boards WHERE slot_id = ? AND status != ?',
                [slot.id, 'archived'])) ??
            0;
        final offcutCount = Sqflite.firstIntValue(await db.rawQuery(
                'SELECT COUNT(*) FROM offcuts WHERE slot_id = ? AND status != ?',
                [slot.id, 'archived'])) ??
            0;
        result.add(SlotOccupancy(slot: slot, boardCount: boardCount, offcutCount: offcutCount));
      }
      return Result.success(result);
    } catch (e, st) {
      _logger.error('getOccupancyForRack failed for $rackId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Slot>> create(Slot entity) async {
    try {
      final createdSlot = entity.copyWith(qrCode: qrCodeFromEntityId(QrTypeLetters.slot, entity.id));
      await _db.transaction((txn) async {
        await txn.insert(_slotsTable, _toRow(createdSlot),
            conflictAlgorithm: ConflictAlgorithm.abort);
      }, label: 'create slot ${entity.id}');
      return Result.success(createdSlot);
    } catch (e, st) {
      _logger.error('create failed for slot ${entity.id}',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Slot>> update(Slot entity) async {
    try {
      final count = await _db.transaction((txn) async {
        return txn.update(_slotsTable, _toRow(entity),
            where: 'id = ?', whereArgs: [entity.id]);
      }, label: 'update slot ${entity.id}');
      if (count == 0) throw NotFoundException('Slot', entity.id);
      return Result.success(entity);
    } catch (e, st) {
      _logger.error('update failed for slot ${entity.id}',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// ⚠️ Brak wymuszenia uprawnień — patrz docs/QR_CODES.md.
  @override
  Future<Result<Slot>> regenerateQrCode(String id) async {
    final current = await getById(id);
    if (current.isFailure) return Result.failure(current.failure);

    try {
      final updated = current.data.copyWith(qrCode: randomQrCode(QrTypeLetters.slot));
      await _db.transaction((txn) async {
        final count = await txn.update(_slotsTable, _toRow(updated),
            where: 'id = ?', whereArgs: [id]);
        if (count == 0) throw NotFoundException('Slot', id);
      }, label: 'regenerate QR for slot $id');

      _logger.info('Regenerated QR for slot $id', tag: 'REPOSITORY');
      return Result.success(updated);
    } catch (e, st) {
      _logger.error('regenerateQrCode failed for slot $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// Physical DELETE, matching the old app: "usunięcie slotu nie
  /// usuwa przypisanych ścinek" — we simply don't cascade; any
  /// board/offcut referencing this slot_id keeps the (now dangling)
  /// reference. A future Slice can add a cleanup step if that proves
  /// confusing in practice — not speculatively building it now.
  @override
  Future<Result<void>> delete(String id) async {
    try {
      final count = await _db.transaction((txn) async {
        return txn.delete(_slotsTable, where: 'id = ?', whereArgs: [id]);
      }, label: 'delete slot $id');
      if (count == 0) throw NotFoundException('Slot', id);
      return Result.success(null);
    } catch (e, st) {
      _logger.error('delete failed for slot $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  Slot _fromRow(Map<String, Object?> row) => Slot(
        id: row['id'] as String,
        rackId: row['rack_id'] as String,
        name: row['name'] as String,
        capacity: row['capacity'] as int,
        qrCode: row['qr_code'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
      );

  Map<String, Object?> _toRow(Slot s) => {
        'id': s.id,
        'rack_id': s.rackId,
        'name': s.name,
        'capacity': s.capacity,
        'qr_code': s.qrCode,
        'created_at': s.createdAt.millisecondsSinceEpoch,
        'updated_at': s.updatedAt.millisecondsSinceEpoch,
      };
}
