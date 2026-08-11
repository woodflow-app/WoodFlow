import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/rack.dart';
import '../../domain/repositories/rack_repository.dart';
import '../../l10n/app_localizations.dart';
import 'slot_grid_screen.dart';

/// Entry point into Slice 4 — "Lokalizacje" from the old app, scoped
/// to one warehouse. Mirrors LocationsScreen's rack list exactly.
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
      appBar: AppBar(title: Text(l10n.racksForWarehouseTitle(widget.warehouseName))),
      body: _buildBody(l10n),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddRackDialog(l10n),
        icon: const Icon(Icons.add),
        label: Text(l10n.newRackTitle),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(l10n.errorPrefix(_error!)));
    if (_list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.noRacksYet,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (context, index) {
        final rack = _list[index];
        return ListTile(
          leading: const Icon(Icons.view_column_outlined),
          title: Text(l10n.rackNameTitle(rack.name)),
          trailing: const Icon(Icons.chevron_right),
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

  Future<void> _openAddRackDialog(AppLocalizations l10n) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.newRackTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.nameHintRack),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.addRack)),
        ],
      ),
    );
    if (confirmed != true || controller.text.trim().isEmpty) return;

    final now = DateTime.now();
    final result = await _racks.create(Rack(
      id: const Uuid().v4(),
      warehouseId: widget.warehouseId,
      name: controller.text.trim(),
      createdAt: now,
      updatedAt: now,
    ));
    result.when(
      success: (_) => _load(),
      failure: (f) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(f.message))),
    );
  }
}
