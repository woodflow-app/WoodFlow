/// Result of `BoardMeasurementCalculator` (Krok 11) — area and volume
/// computed from length × width × thickness. Pure result carrier,
/// same role as `BoardLocation`/`LedgerEntryDescription`: the
/// calculator returns this, the screen only renders it.
class BoardMeasurement {
  final double areaM2;
  final double volumeM3;

  const BoardMeasurement({required this.areaM2, required this.volumeM3});
}
