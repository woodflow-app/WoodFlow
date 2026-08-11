import '../../core/errors/failures.dart';

/// Domain-facing contract for cascading rack deletion — same shape and
/// same reasoning as `DeleteWarehouseUseCase`, one level down the
/// hierarchy. Introduced to close the gap documented in
/// `docs/design-system/EntityEditingSpecification.md` §3, Finding 1:
/// `RackRepository.delete()` was unconditional with no occupancy check
/// and no UI; this is the hardened replacement, following the exact
/// precedent `DeleteWarehouseUseCase` already established.
abstract class DeleteRackUseCase {
  /// Deletes the rack and its slots. Boards/Offcuts inside are
  /// archived, never deleted — see the implementation's doc comment.
  /// Single atomic operation: any failure leaves the rack and
  /// everything in it untouched.
  Future<Result<void>> call(String rackId);
}
