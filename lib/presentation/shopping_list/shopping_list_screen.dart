import 'package:flutter/material.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/decor.dart';
import '../../domain/entities/shopping_list_item.dart';
import '../../domain/repositories/decor_repository.dart';
import '../../domain/services/shopping_list_service.dart';
import '../../l10n/app_localizations.dart';
import '../design_system/design_system.dart';

enum _ThresholdSheetAction { save, clear }

/// Krok 13 — shows every decor currently below its own
/// `minimumStockQuantity` (the "shopping list": what to reorder), and
/// doubles as the only place that threshold gets set or cleared — no
/// separate "manage decors" screen exists, so the FAB's decor search
/// is this screen's only entry point for decors that don't have a
/// threshold yet.
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final DecorRepository _decors = sl<DecorRepository>();
  final ShoppingListService _shoppingListService = sl<ShoppingListService>();

  List<Decor> _allDecors = [];
  List<ShoppingListItem> _items = [];
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

    final decorsResult = await _decors.getAll();
    if (decorsResult.isFailure) {
      setState(() {
        _error = decorsResult.failure.message;
        _isLoading = false;
      });
      return;
    }

    final itemsResult = await _shoppingListService.build();
    if (itemsResult.isFailure) {
      setState(() {
        _error = itemsResult.failure.message;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _allDecors = decorsResult.data;
      _items = itemsResult.data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: WFTopBar(title: l10n.shoppingListTitle),
      body: _buildBody(l10n),
      floatingActionButton: WFFloatingActionButton(
        label: l10n.setThresholdTitle,
        onPressed: _isLoading ? null : () => _openDecorSearchSheet(l10n),
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

    if (_items.isEmpty) {
      final hasAnyThreshold = _allDecors.any((d) => d.minimumStockQuantity != null);
      return WFEmptyState(
        icon: Icons.shopping_cart_outlined,
        title: hasAnyThreshold ? l10n.shoppingListAllSufficient : l10n.shoppingListNoThresholds,
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: WFSpacing.sm),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return WFListTile(
            leading: Icon(Icons.warning_amber_outlined, color: Theme.of(context).colorScheme.tertiary),
            title: '${item.decor.code} — ${item.decor.name}',
            subtitle: '${l10n.currentStockLabel}: ${item.currentStock}   '
                '${l10n.minimumStockLabel}: ${item.decor.minimumStockQuantity}',
            trailing: WFStatusChip(
              label: '-${item.shortageQuantity}',
              level: WFStatusLevel.error,
            ),
            onTap: () => _openThresholdSheet(item.decor, l10n),
          );
        },
      ),
    );
  }

  Future<void> _openDecorSearchSheet(AppLocalizations l10n) async {
    final searchController = TextEditingController();
    var filtered = _allDecors;

    final selected = await showWFBottomSheet<Decor>(
      context,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => SizedBox(
          height: MediaQuery.of(sheetContext).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.setThresholdTitle, style: Theme.of(sheetContext).textTheme.titleLarge),
              const SizedBox(height: WFSpacing.md),
              WFTextField(
                controller: searchController,
                labelText: l10n.searchDecorHint,
                autofocus: true,
                onChanged: (query) {
                  final q = query.trim().toLowerCase();
                  setSheetState(() {
                    filtered = q.isEmpty
                        ? _allDecors
                        : _allDecors
                            .where((d) =>
                                d.code.toLowerCase().contains(q) || d.name.toLowerCase().contains(q))
                            .toList();
                  });
                },
              ),
              const SizedBox(height: WFSpacing.sm),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final decor = filtered[index];
                    return WFListTile(
                      title: '${decor.code} — ${decor.name}',
                      subtitle: decor.minimumStockQuantity != null
                          ? '${l10n.minimumStockLabel}: ${decor.minimumStockQuantity}'
                          : null,
                      onTap: () => Navigator.of(sheetContext).pop(decor),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selected != null && mounted) {
      await _openThresholdSheet(selected, l10n);
    }
  }

  Future<void> _openThresholdSheet(Decor decor, AppLocalizations l10n) async {
    final controller = TextEditingController(
      text: decor.minimumStockQuantity?.toString() ?? '',
    );
    final formKey = GlobalKey<FormState>();

    final action = await showWFBottomSheet<_ThresholdSheetAction>(
      context,
      builder: (sheetContext) => Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('${decor.code} — ${decor.name}', style: Theme.of(sheetContext).textTheme.titleLarge),
            const SizedBox(height: WFSpacing.md),
            WFTextField(
              controller: controller,
              labelText: l10n.minimumStockQuantityLabel,
              keyboardType: TextInputType.number,
              autofocus: true,
              validator: (value) {
                final parsed = value == null || value.isEmpty ? null : int.tryParse(value);
                if (parsed == null || parsed < 0) return l10n.invalidQuantityMessage;
                return null;
              },
            ),
            const SizedBox(height: WFSpacing.lg),
            WFButton(
              label: l10n.save,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(sheetContext).pop(_ThresholdSheetAction.save);
                }
              },
            ),
            if (decor.minimumStockQuantity != null) ...[
              const SizedBox(height: WFSpacing.sm),
              WFButton(
                label: l10n.clearThresholdButton,
                role: WFButtonRole.destructive,
                onPressed: () => Navigator.of(sheetContext).pop(_ThresholdSheetAction.clear),
              ),
            ],
          ],
        ),
      ),
    );

    if (action == null || !mounted) return;

    final newValue = action == _ThresholdSheetAction.clear ? null : int.parse(controller.text);
    final result = await _decors.update(decor.copyWith(minimumStockQuantity: newValue));
    if (!mounted) return;
    result.when(
      success: (_) => _load(),
      failure: (f) => showWFSnackbar(context, f.message),
    );
  }
}
