/// Result of cutting a Board (per WoodFlow Dictionary). Per ADR-022
/// ("Offcut nigdy nie jest małym Board") this is self-sufficient —
/// NOT a join away from being usable:
///
/// - `slotId` — same location model as Board (required, only source
///   of truth; Warehouse/Rack always derived via join, never stored)
/// - `decorId` — DENORMALIZED COPY of the parent Board's decorId at
///   the moment of cutting. Board remains the source of truth for
///   material identity; this copy exists so every offcut screen can
///   show a decor without joining to Board on every row. Copied
///   once, never synced back — if a Board's decor is corrected after
///   cutting, updating existing offcuts is a new, deliberate decision,
///   not an automatic consequence of this field existing.
/// - `parentBoardId` — required, for provenance ("wytnij ze which
///   board"), not for reading material identity day-to-day.
class Offcut {
  final String id;
  final String parentBoardId;
  final String slotId;
  final String decorId;
  final double length; // mm
  final double width; // mm
  final double thickness; // mm
  final String qrCode;
  final OffcutStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Offcut({
    required this.id,
    required this.parentBoardId,
    required this.slotId,
    required this.decorId,
    required this.length,
    required this.width,
    required this.thickness,
    required this.qrCode,
    this.status = OffcutStatus.available,
    required this.createdAt,
    required this.updatedAt,
  });

  Offcut copyWith({
    String? slotId,
    OffcutStatus? status,
    DateTime? updatedAt,
  }) {
    return Offcut(
      id: id,
      parentBoardId: parentBoardId,
      slotId: slotId ?? this.slotId,
      decorId: decorId,
      length: length,
      width: width,
      thickness: thickness,
      qrCode: qrCode,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// `available` (not `inStock` like Board) — matches WoodFlow
/// Dictionary's own wording: "spełniająca minimalne wymiary do
/// dalszego wykorzystania". `archived` mirrors Board's
/// archive-not-delete rule under an append-only Ledger.
enum OffcutStatus {
  available,
  archived;

  String get dbValue => name;

  static OffcutStatus fromDb(String value) =>
      OffcutStatus.values.firstWhere((s) => s.dbValue == value);
}
