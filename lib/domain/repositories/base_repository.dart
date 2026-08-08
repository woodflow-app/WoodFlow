import '../../core/errors/failures.dart';

/// Every domain repository that fits generic CRUD implements this
/// (today: Warehouse, Rack, Slot). It's intentionally minimal — CRUD
/// shapes vary enough between entities that forcing a rigid generic
/// interface would fight you more than it helps everywhere. This
/// just documents the CONVENTION: every method returns Result<T>,
/// none of them throw.
///
/// When a future entity's lifecycle diverges from plain CRUD (e.g.
/// needs archive-not-delete, or an operation that isn't a simple
/// field update), it should get its own explicit contract instead of
/// being force-fit here — evaluate per-entity, don't assume every
/// repository must implement this.
abstract class BaseRepository<T, ID> {
  Future<Result<T>> getById(ID id);
  Future<Result<List<T>>> getAll();
  Future<Result<T>> create(T entity);
  Future<Result<T>> update(T entity);
  Future<Result<void>> delete(ID id);
}
