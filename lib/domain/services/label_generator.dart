import 'dart:typed_data';

import '../entities/label_data.dart';
import '../entities/label_layout.dart';

/// The contract every label output format implements.
/// `PdfLabelGenerator` is the only implementation today; a future
/// `ZebraLabelGenerator`/`PngLabelGenerator`/`SvgLabelGenerator` adds
/// a new file implementing THIS interface — nothing above it
/// (UI, domain) changes.
///
/// Takes `List<LabelData>` from the very first version, never a
/// single `LabelData` — printing one board, a whole rack, or a whole
/// warehouse's worth of labels is the same mechanism, just a longer
/// list. Retrofitting "print many" onto a single-item API later is
/// exactly the kind of rework this avoids.
abstract class LabelGenerator {
  /// Returns the raw output bytes (a PDF file's bytes today). The
  /// caller decides what to do with them (save, share, print) — this
  /// layer only produces the document.
  Future<Uint8List> generate(List<LabelData> labels, LabelLayout layout);
}
