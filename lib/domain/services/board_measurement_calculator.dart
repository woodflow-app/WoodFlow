import '../entities/board_measurement.dart';

/// Pure, stateless — no repository access, no async, same shape as
/// `LedgerEntryFormatter`/`ExportDataBuilder`. Krok 11's first
/// calculator: area (m²) and volume (m³) from length/width/thickness
/// in mm — the same unit Board/Offcut already store their dimensions
/// in, so a caller can pass a Board's/Offcut's fields straight
/// through without conversion.
class BoardMeasurementCalculator {
  BoardMeasurementCalculator._();

  static BoardMeasurement calculate({
    required double lengthMm,
    required double widthMm,
    required double thicknessMm,
  }) {
    final areaM2 = (lengthMm * widthMm) / 1e6;
    final volumeM3 = areaM2 * (thicknessMm / 1000);
    return BoardMeasurement(areaM2: areaM2, volumeM3: volumeM3);
  }
}
