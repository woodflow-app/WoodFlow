import 'board_location.dart';

/// One Board's resolved location, as returned by an AI `location`
/// query (Krok 14). Boards only — `Offcut` has no `getFullLocation()`
/// yet (same pre-existing YAGNI gap already documented on
/// `DashboardService`/`OffcutDetailScreen`); `AiQueryEngine` carries
/// that limitation forward rather than solving it here.
class BoardLocationHit {
  final String boardId;
  final BoardLocation location;

  const BoardLocationHit({required this.boardId, required this.location});
}
