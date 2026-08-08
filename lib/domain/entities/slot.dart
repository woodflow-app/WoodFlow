/// A single slot within a Rack. This is the actual physical location
/// a Board or Offcut occupies — `Board.slotId`/`Offcut.slotId` point
/// here. `capacity` mirrors the old app's field (default 20) — used
/// to compute a fill ratio for the warehouse map view.
class Slot {
  final String id;
  final String rackId;
  final String name;
  final int capacity;
  final String qrCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// `qrCode` defaults to `''` — SlotRepositoryImpl.create() always
  /// generates a fresh "WF-S-######" code server-side, same reasoning
  /// as Warehouse/Rack.
  const Slot({
    required this.id,
    required this.rackId,
    required this.name,
    this.capacity = 20,
    this.qrCode = '',
    required this.createdAt,
    required this.updatedAt,
  });

  Slot copyWith({
    String? name,
    int? capacity,
    String? qrCode,
    DateTime? updatedAt,
  }) {
    return Slot(
      id: id,
      rackId: rackId,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      qrCode: qrCode ?? this.qrCode,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
