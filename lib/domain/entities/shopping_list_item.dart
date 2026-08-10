import 'decor.dart';

/// One decor below its own `minimumStockQuantity` (Krok 13) — computed
/// by `ShoppingListService`, never stored. `shortageQuantity` is
/// always > 0 for any item that exists in a list of these; a decor at
/// or above its threshold never produces one.
class ShoppingListItem {
  final Decor decor;
  final int currentStock;
  final int shortageQuantity;

  const ShoppingListItem({
    required this.decor,
    required this.currentStock,
    required this.shortageQuantity,
  });
}
