import 'package:flutter/material.dart';

import 'dart:convert';

import '../../core/services/service_locator.dart';
import '../../domain/entities/decor.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/entities/offcut.dart';
import '../../domain/entities/rack.dart';
import '../../domain/entities/slot.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/repositories/decor_repository.dart';
import '../../domain/repositories/offcut_repository.dart';
import '../../domain/repositories/rack_repository.dart';
import '../../domain/repositories/slot_repository.dart';
import '../../domain/repositories/warehouse_repository.dart';
import '../../domain/services/ledger_entry_formatter.dart';
import '../../l10n/app_localizations.dart';
import '../board/board_detail_screen.dart';
import '../calculators/calculators_screen.dart';

/// Reached two ways, same as BoardDetailScreen: normal navigation,
/// or as a `WF-O-...` QR-scan destination (Krok 7.2).
///
/// NOTE: unlike Board, Offcut has no `getFullLocation()` of its own
/// yet — resolving the breadcrumb here is a manual 3-step chain
/// (Slot → Rack → Warehouse). Adding a dedicated method to
/// OffcutRepository is a one-file change if this screen turns out
/// to need it in more than one place — not done speculatively now.
///
/// TODO(YAGNI): jeśli drugi ekran będzie potrzebował breadcrumb dla
/// Offcut, przenieść tę logikę do OffcutRepository.getFullLocation()
/// (kopia wzorca z BoardRepository). Do tego czasu jedno miejsce
/// użycia nie uzasadnia tej abstrakcji.
class OffcutDetailScreen extends StatefulWidget {
  final String offcutId;
  const OffcutDetailScreen({super.key, required this.offcutId});

  @override
  State<OffcutDetailScreen> createState() => _OffcutDetailScreenState();
}

class _OffcutDetailScreenState extends State<OffcutDetailScreen> {
  final OffcutRepository _offcuts = sl<OffcutRepository>();
  final DecorRepository _decors = sl<DecorRepository>();
  final SlotRepository _slots = sl<SlotRepository>();
  final RackRepository _racks = sl<RackRepository>();
  final WarehouseRepository _warehouses = sl<WarehouseRepository>();

  Offcut? _offcut;
  Decor? _decor;
  String? _breadcrumb;
  List<LedgerEntry> _ledger = [];
  Map<String, String> _slotNames = {};
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final offcutResult = await _offcuts.getById(widget.offcutId);
    if (offcutResult.isFailure) {
      setState(() {
        _error = offcutResult.failure.message;
        _isLoading = false;
      });
      return;
    }

    final offcut = offcutResult.data;
    final decorResult = await _decors.getById(offcut.decorId);
    final ledgerResult = await _offcuts.getLedgerForOffcut(offcut.id);
    final ledger = ledgerResult.isSuccess ? ledgerResult.data : <LedgerEntry>[];
    final breadcrumb = await _resolveBreadcrumb(offcut.slotId);
    final slotNames = await _resolveSlotNamesForLedger(ledger);

