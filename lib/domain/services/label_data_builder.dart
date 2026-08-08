import '../entities/board.dart';
import '../entities/decor.dart';
import '../entities/label_data.dart';
import '../entities/offcut.dart';

/// Pure mapping functions — no repository access, no async, fully
/// testable without a database. The caller (a screen, which already
/// has `AppLocalizations` and has already fetched Decor/location via
/// the same repositories `BoardDetailScreen`/`OffcutDetailScreen`
/// already use) resolves everything first and passes it in here.
///
/// This keeps the domain/PDF boundary clean in both directions:
/// `LabelGenerator` doesn't know what a Board is, and this builder
/// doesn't know what a repository is.
class LabelDataBuilder {
  LabelDataBuilder._();

  static LabelData fromBoard({
    required Board board,
    required Decor? decor,
    required String? locationBreadcrumb,
    required String statusText,
  }) {
    return LabelData(
      qrCode: board.qrCode,
      title: decor?.code ?? board.decorId,
      subtitle: decor?.name ?? '',
      dimensions:
          '${board.length.toInt()}×${board.width.toInt()}×${board.thickness.toInt()} mm',
      location: locationBreadcrumb,
      status: statusText,
    );
  }

  static LabelData fromOffcut({
    required Offcut offcut,
    required Decor? decor,
    required String? locationBreadcrumb,
    required String statusText,
  }) {
    return LabelData(
      qrCode: offcut.qrCode,
      title: decor?.code ?? offcut.decorId,
      subtitle: decor?.name ?? '',
      dimensions:
          '${offcut.length.toInt()}×${offcut.width.toInt()}×${offcut.thickness.toInt()} mm',
      location: locationBreadcrumb,
      status: statusText,
    );
  }
}
