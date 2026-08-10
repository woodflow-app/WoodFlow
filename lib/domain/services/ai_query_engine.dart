import '../../core/errors/failures.dart';
import '../entities/ai_query_answer.dart';
import '../entities/ai_query_intent.dart';
import '../entities/board_location_hit.dart';
import '../entities/dashboard_snapshot.dart' show StaleItemType;
import '../entities/decor.dart';
import '../entities/dimensions_hit.dart';
import '../repositories/board_repository.dart';
import '../repositories/decor_repository.dart';
import '../repositories/offcut_repository.dart';
import 'ai_query_parser.dart';
import 'dashboard_service.dart';
import 'offcut_match_finder.dart';
import 'shopping_list_service.dart';

/// Krok 14's orchestrator — the ONLY class in the AI module that talks
/// to repositories/other domain services. Per the standing
/// architecture-boundary rule (same one already applied to
/// `PdfLabelGenerator`/`ExportGenerator`): this class never queries the
/// database directly, never recomputes an aggregation another domain
/// service already provides, and any genuinely new decision logic
/// (the offcut-matching geometry) lives in its own service
/// (`OffcutMatchFinder`), not inline here. This class reads as a thin
/// caller: parse → resolve a decor → dispatch to the existing
/// repositories/services → wrap the result.
class AiQueryEngine {
  AiQueryEngine(
    this._parser,
    this._decors,
    this._boards,
    this._offcuts,
    this._dashboard,
    this._shoppingList,
    this._matcher,
  );

  final AiQueryParser _parser;
  final DecorRepository _decors;
  final BoardRepository _boards;
  final OffcutRepository _offcuts;
  final DashboardService _dashboard;
  final ShoppingListService _shoppingList;
  final OffcutMatchFinder _matcher;

