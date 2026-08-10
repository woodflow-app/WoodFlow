import '../../core/errors/failures.dart';

/// Domain-facing contract for cascading warehouse deletion.
/// Presentation depends on THIS, never on the `data/usecases/`
/// implementation directly — same "ViewModels depend on the domain
/// contract" rule every repository interface in this codebase
/// already follows. Split into interface (here) + implementation
/// (`data/usecases/delete_warehouse_use_case_impl.dart`) specifically
/// because the implementation needs direct `DatabaseService` access
/// (see its own doc comment for why) — that data-layer dependency
/// must not leak into what `presentation/` imports.
abstract class DeleteWarehouseUseCase {
  /// Deletes the warehouse, its racks, and its slots. Boards/Offcuts
  /// inside are archived, never deleted — see the implementation's
  /// doc comment for the full reasoning. Single atomic operation:
  /// any failure leaves the warehouse and everything in it untouched.
  Future<Result<void>> call(String warehouseId);
}
