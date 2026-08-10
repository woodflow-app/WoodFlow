import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';

import '../../domain/entities/export_row.dart';
import '../../domain/services/export_generator.dart';

/// One of three `ExportGenerator` implementations (Krok 10).
///
/// Uses `Csv.excel()` (semicolon delimiter + UTF-8 BOM) rather than
/// the plain comma-delimited default: European-locale Excel (the
/// realistic target here — WoodFlow is a Polish tool) treats ',' as
/// the decimal separator and expects ';' as the list separator, so a
/// comma-delimited file opens as a single garbled column on a plain
/// double-click. [title] is intentionally unused in the file body —
/// embedding a title row would misalign it under the real header row
/// in any spreadsheet app; the caller carries the title in the
/// filename/share-sheet text instead.
class CsvExportGenerator implements ExportGenerator {
  @override
  Future<Uint8List> generate({
    required String title,
    required List<ExportRow> rows,
  }) async {
    final table = <List<String>>[
      if (rows.isNotEmpty) rows.first.cells.keys.toList(),
      for (final row in rows) row.cells.values.toList(),
    ];

    final csvString = Csv.excel().encode(table);
    return Uint8List.fromList(utf8.encode(csvString));
  }
}
