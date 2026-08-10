import 'package:flutter_test/flutter_test.dart';

import 'package:woodflow/domain/services/edge_banding_calculator.dart';

void main() {
  group('EdgeBandingCalculator — pure, annulus-cross-section formula', () {
    test('computes length (m) from outer/core diameter and tape thickness', () {
      final result = EdgeBandingCalculator.calculate(
        outerDiameterMm: 100,
        coreDiameterMm: 60,
        tapeThicknessMm: 1,
      );

      // area = π × (100² − 60²) / 4 = π × 1600 ≈ 5026.548 mm → m
      expect(result.meters, closeTo(5.026548, 1e-5));
    });

    test('thinner tape yields more length from the same roll', () {
      final thick = EdgeBandingCalculator.calculate(
        outerDiameterMm: 200,
        coreDiameterMm: 100,
        tapeThicknessMm: 2,
      );
      final thin = EdgeBandingCalculator.calculate(
        outerDiameterMm: 200,
        coreDiameterMm: 100,
        tapeThicknessMm: 1,
      );

      expect(thin.meters, greaterThan(thick.meters));
    });

    test('throws ArgumentError when outer diameter does not exceed core diameter'
        ' — an impossible roll, not something to silently return 0/negative for', () {
      expect(
        () => EdgeBandingCalculator.calculate(
          outerDiameterMm: 60,
          coreDiameterMm: 60,
          tapeThicknessMm: 1,
        ),
        throwsArgumentError,
      );
      expect(
        () => EdgeBandingCalculator.calculate(
          outerDiameterMm: 50,
          coreDiameterMm: 60,
          tapeThicknessMm: 1,
        ),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for non-positive tape thickness', () {
      expect(
        () => EdgeBandingCalculator.calculate(
          outerDiameterMm: 100,
          coreDiameterMm: 60,
          tapeThicknessMm: 0,
        ),
        throwsArgumentError,
      );
    });
  });
}
