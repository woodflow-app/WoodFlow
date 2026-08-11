import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/rack.dart';
import '../../domain/repositories/rack_repository.dart';
import '../../domain/usecases/delete_rack_use_case.dart';
import '../../l10n/app_localizations.dart';
import '../design_system/design_system.dart';
import 'slot_grid_screen.dart';

/// Entry point into Slice 4 — "Lokalizacje" from the old app, scoped
/// to one warehouse. Styled per `docs/design-system/WoodFlowDesignSystem.md`.
class RackListScreen extends StatefulWidget {
  final String warehouseId;
  final String warehouseName;
  const RackListScreen(
      {super.key, required this.warehouseId, required this.warehouseName});

  @override
  State<RackListScreen> createState() => _RackListScreenState();
}

class _RackListScreenState extends State<RackListScreen> {
  final RackRepository _racks = sl<RackRepository>();
  final DeleteRackUseCase _deleteRack = sl<DeleteRackUseCase>();
  List<Rack> _list = [];
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
    final result = await _racks.getByWarehouse(widget.warehouseId);
    result.when(
      success: (racks) => setState(() {
        _list = racks;
        _isLoading = false;
      }),
      failure: (f) => setState(() {
        _error = f.message;
        _isLoading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: WFTopBar(title: l10n.racksForWarehouseTitle(widget.warehouseName)),
      body: _buildBody(l10n),
      floatingActionButton: WFFloatingActionButton(
        label: l10n.newRackTitle,
        onPressed: () => _openAddRackSheet(l10n),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) return const WFLoadingState();
    if (_error != null) {
      return WFEmptyState(
        icon: Icons.error_outline,
        title: l10n.errorPrefix(_error!),
        actionLabel: l10n.retry,
        onAction: _load,
      );
    }
    if (_list.isEmpty) {
      return WFEmptyState(icon: Icons.view_column_outlined, title: l10n.noRacksYet);
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: WFSpacing.sm),
      itemCount: _list.length,
      itemBuilder: (context, index) {
        final rack = _list[index];
        return WFListTile(
          leading: const Icon(Icons.view_column_outlined),
          title: l10n.rackNameTitle(rack.name),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.delete,
            onPressed: () => _confirmDeleteRack(rack, l10n),
          ),
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  SlotGridScreen(rackId: rack.id, rackName: rack.name),
            ));
            _load();
          },
        );
      },
    );
  }

  Future<void> _confirmDeleteRack(Rack rack, AppLocalizations l10n) async {
    final confirmed = await showWFConfirmationDialog(
      context,
      title: l10n.deleteRackQuestion(rack.name),
      message: l10n.deleteRackWarning,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
    );
    if (!confirmed) return;

    final result = await _deleteRack(rack.id);
    result.when(
      success: (_) => _load(),
      failure: (f) {
        if (mounted) showWFSnackbar(context, f.message);
      },
    );
  }

  void _openAddRackSheet(AppLocalizations l10n) {
    final controller = TextEditingController();

    showWFBottomSheet(
      context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.newRackTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: WFSpacing.md),
          WFTextField(controller: controller, labelText: l10n.nameHintRack, autofocus: true),
          const SizedBox(height: WFSpacing.lg),
          WFButton(
            label: l10n.addRack,
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.of(context).pop();
              _addRack(name);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addRack(String name) async {
    final now = DateTime.now();
    final result = await _racks.create(Rack(
      id: const Uuid().v4(),
      warehouseId: widget.warehouseId,
      name: name,
      createdAt: now,
      updatedAt: now,
    ));
    result.when(
      success: (_) => _load(),
      failure: (f) => showWFSnackbar(context, f.message),
    );
  }
}
