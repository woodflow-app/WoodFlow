import '../../core/errors/failures.dart';
import '../entities/rack.dart';
import 'base_repository.dart';

/// Rack's lifecycle is plain CRUD, same shape as Warehouse — no
/// archive-vs-delete complexity (no ledger/transaction history of
/// its own), so this DOES implement BaseRepository. Evaluate this
/// per-entity when Board/Offcut are built later — don't assume they
/// have to fit the same shape just because Rack/Slot do.
abstract class RackRepository implements BaseRepository<Rack, String> {
  Future<Result<List<Rack>>> getByWarehouse(String warehouseId);

  /// Krok 7.2 will call this. See WarehouseRepository.getByQrCode doc.
  Future<Result<Rack>> getByQrCode(String qrCode);

  /// ⚠️ Brak wymuszenia uprawnień — patrz docs/QR_CODES.md.
  Future<Result<Rack>> regenerateQrCode(String id);
}
