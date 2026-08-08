import '../../core/errors/failures.dart';
import '../entities/slot.dart';
import 'base_repository.dart';

class SlotOccupancy {
  final Slot slot;
  final int boardCount;
  final int offcutCount;
  int get used => boardCount + offcutCount;
  double get fillRatio => slot.capacity == 0 ? 0 : used / slot.capacity;

  const SlotOccupancy({
    required this.slot,
    required this.boardCount,
    required this.offcutCount,
  });
}

abstract class SlotRepository implements BaseRepository<Slot, String> {
  Future<Result<List<Slot>>> getByRack(String rackId);

  /// Powers the warehouse-map grid (fill-ratio bars) — mirrors the
  /// old app's LocationsScreen exactly.
  Future<Result<List<SlotOccupancy>>> getOccupancyForRack(String rackId);

  /// Krok 7.2 will call this. See WarehouseRepository.getByQrCode doc.
  Future<Result<Slot>> getByQrCode(String qrCode);

  /// ⚠️ Brak wymuszenia uprawnień — patrz docs/QR_CODES.md.
  Future<Result<Slot>> regenerateQrCode(String id);
}
