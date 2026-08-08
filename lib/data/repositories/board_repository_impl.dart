import 'dart:convert';

import 'package:sqflite/sqflite.dart' hide DatabaseException;
import 'package:uuid/uuid.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/events/event_publisher.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/board.dart';
import '../../domain/entities/board_location.dart';
import '../../domain/entities/board_transaction.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/events/board_events.dart';
import '../../domain/repositories/board_repository.dart';
import '../../domain/repositories/slot_repository.dart';
import '../../domain/repositories/decor_repository.dart';
import '../database/database_service.dart';
import '../database/qr_code_generator.dart';

const _boardsTable = 'boards';
const _transactionsTable = 'board_transactions';
const _ledgerTable = 'ledger_entries';
const _entityTypeBoard = 'board';

class BoardRepositoryImpl implements BoardRepository {
  BoardRepositoryImpl(
      this._db, this._logger, this._events, this._slots, this._decors);

  final DatabaseService _db;
  final AppLogger _logger;
  final EventPublisher _events;
  final SlotRepository _slots; // only used to validate slot existence
  final DecorRepository _decors; // only used to validate decor existence
  final _uuid = const Uuid();

  @override
  Future<Result<Board>> getById(String id) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_boardsTable, where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) throw NotFoundException('Board', id);
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getById failed for board $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Board>>> getAll({bool includeArchived = false}) async {
    try {
      final db = await _db.open();
      final rows = includeArchived
          ? await db.query(_boardsTable, orderBy: 'created_at DESC')
          : await db.query(_boardsTable,
              where: 'status != ?',
              whereArgs: [BoardStatus.archived.dbValue],
              orderBy: 'created_at DESC');
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getAll failed for boards',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Board>>> getBySlot(String slotId) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_boardsTable,
          where: 'slot_id = ?', whereArgs: [slotId], orderBy: 'created_at DESC');
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getBySlot failed for $slotId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Board>>> getByRack(String rackId) async {
    try {
      final db = await _db.open();
      final rows = await db.rawQuery('''
        SELECT boards.* FROM boards
        JOIN slots ON boards.slot_id = slots.id
        WHERE slots.rack_id = ?
        ORDER BY boards.created_at DESC
      ''', [rackId]);
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getByRack failed for $rackId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Board>>> getByWarehouse(String warehouseId) async {
    try {
      final db = await _db.open();
      final rows = await db.rawQuery('''
        SELECT boards.* FROM boards
        JOIN slots ON boards.slot_id = slots.id
        JOIN racks ON slots.rack_id = racks.id
        WHERE racks.warehouse_id = ?
        ORDER BY boards.created_at DESC
      ''', [warehouseId]);
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getByWarehouse failed for $warehouseId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Board>> getByQrCode(String qrCode) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_boardsTable, where: 'qr_code = ?', whereArgs: [qrCode]);
      if (rows.isEmpty) throw NotFoundException('Board (by QR)', qrCode);
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getByQrCode failed for "$qrCode"',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<BoardLocation>> getFullLocation(String boardId) async {
    try {
      final db = await _db.open();
      final rows = await db.rawQuery('''
        SELECT
          warehouses.id   AS warehouse_id,
          warehouses.name AS warehouse_name,
          racks.id        AS rack_id,
          racks.name      AS rack_name,
          slots.id        AS slot_id,
          slots.name      AS slot_name
        FROM boards
        JOIN slots      ON boards.slot_id = slots.id
        JOIN racks      ON slots.rack_id = racks.id
        JOIN warehouses ON racks.warehouse_id = warehouses.id
        WHERE boards.id = ?
      ''', [boardId]);

      if (rows.isEmpty) throw NotFoundException('Board location', boardId);
      final row = rows.first;
      return Result.success(BoardLocation(
        warehouseId: row['warehouse_id'] as String,
        warehouseName: row['warehouse_name'] as String,
        rackId: row['rack_id'] as String,
        rackName: row['rack_name'] as String,
        slotId: row['slot_id'] as String,
        slotName: row['slot_name'] as String,
      ));
    } catch (e, st) {
      _logger.error('getFullLocation failed for $boardId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// Fails fast if [slotId] OR [decorId] doesn't exist — never a raw
  /// SQLite FK violation deep inside the transaction. Atomically:
  /// board insert + BoardTransaction(created) + LedgerEntry, then
  /// publishes BoardCreated.
  @override
  Future<Result<Board>> create({
    required String slotId,
    required String decorId,
    required double length,
    required double width,
    required double thickness,
  }) async {
    final slotCheck = await _slots.getById(slotId);
    if (slotCheck.isFailure) return Result.failure(slotCheck.failure);

    final decorCheck = await _decors.getById(decorId);
    if (decorCheck.isFailure) return Result.failure(decorCheck.failure);

    final now = DateTime.now();
    final boardId = _uuid.v4();
    final board = Board(
      id: boardId,
      slotId: slotId,
      decorId: decorId,
      length: length,
      width: width,
      thickness: thickness,
      qrCode: qrCodeFromEntityId(QrTypeLetters.board, boardId),
      createdAt: now,
      updatedAt: now,
    );

    try {
      final txnId = _uuid.v4();
      final createdBoard = board;

      await _db.transaction((txn) async {
        await txn.insert(_boardsTable, _toRow(createdBoard),
            conflictAlgorithm: ConflictAlgorithm.abort);

        await txn.insert(_transactionsTable, {
          'id': txnId,
          'board_id': createdBoard.id,
          'type': BoardTransactionType.created.dbValue,
          'from_slot_id': null,
          'to_slot_id': slotId,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'note': null,
        });

        await txn.insert(_ledgerTable, {
          'id': _uuid.v4(),
          'transaction_id': txnId,
          'entity_type': _entityTypeBoard,
          'entity_id': createdBoard.id,
          'event_type': BoardTransactionType.created.dbValue,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'payload': jsonEncode({'slotId': slotId}),
        });
      }, label: 'create board ${board.id}');

      await _events.publish(BoardCreated(
        boardId: createdBoard.id,
        slotId: slotId,
        occurredAt: now,
      ));

      _logger.info('Created board ${createdBoard.id} in slot $slotId', tag: 'REPOSITORY');
      return Result.success(createdBoard);
    } catch (e, st) {
      _logger.error('create failed for board ${board.id}',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Board>> moveBoard({
    required String boardId,
    required String toSlotId,
    String? note,
  }) async {
    final current = await getById(boardId);
    if (current.isFailure) return Result.failure(current.failure);

    final slotCheck = await _slots.getById(toSlotId);
    if (slotCheck.isFailure) return Result.failure(slotCheck.failure);

    try {
      final board = current.data;
      final fromSlotId = board.slotId;
      final now = DateTime.now();
      final txnId = _uuid.v4();
      final updated = board.copyWith(slotId: toSlotId, updatedAt: now);

      await _db.transaction((txn) async {
        final count = await txn.update(_boardsTable, _toRow(updated),
            where: 'id = ?', whereArgs: [boardId]);
        if (count == 0) throw NotFoundException('Board', boardId);

        await txn.insert(_transactionsTable, {
          'id': txnId,
          'board_id': boardId,
          'type': BoardTransactionType.moved.dbValue,
          'from_slot_id': fromSlotId,
          'to_slot_id': toSlotId,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'note': note,
        });

        await txn.insert(_ledgerTable, {
          'id': _uuid.v4(),
          'transaction_id': txnId,
          'entity_type': _entityTypeBoard,
          'entity_id': boardId,
          'event_type': BoardTransactionType.moved.dbValue,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'payload': jsonEncode({'fromSlotId': fromSlotId, 'toSlotId': toSlotId}),
        });
      }, label: 'move board $boardId');

      await _events.publish(BoardMoved(
        boardId: boardId,
        fromSlotId: fromSlotId,
        toSlotId: toSlotId,
        occurredAt: now,
      ));

      _logger.info('Moved board $boardId: $fromSlotId → $toSlotId', tag: 'REPOSITORY');
      return Result.success(updated);
    } catch (e, st) {
      _logger.error('moveBoard failed for $boardId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// ⚠️ INWARIANT (dokumentowany, NIE wyegzekwowany — patrz
  /// docs/INVARIANTS.md): Board nie powinien zostać zarchiwizowany,
  /// jeśli ma aktywne (status != archived) Offcut wskazujące na niego
  /// przez parentBoardId — zabezpiecza to ścieżkę pochodzenia
  /// materiału, ważne przy przyszłym Cut Optimizerze i historii
  /// materiału. Ta metoda TEGO NIE SPRAWDZA dziś (świadoma decyzja —
  /// najpierw dokumentacja, egzekwowanie w kodzie później, jeśli/gdy
  /// okaże się potrzebne). Jeśli budujesz tu nowy przepływ
  /// archiwizacji (np. masową z Dashboardu, krok 9), sprawdź najpierw
  /// OffcutRepository.getByParentBoard(id) i zdecyduj świadomie, czy
  /// ta reguła ma być już wyegzekwowana.
  @override
  Future<Result<void>> archive(String id) async {
    final current = await getById(id);
    if (current.isFailure) return Result.failure(current.failure);

    try {
      final now = DateTime.now();
      final txnId = _uuid.v4();

      await _db.transaction((txn) async {
        final count = await txn.update(
          _boardsTable,
          {'status': BoardStatus.archived.dbValue, 'updated_at': now.millisecondsSinceEpoch},
          where: 'id = ?',
          whereArgs: [id],
        );
        if (count == 0) throw NotFoundException('Board', id);

        await txn.insert(_transactionsTable, {
          'id': txnId,
          'board_id': id,
          'type': BoardTransactionType.archived.dbValue,
          'from_slot_id': null,
          'to_slot_id': null,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'note': null,
        });

        await txn.insert(_ledgerTable, {
          'id': _uuid.v4(),
          'transaction_id': txnId,
          'entity_type': _entityTypeBoard,
          'entity_id': id,
          'event_type': BoardTransactionType.archived.dbValue,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'payload': jsonEncode({}),
        });
      }, label: 'archive board $id');

      await _events.publish(BoardArchived(boardId: id, occurredAt: now));

      _logger.info('Archived board $id', tag: 'REPOSITORY');
      return Result.success(null);
    } catch (e, st) {
      _logger.error('archive failed for board $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<LedgerEntry>>> getLedgerForBoard(String boardId) async {
    try {
      final db = await _db.open();
      final rows = await db.query(
        _ledgerTable,
        where: 'entity_type = ? AND entity_id = ?',
        whereArgs: [_entityTypeBoard, boardId],
        orderBy: 'occurred_at DESC',
      );
      return Result.success(rows.map(_ledgerFromRow).toList());
    } catch (e, st) {
      _logger.error('getLedgerForBoard failed for $boardId',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// ⚠️ Brak wymuszenia uprawnień — patrz docs/QR_CODES.md. Nadal
  /// zapisuje pełny ślad w Ledgerze (kto/kiedy — `userId` na razie
  /// zawsze null, jak wszędzie przed Auth), bo reset etykiety
  /// materiału to zdarzenie warte audytu, nawet bez wymuszonej
  /// kontroli dostępu.
  @override
  Future<Result<Board>> regenerateQrCode(String id) async {
    final current = await getById(id);
    if (current.isFailure) return Result.failure(current.failure);

    try {
      final now = DateTime.now();
      final txnId = _uuid.v4();
      final newCode = randomQrCode(QrTypeLetters.board);
      final base = current.data;
      final updated = Board(
        id: base.id,
        slotId: base.slotId,
        decorId: base.decorId,
        length: base.length,
        width: base.width,
        thickness: base.thickness,
        qrCode: newCode,
        status: base.status,
        createdAt: base.createdAt,
        updatedAt: now,
      );

      await _db.transaction((txn) async {
        final count = await txn.update(_boardsTable, _toRow(updated),
            where: 'id = ?', whereArgs: [id]);
        if (count == 0) throw NotFoundException('Board', id);

        await txn.insert(_transactionsTable, {
          'id': txnId,
          'board_id': id,
          'type': BoardTransactionType.qrRegenerated.dbValue,
          'from_slot_id': null,
          'to_slot_id': null,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'note': null,
        });

        await txn.insert(_ledgerTable, {
          'id': _uuid.v4(),
          'transaction_id': txnId,
          'entity_type': _entityTypeBoard,
          'entity_id': id,
          'event_type': BoardTransactionType.qrRegenerated.dbValue,
          'occurred_at': now.millisecondsSinceEpoch,
          'user_id': null,
          'payload': jsonEncode({'newQrCode': newCode}),
        });
      }, label: 'regenerate QR for board $id');

      _logger.info('Regenerated QR for board $id', tag: 'REPOSITORY');
      return Result.success(updated);
    } catch (e, st) {
      _logger.error('regenerateQrCode failed for board $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  // --- Row <-> Entity mapping ---

  Board _fromRow(Map<String, Object?> row) => Board(
        id: row['id'] as String,
        slotId: row['slot_id'] as String,
        decorId: row['decor_id'] as String,
        length: (row['length'] as num).toDouble(),
        width: (row['width'] as num).toDouble(),
        thickness: (row['thickness'] as num).toDouble(),
        qrCode: row['qr_code'] as String,
        status: BoardStatus.fromDb(row['status'] as String),
        createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
      );

  Map<String, Object?> _toRow(Board b) => {
        'id': b.id,
        'slot_id': b.slotId,
        'decor_id': b.decorId,
        'length': b.length,
        'width': b.width,
        'thickness': b.thickness,
        'qr_code': b.qrCode,
        'status': b.status.dbValue,
        'created_at': b.createdAt.millisecondsSinceEpoch,
        'updated_at': b.updatedAt.millisecondsSinceEpoch,
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
