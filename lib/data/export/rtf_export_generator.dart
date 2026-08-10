import 'dart:convert';
import 'dart:typed_data';

import '../../domain/entities/export_row.dart';
import '../../domain/services/export_generator.dart';

/// One of three `ExportGenerator` implementations (Krok 10). Hand-
/// written RTF markup — no maintained RTF-writer package exists on
/// pub.dev, and the format itself is simple enough (plain-text markup,
/// no binary structure) that pulling in a dependency for it would add
/// more risk than it removes.
///
/// Every non-ASCII character is escaped as an RTF `\uN?` sequence
/// (signed UTF-16 code unit + ASCII fallback) rather than relying on
/// a Windows codepage — WoodFlow ships in 21 languages including
/// Cyrillic (`ru`), so a single fixed codepage (e.g. cp1250) can't
/// represent all of them, but `\uN` is codepage-independent and every
/// RTF reader (Word, LibreOffice, WordPad) supports it.
class RtfExportGenerator implements ExportGenerator {
  static const _pageWidthTwips = 9000;

  @override
  Future<Uint8List> generate({
    required String title,
    required List<ExportRow> rows,
  }) async {
    final headers = rows.isEmpty ? const <String>[] : rows.first.cells.keys.toList();
    final columnCount = headers.isEmpty ? 1 : headers.length;
    final columnWidth = _pageWidthTwips ~/ columnCount;

    final buffer = StringBuffer()
      ..write(r'{\rtf1\ansi\ansicpg1252\deff0')
      ..write(r'{\fonttbl{\f0\fswiss Helvetica;}}')
      ..write(r'\f0\fs28\b ')
      ..write(_escape(title))
      ..write(r'\b0\par\par');

    if (headers.isNotEmpty) {
      buffer.write(_row(headers, columnWidth, columnCount, bold: true));
      for (final row in rows) {
        buffer.write(_row(row.cells.values.toList(), columnWidth, columnCount, bold: false));
      }
    }

    buffer.write('}');

    // Every character in [buffer] is plain ASCII by construction —
    // _escape() converts anything else to a \uN? sequence. ascii.encode
    // both confirms that invariant (throws if violated) and produces
    // the exact bytes an RTF reader expects.
    return Uint8List.fromList(ascii.encode(buffer.toString()));
  }

  String _row(List<String> cells, int columnWidth, int columnCount, {required bool bold}) {
    final buffer = StringBuffer()..write(r'\trowd\trgaph70\trleft0');

    var x = 0;
    for (var i = 0; i < columnCount; i++) {
      x += columnWidth;
      buffer.write('\\cellx$x');
    }

    for (var i = 0; i < columnCount; i++) {
      final value = i < cells.length ? cells[i] : '';
      buffer.write(r'\intbl ');
      if (bold) buffer.write(r'\b ');
      buffer.write(_escape(value));
      if (bold) buffer.write(r'\b0');
      buffer.write(r'\cell');
    }

    buffer.write(r'\row');
    return buffer.toString();
  }

  String _escape(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      switch (rune) {
        case 0x5C: // \
          buffer.write(r'\\');
        case 0x7B: // {
          buffer.write(r'\{');
        case 0x7D: // }
          buffer.write(r'\}');
        case 0x0A: // \n
          buffer.write(r'\line ');
        default:
          if (rune >= 0x20 && rune <= 0x7E) {
            buffer.writeCharCode(rune);
          } else if (rune > 0xFFFF) {
            // Outside the Basic Multilingual Plane (e.g. emoji) —
            // RTF's \uN encodes one UTF-16 code UNIT, not one code
            // point, so this has to split into a surrogate pair and
            // emit each half as its own \uN, exactly like a UTF-16
            // string would represent it.
            final adjusted = rune - 0x10000;
            buffer.write('\\u${_signed16(0xD800 + (adjusted >> 10))}?');
            buffer.write('\\u${_signed16(0xDC00 + (adjusted & 0x3FF))}?');
          } else {
            buffer.write('\\u${_signed16(rune)}?');
          }
      }
    }
    return buffer.toString();
  }

  /// RTF \uN expects a SIGNED 16-bit value.
  int _signed16(int value) => value > 0x7FFF ? value - 0x10000 : value;
}
