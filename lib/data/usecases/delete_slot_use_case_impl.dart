import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/events/event_publisher.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/events/board_events.dart';
import '../../domain/events/offcut_events.dart';
import '../../domain/usecases/delete_slot_use_case.dart';
import '../database/database_service.dart';
import 'cascade_archive_helpers.dart';

/// Cascading slot deletion — same reasoning and shape as
/// `DeleteWarehouseUseCaseImpl`, one level down: archives contained
/// Boards/Offcuts, then physically deletes the Slot row itself (Slots
/// carry no ledger history of their own, same precedent already
/// established for Rack/Warehouse). Replaces the previous plain
/// `SlotRepository.delete()` call from `SlotDetailScreen`, which had no
/// occupancy check at all.
class DeleteSlotUseCaseImpl implements DeleteSlotUseCase {
  DeleteSlotUseCaseImpl(this._db, this._logger, this._events);

  final DatabaseService _db;
  final AppLogger _logger;
  final EventPublisher _events;

  @override
  Future<Result<void>> call(String slotId) async {
    final archivedBoardIds = <String>[];
    final archivedOffcutIds = <String>[];

    try {
      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;

      await _db.transaction((txn) async {
        final slotRows = await txn.query('slots', where: 'id = ?', whereArgs: [slotId]);
        if (slotRows.isEmpty) {
          throw NotFoundException('Slot', slotId);
        }

        final boardRows = await txn.query('boards',
            where: 'slot_id = ? AND status = ?', whereArgs: [slotId, 'inStock']);
        for (final boardRow in boardRows) {
          final boardId = boardRow['id'] as String;
          await archiveBoardInTransaction(txn, boardId, now, nowMs, note: 'slot deleted');
          archivedBoardIds.add(boardId);
        }

        final offcutRows = await txn.query('offcuts',
            where: 'slot_id = ? AND status = ?', whereArgs: [slotId, 'available']);
        for (final offcutRow in offcutRows) {
          final offcutId = offcutRow['id'] as String;
          await archiveOffcutInTransaction(txn, offcutId, now, nowMs, note: 'slot deleted');
          archivedOffcutIds.add(offcutId);
        }

        await txn.delete('slots', where: 'id = ?', whereArgs: [slotId]);
      }, label: 'delete slot $slotId with contents');

      // Published only after the whole transaction commits — same rule
      // DeleteWarehouseUseCaseImpl follows (ADR-023).
      for (final boardId in archivedBoardIds) {
        await _events.publish(BoardArchived(boardId: boardId, occurredAt: now));
      }
      for (final offcutId in archivedOffcutIds) {
        await _events.publish(OffcutArchived(offcutId: offcutId, occurredAt: now));
      }

      _logger.info(
        'Deleted slot $slotId (${archivedBoardIds.length} boards, '
        '${archivedOffcutIds.length} offcuts archived)',
        tag: 'USECASE',
      );
      return Result.success(null);
    } catch (e, st) {
      _logger.error('delete slot failed for $slotId', tag: 'USECASE', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
