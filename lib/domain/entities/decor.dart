/// Global decor catalog (EGGER/Kronospan/Pfleiderer codes), per
/// ADR-002 — one shared reference table, not text copied onto every
/// Board/Offcut. `code` is what a user types ("H3303"); `name` is
/// what autocomplete fills in ("Natural Hamilton Oak").
///
/// `minimumStockQuantity` (Krok 13) — null means "no threshold set,
/// never alert"; a set value is a PIECE count (Board+Offcut rows,
/// not m²/m³ — matches how they're naturally counted). Deliberately
/// global per decor, not per-warehouse: "should we reorder this
/// decor" is a company-wide question today, not a per-location one.
/// A future per-warehouse threshold would be a NEW entity keyed by
/// (decorId, warehouseId), not a change to this field — see
/// `ShoppingListService`'s class comment for the extension seam.
class Decor {
  final String id;
  final String code;
  final String name;
  final String manufacturer;
  final int? minimumStockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Decor({
    required this.id,
    required this.code,
    required this.name,
    required this.manufacturer,
    this.minimumStockQuantity,
    required this.createdAt,
    required this.updatedAt,
  });

  Decor copyWith({
    String? name,
    Object? minimumStockQuantity = _unset,
    DateTime? updatedAt,
  }) {
    return Decor(
      id: id,
      code: code,
      name: name ?? this.name,
      manufacturer: manufacturer,
      minimumStockQuantity: identical(minimumStockQuantity, _unset)
          ? this.minimumStockQuantity
          : minimumStockQuantity as int?,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Sentinel so copyWith can distinguish "leave minimumStockQuantity
/// unchanged" from "explicitly clear it to null" — same fix already
/// applied to Warehouse/Board/Offcut's copyWith after catching this
/// bug class once.
const _unset = Object();
