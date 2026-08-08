import '../../core/errors/failures.dart';
import '../entities/board.dart';
import '../entities/board_location.dart';
import '../entities/ledger_entry.dart';

/// Own contract, not BaseRepository — Board's lifecycle (archive not
/// delete, move as an event, QR lookup, location resolved via join)
/// diverges from plain CRUD enough to warrant an explicit contract.
abstract class BoardRepository {
  Future<Result<Board>> getById(String id);

  /// Excludes archived boards by default.
  Future<Result<List<Board>>> getAll({bool includeArchived = false});

  Future<Result<List<Board>>> getBySlot(String slotId);

  /// Resolved via JOIN boards→slots WHERE slots.rack_id = ?
  Future<Result<List<Board>>> getByRack(String rackId);

  /// Resolved via JOIN boards→slots→racks WHERE racks.warehouse_id = ?
  Future<Result<List<Board>>> getByWarehouse(String warehouseId);

  Future<Result<Board>> getByQrCode(String qrCode);

  /// Resolves the full Warehouse > Rack > Slot chain for display —
  /// this is the ONLY place that chain gets computed; Board itself
  /// never stores warehouseId/rackId.
  Future<Result<BoardLocation>> getFullLocation(String boardId);

  /// Fails fast with NotFoundFailure if [slotId] OR [decorId] doesn't
  /// exist — never a raw SQLite FK violation. Atomically: board
  /// insert + BoardTransaction(created) + LedgerEntry, then publishes
  /// BoardCreated.
  Future<Result<Board>> create({
    required String slotId,
    required String decorId,
    required double length,
    required double width,
    required double thickness,
  });

  /// Atomic: board.slot_id update + BoardTransaction(moved) +
  /// LedgerEntry, then publishes BoardMoved. Does NOT change status —
  /// location and lifecycle status are separate concerns.
  Future<Result<Board>> moveBoard({
    required String boardId,
    required String toSlotId,
    String? note,
  });

  /// Archives, never hard-deletes — under an append-only Ledger, a
  /// physical DELETE would orphan ledger_entries referencing this
  /// board.
  Future<Result<void>> archive(String id);

  Future<Result<List<LedgerEntry>>> getLedgerForBoard(String boardId);

  /// ⚠️ Brak wymuszenia uprawnień — patrz docs/QR_CODES.md. Metoda
  /// istnieje (Krok 7.1 wymaga "tylko dla administratora"), ale
  /// żaden ekran jej dziś nie wywołuje — nie ma jeszcze pojęcia
  /// roli/administratora (Auth, v2.5).
  Future<Result<Board>> regenerateQrCode(String id);
}
