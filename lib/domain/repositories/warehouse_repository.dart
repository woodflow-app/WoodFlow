import '../../core/errors/failures.dart';
import '../entities/warehouse.dart';
import 'base_repository.dart';

/// Domain-facing contract. ViewModels depend on THIS, never on
/// WarehouseRepositoryImpl directly — that's what makes swapping
/// SQLite for something else later a one-file change.
abstract class WarehouseRepository implements BaseRepository<Warehouse, String> {
  /// Warehouse-specific query that doesn't fit the generic CRUD shape.
  Future<Result<List<Warehouse>>> searchByName(String query);

  /// Krok 7.2 (skanowanie) will call this — added now as part of
  /// Krok 7.1 since a QR code is useless without a way to look it
  /// back up. The scanning UI itself (camera capture, navigation) is
  /// deliberately NOT built yet.
  Future<Result<Warehouse>> getByQrCode(String qrCode);

  /// ⚠️ Brak wymuszenia uprawnień — patrz docs/QR_CODES.md. Metoda
  /// istnieje (Krok 7.1 wymaga możliwości regeneracji "tylko dla
  /// administratora"), ale żaden ekran jej dziś nie wywołuje, bo nie
  /// ma jeszcze pojęcia roli/administratora w systemie (to Auth,
  /// v2.5). Nie podłączaj przycisku w UI bez świadomej decyzji o tym
  /// kto może to zrobić.
  Future<Result<Warehouse>> regenerateQrCode(String id);
}
