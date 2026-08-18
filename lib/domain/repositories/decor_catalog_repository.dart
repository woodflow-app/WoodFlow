import '../../core/errors/failures.dart';
import '../entities/decor_catalog_entry.dart';

/// Read-only from the app's perspective — catalogue entries are
/// migration-seeded, never created/edited/deleted through the UI, so
/// this deliberately doesn't implement `BaseRepository`'s full CRUD
/// shape (per that interface's own doc comment: entities whose
/// lifecycle diverges from plain CRUD get their own explicit
/// contract instead of being force-fit).
abstract class DecorCatalogRepository {
  Future<Result<List<DecorCatalogEntry>>> getAll();
}
