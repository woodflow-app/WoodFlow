import '../../core/errors/failures.dart';
import '../entities/shopping_list_item.dart';
import '../repositories/board_repository.dart';
import '../repositories/decor_repository.dart';
import '../repositories/offcut_repository.dart';

/// Krok 13 — aggregates current stock (Board+Offcut, non-archived)
/// per decor and compares it against each decor's own
/// `minimumStockQuantity`. Concrete class, not an interface+impl
/// split — same reasoning as `DashboardService`: there is exactly one
/// reasonable way to compute this today, nothing to swap at runtime.
///
/// EXTENSION SEAM for a future per-warehouse threshold (deliberately
/// NOT built now — see `Decor.minimumStockQuantity`'s doc comment):
/// that would mean resolving each Board's/Offcut's warehouse via
/// `BoardRepository.getFullLocation()` (Offcut doesn't have its own
/// yet — same YAGNI note as `OffcutDetailScreen`), grouping the stock
/// count by `(decorId, warehouseId)` instead of just `decorId`, and
/// comparing against a new `(decorId, warehouseId)`-keyed threshold
/// entity — not a change to this class's overall shape.
class ShoppingListService {
  ShoppingListService(this._decors, this._boards, this._offcuts);

  final DecorRepository _decors;
  final BoardRepository _boards;
  final OffcutRepository _offcuts;

  Future<Result<List<ShoppingListItem>>> build() async {
    try {
      final decorsResult = await _decors.getAll();
      if (decorsResult.isFailure) return Result.failure(decorsResult.failure);

      final stockResult = await currentStockByDecor();
      if (stockResult.isFailure) return Result.failure(stockResult.failure);
      final stockByDecorId = stockResult.data;

      final items = <ShoppingListItem>[];
      for (final decor in decorsResult.data) {
        final threshold = decor.minimumStockQuantity;
        if (threshold == null) continue;

        final currentStock = stockByDecorId[decor.id] ?? 0;
        if (currentStock >= threshold) continue;

        items.add(ShoppingListItem(
          decor: decor,
          currentStock: currentStock,
          shortageQuantity: threshold - currentStock,
        ));
      }

      items.sort((a, b) => b.shortageQuantity.compareTo(a.shortageQuantity));
      return Result.success(items);
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// Current stock (Board+Offcut, non-archived) grouped by `decorId`.
  /// Extracted out of `build()` in Krok 14 so `AiQueryEngine` can reuse
  /// the exact same count for `stockQuantity` answers instead of
  /// re-deriving it — the architecture-boundary rule for the AI layer
  /// (extend an existing domain service, never duplicate its
  /// aggregation logic).
  Future<Result<Map<String, int>>> currentStockByDecor() async {
    try {
      final boardsResult = await _boards.getAll();
      final offcutsResult = await _offcuts.getAll();
      final boards = boardsResult.isSuccess ? boardsResult.data : const [];
      final offcuts = offcutsResult.isSuccess ? offcutsResult.data : const [];

      // Counted in Dart, not a SQL GROUP BY — same "small data today,
      // revisit if it's ever measured as slow" tradeoff DashboardService
      // already accepts explicitly for its own boards/offcuts pass.
      final stockByDecorId = <String, int>{};
      for (final board in boards) {
        stockByDecorId[board.decorId] = (stockByDecorId[board.decorId] ?? 0) + 1;
      }
      for (final offcut in offcuts) {
        stockByDecorId[offcut.decorId] = (stockByDecorId[offcut.decorId] ?? 0) + 1;
      }

      return Result.success(stockByDecorId);
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
