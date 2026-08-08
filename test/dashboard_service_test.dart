import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:woodflow/core/logging/app_logger.dart';
import 'package:woodflow/core/events/event_publisher.dart';
import 'package:woodflow/data/database/database_service.dart';
import 'package:woodflow/data/repositories/board_repository_impl.dart';
import 'package:woodflow/data/repositories/decor_repository_impl.dart';
import 'package:woodflow/data/repositories/offcut_repository_impl.dart';
import 'package:woodflow/data/repositories/rack_repository_impl.dart';
import 'package:woodflow/data/repositories/slot_repository_impl.dart';
import 'package:woodflow/data/repositories/warehouse_repository_impl.dart';
import 'package:woodflow/domain/entities/organization.dart';
import 'package:woodflow/domain/entities/rack.dart';
import 'package:woodflow/domain/entities/slot.dart';
import 'package:woodflow/domain/entities/warehouse.dart';
import 'package:woodflow/domain/services/dashboard_service.dart';

const _decorH3303 = 'decor-h3303';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseService dbService;
  late DashboardService dashboardService;
  late WarehouseRepositoryImpl warehouseRepo;
  late RackRepositoryImpl rackRepo;
  late SlotRepositoryImpl slotRepo;
  late BoardRepositoryImpl boardRepo;
  late OffcutRepositoryImpl offcutRepo;
  late DecorRepositoryImpl decorRepo;

  setUp(() async {
    dbService = DatabaseService(const AppLogger(), inMemory: true);
    final events = InMemoryEventPublisher();
    warehouseRepo = WarehouseRepositoryImpl(dbService, const AppLogger());
    rackRepo = RackRepositoryImpl(dbService, const AppLogger());
    slotRepo = SlotRepositoryImpl(dbService, const AppLogger());
    decorRepo = DecorRepositoryImpl(dbService, const AppLogger());
    boardRepo = BoardRepositoryImpl(dbService, const AppLogger(), events, slotRepo, decorRepo);
    offcutRepo = OffcutRepositoryImpl(dbService, const AppLogger(), events, boardRepo, slotRepo);
    dashboardService = DashboardService(
        warehouseRepo, rackRepo, slotRepo, boardRepo, offcutRepo, decorRepo);
    await dbService.open();
  });

  tearDown(() async {
    await dbService.close();
  });

  test('empty warehouse: zero counts, zero fill rate, no stale items',
      () async {
    final result = await dashboardService.build();
    expect(result.isSuccess, isTrue);
    expect(result.data.totalWarehouses, 0);
    expect(result.data.totalBoards, 0);
    expect(result.data.overallFillRate, 0.0);
    expect(result.data.staleItems, isEmpty);
  });

  test('counts warehouses/racks/slots/boards/offcuts correctly across'
      ' the whole hierarchy', () async {
    final now = DateTime.now();
    await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: now, updatedAt: now,
    ));
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );
    await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', capacity: 10, createdAt: now, updatedAt: now),
    );
    final board = await boardRepo.create(
      slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18,
    );
    await offcutRepo.cutFromBoard(
      parentBoardId: board.data.id, slotId: 's-1', length: 400, width: 300, thickness: 18,
    );

    final result = await dashboardService.build();
    expect(result.isSuccess, isTrue);
    expect(result.data.totalWarehouses, 1);
    expect(result.data.totalRacks, 1);
    expect(result.data.totalSlots, 1);
    expect(result.data.totalBoards, 1);
    expect(result.data.totalOffcuts, 1);
    // 1 board + 1 offcut in a slot of capacity 10 → 2/10
    expect(result.data.overallFillRate, 0.2);
  });

  test('archived boards/offcuts are excluded from counts (matches the'
      ' default behavior of getAll — archived is not "gone", but it is'
      ' not active stock either)', () async {
    final now = DateTime.now();
    await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: now, updatedAt: now,
    ));
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );
    await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', createdAt: now, updatedAt: now),
    );
    final board = await boardRepo.create(
      slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18,
    );
    await boardRepo.archive(board.data.id);

    final result = await dashboardService.build();
    expect(result.data.totalBoards, 0);
  });

  test('a board created over a year ago appears in staleItems, a'
      ' recently-created one does not', () async {
    final longAgo = DateTime.now().subtract(const Duration(days: 400));
    final recent = DateTime.now();

    await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: recent, updatedAt: recent,
    ));
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: recent, updatedAt: recent),
    );
    await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', createdAt: recent, updatedAt: recent),
    );

    // BoardRepositoryImpl.create() always stamps createdAt as
    // DateTime.now() internally — there's no (and shouldn't be a)
    // public way to backdate it through the repository API. To
    // actually exercise the POSITIVE detection path (not just "a
    // fresh board is correctly not stale"), this inserts a row
    // directly via raw SQL, bypassing the repository on purpose —
    // the only honest way to construct "a board created 400 days
    // ago" as test data.
    final db = await dbService.open();
    await db.insert('boards', {
      'id': 'old-board',
      'slot_id': 's-1',
      'decor_id': _decorH3303,
      'length': 2800.0,
      'width': 2070.0,
      'thickness': 18.0,
      'qr_code': 'WF-B-OLDOLD01',
      'status': 'inStock',
      'created_at': longAgo.millisecondsSinceEpoch,
      'updated_at': longAgo.millisecondsSinceEpoch,
    });

    final recentBoard = await boardRepo.create(
      slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18,
    );

    final result = await dashboardService.build();
    expect(result.isSuccess, isTrue);
    expect(
      result.data.staleItems.any((item) => item.entityId == 'old-board'),
      isTrue,
      reason: 'a board created 400 days ago must be flagged as stale',
    );
    expect(
      result.data.staleItems.any((item) => item.entityId == recentBoard.data.id),
      isFalse,
      reason: 'a board created just now must never be flagged as stale',
    );
  });

  test('boundary: exactly 364 days old is NOT stale, exactly 365 days'
      ' old IS stale — the off-by-one most likely to break', () async {
    final now = DateTime.now();
    final justUnder = now.subtract(const Duration(days: 364));
    final exactlyThreshold = now.subtract(const Duration(days: 365));

    await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: now, updatedAt: now,
    ));
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );
    await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', createdAt: now, updatedAt: now),
    );

    final db = await dbService.open();
    await db.insert('boards', {
      'id': 'board-364',
      'slot_id': 's-1',
      'decor_id': _decorH3303,
      'length': 2800.0, 'width': 2070.0, 'thickness': 18.0,
      'qr_code': 'WF-B-D364DAYS',
      'status': 'inStock',
      'created_at': justUnder.millisecondsSinceEpoch,
      'updated_at': justUnder.millisecondsSinceEpoch,
    });
    await db.insert('boards', {
      'id': 'board-365',
      'slot_id': 's-1',
      'decor_id': _decorH3303,
      'length': 2800.0, 'width': 2070.0, 'thickness': 18.0,
      'qr_code': 'WF-B-D365DAYS',
      'status': 'inStock',
      'created_at': exactlyThreshold.millisecondsSinceEpoch,
      'updated_at': exactlyThreshold.millisecondsSinceEpoch,
    });

    final result = await dashboardService.build();
    expect(result.isSuccess, isTrue);
    expect(
      result.data.staleItems.any((item) => item.entityId == 'board-364'),
      isFalse,
      reason: '364 days old must NOT be flagged as stale yet',
    );
    expect(
      result.data.staleItems.any((item) => item.entityId == 'board-365'),
      isTrue,
      reason: '365 days old (the threshold itself) MUST be flagged as stale',
    );
  });

  test('stale items are sorted oldest-first', () async {
    final veryOld = DateTime.now().subtract(const Duration(days: 800));
    final old = DateTime.now().subtract(const Duration(days: 400));
    final recent = DateTime.now();

    await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: recent, updatedAt: recent,
    ));
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: recent, updatedAt: recent),
    );
    await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', createdAt: recent, updatedAt: recent),
    );

    final db = await dbService.open();
    for (final entry in [
      ('board-old', old.millisecondsSinceEpoch, 'WF-B-OLD00001'),
      ('board-very-old', veryOld.millisecondsSinceEpoch, 'WF-B-VOLD0001'),
    ]) {
      await db.insert('boards', {
        'id': entry.$1,
        'slot_id': 's-1',
        'decor_id': _decorH3303,
        'length': 2800.0,
        'width': 2070.0,
        'thickness': 18.0,
        'qr_code': entry.$3,
        'status': 'inStock',
        'created_at': entry.$2,
        'updated_at': entry.$2,
      });
    }

    final result = await dashboardService.build();
    expect(result.isSuccess, isTrue);
    expect(result.data.staleItems.length, 2);
    expect(result.data.staleItems.first.entityId, 'board-very-old');
    expect(result.data.staleItems.last.entityId, 'board-old');
  });
}
