import 'package:flutter_test/flutter_test.dart';

import 'package:woodflow/domain/services/board_measurement_calculator.dart';

void main() {
  group('BoardMeasurementCalculator — pure, no repository access', () {
    test('computes area (m²) and volume (m³) from length/width/thickness in mm', () {
      final result = BoardMeasurementCalculator.calculate(
        lengthMm: 2800,
        widthMm: 2070,
        thicknessMm: 18,
      );

      expect(result.areaM2, closeTo(5.796, 1e-9));
      expect(result.volumeM3, closeTo(0.104328, 1e-9));
    });

    test('zero thickness gives zero volume but a real area (degenerate but'
        ' not a crash — the screen validates positive input before calling'
        ' this, this just documents the pure function\'s own behavior)', () {
      final result = BoardMeasurementCalculator.calculate(
        lengthMm: 1000,
        widthMm: 1000,
        thicknessMm: 0,
      );

      expect(result.areaM2, 1.0);
      expect(result.volumeM3, 0.0);
    });
  });
}
