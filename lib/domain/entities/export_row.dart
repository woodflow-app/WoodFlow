/// One row of tabular export data (Krok 10). Deliberately generic —
/// knows nothing about Board, Offcut, Warehouse, or any other domain
/// entity, the same way `LabelData` knows nothing about PDF.
///
/// Self-describing on purpose: [cells] maps column label → value,
/// insertion-ordered (Dart's `Map` literal preserves insertion
/// order), so the header row is always just `rows.first.cells.keys`
/// — there is no separate header list to keep in sync with row order.
///
/// Every row in one export must use the same keys in the same order.
/// Type safety for THIS shape lives in `ExportDataBuilder`, not here
/// — it exposes named, typed methods (`fromBoard`, `fromOffcut`) and
/// is the only place that constructs an `ExportRow` by hand.
class ExportRow {
  final Map<String, String> cells;

  const ExportRow(this.cells);
}
