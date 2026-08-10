import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/board.dart';
import '../../domain/entities/export_row.dart';
import '../../domain/entities/offcut.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/repositories/board_repository.dart';
import '../../domain/repositories/decor_repository.dart';
import '../../domain/repositories/offcut_repository.dart';
import '../../domain/repositories/rack_repository.dart';
import '../../domain/repositories/slot_repository.dart';
import '../../domain/repositories/warehouse_repository.dart';
import '../../domain/services/export_data_builder.dart';
import '../../domain/services/export_generator.dart';
import '../../l10n/app_localizations.dart';

/// Krok 10 — lets the user export a warehouse's full Board+Offcut
/// inventory (with resolved location/decor/status) as PDF, CSV, or
/// RTF, then hands the file to the platform share sheet.
///
/// Deliberately plain Material widgets, same reasoning as
/// `WarehouseListScreen`: prove the architecture (ExportRow →
/// ExportGenerator → ExportScreen) end-to-end first, restyle once
/// WoodFlow Design Tokens exist.
class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  final WarehouseRepository _warehouses = sl<WarehouseRepository>();
  final RackRepository _racks = sl<RackRepository>();
  final SlotRepository _slots = sl<SlotRepository>();
  final BoardRepository _boards = sl<BoardRepository>();
  final OffcutRepository _offcuts = sl<OffcutRepository>();
  final DecorRepository _decors = sl<DecorRepository>();

  List<Warehouse> _warehouseList = [];
  bool _isLoadingWarehouses = true;
  String? _loadErrorMessage;

  String? _selectedWarehouseId;
  ExportFormat _selectedFormat = ExportFormat.pdf;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadWarehouses();
  }

  Future<void> _loadWarehouses() async {
    setState(() {
      _isLoadingWarehouses = true;
      _loadErrorMessage = null;
    });

    final result = await _warehouses.getAll();
    if (!mounted) return;
    result.when(
      success: (warehouses) => setState(() {
        _warehouseList = warehouses;
        _selectedWarehouseId = warehouses.isEmpty ? null : warehouses.first.id;
        _isLoadingWarehouses = false;
      }),
      failure: (f) => setState(() {
        _loadErrorMessage = f.message;
        _isLoadingWarehouses = false;
      }),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  ExportGenerator _generatorFor(ExportFormat format) {
    return sl<ExportGenerator>(instanceName: 'export_${format.name}');
  }

  String _mimeTypeFor(ExportFormat format) {
    switch (format) {
      case ExportFormat.pdf:
        return 'application/pdf';
      case ExportFormat.csv:
        return 'text/csv';
      case ExportFormat.rtf:
        return 'application/rtf';
    }
  }

  String _sanitizedFileName(String warehouseName) {
    final safe = warehouseName.replaceAll(RegExp(r'[^A-Za-z0-9_-]+'), '_');
    return safe.isEmpty ? 'warehouse' : safe;
  }

  Future<void> _export() async {
    final warehouseId = _selectedWarehouseId;
    if (warehouseId == null) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isExporting = true);
    try {
      // Looked up inside the try — if the selected warehouse was
      // deleted elsewhere while this screen was open, firstWhere's
      // StateError is caught below like any other export failure,
      // not left to propagate as an unhandled exception.
      final warehouse = _warehouseList.firstWhere((w) => w.id == warehouseId);

      final racksResult = await _racks.getByWarehouse(warehouseId);
      final boardsResult = await _boards.getByWarehouse(warehouseId);
      final offcutsResult = await _offcuts.getByWarehouse(warehouseId);
      final decorsResult = await _decors.getAll();

      if (!mounted) return;

      for (final result in [racksResult, boardsResult, offcutsResult, decorsResult]) {
        if (result.isFailure) {
          _showMessage(l10n.errorPrefix(result.failure.message));
          return;
        }
      }

      final racks = racksResult.data;
      final boards = boardsResult.data;
      final offcuts = offcutsResult.data;
      final decorById = {for (final d in decorsResult.data) d.id: d};

      if (boards.isEmpty && offcuts.isEmpty) {
        _showMessage(l10n.exportEmptyWarehouse);
        return;
      }

      // Location breadcrumb resolved once per slot (batched: one
      // getByRack call per rack), not once per board/offcut — same
      // N+1 avoidance as LedgerEntryFormatter's slotNames lookup.
      final slotBreadcrumbs = <String, String>{};
      for (final rack in racks) {
        final slotsResult = await _slots.getByRack(rack.id);
        if (slotsResult.isFailure) continue;
        for (final slot in slotsResult.data) {
          slotBreadcrumbs[slot.id] = '${warehouse.name} > ${rack.name} > ${slot.name}';
        }
      }

      final labels = ExportColumnLabels(
        type: l10n.exportColumnType,
        qrCode: l10n.exportColumnQrCode,
        decorCode: l10n.exportColumnDecorCode,
        decorName: l10n.exportColumnDecorName,
        length: l10n.lengthMm,
        width: l10n.widthMm,
        thickness: l10n.thicknessMm,
        location: l10n.exportColumnLocation,
        status: l10n.exportColumnStatus,
        createdAt: l10n.exportColumnCreatedAt,
      );

      final rows = <ExportRow>[
        for (final board in boards)
          ExportDataBuilder.fromBoard(
            board: board,
            decor: decorById[board.decorId],
            locationBreadcrumb: slotBreadcrumbs[board.slotId],
            statusText:
                board.status == BoardStatus.archived ? l10n.statusArchived : l10n.statusInStock,
            typeLabel: l10n.boardTitle,
            labels: labels,
          ),
        for (final offcut in offcuts)
          ExportDataBuilder.fromOffcut(
            offcut: offcut,
            decor: decorById[offcut.decorId],
            locationBreadcrumb: slotBreadcrumbs[offcut.slotId],
            statusText:
                offcut.status == OffcutStatus.archived ? l10n.statusArchived : l10n.statusAvailable,
            typeLabel: l10n.offcutTitle,
            labels: labels,
          ),
      ];

      final title = '${l10n.exportTitle} — ${warehouse.name}';
      final bytes = await _generatorFor(_selectedFormat).generate(title: title, rows: rows);

      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              name: '${_sanitizedFileName(warehouse.name)}.${_selectedFormat.fileExtension}',
              mimeType: _mimeTypeFor(_selectedFormat),
            ),
          ],
          subject: title,
        ),
      );
    } catch (e) {
      if (mounted) _showMessage(l10n.exportFailedMessage(e.toString()));
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.exportTitle)),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoadingWarehouses) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadErrorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.errorPrefix(_loadErrorMessage!)),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _loadWarehouses, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }

    if (_warehouseList.isEmpty) {
      return Center(child: Text(l10n.noWarehousesYet));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedWarehouseId,
            decoration: InputDecoration(labelText: l10n.exportWarehouseLabel),
            items: _warehouseList
                .map((w) => DropdownMenuItem(value: w.id, child: Text(w.name)))
                .toList(),
            onChanged: (value) => setState(() => _selectedWarehouseId = value),
          ),
          const SizedBox(height: 24),
          SegmentedButton<ExportFormat>(
            segments: const [
              ButtonSegment(value: ExportFormat.pdf, label: Text('PDF')),
              ButtonSegment(value: ExportFormat.csv, label: Text('CSV')),
              ButtonSegment(value: ExportFormat.rtf, label: Text('RTF')),
            ],
            selected: {_selectedFormat},
            onSelectionChanged: (selection) => setState(() => _selectedFormat = selection.first),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isExporting || _selectedWarehouseId == null ? null : _export,
            child: _isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.exportButton),
          ),
        ],
      ),
    );
  }
}
