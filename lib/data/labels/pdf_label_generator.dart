import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/label_data.dart';
import '../../domain/entities/label_layout.dart';
import '../../domain/services/label_generator.dart';

/// The only `LabelGenerator` implementation today. A future
/// `ZebraLabelGenerator` (ZPL output) or `PngLabelGenerator` would be
/// a NEW file implementing the same interface — this class never
/// changes when that happens, and neither does anything that calls
/// `LabelGenerator` today.
///
/// Deliberately has zero imports from `domain/entities/board.dart`
/// or `offcut.dart` — it only knows `LabelData`. If this file ever
/// imports Board or Offcut directly, that's a sign the domain
/// boundary from Krok 7.3's design has been violated.
class PdfLabelGenerator implements LabelGenerator {
  @override
  Future<Uint8List> generate(List<LabelData> labels, LabelLayout layout) async {
    final doc = pw.Document();
    final pageFormat = PdfPageFormat(
      layout.sheetWidthMm * PdfPageFormat.mm,
      layout.sheetHeightMm * PdfPageFormat.mm,
    );

    // Paginate: layout.labelsPerSheet labels per page. Printing one
    // board, a whole rack, or a whole warehouse is the same loop —
    // only the length of [labels] differs.
    for (var offset = 0; offset < labels.length; offset += layout.labelsPerSheet) {
      final pageLabels = labels.skip(offset).take(layout.labelsPerSheet).toList();

      doc.addPage(
        pw.Page(
          pageFormat: pageFormat,
          build: (context) => pw.GridView(
            crossAxisCount: layout.columns,
            childAspectRatio: 1.3,
            children: pageLabels.map(_buildLabel).toList(),
          ),
        ),
      );
    }

    return doc.save();
  }

  pw.Widget _buildLabel(LabelData label) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
      child: pw.Row(
        children: [
          pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: label.qrCode,
            width: 50,
            height: 50,
          ),
          pw.SizedBox(width: 6),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(label.title,
                    style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                if (label.subtitle.isNotEmpty)
                  pw.Text(label.subtitle, style: const pw.TextStyle(fontSize: 8)),
                pw.Text(label.dimensions, style: const pw.TextStyle(fontSize: 8)),
                if (label.location != null)
                  pw.Text(label.location!, style: const pw.TextStyle(fontSize: 7)),
                pw.Text(label.status, style: const pw.TextStyle(fontSize: 7)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
