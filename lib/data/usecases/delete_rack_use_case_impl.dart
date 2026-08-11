import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/events/event_publisher.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/events/board_events.dart';
import '../../domain/events/offcut_events.dart';
import '../../domain/usecases/delete_rack_use_case.dart';
import '../database/database_service.dart';
import 'cascade_archive_helpers.dart';

/// Cascading rack deletion — same reasoning and shape as
/// `DeleteWarehouseUseCaseImpl`, one level down: for every Slot in the
/// rack, archives contained Boards/Offcuts and deletes the Slot, then
/// deletes the Rack itself. Racks/Slots carry no ledger history of
/// their own (same precedent as Warehouse). Replaces the previous bare
/// `RackRepository.delete()`, which had no UI, no occupancy check, and
/// no cascade at all.
class DeleteRackUseCaseImpl implements DeleteRackUseCase {
  DeleteRackUseCaseImpl(this._db, this._logger, this._events);

  final DatabaseService _db;
  final AppLogger _logger;
  final EventPublisher _events;

  @override
  Future<Result<void>> call(String rackId) async {
    final archivedBoardIds = <String>[];
    final archivedOffcutIds = <String>[];

    try {
      final now = DateTime.now();
      final nowMs = now.millisecondsSinceEpoch;

      await _db.transaction((txn) async {
        final rackRows = await txn.query('racks', where: 'id = ?', whereArgs: [rackId]);
        if (rackRows.isEmpty) {
          throw NotFoundException('Rack', rackId);
        }

        final slotRows = await txn.query('slots', where: 'rack_id = ?', whereArgs: [rackId]);

        for (final slotRow in slotRows) {
          final slotId = slotRow['id'] as String;

          final boardRows = await txn.query('boards',
              where: 'slot_id = ? AND status = ?', whereArgs: [slotId, 'inStock']);
          for (final boardRow in boardRows) {
            final boardId = boardRow['id'] as String;
            await archiveBoardInTransaction(txn, boardId, now, nowMs, note: 'rack deleted');
            archivedBoardIds.add(boardId);
          }

          final offcutRows = await txn.query('offcuts',
              where: 'slot_id = ? AND status = ?', whereArgs: [slotId, 'available']);
          for (final offcutRow in offcutRows) {
            final offcutId = offcutRow['id'] as String;
            await archiveOffcutInTransaction(txn, offcutId, now, nowMs, note: 'rack deleted');
            archivedOffcutIds.add(offcutId);
          }

          await txn.delete('slots', where: 'id = ?', whereArgs: [slotId]);
        }

        await txn.delete('racks', where: 'id = ?', whereArgs: [rackId]);
      }, label: 'delete rack $rackId with contents');

      // Published only after the whole transaction commits — same rule
      // DeleteWarehouseUseCaseImpl follows (ADR-023).
      for (final boardId in archivedBoardIds) {
        await _events.publish(BoardArchived(boardId: boardId, occurredAt: now));
      }
      for (final offcutId in archivedOffcutIds) {
        await _events.publish(OffcutArchived(offcutId: offcutId, occurredAt: now));
      }

      _logger.info(
        'Deleted rack $rackId (${archivedBoardIds.length} boards, '
        '${archivedOffcutIds.length} offcuts archived)',
        tag: 'USECASE',
      );
      return Result.success(null);
    } catch (e, st) {
      _logger.error('delete rack failed for $rackId', tag: 'USECASE', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
