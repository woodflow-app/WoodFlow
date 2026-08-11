import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/events/event_publisher.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/events/board_events.dart';
import '../../domain/events/offcut_events.dart';
import '../../domain/usecases/delete_warehouse_use_case.dart';
import '../database/database_service.dart';
import 'cascade_archive_helpers.dart';

/// Cascading warehouse deletion. Lives in `data/usecases/`, not as a
/// method on `WarehouseRepositoryImpl`, because it must touch six
/// tables (warehouses/racks/slots/boards/offcuts + their
/// transaction/ledger tables) atomically — sqflite doesn't support
/// nested transactions on one connection, so this can't be built by
/// calling `WarehouseRepository`/`RackRepository`/.../`OffcutRepository`
/// methods from inside each other (each opens its own transaction).
/// Same reasoning as the "multi-entity operations get a dedicated use
/// case operating directly on `DatabaseService`" pattern already
/// established in this codebase for `CutBoardUseCase`-shaped problems
/// (see `docs/adr/_archived_not_official/023-...md` — archived by the
/// architecture reset, but the underlying sqflite constraint it
/// documents is still exactly true today).
///
/// **What gets deleted vs. archived, and why:**
/// - Warehouses/Racks/Slots are physically DELETEd — they carry no
///   ledger history of their own, matching the exact precedent
///   already shipped in `RackRepositoryImpl.delete()` and
///   `SlotRepositoryImpl.delete()` ("Racks/Slots have no ledger
///   history of their own, so unlike Board/Offcut there's no
///   append-only trail to protect").
/// - Boards/Offcuts are ARCHIVED, never deleted — hard-deleting them
///   would orphan `ledger_entries` rows that reference them, breaking
///   the standing invariant documented on `BoardRepository.archive()`/
///   `OffcutRepository.archive()` and in `docs/INVARIANTS.md`
///   ("Soft delete nie usuwa historii... archive() na Board/Offcut
///   nigdy nie robi DELETE"). This holds even when their *container*
///   is deleted — same "dangling reference is acceptable, the
///   material row itself is not" behavior `SlotRepositoryImpl.delete()`
///   already established for slot deletion.
///
/// Archiving itself is done via `archiveBoardInTransaction`/
/// `archiveOffcutInTransaction` (`cascade_archive_helpers.dart`) — a
/// small shared helper, not a call into `BoardRepositoryImpl.archive()`/
/// `OffcutRepositoryImpl.archive()` (those open their own transaction,
/// which sqflite can't nest inside this one). The same helper is shared
/// by `DeleteRackUseCaseImpl`/`DeleteSlotUseCaseImpl`, which face the
/// identical "archive contained stock, delete the container" shape one
/// level down the hierarchy.
class DeleteWarehouseUseCaseImpl implements DeleteWarehouseUseCase {
  DeleteWarehouseUseCaseImpl(this._db, this._logger, this._events);

  final DatabaseService _db;
  final AppLogger _logger;
  final EventPublisher _events;

  @override
  Future<Result<void>> call(String warehouseId) async {
    final archivedBoardIds = <String>[];
    final archivedOffcutIds = <String>[];

    try {
      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;

      await _db.transaction((txn) async {
        final warehouseRows =
            await txn.query('warehouses', where: 'id = ?', whereArgs: [warehouseId]);
        if (warehouseRows.isEmpty) {
          throw NotFoundException('Warehouse', warehouseId);
        }

        final rackRows =
            await txn.query('racks', where: 'warehouse_id = ?', whereArgs: [warehouseId]);

        for (final rackRow in rackRows) {
          final rackId = rackRow['id'] as String;
          final slotRows = await txn.query('slots', where: 'rack_id = ?', whereArgs: [rackId]);

          for (final slotRow in slotRows) {
            final slotId = slotRow['id'] as String;

            final boardRows = await txn.query('boards',
                where: 'slot_id = ? AND status = ?', whereArgs: [slotId, 'inStock']);
            for (final boardRow in boardRows) {
              final boardId = boardRow['id'] as String;
              await archiveBoardInTransaction(txn, boardId, now, nowMs, note: 'warehouse deleted');
              archivedBoardIds.add(boardId);
            }

            final offcutRows = await txn.query('offcuts',
                where: 'slot_id = ? AND status = ?', whereArgs: [slotId, 'available']);
            for (final offcutRow in offcutRows) {
              final offcutId = offcutRow['id'] as String;
              await archiveOffcutInTransaction(txn, offcutId, now, nowMs, note: 'warehouse deleted');
              archivedOffcutIds.add(offcutId);
            }

            await txn.delete('slots', where: 'id = ?', whereArgs: [slotId]);
          }

          await txn.delete('racks', where: 'id = ?', whereArgs: [rackId]);
        }

        await txn.delete('warehouses', where: 'id = ?', whereArgs: [warehouseId]);
      }, label: 'delete warehouse $warehouseId with contents');

      // Published only after the whole transaction commits — matches
      // ADR-023's rule ("publikuje wszystkie odpowiednie eventy PO
      // udanym committcie całej transakcji").
      for (final boardId in archivedBoardIds) {
        await _events.publish(BoardArchived(boardId: boardId, occurredAt: now));
      }
      for (final offcutId in archivedOffcutIds) {
        await _events.publish(OffcutArchived(offcutId: offcutId, occurredAt: now));
      }

      _logger.info(
        'Deleted warehouse $warehouseId (${archivedBoardIds.length} boards, '
        '${archivedOffcutIds.length} offcuts archived)',
        tag: 'USECASE',
      );
      return Result.success(null);
    } catch (e, st) {
      _logger.error('delete warehouse failed for $warehouseId',
          tag: 'USECASE', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
