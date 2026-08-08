/// Full, uncut board (per WoodFlow Dictionary — distinct from Offcut).
///
/// LOCATION MODEL: `slotId` is the ONLY location field, and it is
/// REQUIRED. There is no `warehouseId`/`rackId` on this entity at
/// all — those are always DERIVED by joining
/// `slot → rack → warehouse`, never stored redundantly here. This
/// eliminates an entire class of bug: a Board's `warehouse_id`
/// disagreeing with the warehouse its `slot_id` actually belongs to.
/// See `BoardLocation` for how the resolved chain is fetched.
///
/// Consequence: a Board cannot exist before at least one Rack and
/// Slot exist in some Warehouse. This matches the original,
/// real-world-proven app behavior (block adding stock before a
/// location exists) rather than the softer "nullable slot" version
/// explored earlier in this rebuild — reverted on purpose.
///
/// `decorId` (not a free-text `decorCode`) references the global
/// `Decor` catalog — per ADR-002 and the Pre-Build Audit, this is
/// the same class of mistake Project/Supplier were built to avoid,
/// caught before Board shipped anywhere.
class Board {
  final String id;
  final String slotId;
  final String decorId;
  final double length; // mm
  final double width; // mm
  final double thickness; // mm
  final String qrCode;
  final BoardStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Board({
    required this.id,
    required this.slotId,
    required this.decorId,
    required this.length,
    required this.width,
    required this.thickness,
    required this.qrCode,
    this.status = BoardStatus.inStock,
    required this.createdAt,
    required this.updatedAt,
  });

  Board copyWith({
    String? slotId,
    BoardStatus? status,
    DateTime? updatedAt,
  }) {
    return Board(
      id: id,
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

/// `moved` deliberately absent — moving is an event (BoardMoved in
/// the ledger), not a persistent status. `archived` mirrors the
/// project-wide archive-not-delete rule under an append-only Ledger.
enum BoardStatus {
  inStock,
  archived;

  String get dbValue => name;

  static BoardStatus fromDb(String value) =>
      BoardStatus.values.firstWhere((s) => s.dbValue == value);
}
