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
import '../../domain/usecases/delete_slot_use_case.dart';
import '../../l10n/app_localizations.dart';
import '../board/board_detail_screen.dart';
import '../design_system/design_system.dart';
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
  final DeleteSlotUseCase _deleteSlot = sl<DeleteSlotUseCase>();

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
      appBar: WFTopBar(
        title: '${widget.rackName} · ${_slot?.name ?? ''}',
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
          ? const WFLoadingState()
          : _error != null
              ? WFEmptyState(
                  icon: Icons.error_outline,
                  title: l10n.errorPrefix(_error!),
                  actionLabel: l10n.retry,
                  onAction: _load,
                )
              : _buildBody(_slot!, l10n),
      floatingActionButton: _isLoading || _error != null
          ? null
          : WFFloatingActionButton(
              label: l10n.newBoardTitle,
              onPressed: () => _openAddBoardSheet(l10n),
            ),
    );
  }

  Widget _buildBody(Slot slot, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(WFSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          WFListTile(
            title: l10n.capacityLabel,
            trailing: Text(l10n.slotFillCount(_totalItems, slot.capacity)),
          ),
          const Divider(),
          Expanded(
            child: (_boardsInSlot.isEmpty && _offcutsInSlot.isEmpty)
                ? WFEmptyState(icon: Icons.inbox_outlined, title: l10n.noItemsInSlot)
                : ListView(
                    children: [
                      if (_boardsInSlot.isNotEmpty)
                        WFSectionHeader(title: l10n.boardsSectionLabel),
                      ..._boardsInSlot.map((board) {
                        final decor = _decorFor(board.decorId);
                        return WFListTile(
                          leading: const Icon(Icons.crop_landscape_outlined),
                          title: decor != null ? '${decor.code} — ${decor.name}' : board.decorId,
                          subtitle:
                              '${board.length.toInt()}×${board.width.toInt()}×${board.thickness.toInt()} mm',
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => BoardDetailScreen(boardId: board.id),
                            ));
                            _load();
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.content_cut, size: 20),
                            tooltip: l10n.cutOffcut,
                            onPressed: () => _openCutSheet(board, l10n),
                          ),
                        );
                      }),
                      if (_offcutsInSlot.isNotEmpty)
                        WFSectionHeader(title: l10n.offcutsSectionLabel),
                      ..._offcutsInSlot.map((offcut) {
                        final decor = _decorFor(offcut.decorId);
                        return WFListTile(
                          leading: const Icon(Icons.content_cut, size: 20),
                          title: decor != null ? '${decor.code} — ${decor.name}' : offcut.decorId,
                          subtitle:
                              '${offcut.length.toInt()}×${offcut.width.toInt()}×${offcut.thickness.toInt()} mm · ${offcut.parentBoardId.substring(0, 8)}…',
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
          const SizedBox(height: WFSpacing.sm),
          WFButton(
            label: l10n.deleteSlotButton,
            icon: Icons.delete_outline,
            role: WFButtonRole.destructive,
            onPressed: () => _confirmDelete(slot, l10n),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddBoardSheet(AppLocalizations l10n) async {
    if (_allDecors.isEmpty) {
      showWFSnackbar(context, l10n.noDecorsInCatalog);
      return;
    }

    Decor selectedDecor = _allDecors.first;
    final lengthController = TextEditingController();
    final widthController = TextEditingController();
    final thicknessController = TextEditingController();

    await showWFBottomSheet(
      context,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.newBoardTitle, style: Theme.of(sheetContext).textTheme.titleLarge),
            const SizedBox(height: WFSpacing.md),
            DropdownButtonFormField<Decor>(
              initialValue: selectedDecor,
              decoration: InputDecoration(
                labelText: l10n.decorLabel,
                border: const OutlineInputBorder(),
              ),
              items: _allDecors
                  .map((d) => DropdownMenuItem(
                        value: d,
                        child: Text('${d.code} — ${d.name}'),
                      ))
                  .toList(),
              onChanged: (d) {
                if (d != null) setSheetState(() => selectedDecor = d);
              },
            ),
            const SizedBox(height: WFSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: WFTextField(
                    controller: lengthController,
                    labelText: l10n.lengthMm,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: WFSpacing.sm),
                Expanded(
                  child: WFTextField(
                    controller: widthController,
                    labelText: l10n.widthMm,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: WFSpacing.sm),
                Expanded(
                  child: WFTextField(
                    controller: thicknessController,
                    labelText: l10n.thicknessMm,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: WFSpacing.lg),
            WFButton(
              label: l10n.addBoard,
              onPressed: () {
                Navigator.of(sheetContext).pop();
                _submitAddBoard(selectedDecor, lengthController, widthController, thicknessController, l10n);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAddBoard(
    Decor selectedDecor,
    TextEditingController lengthController,
    TextEditingController widthController,
    TextEditingController thicknessController,
    AppLocalizations l10n,
  ) async {
    final length = double.tryParse(lengthController.text);
    final width = double.tryParse(widthController.text);
    final thickness = double.tryParse(thicknessController.text);
    if (length == null || width == null || thickness == null) {
      if (mounted) showWFSnackbar(context, l10n.fillDimensionsCorrectly);
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
        if (mounted) showWFSnackbar(context, f.message);
      },
    );
  }

  /// "Wytnij ścinek" — creates an Offcut from this Board, staying in
  /// the same slot by default. Deliberately does NOT resize/touch
  /// the Board — that's the Cut Optimizer's job (later, separate
  /// v2.0/PRO feature), not this simple entity-creation step.
  Future<void> _openCutSheet(Board board, AppLocalizations l10n) async {
    final lengthController = TextEditingController();
    final widthController = TextEditingController();
    final thicknessController = TextEditingController(text: board.thickness.toString());

    await showWFBottomSheet(
      context,
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.cutOffcut, style: Theme.of(sheetContext).textTheme.titleLarge),
          const SizedBox(height: WFSpacing.sm),
          Text(
            l10n.cutFromBoardNote(_decorFor(board.decorId)?.code ?? board.decorId),
            style: Theme.of(sheetContext)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(sheetContext).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: WFSpacing.md),
          Row(
            children: [
              Expanded(
                child: WFTextField(
                  controller: lengthController,
                  labelText: l10n.lengthMm,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                ),
              ),
              const SizedBox(width: WFSpacing.sm),
              Expanded(
                child: WFTextField(
                  controller: widthController,
                  labelText: l10n.widthMm,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: WFSpacing.sm),
              Expanded(
                child: WFTextField(
                  controller: thicknessController,
                  labelText: l10n.thicknessMm,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: WFSpacing.lg),
          WFButton(
            label: l10n.cut,
            onPressed: () {
              Navigator.of(sheetContext).pop();
              _submitCut(board, lengthController, widthController, thicknessController, l10n);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submitCut(
    Board board,
    TextEditingController lengthController,
    TextEditingController widthController,
    TextEditingController thicknessController,
    AppLocalizations l10n,
  ) async {
    final length = double.tryParse(lengthController.text);
    final width = double.tryParse(widthController.text);
    final thickness = double.tryParse(thicknessController.text);
    if (length == null || width == null || thickness == null) {
      if (mounted) showWFSnackbar(context, l10n.fillDimensionsCorrectly);
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
        if (mounted) showWFSnackbar(context, f.message);
      },
    );
  }

  Future<void> _confirmDelete(Slot slot, AppLocalizations l10n) async {
    final confirmed = await showWFConfirmationDialog(
      context,
      title: l10n.deleteSlotQuestion,
      message: l10n.deleteSlotWarning,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
    );
    if (!confirmed) return;

    final result = await _deleteSlot(slot.id);
    result.when(
      success: (_) {
        if (mounted) Navigator.of(context).pop();
      },
      failure: (f) {
        if (mounted) showWFSnackbar(context, f.message);
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
