/// Describes the PHYSICAL size and arrangement of labels — completely
/// separate from the output format. "A4 sheet with a 3×8 grid" and
/// "single 50×30mm sticker" are both just a [LabelLayout]; whether
/// that gets rendered as PDF, PNG, or sent to a Zebra printer is the
/// generator's concern, not this class's.
///
/// Adding a new physical label size later (e.g. a 100×50mm sticker
/// roll) is a new constant here, never a change to any generator.
class LabelLayout {
  final String name;
  final double sheetWidthMm;
  final double sheetHeightMm;
  final int columns;
  final int rows;

  const LabelLayout({
    required this.name,
    required this.sheetWidthMm,
    required this.sheetHeightMm,
    required this.columns,
    required this.rows,
  });

  int get labelsPerSheet => columns * rows;

  /// A4 sheet, 3×8 grid — 24 labels per sheet, standard office
  /// printer paper. The only layout Krok 7.3 actually needs (Piotr's
  /// scope: "zwykła drukarka", not label-roll hardware).
  static const a4Grid3x8 = LabelLayout(
    name: 'A4 (3×8)',
    sheetWidthMm: 210,
    sheetHeightMm: 297,
    columns: 3,
    rows: 8,
  );

  /// Single-sticker layouts — NOT built now (no label-roll printer
  /// exists in scope yet), but the shape of LabelLayout already
  /// supports them without any generator change when they're needed:
  /// `LabelLayout(name: '50×30mm', sheetWidthMm: 50, sheetHeightMm: 30, columns: 1, rows: 1)`
}
