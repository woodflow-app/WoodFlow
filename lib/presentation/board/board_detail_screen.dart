import 'package:flutter/material.dart';

import 'dart:convert';

import '../../core/services/service_locator.dart';
import '../../domain/entities/board.dart';
import '../../domain/entities/board_location.dart';
import '../../domain/entities/decor.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/entities/slot.dart';
import '../../domain/repositories/board_repository.dart';
import '../../domain/repositories/decor_repository.dart';
import '../../domain/repositories/slot_repository.dart';
import '../../domain/services/ledger_entry_formatter.dart';
import '../../l10n/app_localizations.dart';

/// Reached two ways: normal navigation from a slot's board list, OR
/// as a QR-scan destination (Krok 7.2) — `QrResolver` resolves
/// `WF-B-...` codes straight here. Either path lands on the exact
/// same screen; the entity doesn't know or care how it was reached.
class BoardDetailScreen extends StatefulWidget {
  final String boardId;
  const BoardDetailScreen({super.key, required this.boardId});

  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}

class _BoardDetailScreenState extends State<BoardDetailScreen> {
  final BoardRepository _boards = sl<BoardRepository>();
  final DecorRepository _decors = sl<DecorRepository>();
  final SlotRepository _slots = sl<SlotRepository>();

  Board? _board;
  Decor? _decor;
  BoardLocation? _location;
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

    final boardResult = await _boards.getById(widget.boardId);
    if (boardResult.isFailure) {
      setState(() {
        _error = boardResult.failure.message;
        _isLoading = false;
      });
      return;
    }

    final board = boardResult.data;
    final decorResult = await _decors.getById(board.decorId);
    final locationResult = await _boards.getFullLocation(board.id);
    final ledgerResult = await _boards.getLedgerForBoard(board.id);
    final ledger = ledgerResult.isSuccess ? ledgerResult.data : <LedgerEntry>[];
    final slotNames = await _resolveSlotNamesForLedger(ledger);

    setState(() {
      _board = board;
      _decor = decorResult.isSuccess ? decorResult.data : null;
      _location = locationResult.isSuccess ? locationResult.data : null;
      _ledger = ledger;
      _slotNames = slotNames;
      _isLoading = false;
    });
  }

  /// Batched — one lookup per UNIQUE slot id across the whole ledger,
  /// not one query per entry. Krok 8's whole point is reading the
  /// `fromSlotId`/`toSlotId`/`slotId` that were always being stored
  /// in the payload; this is where that finally gets used.
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

  String _statusText(AppLocalizations l10n, BoardStatus status) => switch (status) {
        BoardStatus.inStock => l10n.statusInStock,
        BoardStatus.archived => l10n.statusArchived,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.boardTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(l10n.errorPrefix(_error!)))
              : _buildBody(_board!, l10n),
    );
  }

  Widget _buildBody(Board board, AppLocalizations l10n) {
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
                  SelectableText(board.qrCode,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _decor != null ? '${_decor!.code} — ${_decor!.name}' : board.decorId,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            '${board.length.toInt()} × ${board.width.toInt()} × ${board.thickness.toInt()} mm',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          if (_location != null)
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(_location!.breadcrumb),
              dense: true,
            ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.statusLabel(_statusText(l10n, board.status))),
            dense: true,
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.swap_horiz),
                  label: Text(l10n.move),
                  onPressed: _location == null ? null : () => _openMoveDialog(board, l10n),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.archive_outlined),
                  label: Text(l10n.archive),
                  onPressed: board.status == BoardStatus.archived
                      ? null
                      : () => _confirmArchive(board, l10n),
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
        'created' => Icons.add_circle_outline,
        'moved' => Icons.swap_horiz,
        'archived' => Icons.archive_outlined,
        'qrRegenerated' => Icons.qr_code,
        _ => Icons.circle_outlined,
      };

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Future<void> _openMoveDialog(Board board, AppLocalizations l10n) async {
    // Minimal slot picker: all slots in the same rack as the current
    // one. Cross-rack/cross-warehouse moves are just as valid (the
    // model has no restriction), but a full picker across every
    // warehouse→rack→slot is a UI-scope decision for later, not this
    // screen's job to invent right now.
    final slotsResult = await _slots.getByRack(_location!.rackId);
    if (!mounted || slotsResult.isFailure) return;
    final others = slotsResult.data.where((s) => s.id != board.slotId).toList();
    if (others.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noOtherSlotInRack)),
      );
      return;
    }

    final Slot? target = await showDialog<Slot>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(l10n.moveToLabel),
        children: others
            .map((s) => SimpleDialogOption(
                  onPressed: () => Navigator.of(dialogContext).pop(s),
                  child: Text(s.name),
                ))
            .toList(),
      ),
    );
    if (target == null) return;

    final result = await _boards.moveBoard(boardId: board.id, toSlotId: target.id);
    result.when(
      success: (_) => _load(),
      failure: (f) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.message)));
        }
      },
    );
  }

  Future<void> _confirmArchive(Board board, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.archiveBoardQuestion),
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

    final result = await _boards.archive(board.id);
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
