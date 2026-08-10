import 'dart:typed_data';

import '../entities/export_row.dart';

/// Krok 10 output format. The user picks one in `ExportScreen`; unlike
/// `LabelGenerator` (one implementation, bound via get_it), all three
/// formats have to exist side by side and be selected by this value —
/// there is no single "the" implementation to swap in.
enum ExportFormat {
  pdf,
  csv,
  rtf;

  /// File extension (no dot) — used when naming the temp file handed
  /// to the share sheet.
  String get fileExtension => name;
}

/// The contract every export output format implements. Mirrors
/// `LabelGenerator`'s shape: a new format (e.g. XLSX) is a new file
/// implementing THIS interface — nothing above it (domain, UI)
/// changes, and nothing here ever needs to know what a Board is.
///
/// [rows] carries its own column labels (`ExportRow.cells` keys) —
/// implementations derive the header row from `rows.first.cells.keys`
/// rather than taking a separate headers parameter that could drift
/// out of sync with row order. An empty [rows] list is valid (e.g. a
/// warehouse with nothing to export yet); implementations must
/// produce a minimal valid document (title only, no table) rather
/// than throwing.
abstract class ExportGenerator {
  /// Returns the raw output bytes. The caller decides what to do with
  /// them (save to a temp file, then hand to the share sheet) — this
  /// layer only produces the document.
  Future<Uint8List> generate({
    required String title,
    required List<ExportRow> rows,
  });
}
