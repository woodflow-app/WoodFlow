import 'package:flutter/material.dart';

import '../../core/services/service_locator.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/services/dashboard_service.dart';
import '../../l10n/app_localizations.dart';
import '../board/board_detail_screen.dart';
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
      appBar: AppBar(title: Text(l10n.ownerDashboardTitle)),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(l10n.errorPrefix(_error!)))
                : _buildBody(_snapshot!, l10n),
      ),
    );
  }

  Widget _buildBody(DashboardSnapshot snapshot, AppLocalizations l10n) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _statCard(l10n.totalBoardsLabel, '${snapshot.totalBoards}')),
            const SizedBox(width: 12),
            Expanded(child: _statCard(l10n.totalOffcutsLabel, '${snapshot.totalOffcuts}')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _statCard(
                l10n.overallFillRateLabel,
                '${(snapshot.overallFillRate * 100).toStringAsFixed(0)}%',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                l10n.totalRacksSlotsLabel,
                '${snapshot.totalRacks} / ${snapshot.totalSlots}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(l10n.staleItemsSectionTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(l10n.staleItemsSectionSubtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        if (snapshot.staleItems.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(l10n.noStaleItems, style: const TextStyle(color: Colors.grey)),
          )
        else
          ...snapshot.staleItems.map((item) => Card(
                child: ListTile(
                  leading: Icon(item.type == StaleItemType.board
                      ? Icons.crop_square
                      : Icons.content_cut),
                  title: Text(item.decorLabel),
                  subtitle: Text(item.locationBreadcrumb ?? l10n.locationUnknown),
                  trailing: Text(_ageInDays(item.createdAt, l10n)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => item.type == StaleItemType.board
                          ? BoardDetailScreen(boardId: item.entityId)
                          : OffcutDetailScreen(offcutId: item.entityId),
                    ));
                  },
                ),
              )),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  String _ageInDays(DateTime createdAt, AppLocalizations l10n) {
    final days = DateTime.now().difference(createdAt).inDays;
    return l10n.daysAgo(days);
  }
}
