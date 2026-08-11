import '../../core/errors/failures.dart';

/// Domain-facing contract for cascading slot deletion — same shape and
/// same reasoning as `DeleteWarehouseUseCase`/`DeleteRackUseCase`.
/// Introduced to close the gap documented in
/// `docs/design-system/EntityEditingSpecification.md` §3, Finding 1:
/// `SlotRepository.delete()` was unconditional with no occupancy check,
/// despite being reachable from `SlotDetailScreen` today; this is the
/// hardened replacement.
abstract class DeleteSlotUseCase {
  /// Deletes the slot. Boards/Offcuts inside are archived, never
  /// deleted — see the implementation's doc comment. Single atomic
  /// operation: any failure leaves the slot and its contents untouched.
  Future<Result<void>> call(String slotId);
}