  Future<Result<AiQueryAnswer>> ask(String rawText, String languageCode) async {
    try {
      final parsed = _parser.parse(rawText, languageCode);
      if (parsed == null) {
        return Result.success(UnrecognizedQueryAnswer(rawText: rawText));
      }

      Decor? decor;
      if (parsed.decorQueryText != null) {
        final decorsResult = await _decors.getAll();
        if (decorsResult.isFailure) return Result.failure(decorsResult.failure);
        decor = _resolveDecor(parsed.decorQueryText!, decorsResult.data);
      }

      // Every intent except staleMaterials needs a resolved decor to
      // answer anything meaningful — staleMaterials alone can answer
      // "show everything stale" with no decor named.
      final requiresDecor = parsed.intentType != AiQueryIntentType.staleMaterials;
      if (requiresDecor && decor == null) {
        return Result.success(UnrecognizedQueryAnswer(rawText: rawText));
      }

      switch (parsed.intentType) {
        case AiQueryIntentType.stockQuantity:
          return _answerStockQuantity(decor!);
        case AiQueryIntentType.location:
          return _answerLocation(decor!);
        case AiQueryIntentType.dimensions:
          return _answerDimensions(decor!);
        case AiQueryIntentType.staleMaterials:
          return _answerStaleMaterials(decor);
        case AiQueryIntentType.offcutMatch:
          return _answerOffcutMatch(decor!, parsed, rawText);
      }
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  /// [queryText] is a leftover NL remainder (after the parser strips a
  /// trigger phrase), not clean search-box input — it can still carry
  /// filler words the trigger phrase didn't capture (e.g. Polish
  /// "jakie wymiary MA h3303" leaves "ma h3303"). Three passes, most
  /// specific first: exact code match; the decor's code appearing
  /// literally inside the leftover text (handles filler words around
  /// an otherwise-complete code); finally the reverse containment
  /// already used by `ShoppingListScreen`'s decor search and
  /// `egger_colours.searchEggerColours()`, for partial/incomplete
  /// typing (e.g. "h33").
  Decor? _resolveDecor(String queryText, List<Decor> allDecors) {
    final q = queryText.trim().toLowerCase();
    if (q.isEmpty) return null;

    for (final decor in allDecors) {
      if (decor.code.toLowerCase() == q) return decor;
    }
    for (final decor in allDecors) {
      if (q.contains(decor.code.toLowerCase())) return decor;
    }
    for (final decor in allDecors) {
      if (decor.code.toLowerCase().contains(q) || decor.name.toLowerCase().contains(q)) {
        return decor;
      }
    }
    return null;
  }

  Future<Result<AiQueryAnswer>> _answerStockQuantity(Decor decor) async {
    final stockResult = await _shoppingList.currentStockByDecor();
    if (stockResult.isFailure) return Result.failure(stockResult.failure);
    final quantity = stockResult.data[decor.id] ?? 0;
    return Result.success(StockQuantityAnswer(decor: decor, quantity: quantity));
  }

  /// Boards only — Offcut has no `getFullLocation()` yet, same
  /// pre-existing, already-documented gap `DashboardService` carries
  /// forward rather than solves here (see `BoardLocationHit`).
  Future<Result<AiQueryAnswer>> _answerLocation(Decor decor) async {
    final boardsResult = await _boards.getAll();
    if (boardsResult.isFailure) return Result.failure(boardsResult.failure);

    final hits = <BoardLocationHit>[];
    for (final board in boardsResult.data.where((b) => b.decorId == decor.id)) {
      final locationResult = await _boards.getFullLocation(board.id);
      if (locationResult.isFailure) continue;
      hits.add(BoardLocationHit(boardId: board.id, location: locationResult.data));
    }
    return Result.success(LocationAnswer(decor: decor, locations: hits));
  }

  Future<Result<AiQueryAnswer>> _answerDimensions(Decor decor) async {
    final boardsResult = await _boards.getAll();
    if (boardsResult.isFailure) return Result.failure(boardsResult.failure);
    final offcutsResult = await _offcuts.getAll();
    if (offcutsResult.isFailure) return Result.failure(offcutsResult.failure);

    final hits = <DimensionsHit>[
      for (final board in boardsResult.data.where((b) => b.decorId == decor.id))
        DimensionsHit(
          entityId: board.id,
          type: StaleItemType.board,
          lengthMm: board.length,
          widthMm: board.width,
          thicknessMm: board.thickness,
        ),
      for (final offcut in offcutsResult.data.where((o) => o.decorId == decor.id))
        DimensionsHit(
          entityId: offcut.id,
          type: StaleItemType.offcut,
          lengthMm: offcut.length,
          widthMm: offcut.width,
          thicknessMm: offcut.thickness,
        ),
    ];
    return Result.success(DimensionsAnswer(decor: decor, hits: hits));
  }

  /// Reuses `DashboardService.build()`'s already-computed `staleItems`
  /// (its own >1-year threshold stays private there — this method
  /// never reimplements the age check). `StaleItem` doesn't carry a
  /// `decorId` (only an already-resolved display label), so an optional
  /// decor filter matches on that label's exact `"code — name"` format
  /// — the same format `DashboardService` builds it in, not a second
  /// independent formatting rule.
  Future<Result<AiQueryAnswer>> _answerStaleMaterials(Decor? decor) async {
    final snapshotResult = await _dashboard.build();
    if (snapshotResult.isFailure) return Result.failure(snapshotResult.failure);

    var items = snapshotResult.data.staleItems;
    if (decor != null) {
      final expectedLabel = '${decor.code} — ${decor.name}';
      items = items.where((item) => item.decorLabel == expectedLabel).toList();
    }
    return Result.success(StaleMaterialsAnswer(items: items));
  }

  Future<Result<AiQueryAnswer>> _answerOffcutMatch(
    Decor decor,
    ParsedAiQuery parsed,
    String rawText,
  ) async {
    final lengthMm = parsed.requestedLengthMm;
    final widthMm = parsed.requestedWidthMm;
    if (lengthMm == null || widthMm == null) {
      return Result.success(UnrecognizedQueryAnswer(rawText: rawText));
    }

    final offcutsResult = await _offcuts.getAll();
    if (offcutsResult.isFailure) return Result.failure(offcutsResult.failure);

    final candidates = offcutsResult.data.where((o) => o.decorId == decor.id).toList();
    final matches = _matcher.findAlternatives(
      candidates: candidates,
      minLengthMm: lengthMm,
      minWidthMm: widthMm,
      minThicknessMm: parsed.requestedThicknessMm,
    );
    return Result.success(OffcutMatchAnswer(decor: decor, candidates: matches));
  }
}
