import 'dashboard_snapshot.dart' show StaleItemType;

/// One Board's or Offcut's stored dimensions, as returned by an AI
/// `dimensions` query (Krok 14). Reuses `StaleItemType` (already
/// `board`/`offcut`, defined in `dashboard_snapshot.dart`) instead of
/// declaring a second identical enum — same board-or-offcut
/// distinction, no new vocabulary for the same concept.
class DimensionsHit {
  final String entityId;
  final StaleItemType type;
  final double lengthMm;
  final double widthMm;
  final double thicknessMm;

  const DimensionsHit({
    required this.entityId,
    required this.type,
    required this.lengthMm,
    required this.widthMm,
    required this.thicknessMm,
  });
}
