import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/slot.dart';
import '../../domain/repositories/slot_repository.dart';
import '../../l10n/app_localizations.dart';
import '../design_system/design_system.dart';
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
      appBar: WFTopBar(title: l10n.rackNameTitle(widget.rackName)),
      body: _buildBody(l10n),
      floatingActionButton: WFFloatingActionButton(
        label: l10n.newSlotTitle,
        onPressed: () => _openAddSlotSheet(l10n),
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
    if (_occupancy.isEmpty) {
      return WFEmptyState(icon: Icons.inbox_outlined, title: l10n.noSlotsYet);
    }
    return GridView.builder(
      padding: const EdgeInsets.all(WFSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: WFSpacing.sm,
        crossAxisSpacing: WFSpacing.sm,
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

  void _openAddSlotSheet(AppLocalizations l10n) {
    final nameController = TextEditingController();
    final capacityController = TextEditingController(text: '20');

    showWFBottomSheet(
      context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.newSlotTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: WFSpacing.md),
          WFTextField(controller: nameController, labelText: l10n.nameHintSlot, autofocus: true),
          const SizedBox(height: WFSpacing.sm),
          WFTextField(
            controller: capacityController,
            labelText: l10n.capacityPcsLabel,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: WFSpacing.lg),
          WFButton(
            label: l10n.addSlot,
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              final capacity = int.tryParse(capacityController.text) ?? 20;
              Navigator.of(context).pop();
              _addSlot(name, capacity);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _addSlot(String name, int capacity) async {
    final now = DateTime.now();
    final result = await _slots.create(Slot(
      id: const Uuid().v4(),
      rackId: widget.rackId,
      name: name,
      capacity: capacity,
      createdAt: now,
      updatedAt: now,
    ));
    result.when(
      success: (_) => _load(),
      failure: (f) => showWFSnackbar(context, f.message),
    );
  }
}

class _SlotChip extends StatelessWidget {
  final SlotOccupancy occupancy;
  final VoidCallback onTap;
  const _SlotChip({required this.occupancy, required this.onTap});

  /// Fill-level color, from the theme (`WoodFlowDesignSystem.md` §3),
  /// never a raw `Colors.*` value.
  Color _fillColor(BuildContext context, double ratio) {
    final scheme = Theme.of(context).colorScheme;
    if (ratio >= 0.9) return scheme.error;
    if (ratio >= 0.5) return scheme.tertiary;
    return scheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final ratio = occupancy.fillRatio.clamp(0, 1).toDouble();
    final color = _fillColor(context, ratio);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(WFRadius.medium),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(WFRadius.medium),
        ),
        padding: const EdgeInsets.all(WFSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 18, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: WFSpacing.xs),
            Text(occupancy.slot.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: WFSpacing.sm),
            WFProgressIndicator(value: ratio, color: color),
            const SizedBox(height: WFSpacing.xs),
            // Numeric ratio is the non-color fill-level signal —
            // WoodFlowDesignSystem.md's Accessibility note (color is
            // never the only signal) is satisfied by this label, not
            // by the bar color alone.
            Text(
              '${occupancy.used} / ${occupancy.slot.capacity}',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
