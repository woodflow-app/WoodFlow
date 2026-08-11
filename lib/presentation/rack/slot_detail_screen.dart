import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/board.dart';
import '../../domain/entities/decor.dart';
import '../../domain/entities/label_data.dart';
import '../../domain/entities/label_layout.dart';
import '../../domain/entities/offcut.dart';
import '../../domain/entities/rack.dart';
import '../../domain/entities/slot.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/repositories/board_repository.dart';
import '../../domain/repositories/decor_repository.dart';
import '../../domain/repositories/offcut_repository.dart';
import '../../domain/repositories/rack_repository.dart';
import '../../domain/repositories/slot_repository.dart';
import '../../domain/repositories/warehouse_repository.dart';
import '../../domain/services/label_data_builder.dart';
import '../../domain/services/label_generator.dart';
import '../../l10n/app_localizations.dart';
import '../board/board_detail_screen.dart';
import '../offcut/offcut_detail_screen.dart';

class SlotDetailScreen extends StatefulWidget {
  final String slotId;
  final String rackName;
  const SlotDetailScreen({super.key, required this.slotId, required this.rackName});

  @override
  State<SlotDetailScreen> createState() => _SlotDetailScreenState();
}

class _SlotDetailScreenState extends State<SlotDetailScreen> {
  final SlotRepository _slots = sl<SlotRepository>();
  final BoardRepository _boards = sl<BoardRepository>();
  final OffcutRepository _offcuts = sl<OffcutRepository>();
  final DecorRepository _decors = sl<DecorRepository>();
  final RackRepository _racks = sl<RackRepository>();
  final WarehouseRepository _warehouses = sl<WarehouseRepository>();
  final LabelGenerator _labelGenerator = sl<LabelGenerator>();

