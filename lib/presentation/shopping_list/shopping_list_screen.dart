import 'package:flutter/material.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/decor.dart';
import '../../domain/entities/shopping_list_item.dart';
import '../../domain/repositories/decor_repository.dart';
import '../../domain/services/shopping_list_service.dart';
import '../../l10n/app_localizations.dart';

enum _ThresholdDialogAction { save, clear }

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
      appBar: AppBar(title: Text(l10n.shoppingListTitle)),
      body: _buildBody(l10n),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.setThresholdTitle,
        onPressed: _isLoading ? null : () => _openDecorSearch(l10n),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.errorPrefix(_error!)),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _load, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      final hasAnyThreshold = _allDecors.any((d) => d.minimumStockQuantity != null);
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            hasAnyThreshold ? l10n.shoppingListAllSufficient : l10n.shoppingListNoThresholds,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            leading: const Icon(Icons.warning_amber_outlined, color: Colors.orange),
            title: Text('${item.decor.code} — ${item.decor.name}'),
            subtitle: Text(
              '${l10n.currentStockLabel}: ${item.currentStock}   '
              '${l10n.minimumStockLabel}: ${item.decor.minimumStockQuantity}',
            ),
            trailing: Text(
              '-${item.shortageQuantity}',
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () => _openThresholdDialog(item.decor, l10n),
          );
        },
      ),
    );
  }

  Future<void> _openDecorSearch(AppLocalizations l10n) async {
    final searchController = TextEditingController();
    var filtered = _allDecors;

    final selected = await showDialog<Decor>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(l10n.setThresholdTitle),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(labelText: l10n.searchDecorHint),
                  onChanged: (query) {
                    final q = query.trim().toLowerCase();
                    setDialogState(() {
                      filtered = q.isEmpty
                          ? _allDecors
                          : _allDecors
                              .where((d) =>
                                  d.code.toLowerCase().contains(q) ||
                                  d.name.toLowerCase().contains(q))
                              .toList();
                    });
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final decor = filtered[index];
                      return ListTile(
                        title: Text('${decor.code} — ${decor.name}'),
                        subtitle: decor.minimumStockQuantity != null
                            ? Text('${l10n.minimumStockLabel}: ${decor.minimumStockQuantity}')
                            : null,
                        onTap: () => Navigator.of(dialogContext).pop(decor),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        ),
      ),
    );

    if (selected != null && mounted) {
      await _openThresholdDialog(selected, l10n);
    }
  }

  Future<void> _openThresholdDialog(Decor decor, AppLocalizations l10n) async {
    final controller = TextEditingController(
      text: decor.minimumStockQuantity?.toString() ?? '',
    );
    final formKey = GlobalKey<FormState>();

    final action = await showDialog<_ThresholdDialogAction>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${decor.code} — ${decor.name}'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.minimumStockQuantityLabel),
            validator: (value) {
              final parsed = value == null || value.isEmpty ? null : int.tryParse(value);
              if (parsed == null || parsed < 0) return l10n.invalidQuantityMessage;
              return null;
            },
          ),
        ),
        actions: [
          if (decor.minimumStockQuantity != null)
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(_ThresholdDialogAction.clear),
              child: Text(l10n.clearThresholdButton),
            ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(dialogContext).pop(_ThresholdDialogAction.save);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (action == null || !mounted) return;

    final newValue = action == _ThresholdDialogAction.clear ? null : int.parse(controller.text);
    final result = await _decors.update(decor.copyWith(minimumStockQuantity: newValue));
    if (!mounted) return;
    result.when(
      success: (_) => _load(),
      failure: (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(f.message))),
    );
  }
}
