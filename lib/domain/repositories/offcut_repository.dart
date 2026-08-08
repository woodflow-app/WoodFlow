import '../../core/errors/failures.dart';
import '../entities/offcut.dart';
import '../entities/ledger_entry.dart';

/// Own contract, not BaseRepository — same reasoning as
/// BoardRepository: archive-not-delete, move-as-event, and
/// cutFromBoard() aren't a generic CRUD shape.
abstract class OffcutRepository {
  Future<Result<Offcut>> getById(String id);

  /// Excludes archived offcuts by default.
  Future<Result<List<Offcut>>> getAll({bool includeArchived = false});

  Future<Result<List<Offcut>>> getBySlot(String slotId);

  /// Resolved via JOIN offcuts→slots WHERE slots.rack_id = ?
  Future<Result<List<Offcut>>> getByRack(String rackId);

  /// Resolved via JOIN offcuts→slots→racks WHERE racks.warehouse_id = ?
  Future<Result<List<Offcut>>> getByWarehouse(String warehouseId);

  /// All offcuts that came from a specific Board — "what did this
  /// board produce".
  Future<Result<List<Offcut>>> getByParentBoard(String parentBoardId);

  Future<Result<Offcut>> getByQrCode(String qrCode);

  /// THE creation path for Offcut — deliberately not called
  /// `create()`. Fails fast (NotFoundFailure) if [parentBoardId] or
  /// [slotId] doesn't exist. `decorId` is NOT a parameter — it is
  /// read from the parent Board and copied, so it can never
  /// disagree with where the material actually came from. Atomically:
  /// offcut insert + OffcutTransaction(cut) + LedgerEntry, then
  /// publishes OffcutCut. Does NOT touch the parent Board (no resize,
  /// no status change) — that's the Cut Optimizer's job, a later,
  /// separate feature (v2.0/PRO).
  Future<Result<Offcut>> cutFromBoard({
    required String parentBoardId,
    required String slotId,
    required double length,
    required double width,
    required double thickness,
  });

  /// Same atomic pattern as BoardRepository.moveBoard. Does NOT
  /// change status — location and lifecycle status are separate.
  Future<Result<Offcut>> moveOffcut({
    required String offcutId,
    required String toSlotId,
    String? note,
  });

  /// Archives, never hard-deletes — same reasoning as Board.
  Future<Result<void>> archive(String id);

  Future<Result<List<LedgerEntry>>> getLedgerForOffcut(String offcutId);

  /// ⚠️ Brak wymuszenia uprawnień — patrz docs/QR_CODES.md.
  Future<Result<Offcut>> regenerateQrCode(String id);
}
