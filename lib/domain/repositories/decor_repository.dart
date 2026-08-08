import '../../core/errors/failures.dart';
import '../entities/decor.dart';
import 'base_repository.dart';

/// Decor's lifecycle is plain CRUD (like Warehouse/Rack/Slot) — no
/// archive/ledger complexity of its own, so this fits BaseRepository.
abstract class DecorRepository implements BaseRepository<Decor, String> {
  /// Powers the autocomplete: user types "H3303", this resolves the
  /// full catalog entry ("Natural Hamilton Oak").
  Future<Result<Decor>> getByCode(String code);
}
