import 'dart:convert';

import 'package:sqflite/sqflite.dart' hide DatabaseException;
import 'package:uuid/uuid.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/events/event_publisher.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/offcut.dart';
import '../../domain/entities/offcut_transaction.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/events/offcut_events.dart';
import '../../domain/repositories/board_repository.dart';
import '../../domain/repositories/offcut_repository.dart';
import '../../domain/repositories/slot_repository.dart';
import '../database/database_service.dart';
import '../database/qr_code_generator.dart';

const _offcutsTable = 'offcuts';
const _transactionsTable = 'offcut_transactions';
const _ledgerTable = 'ledger_entries';
const _entityTypeOffcut = 'offcut';

class OffcutRepositoryImpl implements OffcutRepository {
  OffcutRepositoryImpl(
      this._db, this._logger, this._events, this._boards, this._slots);

  final DatabaseService _db;
  final AppLogger _logger;
  final EventPublisher _events;
  final BoardRepository _boards; // reads parent's decorId, validates existence
  final SlotRepository _slots; // only used to validate slot existence
  final _uuid = const Uuid();

  @override
  Future<Result<Offcut>> getById(String id) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_offcutsTable, where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) throw NotFoundException('Offcut', id);
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getById failed for offcut $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Offcut>>> getAll({bool includeArchived = false}) async {
    try {
      final db = await _db.open();
      final rows = includeArchived
          ? await db.query(_offcutsTable, orderBy: 'created_at DESC')
          : await db.query(_offcutsTable,
              where: 'status != ?',
              whereArgs: [OffcutStatus.archived.dbValue],
              orderBy: 'created_at DESC');
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getAll failed for offcuts',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Offcut>>> getBySlot(String slotId) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_offcutsTable,
          where: 'slot_id = ?', whereArgs: [slotId], orderBy: 'created_at DESC');
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getBySlot failed for $slotId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Offcut>>> getByRack(String rackId) async {
    try {
      final db = await _db.open();
      final rows = await db.rawQuery('''
        SELECT offcuts.* FROM offcuts
        JOIN slots ON offcuts.slot_id = slots.id
        WHERE slots.rack_id = ?
        ORDER BY offcuts.created_at DESC
      ''', [rackId]);
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getByRack failed for $rackId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Offcut>>> getByWarehouse(String warehouseId) async {
    try {
      final db = await _db.open();
      final rows = await db.rawQuery('''
        SELECT offcuts.* FROM offcuts
        JOIN slots ON offcuts.slot_id = slots.id
        JOIN racks ON slots.rack_id = racks.id
        WHERE racks.warehouse_id = ?
        ORDER BY offcuts.created_at DESC
      ''', [warehouseId]);
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getByWarehouse failed for $warehouseId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Offcut>>> getByParentBoard(String parentBoardId) async {
    try {
      final db = await _db.open();
      final rows = await db.query(
        _offcutsTable,
        where: 'parent_board_id = ?',
        whereArgs: [parentBoardId],
        orderBy: 'created_at DESC',
      );
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getByParentBoard failed for $parentBoardId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Offcut>> getByQrCode(String qrCode) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_offcutsTable, where: 'qr_code = ?', whereArgs: [qrCode]);
      if (rows.isEmpty) throw NotFoundException('Offcut (by QR)', qrCode);
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getByQrCode failed for "$qrCode"',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// Fails fast if [parentBoardId] or [slotId] doesn't exist.
  /// `decorId` is deliberately not a parameter — it's read from the
  /// parent Board and copied, so a caller can never pass a decor
  /// that disagrees with where the material actually came from.
  @override
  Future<Result<Offcut>> cutFromBoard({
    required String parentBoardId,
    required String slotId,
    required double length,
    required double width,
    required double thickness,
  }) async {
    final boardCheck = await _boards.getById(parentBoardId);
    if (boardCheck.isFailure) return Result.failure(boardCheck.failure);

    final slotCheck = await _slots.getById(slotId);
    if (slotCheck.isFailure) return Result.failure(slotCheck.failure);

    final now = DateTime.now();
    final offcutId = _uuid.v4();
    final offcut = Offcut(
      id: offcutId,
      parentBoardId: parentBoardId,
      slotId: slotId,
      decorId: boardCheck.data.decorId, // copied, never re-derived later
      length: length,
      width: width,
      thickness: thickness,
      qrCode: qrCodeFromEntityId(QrTypeLetters.offcut, offcutId),
      createdAt: now,
      updatedAt: now,
    );

    try {
      final txnId = _uuid.v4();
      final createdOffcut = offcut;

      await _db.transaction((txn) async {
        await txn.insert(_offcutsTable, _toRow(createdOffcut),
            conflictAlgorithm: ConflictAlgorithm.abort);

        await txn.insert(_transactionsTable, {
          'id': txnId,
          'offcut_id': createdOffcut.id,
          'type': OffcutTransactionType.cut.dbValue,
          'from_slot_id': null,
          'to_slot_id': slotId,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'note': null,
        });

        await txn.insert(_ledgerTable, {
          'id': _uuid.v4(),
          'transaction_id': txnId,
          'entity_type': _entityTypeOffcut,
          'entity_id': createdOffcut.id,
          'event_type': OffcutTransactionType.cut.dbValue,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'payload': jsonEncode({
            'parentBoardId': parentBoardId,
            'slotId': slotId,
          }),
        });
      }, label: 'cut offcut ${offcut.id} from board $parentBoardId');

      await _events.publish(OffcutCut(
        offcutId: createdOffcut.id,
        parentBoardId: parentBoardId,
        slotId: slotId,
        occurredAt: now,
      ));

      _logger.info(
          'Cut offcut ${createdOffcut.id} from board $parentBoardId', tag: 'REPOSITORY');
      return Result.success(createdOffcut);
    } catch (e, st) {
      _logger.error('cutFromBoard failed for board $parentBoardId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Offcut>> moveOffcut({
    required String offcutId,
    required String toSlotId,
    String? note,
  }) async {
    final current = await getById(offcutId);
    if (current.isFailure) return Result.failure(current.failure);

    final slotCheck = await _slots.getById(toSlotId);
    if (slotCheck.isFailure) return Result.failure(slotCheck.failure);

    try {
      final offcut = current.data;
      final fromSlotId = offcut.slotId;
      final now = DateTime.now();
      final txnId = _uuid.v4();
      final updated = offcut.copyWith(slotId: toSlotId, updatedAt: now);

      await _db.transaction((txn) async {
        final count = await txn.update(_offcutsTable, _toRow(updated),
            where: 'id = ?', whereArgs: [offcutId]);
        if (count == 0) throw NotFoundException('Offcut', offcutId);

        await txn.insert(_transactionsTable, {
          'id': txnId,
          'offcut_id': offcutId,
          'type': OffcutTransactionType.moved.dbValue,
          'from_slot_id': fromSlotId,
          'to_slot_id': toSlotId,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'note': note,
        });

        await txn.insert(_ledgerTable, {
          'id': _uuid.v4(),
          'transaction_id': txnId,
          'entity_type': _entityTypeOffcut,
          'entity_id': offcutId,
          'event_type': OffcutTransactionType.moved.dbValue,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'payload': jsonEncode({'fromSlotId': fromSlotId, 'toSlotId': toSlotId}),
        });
      }, label: 'move offcut $offcutId');

      await _events.publish(OffcutMoved(
        offcutId: offcutId,
        fromSlotId: fromSlotId,
        toSlotId: toSlotId,
        occurredAt: now,
      ));

      _logger.info('Moved offcut $offcutId: $fromSlotId → $toSlotId',
          tag: 'REPOSITORY');
      return Result.success(updated);
    } catch (e, st) {
      _logger.error('moveOffcut failed for $offcutId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> archive(String id) async {
    final current = await getById(id);
    if (current.isFailure) return Result.failure(current.failure);

    try {
      final now = DateTime.now();
      final txnId = _uuid.v4();

      await _db.transaction((txn) async {
        final count = await txn.update(
          _offcutsTable,
          {'status': OffcutStatus.archived.dbValue, 'updated_at': now.millisecondsSinceEpoch},
          where: 'id = ?',
          whereArgs: [id],
        );
        if (count == 0) throw NotFoundException('Offcut', id);

        await txn.insert(_transactionsTable, {
          'id': txnId,
          'offcut_id': id,
          'type': OffcutTransactionType.archived.dbValue,
          'from_slot_id': null,
          'to_slot_id': null,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'note': null,
        });

        await txn.insert(_ledgerTable, {
          'id': _uuid.v4(),
          'transaction_id': txnId,
          'entity_type': _entityTypeOffcut,
          'entity_id': id,
          'event_type': OffcutTransactionType.archived.dbValue,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'payload': jsonEncode({}),
        });
      }, label: 'archive offcut $id');

      await _events.publish(OffcutArchived(offcutId: id, occurredAt: now));

      _logger.info('Archived offcut $id', tag: 'REPOSITORY');
      return Result.success(null);
    } catch (e, st) {
      _logger.error('archive failed for offcut $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<LedgerEntry>>> getLedgerForOffcut(String offcutId) async {
    try {
      final db = await _db.open();
      final rows = await db.query(
        _ledgerTable,
        where: 'entity_type = ? AND entity_id = ?',
        whereArgs: [_entityTypeOffcut, offcutId],
        orderBy: 'occurred_at DESC',
      );
      return Result.success(rows.map(_ledgerFromRow).toList());
    } catch (e, st) {
      _logger.error('getLedgerForOffcut failed for $offcutId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// ⚠️ Brak wymuszenia uprawnień — patrz docs/QR_CODES.md.
  @override
  Future<Result<Offcut>> regenerateQrCode(String id) async {
    final current = await getById(id);
    if (current.isFailure) return Result.failure(current.failure);

    try {
      final now = DateTime.now();
      final txnId = _uuid.v4();
      final base = current.data;
      final updated = Offcut(
        id: base.id,
        parentBoardId: base.parentBoardId,
        slotId: base.slotId,
        decorId: base.decorId,
        length: base.length,
        width: base.width,
        thickness: base.thickness,
        qrCode: randomQrCode(QrTypeLetters.offcut),
        status: base.status,
        createdAt: base.createdAt,
        updatedAt: now,
      );

      await _db.transaction((txn) async {
        final count = await txn.update(_offcutsTable, _toRow(updated),
            where: 'id = ?', whereArgs: [id]);
        if (count == 0) throw NotFoundException('Offcut', id);

        await txn.insert(_transactionsTable, {
          'id': txnId,
          'offcut_id': id,
          'type': OffcutTransactionType.qrRegenerated.dbValue,
          'from_slot_id': null,
          'to_slot_id': null,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'note': null,
        });

        await txn.insert(_ledgerTable, {
          'id': _uuid.v4(),
          'transaction_id': txnId,
          'entity_type': _entityTypeOffcut,
          'entity_id': id,
          'event_type': OffcutTransactionType.qrRegenerated.dbValue,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'payload': jsonEncode({'newQrCode': updated.qrCode}),
        });
      }, label: 'regenerate QR for offcut $id');

      _logger.info('Regenerated QR for offcut $id', tag: 'REPOSITORY');
      return Result.success(updated);
    } catch (e, st) {
      _logger.error('regenerateQrCode failed for offcut $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  // --- Row <-> Entity mapping ---

  Offcut _fromRow(Map<String, Object?> row) => Offcut(
        id: row['id'] as String,
        parentBoardId: row['parent_board_id'] as String,
        slotId: row['slot_id'] as String,
        decorId: row['decor_id'] as String,
        length: (row['length'] as num).toDouble(),
        width: (row['width'] as num).toDouble(),
        thickness: (row['thickness'] as num).toDouble(),
        qrCode: row['qr_code'] as String,
        status: OffcutStatus.fromDb(row['status'] as String),
        createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
      );

  Map<String, Object?> _toRow(Offcut o) => {
        'id': o.id,
        'parent_board_id': o.parentBoardId,
        'slot_id': o.slotId,
        'decor_id': o.decorId,
        'length': o.length,
        'width': o.width,
        'thickness': o.thickness,
        'qr_code': o.qrCode,
        'status': o.status.dbValue,
        'created_at': o.createdAt.millisecondsSinceEpoch,
        'updated_at': o.updatedAt.millisecondsSinceEpoch,
      };

  LedgerEntry _ledgerFromRow(Map<String, Object?> row) => LedgerEntry(
        id: row['id'] as String,
        transactionId: row['transaction_id'] as String,
        entityType: row['entity_type'] as String,
        entityId: row['entity_id'] as String,
        eventType: row['event_type'] as String,
        occurredAt: DateTime.fromMillisecondsSinceEpoch(row['occurred_at'] as int),
        userId: row['user_id'] as String?,
        payloadJson: row['payload'] as String,
      );
}
