/// A single manufacturer catalogue entry (v10 migration) — EGGER or
/// Kronospan decor, distinguished from siblings sharing the same
/// `code` by `texture`/`productType`. `productType` is `'Board' |
/// 'Worktop' | 'Edging'`.
///
/// For the 4 legacy codes already tracked as real inventory decors
/// (H3303, U702, H1180, U708), `decorId` points at the corresponding
/// `decors` row, which is the sole authoritative source for `name`/
/// `manufacturer` — `DecorCatalogRepositoryImpl` resolves those two
/// fields via a JOIN, so by the time this entity is constructed they
/// are always populated, regardless of which table actually stores
/// them. Every other entry is self-contained (`decorId` null).
class DecorCatalogEntry {
  final String id;
  final String code;
  final String? texture;
  final String productType;
  final String name;
  final String manufacturer;
  final String? imageUrl;
  final String? swatchColor;
  final String? decorId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DecorCatalogEntry({
    required this.id,
    required this.code,
    this.texture,
    this.productType = 'Board',
    required this.name,
    required this.manufacturer,
    this.imageUrl,
    this.swatchColor,
    this.decorId,
    required this.createdAt,
    required this.updatedAt,
  });
}