    setState(() {
      _offcut = offcut;
      _decor = decorResult.isSuccess ? decorResult.data : null;
      _ledger = ledger;
      _breadcrumb = breadcrumb;
      _slotNames = slotNames;
      _isLoading = false;
    });
  }

  Future<String?> _resolveBreadcrumb(String slotId) async {
    final slotResult = await _slots.getById(slotId);
    if (slotResult.isFailure) return null;
    final Slot slot = slotResult.data;

    final rackResult = await _racks.getById(slot.rackId);
    if (rackResult.isFailure) return null;
    final Rack rack = rackResult.data;

    final warehouseResult = await _warehouses.getById(rack.warehouseId);
    if (warehouseResult.isFailure) return null;
    final Warehouse warehouse = warehouseResult.data;

    return '${warehouse.name} > ${rack.name} > ${slot.name}';
  }

  /// Same batched pattern as BoardDetailScreen — one lookup per
  /// unique slot id across the whole ledger, not per entry.
  Future<Map<String, String>> _resolveSlotNamesForLedger(List<LedgerEntry> ledger) async {
    final ids = <String>{};
    for (final entry in ledger) {
      try {
        final payload = jsonDecode(entry.payloadJson) as Map<String, dynamic>;
        for (final key in ['fromSlotId', 'toSlotId', 'slotId']) {
          final id = payload[key];
          if (id is String) ids.add(id);
        }
      } catch (_) {
        // malformed/empty payload — nothing to resolve for this entry
      }
    }

    final names = <String, String>{};
    for (final id in ids) {
      final result = await _slots.getById(id);
      if (result.isSuccess) names[id] = result.data.name;
    }
    return names;
  }

  Map<String, String> _eventLabels(AppLocalizations l10n) => {
        'created': l10n.eventCreated,
        'moved': l10n.eventMoved,
        'archived': l10n.eventArchived,
        'cut': l10n.eventCut,
        'qrRegenerated': l10n.eventQrRegenerated,
      };

  String _statusText(AppLocalizations l10n, OffcutStatus status) => switch (status) {
        OffcutStatus.available => l10n.statusAvailable,
        OffcutStatus.archived => l10n.statusArchived,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.offcutTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate_outlined),
            tooltip: l10n.calculatorsTitle,
            onPressed: _offcut == null ? null : () => _openCalculators(_offcut!),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(l10n.errorPrefix(_error!)))
              : _buildBody(_offcut!, l10n),
    );
  }

  Widget _buildBody(Offcut offcut, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.qr_code_2, size: 96),
                  const SizedBox(height: 6),
                  SelectableText(offcut.qrCode,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _decor != null ? '${_decor!.code} — ${_decor!.name}' : offcut.decorId,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            '${offcut.length.toInt()} × ${offcut.width.toInt()} × ${offcut.thickness.toInt()} mm',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          if (_breadcrumb != null)
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(_breadcrumb!),
              dense: true,
            ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.statusLabel(_statusText(l10n, offcut.status))),
            dense: true,
          ),
          TextButton.icon(
            icon: const Icon(Icons.crop_square, size: 18),
            label: Text(l10n.viewSourceBoard),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BoardDetailScreen(boardId: offcut.parentBoardId),
              ));
            },
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.archive_outlined),
                  label: Text(l10n.archive),
                  onPressed: offcut.status == OffcutStatus.archived
                      ? null
                      : () => _confirmArchive(offcut, l10n),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l10n.historyLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (_ledger.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(l10n.noEntries, style: const TextStyle(color: Colors.grey)),
            )
          else
            ..._ledger.map((entry) {
              final description = LedgerEntryFormatter.format(
                entry,
                eventLabels: _eventLabels(l10n),
                slotNames: _slotNames,
              );
              return ListTile(
                dense: true,
                leading: Icon(_iconForEvent(entry.eventType)),
                title: Text(description.title),
                subtitle: description.detail != null ? Text(description.detail!) : null,
                trailing: Text(_formatDate(entry.occurredAt)),
              );
            }),
        ],
      ),
    );
  }

  IconData _iconForEvent(String eventType) => switch (eventType) {
        'cut' => Icons.content_cut,
        'moved' => Icons.swap_horiz,
        'archived' => Icons.archive_outlined,
        'qrRegenerated' => Icons.qr_code,
        _ => Icons.circle_outlined,
      };

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  void _openCalculators(Offcut offcut) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CalculatorsScreen(
        initialLengthMm: offcut.length,
        initialWidthMm: offcut.width,
        initialThicknessMm: offcut.thickness,
      ),
    ));
  }

  Future<void> _confirmArchive(Offcut offcut, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.archiveOffcutQuestion),
        content: Text(l10n.historyStaysVisible),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel)),
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.archive)),
        ],
      ),
    );
    if (confirmed != true) return;

    final result = await _offcuts.archive(offcut.id);
    result.when(
      success: (_) => _load(),
      failure: (f) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.message)));
        }
      },
    );
  }
}
