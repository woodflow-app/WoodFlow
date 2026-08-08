/// Organizational structure inside a Warehouse. Built right after
/// Warehouse, before Board/Offcut — matches how a real workshop
/// actually organizes stock (find the rack, find the shelf/slot,
/// then find the material), not an afterthought bolted on later.
class Rack {
  final String id;
  final String warehouseId;
  final String name;
  final String qrCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// `qrCode` defaults to `''` — RackRepositoryImpl.create() always
  /// generates a fresh "WF-R-######" code server-side, same reasoning
  /// as Warehouse.
  const Rack({
    required this.id,
    required this.warehouseId,
    required this.name,
    this.qrCode = '',
    required this.createdAt,
    required this.updatedAt,
  });

  Rack copyWith({
    String? name,
    String? qrCode,
    DateTime? updatedAt,
  }) {
    return Rack(
      id: id,
      warehouseId: warehouseId,
      name: name ?? this.name,
      qrCode: qrCode ?? this.qrCode,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
