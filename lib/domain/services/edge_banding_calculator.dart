import 'dart:math' as math;

import '../entities/edge_banding_length.dart';

/// Pure, stateless. Krok 11's second calculator — converts an edge
/// banding roll's physical dimensions into linear meters, using the
/// annulus-cross-section approximation standard for wound tape/film:
/// the roll's cross-section area (outer circle minus core circle)
/// equals the total cross-section of the unrolled tape (length ×
/// thickness), so length = area / thickness.
///
/// Only the conversion — NOT roll-state tracking (remaining length as
/// stock is used up). That is a deliberately separate, larger
/// feature (a persisted `EdgeBandingRoll` entity + repository +
/// migration, comparable in size to Board/Offcut) — this function is
/// written so that future entity can call the same math directly for
/// its own remaining-length calculations without this calculator's
/// shape changing.
class EdgeBandingCalculator {
  EdgeBandingCalculator._();

  /// Throws [ArgumentError] if [outerDiameterMm] <= [coreDiameterMm]
  /// or [tapeThicknessMm] <= 0 — the screen validates input before
  /// calling this, the same way board-dimension forms already
  /// validate before calling a repository's `create()`.
  static EdgeBandingLength calculate({
    required double outerDiameterMm,
    required double coreDiameterMm,
    required double tapeThicknessMm,
  }) {
    if (outerDiameterMm <= coreDiameterMm) {
      throw ArgumentError('outerDiameterMm must be greater than coreDiameterMm');
    }
    if (tapeThicknessMm <= 0) {
      throw ArgumentError('tapeThicknessMm must be positive');
    }

    final annulusAreaMm2 =
        math.pi * (math.pow(outerDiameterMm, 2) - math.pow(coreDiameterMm, 2)) / 4;
    final lengthMm = annulusAreaMm2 / tapeThicknessMm;
    return EdgeBandingLength(meters: lengthMm / 1000);
  }
}
