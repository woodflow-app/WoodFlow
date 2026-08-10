import 'board_location_hit.dart';
import 'dashboard_snapshot.dart' show StaleItem;
import 'decor.dart';
import 'dimensions_hit.dart';
import 'offcut_match_candidate.dart';

/// The result of `AiQueryEngine.ask()` — Krok 14's deterministic AI
/// query engine. `sealed` (first use in this codebase; Dart SDK is
/// >=3.3.0) rather than one class with nullable fields per intent, on
/// purpose: these 6 shapes are genuinely different (not close variants
/// like `StaleItem`'s board/offcut split), and a sealed class makes
/// `AiQueryScreen`'s render `switch` exhaustive — a 7th variant added
/// later fails to compile everywhere it isn't handled, instead of
/// silently rendering nothing.
sealed class AiQueryAnswer {
  const AiQueryAnswer();
}

/// Answer to a `stockQuantity` query — how many Board+Offcut rows
/// (active only) exist for this decor. See
/// `ShoppingListService.currentStockByDecor()`, reused here rather
/// than re-counted.
class StockQuantityAnswer extends AiQueryAnswer {
  final Decor decor;
  final int quantity;

  const StockQuantityAnswer({required this.decor, required this.quantity});
}

/// Answer to a `location` query. Boards only — see
/// `BoardLocationHit`'s doc comment for why.
class LocationAnswer extends AiQueryAnswer {
  final Decor decor;
  final List<BoardLocationHit> locations;

  const LocationAnswer({required this.decor, required this.locations});
}

/// Answer to a `dimensions` query — every Board/Offcut of this decor
/// with its stored size.
class DimensionsAnswer extends AiQueryAnswer {
  final Decor decor;
  final List<DimensionsHit> hits;

  const DimensionsAnswer({required this.decor, required this.hits});
}

/// Answer to a `staleMaterials` query — reuses `DashboardService`'s
/// own `StaleItem`/>1-year definition directly, optionally pre-filtered
/// to one decor by `AiQueryEngine` when the query named one.
class StaleMaterialsAnswer extends AiQueryAnswer {
  final List<StaleItem> items;

  const StaleMaterialsAnswer({required this.items});
}

/// Answer to an `offcutMatch` query — candidates from
/// `OffcutMatchFinder`, already sorted smallest-sufficient-first.
class OffcutMatchAnswer extends AiQueryAnswer {
  final Decor decor;
  final List<OffcutMatchCandidate> candidates;

  const OffcutMatchAnswer({required this.decor, required this.candidates});
}

/// No intent matched the raw text, or an intent matched but its
/// required decor couldn't be resolved against `DecorRepository`.
/// `rawText` is carried through so the screen can echo back what it
/// failed to understand, rather than a generic error.
class UnrecognizedQueryAnswer extends AiQueryAnswer {
  final String rawText;

  const UnrecognizedQueryAnswer({required this.rawText});
}
