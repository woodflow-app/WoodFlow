/// The ONE model `OwnerDashboardScreen` renders. Per the rule
/// established before Krok 9: "Dashboard nie może wykonywać logiki
/// biznesowej. Powinien otrzymywać gotowy model z jednego serwisu" —
/// this is that model. It carries only already-computed numbers and
/// already-resolved display strings; the screen's job is limited to
/// laying them out on screen.
///
/// Scoped to what real data supports TODAY. Deliberately excludes
/// "wycena magazynu" (valuation) and "miesięczne oszczędności"
/// (savings) from Katalog Funkcji's FREE-tier Dashboard description —
/// both require a price field that doesn't exist anywhere in the
/// schema yet (Board/Offcut/Decor have none). Added back once that's
/// a real, deliberate decision (see conversation before Krok 9),
/// not invented here as a fake default price.
class DashboardSnapshot {
  final int totalWarehouses;
  final int totalRacks;
  final int totalSlots;
  final int totalBoards; // active only — archived excluded, same as getAll()'s default
  final int totalOffcuts; // active only
  final double overallFillRate; // 0.0–1.0, across every slot in every warehouse
  final List<StaleItem> staleItems; // active, created >1 year ago

  // Future (not implemented — plan, not a promise):
  //   inventoryValue    — needs a price field, doesn't exist yet
  //   wasteValue        — needs price + a "waste" definition
  //   monthlySavings    — needs price + reuse-event tracking
  // Adding any of these means adding a real field to this class
  // when the underlying price/price-history decision is made — not
  // before.

  const DashboardSnapshot({
    required this.totalWarehouses,
    required this.totalRacks,
    required this.totalSlots,
    required this.totalBoards,
    required this.totalOffcuts,
    required this.overallFillRate,
    required this.staleItems,
  });
}

/// A single board or offcut that's been sitting for over a year
/// without being used or archived — Katalog Funkcji's "materiały
/// zalegające >1 rok", the one owner-dashboard metric that needs no
/// price data to compute.
class StaleItem {
  final String entityId;
  final StaleItemType type;
  final String decorLabel; // e.g. "H3303 — Natural Hamilton Oak", already resolved
  final DateTime createdAt;
  final String? locationBreadcrumb; // already resolved, nullable if unavailable

  const StaleItem({
    required this.entityId,
    required this.type,
    required this.decorLabel,
    required this.createdAt,
    this.locationBreadcrumb,
  });
}

enum StaleItemType { board, offcut }
