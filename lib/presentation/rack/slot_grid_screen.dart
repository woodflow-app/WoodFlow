import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/slot.dart';
import '../../domain/repositories/slot_repository.dart';
import '../../l10n/app_localizations.dart';
import 'slot_detail_screen.dart';

class SlotGridScreen extends StatefulWidget {
  final String rackId;
  final String rackName;
  const SlotGridScreen({super.key, required this.rackId, required this.rackName});

  @override
  State<SlotGridScreen> createState() => _SlotGridScreenState();
}

class _SlotGridScreenState extends State<SlotGridScreen> {
  final SlotRepository _slots = sl<SlotRepository>();
  List<SlotOccupancy> _occupancy = [];
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
    final result = await _slots.getOccupancyForRack(widget.rackId);
    result.when(
      success: (occupancy) => setState(() {
        _occupancy = occupancy;
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
      appBar: AppBar(title: Text(l10n.rackNameTitle(widget.rackName))),
      body: _buildBody(l10n),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSlotDialog(l10n),
        icon: const Icon(Icons.add),
        label: Text(l10n.newSlotTitle),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(l10n.errorPrefix(_error!)));
    if (_occupancy.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.noSlotsYet,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: _occupancy.length,
      itemBuilder: (context, index) {
        final occ = _occupancy[index];
        return _SlotChip(
          occupancy: occ,
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SlotDetailScreen(
                slotId: occ.slot.id,
                rackName: widget.rackName,
              ),
            ));
            _load();
          },
        );
      },
    );
  }

  Future<void> _openAddSlotDialog(AppLocalizations l10n) async {
    final nameController = TextEditingController();
    final capacityController = TextEditingController(text: '20');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.newSlotTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.nameHintSlot),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: capacityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.capacityPcsLabel),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.addSlot)),
        ],
      ),
    );
    if (confirmed != true || nameController.text.trim().isEmpty) return;

    final capacity = int.tryParse(capacityController.text) ?? 20;
    final now = DateTime.now();
    final result = await _slots.create(Slot(
      id: const Uuid().v4(),
      rackId: widget.rackId,
      name: nameController.text.trim(),
      capacity: capacity,
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

class _SlotChip extends StatelessWidget {
  final SlotOccupancy occupancy;
  final VoidCallback onTap;
  const _SlotChip({required this.occupancy, required this.onTap});

  Color _fillColor(double ratio) {
    if (ratio >= 0.9) return Colors.red;
    if (ratio >= 0.5) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final ratio = occupancy.fillRatio.clamp(0, 1).toDouble();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(occupancy.slot.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                color: _fillColor(ratio),
              ),
            ),
            const SizedBox(height: 6),
            Text('${occupancy.used} / ${occupancy.slot.capacity}',
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
