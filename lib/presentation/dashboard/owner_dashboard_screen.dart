import 'package:flutter/material.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/services/dashboard_service.dart';
import '../../l10n/app_localizations.dart';
import '../board/board_detail_screen.dart';
import '../design_system/design_system.dart';
import '../offcut/offcut_detail_screen.dart';

/// Krok 9. Deliberately does ZERO aggregation, computation, or
/// repository iteration of its own — every number here comes
/// straight from `DashboardSnapshot`, built entirely by
/// `DashboardService`. If a future change adds logic to this file
/// beyond formatting/layout (a loop over repositories, a sum, a
/// percentage calculation), that's the exact "rozlewanie się"
/// Piotr flagged before this step started — it belongs in
/// `DashboardService`, not here.
class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  final DashboardService _dashboard = sl<DashboardService>();

  DashboardSnapshot? _snapshot;
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
    final result = await _dashboard.build();
    result.when(
      success: (snapshot) => setState(() {
        _snapshot = snapshot;
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
      appBar: WFTopBar(title: l10n.ownerDashboardTitle),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _isLoading
            ? const WFLoadingState()
            : _error != null
                ? WFEmptyState(
                    icon: Icons.error_outline,
                    title: l10n.errorPrefix(_error!),
                    actionLabel: l10n.retry,
                    onAction: _load,
                  )
                : _buildBody(_snapshot!, l10n),
      ),
    );
  }

  Widget _buildBody(DashboardSnapshot snapshot, AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(WFSpacing.md),
      children: [
        Row(
          children: [
            Expanded(child: _statCard(context, l10n.totalBoardsLabel, '${snapshot.totalBoards}')),
            const SizedBox(width: WFSpacing.sm),
            Expanded(child: _statCard(context, l10n.totalOffcutsLabel, '${snapshot.totalOffcuts}')),
          ],
        ),
        const SizedBox(height: WFSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _statCard(
                context,
                l10n.overallFillRateLabel,
                '${(snapshot.overallFillRate * 100).toStringAsFixed(0)}%',
              ),
            ),
            const SizedBox(width: WFSpacing.sm),
            Expanded(
              child: _statCard(
                context,
                l10n.totalRacksSlotsLabel,
                '${snapshot.totalRacks} / ${snapshot.totalSlots}',
              ),
            ),
          ],
        ),
        const SizedBox(height: WFSpacing.xl),
        WFSectionHeader(title: l10n.staleItemsSectionTitle),
        Text(
          l10n.staleItemsSectionSubtitle,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: WFSpacing.sm),
        if (snapshot.staleItems.isEmpty)
          WFEmptyState(icon: Icons.check_circle_outline, title: l10n.noStaleItems)
        else
          ...snapshot.staleItems.map((item) => WFCard(
                padding: EdgeInsets.zero,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => item.type == StaleItemType.board
                        ? BoardDetailScreen(boardId: item.entityId)
                        : OffcutDetailScreen(offcutId: item.entityId),
                  ));
                },
                child: WFListTile(
                  leading: Icon(item.type == StaleItemType.board
                      ? Icons.crop_landscape_outlined
                      : Icons.content_cut),
                  title: item.decorLabel,
                  subtitle: item.locationBreadcrumb ?? l10n.locationUnknown,
                  trailing: Text(_ageInDays(item.createdAt, l10n)),
                ),
              )),
      ],
    );
  }

  Widget _statCard(BuildContext context, String label, String value) {
    return WFCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: WFSpacing.xs),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  String _ageInDays(DateTime createdAt, AppLocalizations l10n) {
    final days = DateTime.now().difference(createdAt).inDays;
    return l10n.daysAgo(days);
  }
}
