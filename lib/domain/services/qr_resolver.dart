import '../repositories/board_repository.dart';
import '../repositories/offcut_repository.dart';
import '../repositories/rack_repository.dart';
import '../repositories/slot_repository.dart';
import '../repositories/warehouse_repository.dart';
import 'qr_resolution.dart';

/// The ONLY place in the app that knows how to turn a scanned QR
/// string into "which screen to open". Every screen that scans a
/// code calls `QrResolver.resolve(code)` and switches on the result
/// — never `if (code.startsWith('WF-B'))` scattered across widgets.
///
/// Dispatches by the type letter embedded in the code
/// (`WF-{LETTER}-...`) directly to the matching repository's
/// `getByQrCode()` — no need to try all five repositories in turn.
class QrResolver {
  QrResolver(
    this._warehouses,
    this._racks,
    this._slots,
    this._boards,
    this._offcuts,
  );

  final WarehouseRepository _warehouses;
  final RackRepository _racks;
  final SlotRepository _slots;
  final BoardRepository _boards;
  final OffcutRepository _offcuts;

  static final _codePattern = RegExp(r'^WF-([A-Z])-[0-9A-F]{8}$');

  /// DECYZJA (dokumentowana i przetestowana, nie domyślne zachowanie
  /// przypadkiem): format WF-{TYP}-{hex} jest normalizowany do
  /// wielkich liter PRZED dopasowaniem i wyszukaniem — `wf-b-...`
  /// oraz `WF-b-...` rozwiążą się tak samo jak `WF-B-...`. Wszystkie
  /// kody zapisane w bazie są zawsze wielkimi literami (patrz
  /// qr_code_generator.dart), więc normalizacja tylko na wejściu do
  /// resolvera jest wystarczająca — nie trzeba zmieniać niczego w
  /// zapisie. Powód: skan kamerą powinien zawsze dać dokładnie to,
  /// co zakodowano, ale ręczne wpisanie kodu (przyszła funkcja) albo
  /// niestandardowy generator etykiety może dać inną wielkość liter
  /// — lepiej być wyrozumiałym na wejściu niż zmuszać użytkownika do
  /// precyzji, której QR i tak nigdy nie wymaga (zawsze skanowany,
  /// nigdy przepisywany ręcznie w normalnym użyciu). Patrz
  /// docs/QR_CODES.md.
  Future<QrResolution> resolve(String rawCode) async {
    final code = rawCode.trim().toUpperCase();
    final match = _codePattern.firstMatch(code);
    if (match == null) return const QrNotFound();

    final typeLetter = match.group(1);
    switch (typeLetter) {
      case 'W':
        final result = await _warehouses.getByQrCode(code);
        return result.when(
          success: (w) => WarehouseFound(w),
          failure: (_) => const QrNotFound(),
        );
      case 'R':
        final result = await _racks.getByQrCode(code);
        return result.when(
          success: (r) => RackFound(r),
          failure: (_) => const QrNotFound(),
        );
      case 'S':
        final result = await _slots.getByQrCode(code);
        return result.when(
          success: (s) => SlotFound(s),
          failure: (_) => const QrNotFound(),
        );
      case 'B':
        final result = await _boards.getByQrCode(code);
        return result.when(
          success: (b) => BoardFound(b),
          failure: (_) => const QrNotFound(),
        );
      case 'O':
        final result = await _offcuts.getByQrCode(code);
        return result.when(
          success: (o) => OffcutFound(o),
          failure: (_) => const QrNotFound(),
        );
      default:
        return const QrNotFound();
    }
  }
}
