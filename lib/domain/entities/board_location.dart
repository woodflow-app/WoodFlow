/// Resolved location chain for a Board — computed by joining
/// `slots → racks → warehouses`, never stored on Board itself. This
/// is what lets UI show "Warsztat główny > Regał A > Półka A2"
/// without Board ever holding a warehouseId/rackId that could
/// disagree with its slotId.
class BoardLocation {
  final String warehouseId;
  final String warehouseName;
  final String rackId;
  final String rackName;
  final String slotId;
  final String slotName;

  const BoardLocation({
    required this.warehouseId,
    required this.warehouseName,
    required this.rackId,
    required this.rackName,
    required this.slotId,
    required this.slotName,
  });

  String get breadcrumb => '$warehouseName > $rackName > $slotName';
}
