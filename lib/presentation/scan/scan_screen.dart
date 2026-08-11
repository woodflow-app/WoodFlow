import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/services/service_locator.dart';
import '../../domain/repositories/rack_repository.dart';
import '../../domain/services/qr_resolution.dart';
import '../../domain/services/qr_resolver.dart';
import '../board/board_detail_screen.dart';
import '../offcut/offcut_detail_screen.dart';
import '../rack/rack_list_screen.dart';
import '../rack/slot_detail_screen.dart';
import '../rack/slot_grid_screen.dart';
import '../../l10n/app_localizations.dart';
import '../design_system/design_system.dart';

/// Krok 7.2. The ONLY place that knows how to turn a camera frame
/// into a navigation decision — it does this by asking QrResolver,
/// never by inspecting the code string itself. Works for all five
/// entity types without this widget knowing anything about their
/// internals beyond "here's a QrResolution, go to the matching
/// screen".
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final QrResolver _resolver = sl<QrResolver>();
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Explicit camera lifecycle (per review), not an implicit side
  /// effect of `pushReplacement`. The sequence is always: STOP the
  /// camera → resolve → navigate (or restart if not found). This
  /// makes the camera state independent of whatever navigation
  /// method a future screen change uses, and means only one frame
  /// is ever in flight — no separate `_isProcessing` flag needed,
  /// the stopped controller itself is the guard against duplicate
  /// detections.
  Future<void> _handleDetection(String rawCode) async {
    await _controller.stop();
    if (!mounted) return;

    final resolution = await _resolver.resolve(rawCode);
    if (!mounted) return;

    switch (resolution) {
      case WarehouseFound(:final warehouse):
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => RackListScreen(
            warehouseId: warehouse.id,
            warehouseName: warehouse.name,
          ),
        ));
      case RackFound(:final rack):
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => SlotGridScreen(rackId: rack.id, rackName: rack.name),
        ));
      case SlotFound(:final slot):
        // SlotDetailScreen wants a rackName for its title — Slot
        // itself doesn't carry one. Resolving it here (one extra
        // lookup) is simpler than adding a getFullLocation-style
        // method to SlotRepository for a single call site.
        final rackName = await _resolveRackName(slot.rackId);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => SlotDetailScreen(slotId: slot.id, rackName: rackName),
        ));
      case BoardFound(:final board):
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => BoardDetailScreen(boardId: board.id),
        ));
      case OffcutFound(:final offcut):
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => OffcutDetailScreen(offcutId: offcut.id),
        ));
      case QrNotFound():
        _showNotFound(); // restarts the camera itself, see below
    }
  }

  Future<String> _resolveRackName(String rackId) async {
    final racks = sl<RackRepository>();
    final result = await racks.getById(rackId);
    return result.isSuccess ? result.data.name : '?';
  }

  /// Per Piotr: never a bare "not found" — explain it's the code
  /// that's gone, not the scan that failed, and offer a way forward
  /// instead of a dead end. Also responsible for restarting the
  /// camera, since `_handleDetection` stopped it unconditionally
  /// before resolving.
  void _showNotFound() {
    final l10n = AppLocalizations.of(context)!;
    showWFBottomSheet(
      context,
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.qr_code_scanner, size: 40, color: Theme.of(sheetContext).colorScheme.onSurfaceVariant),
          const SizedBox(height: WFSpacing.sm),
          Text(
            l10n.qrCodeNotFound,
            style: Theme.of(sheetContext).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: WFSpacing.md),
          Row(
            children: [
              Expanded(
                child: WFButton(
                  label: l10n.scanAgain,
                  role: WFButtonRole.secondary,
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    _controller.start();
                  },
                ),
              ),
              const SizedBox(width: WFSpacing.sm),
              Expanded(
                child: WFButton(
                  label: l10n.searchManually,
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    // No dedicated manual-search screen exists yet
                    // (that's Smart Material Finder, v1.5/START) —
                    // popping back to wherever the user came from
                    // is the honest, working fallback for today.
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WFTopBar(title: AppLocalizations.of(context)!.scanQrCode),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          final barcodes = capture.barcodes;
          if (barcodes.isEmpty) return;
          final value = barcodes.first.rawValue;
          if (value == null) return;
          _handleDetection(value);
        },
      ),
    );
  }
}
