import '../entities/offcut.dart';
import '../entities/offcut_match_candidate.dart';

/// Krok 14's one piece of genuinely new decision logic — pure,
/// stateless geometric matching, same shape as
/// `BoardMeasurementCalculator`/`EdgeBandingCalculator`. Given a set
/// of offcuts (already filtered to the requested decor by
/// `AiQueryEngine`) and a requested size, returns the ones big enough
/// to cover it, closest fit first.
///
/// Deliberately simple for v1: exact-decor, all-dimensions-fit
/// comparison only — no rotation/nesting/cut-layout reasoning. That is
/// the Cut Optimizer's job (Krok 15, not built yet); this is
/// preparation for it, not a preview of it.
class OffcutMatchFinder {
  const OffcutMatchFinder();

  /// [candidates] should already be limited to offcuts of the desired
  /// decor and to `OffcutStatus.available` — this method does not
  /// filter by decor or status, only by size, so the caller stays the
  /// single place decor/status filtering rules live.
  List<OffcutMatchCandidate> findAlternatives({
    required List<Offcut> candidates,
    required double minLengthMm,
    required double minWidthMm,
    double? minThicknessMm,
  }) {
    final matches = <OffcutMatchCandidate>[];
    final requestedAreaMm2 = minLengthMm * minWidthMm;

    for (final offcut in candidates) {
      final fitsLength = offcut.length >= minLengthMm;
      final fitsWidth = offcut.width >= minWidthMm;
      final fitsThickness = minThicknessMm == null || offcut.thickness >= minThicknessMm;
      if (!fitsLength || !fitsWidth || !fitsThickness) continue;

      final offcutAreaMm2 = offcut.length * offcut.width;
      matches.add(OffcutMatchCandidate(
        offcut: offcut,
        wasteAreaMm2: offcutAreaMm2 - requestedAreaMm2,
      ));
    }

    matches.sort((a, b) => a.wasteAreaMm2.compareTo(b.wasteAreaMm2));
    return matches;
  }
}
