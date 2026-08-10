import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/entities/organization.dart';
import '../../domain/repositories/warehouse_repository.dart';
import '../../domain/usecases/delete_warehouse_use_case.dart';
import '../../l10n/app_localizations.dart';
import '../rack/rack_list_screen.dart';
import '../dashboard/owner_dashboard_screen.dart';
import '../scan/scan_screen.dart';
import '../export/export_screen.dart';
import '../calculators/calculators_screen.dart';
import '../shopping_list/shopping_list_screen.dart';
import '../ai_query/ai_query_screen.dart';
// QA-ONLY (see file doc comment) — DELETE this import before v1.0.
import '../debug/qa_language_switcher_button.dart';

/// Deliberately plain Material widgets — no WoodFlow Design Tokens
/// applied here yet. This screen's job is to prove Warehouse can be
/// listed/created end-to-end through the architecture, not to look
/// finished. Restyle once Design Tokens exist; don't invent one-off
/// colors/spacing here that the token system would otherwise define.
class WarehouseListScreen extends StatefulWidget {
  const WarehouseListScreen({super.key});

  @override
  State<WarehouseListScreen> createState() => _WarehouseListScreenState();
}

class _WarehouseListScreenState extends State<WarehouseListScreen> {
  final WarehouseRepository _repository = sl<WarehouseRepository>();
  final DeleteWarehouseUseCase _deleteWarehouse = sl<DeleteWarehouseUseCase>();

  List<Warehouse> _warehouses = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _repository.getAll();
    result.when(
      success: (warehouses) {
        setState(() {
          _warehouses = warehouses;
          _isLoading = false;
        });
      },
      failure: (f) {
        setState(() {
          _errorMessage = f.message;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _addWarehouse(String name, String? address) async {
    final now = DateTime.now();
    final warehouse = Warehouse(
      id: const Uuid().v4(),
      organizationId: defaultOrganizationId,
      name: name,
      address: address,
      createdAt: now,
      updatedAt: now,
    );

    final result = await _repository.create(warehouse);
    result.when(
      success: (_) => _load(),
      failure: (f) => _showError(f.message),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.warehousesTitle),
        actions: [
          // === QA-ONLY — DELETE this block before v1.0 (see
          // qa_language_switcher_button.dart's doc comment) ===
          // kDebugMode means this literally does not exist in a
          // release/profile build — nothing to gate at runtime.
          if (kDebugMode) const QaLanguageSwitcherButton(),
          // === end QA-ONLY block ===
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: l10n.shoppingListTitle,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const ShoppingListScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.calculate_outlined),
            tooltip: l10n.calculatorsTitle,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const CalculatorsScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.ios_share_outlined),
            tooltip: l10n.exportTitle,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const ExportScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.dashboard_outlined),
            tooltip: l10n.ownerDashboardTitle,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const OwnerDashboardScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: l10n.scanQrCode,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const ScanScreen(),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            tooltip: l10n.aiQueryTitle,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const AiQueryScreen(),
              ));
            },
          ),
        ],
      ),
      body: _buildBody(l10n),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddWarehouseSheet(l10n),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.errorPrefix(_errorMessage!)),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: _load, child: Text(l10n.retry)),
            ],
          ),
        ),
      );
    }

    if (_warehouses.isEmpty) {
      return Center(
        child: Text(l10n.noWarehousesYet),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _warehouses.length,
        itemBuilder: (context, index) {
          final w = _warehouses[index];
          return ListTile(
            leading: const Icon(Icons.warehouse_outlined),
            title: Text(w.name),
            subtitle: w.address != null ? Text(w.address!) : null,
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.delete,
              onPressed: () => _confirmDeleteWarehouse(w, l10n),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => RackListScreen(
                  warehouseId: w.id,
                  warehouseName: w.name,
                ),
              ));
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDeleteWarehouse(Warehouse warehouse, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteWarehouseQuestion(warehouse.name)),
        content: Text(l10n.deleteWarehouseWarning),
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

    final result = await _deleteWarehouse(warehouse.id);
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

  void _openAddWarehouseSheet(AppLocalizations l10n) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.newWarehouseTitle, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.nameLabel),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: l10n.addressOptional),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                Navigator.of(context).pop();
                _addWarehouse(
                  name,
                  addressController.text.trim().isEmpty
                      ? null
                      : addressController.text.trim(),
                );
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
