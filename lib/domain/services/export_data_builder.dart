import '../entities/board.dart';
import '../entities/decor.dart';
import '../entities/export_row.dart';
import '../entities/offcut.dart';

/// The column labels for an inventory export, already localized by
/// the caller — same reasoning as `LabelData.status`: this builder
/// has no i18n dependency of its own, it only carries whatever text
/// it's given. Built once per export (in `ExportScreen`) from
/// `AppLocalizations`, then reused for every row so the label strings
/// aren't re-resolved per item.
///
/// This is what makes `ExportRow.cells` self-describing without every
/// `fromBoard`/`fromOffcut` call repeating ten header strings.
class ExportColumnLabels {
  final String type;
  final String qrCode;
  final String decorCode;
  final String decorName;
  final String length;
  final String width;
  final String thickness;
  final String location;
  final String status;
  final String createdAt;

  const ExportColumnLabels({
    required this.type,
    required this.qrCode,
    required this.decorCode,
    required this.decorName,
    required this.length,
    required this.width,
    required this.thickness,
    required this.location,
    required this.status,
    required this.createdAt,
  });
}

/// Pure mapping functions — no repository access, no async, fully
/// testable without a database. The caller (`ExportScreen`) resolves
/// Decor/location/status text first (the same repositories
/// `BoardDetailScreen`/`OffcutDetailScreen` already use) and passes it
/// in here, exactly like `LabelDataBuilder`.
///
/// This keeps the domain/export boundary clean in both directions:
/// `ExportGenerator` doesn't know what a Board is, and this builder
/// doesn't know what a PDF, CSV, or RTF file is.
class ExportDataBuilder {
  ExportDataBuilder._();

  static ExportRow fromBoard({
    required Board board,
    required Decor? decor,
    required String? locationBreadcrumb,
    required String statusText,
    required String typeLabel,
    required ExportColumnLabels labels,
  }) {
    return ExportRow({
      labels.type: typeLabel,
      labels.qrCode: board.qrCode,
      labels.decorCode: decor?.code ?? board.decorId,
      labels.decorName: decor?.name ?? '',
      labels.length: _mm(board.length),
      labels.width: _mm(board.width),
      labels.thickness: _mm(board.thickness),
      labels.location: locationBreadcrumb ?? '',
      labels.status: statusText,
      labels.createdAt: _isoDate(board.createdAt),
    });
  }

  static ExportRow fromOffcut({
    required Offcut offcut,
    required Decor? decor,
    required String? locationBreadcrumb,
    required String statusText,
    required String typeLabel,
    required ExportColumnLabels labels,
  }) {
    return ExportRow({
      labels.type: typeLabel,
      labels.qrCode: offcut.qrCode,
      labels.decorCode: decor?.code ?? offcut.decorId,
      labels.decorName: decor?.name ?? '',
      labels.length: _mm(offcut.length),
      labels.width: _mm(offcut.width),
      labels.thickness: _mm(offcut.thickness),
      labels.location: locationBreadcrumb ?? '',
      labels.status: statusText,
      labels.createdAt: _isoDate(offcut.createdAt),
    });
  }

  static String _mm(double value) => value.toInt().toString();

  static String _isoDate(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';
}