  Slot? _slot;
  List<Board> _boardsInSlot = [];
  List<Offcut> _offcutsInSlot = [];
  List<Decor> _allDecors = [];
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
    final slotResult = await _slots.getById(widget.slotId);
    if (slotResult.isFailure) {
      setState(() {
        _error = slotResult.failure.message;
        _isLoading = false;
      });
      return;
    }
    final boardsResult = await _boards.getBySlot(widget.slotId);
    final offcutsResult = await _offcuts.getBySlot(widget.slotId);
    final decorsResult = await _decors.getAll();
    setState(() {
      _slot = slotResult.data;
      _boardsInSlot = boardsResult.isSuccess ? boardsResult.data : [];
      _offcutsInSlot = offcutsResult.isSuccess ? offcutsResult.data : [];
      _allDecors = decorsResult.isSuccess ? decorsResult.data : [];
      _isLoading = false;
    });
  }

  /// Small catalog — simple in-memory lookup by id is fine, no need
  /// for a join query just to render a label.
  Decor? _decorFor(String decorId) {
    for (final d in _allDecors) {
      if (d.id == decorId) return d;
    }
    return null;
  }

  int get _totalItems => _boardsInSlot.length + _offcutsInSlot.length;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.rackName} · ${_slot?.name ?? ''}'),
        actions: [
          if (!_isLoading && _error == null && _totalItems > 0)
            IconButton(
              icon: const Icon(Icons.print_outlined),
              tooltip: l10n.printLabelsForSlot,
              onPressed: _printLabelsForSlot,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(l10n.errorPrefix(_error!)))
              : _buildBody(_slot!, l10n),
      floatingActionButton: _isLoading || _error != null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openAddBoardDialog(l10n),
              icon: const Icon(Icons.add),
              label: Text(l10n.newBoardTitle),
            ),
    );
  }

  Widget _buildBody(Slot slot, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(l10n.capacityLabel),
            trailing: Text(l10n.slotFillCount(_totalItems, slot.capacity)),
          ),
          const Divider(),
          Expanded(
            child: (_boardsInSlot.isEmpty && _offcutsInSlot.isEmpty)
                ? Center(
                    child: Text(l10n.noItemsInSlot,
                        style: const TextStyle(color: Colors.grey)),
                  )
                : ListView(
                    children: [
                      if (_boardsInSlot.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(l10n.boardsSectionLabel,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ),
                      ..._boardsInSlot.map((board) {
                        final decor = _decorFor(board.decorId);
                        return ListTile(
                          leading: const Icon(Icons.crop_landscape_outlined),
                          title: Text(decor != null ? '${decor.code} — ${decor.name}' : board.decorId),
                          subtitle: Text(
                              '${board.length.toInt()}×${board.width.toInt()}×${board.thickness.toInt()} mm'),
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => BoardDetailScreen(boardId: board.id),
                            ));
                            _load();
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.content_cut, size: 20),
                            tooltip: l10n.cutOffcut,
                            onPressed: () => _openCutDialog(board, l10n),
                          ),
                        );
                      }),
                      if (_offcutsInSlot.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(l10n.offcutsSectionLabel,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ),
                      ..._offcutsInSlot.map((offcut) {
                        final decor = _decorFor(offcut.decorId);
                        return ListTile(
                          leading: const Icon(Icons.content_cut, size: 20),
                          title: Text(decor != null ? '${decor.code} — ${decor.name}' : offcut.decorId),
                          subtitle: Text(
                              '${offcut.length.toInt()}×${offcut.width.toInt()}×${offcut.thickness.toInt()} mm · ${offcut.parentBoardId.substring(0, 8)}…'),
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => OffcutDetailScreen(offcutId: offcut.id),
                            ));
                            _load();
                          },
                        );
                      }),
                    ],
                  ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: Text(l10n.deleteSlotButton, style: const TextStyle(color: Colors.red)),
            onPressed: () => _confirmDelete(slot, l10n),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddBoardDialog(AppLocalizations l10n) async {
    if (_allDecors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noDecorsInCatalog)),
      );
      return;
    }

    Decor selectedDecor = _allDecors.first;
    final lengthController = TextEditingController();
    final widthController = TextEditingController();
    final thicknessController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(l10n.newBoardTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Decor>(
                  initialValue: selectedDecor,
                  decoration: InputDecoration(labelText: l10n.decorLabel),
                  items: _allDecors
                      .map((d) => DropdownMenuItem(
                            value: d,
                            child: Text('${d.code} — ${d.name}'),
                          ))
                      .toList(),
                  onChanged: (d) {
                    if (d != null) setDialogState(() => selectedDecor = d);
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: lengthController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: l10n.lengthMm),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: widthController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: l10n.widthMm),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: thicknessController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: l10n.thicknessMm),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel)),
            FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.addBoard)),
          ],
        ),
      ),
    );
    if (confirmed != true) return;

    final length = double.tryParse(lengthController.text);
    final width = double.tryParse(widthController.text);
    final thickness = double.tryParse(thicknessController.text);
    if (length == null || width == null || thickness == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.fillDimensionsCorrectly)),
        );
      }
      return;
    }

    final result = await _boards.create(
      slotId: widget.slotId,
      decorId: selectedDecor.id,
      length: length,
      width: width,
      thickness: thickness,
    );
    result.when(
      success: (_) => _load(),
      failure: (f) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(f.message)));
        }
      },
    );
  }

  /// "Wytnij ścinek" — creates an Offcut from this Board, staying in
  /// the same slot by default. Deliberately does NOT resize/touch
  /// the Board — that's the Cut Optimizer's job (later, separate
  /// v2.0/PRO feature), not this simple entity-creation step.
  Future<void> _openCutDialog(Board board, AppLocalizations l10n) async {
    final lengthController = TextEditingController();
    final widthController = TextEditingController();
    final thicknessController = TextEditingController(text: board.thickness.toString());

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.cutOffcut),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.cutFromBoardNote(_decorFor(board.decorId)?.code ?? board.decorId),
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: lengthController,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: InputDecoration(labelText: l10n.lengthMm),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: widthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.widthMm),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: thicknessController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: l10n.thicknessMm),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.cut)),
        ],
      ),
    );
    if (confirmed != true) return;

    final length = double.tryParse(lengthController.text);
    final width = double.tryParse(widthController.text);
    final thickness = double.tryParse(thicknessController.text);
    if (length == null || width == null || thickness == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.fillDimensionsCorrectly)),
        );
      }
      return;
    }

    final result = await _offcuts.cutFromBoard(
      parentBoardId: board.id,
      slotId: widget.slotId,
      length: length,
      width: width,
      thickness: thickness,
    );
    result.when(
      success: (_) => _load(),
      failure: (f) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(f.message)));
        }
      },
    );
  }

  Future<void> _confirmDelete(Slot slot, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteSlotQuestion),
        content: Text(l10n.deleteSlotWarning),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel)),
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.delete, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true) return;

    final result = await _slots.delete(slot.id);
    result.when(
      success: (_) {
        if (mounted) Navigator.of(context).pop();
      },
      failure: (f) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(f.message)));
        }
      },
    );
  }

  /// Krok 7.3 — builds `List<LabelData>` for everything in this slot
  /// (boards AND offcuts together) and hands it to `LabelGenerator`.
  /// Printing one item, this whole slot, or — later — a whole rack/
  /// warehouse is the exact same call with a longer list; nothing
  /// here changes when that future screen gets built.
  Future<void> _printLabelsForSlot() async {
    final l10n = AppLocalizations.of(context)!;

    // Location breadcrumb is the same for every item in this slot —
    // resolved once, not per-label.
    String? breadcrumb;
    final rackResult = await _racks.getById(_slot!.rackId);
    if (rackResult.isSuccess) {
      final Rack rack = rackResult.data;
      final warehouseResult = await _warehouses.getById(rack.warehouseId);
      if (warehouseResult.isSuccess) {
        final Warehouse warehouse = warehouseResult.data;
        breadcrumb = '${warehouse.name} > ${rack.name} > ${_slot!.name}';
      }
    }

    final labels = <LabelData>[
      ..._boardsInSlot.map((board) => LabelDataBuilder.fromBoard(
            board: board,
            decor: _decorFor(board.decorId),
            locationBreadcrumb: breadcrumb,
            statusText: board.status == BoardStatus.archived
                ? l10n.statusArchived
                : l10n.statusInStock,
          )),
      ..._offcutsInSlot.map((offcut) => LabelDataBuilder.fromOffcut(
            offcut: offcut,
            decor: _decorFor(offcut.decorId),
            locationBreadcrumb: breadcrumb,
            statusText: offcut.status == OffcutStatus.archived
                ? l10n.statusArchived
                : l10n.statusAvailable,
          )),
    ];

    final bytes = await _labelGenerator.generate(labels, LabelLayout.a4Grid3x8);

    if (!mounted) return;
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }
}
