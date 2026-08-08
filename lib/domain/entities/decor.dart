/// Global decor catalog (EGGER/Kronospan/Pfleiderer codes), per
/// ADR-002 — one shared reference table, not text copied onto every
/// Board/Offcut. `code` is what a user types ("H3303"); `name` is
/// what autocomplete fills in ("Natural Hamilton Oak").
class Decor {
  final String id;
  final String code;
  final String name;
  final String manufacturer;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Decor({
    required this.id,
    required this.code,
    required this.name,
    required this.manufacturer,
    required this.createdAt,
    required this.updatedAt,
  });
}
