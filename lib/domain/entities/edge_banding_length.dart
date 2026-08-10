/// Result of `EdgeBandingCalculator` (Krok 11) — the length of tape
/// wound on a roll, computed from its outer/core diameter and
/// thickness via the annulus-cross-section formula.
///
/// Deliberately a dedicated type rather than a bare `double`: a
/// future `EdgeBandingRoll` entity (full inventory tracking — not
/// built yet, see docs/CHANGELOG.md Krok 11) can add fields here
/// (e.g. `wrapsCount`, `estimatedWeightKg`) without changing
/// `EdgeBandingCalculator`'s call signature at any existing call site.
class EdgeBandingLength {
  final double meters;

  const EdgeBandingLength({required this.meters});
}
