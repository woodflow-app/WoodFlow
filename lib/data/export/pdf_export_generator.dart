import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/export_row.dart';
import '../../domain/services/export_generator.dart';

/// One of three `ExportGenerator` implementations (Krok 10). Uses the
/// same `pdf` package `PdfLabelGenerator` already depends on, but
/// renders a generic table instead of a sticker grid.
///
/// Deliberately has zero imports from `domain/entities/board.dart` or
/// `offcut.dart` — same boundary rule as `PdfLabelGenerator`: it only
/// knows `ExportRow`.
class PdfExportGenerator implements ExportGenerator {
  static const _fontAsset = 'assets/fonts/NotoSans-Variable.ttf';

  // Cached across calls — this class is a get_it lazy singleton, so
  // there's exactly one instance for the app's lifetime, and parsing
  // a 2 MB font file on every export would be wasted work.
  pw.Font? _cachedFont;

  /// The `pdf` package's built-in Helvetica is a Base-14 PDF font —
  /// it has NO glyphs beyond basic Latin, so Polish diacritics
  /// (ł/ż/ć/ę/ś/ą/ź/ń), Cyrillic (`ru`), or any other non-ASCII
  /// character in a decor/warehouse name silently fails to draw.
  /// Since WoodFlow ships in 21 languages, that's not an edge case —
  /// it's most of the target audience. Noto Sans covers Latin
  /// Extended-A/B and Cyrillic (SIL OFL 1.1, see
  /// assets/fonts/NotoSans-OFL.txt).
  Future<pw.Font> _unicodeFont() async {
    final cached = _cachedFont;
    if (cached != null) return cached;
    final font = pw.Font.ttf(await rootBundle.load(_fontAsset));
    _cachedFont = font;
    return font;
  }

  @override
  Future<Uint8List> generate({
    required String title,
    required List<ExportRow> rows,
  }) async {
    final font = await _unicodeFont();
    final doc = pw.Document(theme: pw.ThemeData.withFont(base: font, bold: font));
    final headers = rows.isEmpty ? const <String>[] : rows.first.cells.keys.toList();
    final data = rows.map((row) => row.cells.values.toList()).toList();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) => [
          pw.Header(text: title, level: 0),
          if (headers.isNotEmpty)
            pw.TableHelper.fromTextArray(
              context: context,
              headers: headers,
              data: data,
              cellStyle: const pw.TextStyle(fontSize: 8),
              headerStyle: const pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
            ),
        ],
      ),
    );

    return doc.save();
  }
}
