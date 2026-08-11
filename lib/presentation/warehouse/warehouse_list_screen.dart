import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/warehouse.dart';
import '../../domain/entities/organization.dart';
import '../../domain/repositories/warehouse_repository.dart';
import '../../domain/usecases/delete_warehouse_use_case.dart';
import '../../l10n/app_localizations.dart';
import '../design_system/design_system.dart';
import '../rack/rack_list_screen.dart';
import '../dashboard/owner_dashboard_screen.dart';
import '../scan/scan_screen.dart';
import '../export/export_screen.dart';
import '../calculators/calculators_screen.dart';
import '../shopping_list/shopping_list_screen.dart';
import '../ai_query/ai_query_screen.dart';
// QA-ONLY (see file doc comment) — DELETE this import before v1.0.
import '../debug/qa_language_switcher_button.dart';

/// Styled per `docs/design-system/WoodFlowDesignSystem.md`. The
/// 7-action-icon AppBar below is a known open question from that
/// document (information architecture, not a token decision) — icon
/// count/placement is unchanged here on purpose pending that call.
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
      failure: (f) => showWFSnackbar(context, f.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: WFTopBar(
        title: l10n.warehousesTitle,
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
            icon: const Icon(Icons.auto_awesome_outlined),
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
      floatingActionButton: WFFloatingActionButton(
        label: l10n.newWarehouseTitle,
        onPressed: () => _openAddWarehouseSheet(l10n),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const WFLoadingState();
    }

    if (_errorMessage != null) {
      return WFEmptyState(
        icon: Icons.error_outline,
        title: l10n.errorPrefix(_errorMessage!),
        actionLabel: l10n.retry,
        onAction: _load,
      );
    }

    if (_warehouses.isEmpty) {
      return WFEmptyState(
        icon: Icons.warehouse_outlined,
        title: l10n.noWarehousesYet,
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: WFSpacing.sm),
        itemCount: _warehouses.length,
        itemBuilder: (context, index) {
          final w = _warehouses[index];
          return WFListTile(
            leading: const Icon(Icons.warehouse_outlined),
            title: w.name,
            subtitle: w.address,
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
    final confirmed = await showWFConfirmationDialog(
      context,
      title: l10n.deleteWarehouseQuestion(warehouse.name),
      message: l10n.deleteWarehouseWarning,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
    );
    if (!confirmed) return;

    final result = await _deleteWarehouse(warehouse.id);
    result.when(
      success: (_) => _load(),
      failure: (f) {
        if (mounted) showWFSnackbar(context, f.message);
      },
    );
  }

  void _openAddWarehouseSheet(AppLocalizations l10n) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();

    showWFBottomSheet(
      context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.newWarehouseTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: WFSpacing.md),
          WFTextField(controller: nameController, labelText: l10n.nameLabel, autofocus: true),
          const SizedBox(height: WFSpacing.sm),
          WFTextField(controller: addressController, labelText: l10n.addressOptional),
          const SizedBox(height: WFSpacing.lg),
          WFButton(
            label: l10n.save,
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              Navigator.of(context).pop();
              _addWarehouse(
                name,
                addressController.text.trim().isEmpty ? null : addressController.text.trim(),
              );
            },
          ),
        ],
      ),
    );
  }
}
