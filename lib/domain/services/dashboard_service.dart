import '../../core/errors/failures.dart';
import '../entities/dashboard_snapshot.dart';
import '../repositories/board_repository.dart';
import '../repositories/decor_repository.dart';
import '../repositories/offcut_repository.dart';
import '../repositories/rack_repository.dart';
import '../repositories/slot_repository.dart';
import '../repositories/warehouse_repository.dart';

/// Krok 9 is the first step that reads from every module built so
/// far (Warehouse, Rack, Slot, Board, Offcut, Decor) at once. This
/// class is where that cross-cutting aggregation lives — deliberately
/// NOT in `OwnerDashboardScreen`, per the rule agreed before starting
/// this step: the screen only renders a `DashboardSnapshot`, it never
/// computes one.
///
/// Concrete class, not an abstract interface — unlike `LabelGenerator`
/// (which genuinely needed multiple swappable implementations for
/// different printers), there's only one reasonable way to aggregate
/// this data. Same reasoning as `QrResolver`: a single class taking
/// repositories as constructor dependencies, no interface+impl split
/// for a single implementation that would never be swapped.
class DashboardService {
  DashboardService(
    this._warehouses,
    this._racks,
    this._slots,
    this._boards,
    this._offcuts,
    this._decors,
  );

  final WarehouseRepository _warehouses;
  final RackRepository _racks;
  final SlotRepository _slots;
  final BoardRepository _boards;
  final OffcutRepository _offcuts;
  final DecorRepository _decors;

  static const _staleThreshold = Duration(days: 365);

  Future<Result<DashboardSnapshot>> build() async {
    // TODO(optymalizacja — świadomie NIE teraz): getAll() (boards),
    // getAll() (offcuts), i pętla getByWarehouse()/
    // getOccupancyForRack() wykonują się dziś sekwencyjnie, jedno po
    // drugim. Część z nich (np. boardsResult/offcutsResult, albo
    // niezależne od siebie racki różnych magazynów) mogłaby iść
    // równolegle przez Future.wait i skrócić czas budowania
    // dashboardu. Przedwczesna optymalizacja na obecnym etapie
    // (mała liczba danych, brak zmierzonego problemu z czasem) —
    // rozważyć dopiero, gdy realny czas budowania Dashboardu stanie
    // się zauważalny dla użytkownika, nie zanim to się stanie.
    try {
      final warehousesResult = await _warehouses.getAll();
      if (warehousesResult.isFailure) return Result.failure(warehousesResult.failure);
      final warehouses = warehousesResult.data;

      var totalRacks = 0;
      var totalSlots = 0;
      var totalUsed = 0;
      var totalCapacity = 0;
      // NOTE: `capacity` (from Slot) today means NUMBER OF STORED
      // OBJECTS (boards + offcuts), not occupied area or volume.
      // `overallFillRate` below is a straight object-count ratio,
      // which is correct ONLY under that meaning. If a slot's
      // capacity is ever redefined in terms of area/volume, this
      // ratio calculation must be revisited — it would silently keep
      // compiling and running while producing a meaningless number.

      for (final warehouse in warehouses) {
        final racksResult = await _racks.getByWarehouse(warehouse.id);
        if (racksResult.isFailure) continue;
        for (final rack in racksResult.data) {
          totalRacks++;
          final occupancyResult = await _slots.getOccupancyForRack(rack.id);
          if (occupancyResult.isFailure) continue;
          for (final occ in occupancyResult.data) {
            totalSlots++;
            totalUsed += occ.used;
            totalCapacity += occ.slot.capacity;
          }
        }
      }

      final boardsResult = await _boards.getAll();
      final offcutsResult = await _offcuts.getAll();
      final boards = boardsResult.isSuccess ? boardsResult.data : [];
      final offcuts = offcutsResult.isSuccess ? offcutsResult.data : [];

      final now = DateTime.now();
      final staleItems = <StaleItem>[];

      // TODO(wydajność — nie blokuje Kroku 9, ale zanotowane wprost):
      // dla każdej starej płyty/ścinka to dwa kolejne zapytania
      // (decor + lokalizacja). Przy setkach starych pozycji to
      // realny N+1 — ten sam typ problemu, który rozwiązaliśmy przez
      // batching w LedgerEntryFormatter (jedno zapytanie na unikalny
      // slotId zamiast jednego na wpis). Tutaj analogiczne
      // rozwiązanie: zebrać unikalne decorId/slotId ze wszystkich
      // starych elementów najpierw, potem odpytać każdy raz, dopiero
      // na końcu złożyć StaleItem. Nie robić tego teraz — dziś liczba
      // "zalegających" materiałów jest mała, to optymalizacja na
      // przyszłość, nie dzisiejszy blocker.
      for (final board in boards) {
        if (now.difference(board.createdAt) >= _staleThreshold) {
          final decorResult = await _decors.getById(board.decorId);
          final locationResult = await _boards.getFullLocation(board.id);
          staleItems.add(StaleItem(
            entityId: board.id,
            type: StaleItemType.board,
            decorLabel: decorResult.isSuccess
                ? '${decorResult.data.code} — ${decorResult.data.name}'
                : board.decorId,
            createdAt: board.createdAt,
            locationBreadcrumb: locationResult.isSuccess ? locationResult.data.breadcrumb : null,
          ));
        }
      }

      for (final offcut in offcuts) {
        if (now.difference(offcut.createdAt) >= _staleThreshold) {
          final decorResult = await _decors.getById(offcut.decorId);
          staleItems.add(StaleItem(
            entityId: offcut.id,
            type: StaleItemType.offcut,
            decorLabel: decorResult.isSuccess
                ? '${decorResult.data.code} — ${decorResult.data.name}'
                : offcut.decorId,
            createdAt: offcut.createdAt,
            // No getFullLocation() for Offcut yet (same YAGNI TODO as
            // OffcutDetailScreen) — breadcrumb omitted here rather
            // than duplicating that 3-step chain a second place.
            locationBreadcrumb: null,
          ));
        }
      }

      staleItems.sort((a, b) => a.createdAt.compareTo(b.createdAt)); // oldest first

      return Result.success(DashboardSnapshot(
        totalWarehouses: warehouses.length,
        totalRacks: totalRacks,
        totalSlots: totalSlots,
        totalBoards: boards.length,
        totalOffcuts: offcuts.length,
        overallFillRate: totalCapacity == 0 ? 0.0 : totalUsed / totalCapacity,
        staleItems: staleItems,
      ));
    } catch (e) {
      return Result.failure(mapExceptionToFailure(e));
    }
  }
}
