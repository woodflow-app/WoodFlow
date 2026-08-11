import 'dart:convert';

import 'package:sqflite/sqflite.dart' hide DatabaseException;
import 'package:uuid/uuid.dart';

import '../../domain/entities/board_transaction.dart';
import '../../domain/entities/offcut_transaction.dart';

const _uuid = Uuid();

/// Shared by every cascade-delete use case (`DeleteWarehouseUseCaseImpl`,
/// `DeleteRackUseCaseImpl`, `DeleteSlotUseCaseImpl`) — archives one Board
/// row inside an already-open transaction, exactly like
/// `BoardRepositoryImpl.archive()` does, but callable from a use case
/// that can't call the repository directly (sqflite has no nested
/// transactions on one connection — same ADR-023 reasoning documented
/// on `DeleteWarehouseUseCaseImpl`). [note] records which cascade caused
/// the archive (e.g. "rack deleted"), same field `moveBoard()` already
/// uses for its own note.
Future<void> archiveBoardInTransaction(
  Transaction txn,
  String boardId,
  DateTime now,
  int nowMs, {
  required String note,
}) async {
  await txn.update(
    'boards',
    {'status': 'archived', 'updated_at': nowMs},
    where: 'id = ?',
    whereArgs: [boardId],
  );

  final txnId = _uuid.v4();
  await txn.insert('board_transactions', {
    'id': txnId,
    'board_id': boardId,
    'type': BoardTransactionType.archived.dbValue,
    'from_slot_id': null,
    'to_slot_id': null,
    'occurred_at': nowMs,
    'user_id': null,
    'note': note,
  });

  await txn.insert('ledger_entries', {
    'id': _uuid.v4(),
    'transaction_id': txnId,
    'entity_type': 'board',
    'entity_id': boardId,
    'event_type': BoardTransactionType.archived.dbValue,
    'occurred_at': nowMs,
    'user_id': null,
    'payload': jsonEncode({}),
  });
}

/// Offcut equivalent of [archiveBoardInTransaction] — same reasoning.
Future<void> archiveOffcutInTransaction(
  Transaction txn,
  String offcutId,
  DateTime now,
  int nowMs, {
  required String note,
}) async {
  await txn.update(
    'offcuts',
    {'status': 'archived', 'updated_at': nowMs},
    where: 'id = ?',
    whereArgs: [offcutId],
  );

  final txnId = _uuid.v4();
  await txn.insert('offcut_transactions', {
    'id': txnId,
    'offcut_id': offcutId,
    'type': OffcutTransactionType.archived.dbValue,
    'from_slot_id': null,
    'to_slot_id': null,
    'occurred_at': nowMs,
    'user_id': null,
    'note': note,
  });

  await txn.insert('ledger_entries', {
    'id': _uuid.v4(),
    'transaction_id': txnId,
    'entity_type': 'offcut',
    'entity_id': offcutId,
    'event_type': OffcutTransactionType.archived.dbValue,
    'occurred_at': nowMs,
    'user_id': null,
    'payload': jsonEncode({}),
  });
}
