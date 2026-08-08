import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:woodflow/core/logging/app_logger.dart';
import 'package:woodflow/core/events/event_publisher.dart';
import 'package:woodflow/data/database/database_service.dart';
import 'package:woodflow/data/repositories/board_repository_impl.dart';
import 'package:woodflow/data/repositories/decor_repository_impl.dart';
import 'package:woodflow/data/repositories/rack_repository_impl.dart';
import 'package:woodflow/data/repositories/slot_repository_impl.dart';
import 'package:woodflow/data/repositories/warehouse_repository_impl.dart';
import 'package:woodflow/domain/entities/board.dart';
import 'package:woodflow/domain/entities/rack.dart';
import 'package:woodflow/domain/entities/slot.dart';
import 'package:woodflow/domain/entities/warehouse.dart';
import 'package:woodflow/domain/entities/organization.dart';
import 'package:woodflow/domain/events/board_events.dart';

// Matches the seed data inserted by V4AddDecorsMigration — tests
// don't need to create their own Decor rows, the migration already
// provides a handful for development/testing.
const _decorH3303 = 'decor-h3303';
const _decorU702 = 'decor-u702';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseService dbService;
  late BoardRepositoryImpl boardRepo;
  late SlotRepositoryImpl slotRepo;
  late RackRepositoryImpl rackRepo;
  late WarehouseRepositoryImpl warehouseRepo;
  late DecorRepositoryImpl decorRepo;
  late InMemoryEventPublisher events;

  setUp(() async {
    dbService = DatabaseService(const AppLogger(), inMemory: true);
    events = InMemoryEventPublisher();
    warehouseRepo = WarehouseRepositoryImpl(dbService, const AppLogger());
    rackRepo = RackRepositoryImpl(dbService, const AppLogger());
    slotRepo = SlotRepositoryImpl(dbService, const AppLogger());
    decorRepo = DecorRepositoryImpl(dbService, const AppLogger());
    boardRepo = BoardRepositoryImpl(
        dbService, const AppLogger(), events, slotRepo, decorRepo);

    // Opening the DB runs all migrations, including V4's decor seed
    // (decor-h3303, decor-u702, ...) — no manual seeding needed here.
    await dbService.open();

    final now = DateTime(2026, 1, 1);
    await warehouseRepo.create(
      Warehouse(id: 'wh-a', organizationId: defaultOrganizationId, name: 'Warehouse A', createdAt: now, updatedAt: now),
    );
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );
    await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', createdAt: now, updatedAt: now),
    );
  });

  tearDown(() async {
    await dbService.close();
  });

  test('v5 migration creates boards/board_transactions/ledger_entries,'
      ' boards has decor_id (not decor_code) and NO warehouse_id/rack_id',
      () async {
    final db = await dbService.open();
    for (final table in ['boards', 'board_transactions', 'ledger_entries']) {
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [table],
      );
      expect(result, isNotEmpty, reason: 'missing table: $table');
    }

    final columns = await db.rawQuery('PRAGMA table_info(boards)');
    final columnNames = columns.map((c) => c['name']).toSet();
    expect(columnNames, contains('slot_id'));
    expect(columnNames, contains('decor_id'));
    expect(columnNames, isNot(contains('decor_code')));
    expect(columnNames, isNot(contains('warehouse_id')));
    expect(columnNames, isNot(contains('rack_id')));
  });

  test('v4 migration seeds a handful of decors', () async {
    final result = await decorRepo.getByCode('H3303');
    expect(result.isSuccess, isTrue);
    expect(result.data.name, 'Natural Hamilton Oak');
  });

  test('create() fails fast with NotFoundFailure when slot does not exist,'
      ' no orphaned row written', () async {
    final result = await boardRepo.create(
      slotId: 'does-not-exist',
      decorId: _decorH3303,
      length: 2800,
      width: 2070,
      thickness: 18,
    );

    expect(result.isFailure, isTrue);

    final all = await boardRepo.getAll(includeArchived: true);
    expect(all.data, isEmpty);
  });

  test('create() fails fast with NotFoundFailure when decor does not exist',
      () async {
    final result = await boardRepo.create(
      slotId: 's-1',
      decorId: 'does-not-exist',
      length: 2800,
      width: 2070,
      thickness: 18,
    );

    expect(result.isFailure, isTrue);

    final all = await boardRepo.getAll(includeArchived: true);
    expect(all.data, isEmpty);
  });

  test('create() succeeds, writes a "created" ledger entry, publishes'
      ' BoardCreated', () async {
    final publishedEvents = <BoardCreated>[];
    events.events.listen((e) {
      if (e is BoardCreated) publishedEvents.add(e);
    });

    final result = await boardRepo.create(
      slotId: 's-1',
      decorId: _decorH3303,
      length: 2800,
      width: 2070,
      thickness: 18,
    );

    expect(result.isSuccess, isTrue);
    expect(result.data.slotId, 's-1');
    expect(result.data.decorId, _decorH3303);
    expect(result.data.status, BoardStatus.inStock);

    final ledger = await boardRepo.getLedgerForBoard(result.data.id);
    expect(ledger.data, hasLength(1));
    expect(ledger.data.first.eventType, 'created');

    await Future.delayed(Duration.zero);
    expect(publishedEvents, hasLength(1));
  });

  test('getFullLocation resolves the correct Warehouse > Rack > Slot chain',
      () async {
    final created = await boardRepo.create(
      slotId: 's-1',
      decorId: _decorH3303,
      length: 2800,
      width: 2070,
      thickness: 18,
    );

    final location = await boardRepo.getFullLocation(created.data.id);
    expect(location.isSuccess, isTrue);
    expect(location.data.warehouseId, 'wh-a');
    expect(location.data.rackId, 'r-1');
    expect(location.data.slotId, 's-1');
    expect(location.data.breadcrumb, 'Warehouse A > A > A1');
  });

  test('moveBoard updates slot_id, appends a "moved" ledger entry,'
      ' fails fast if target slot does not exist', () async {
    final now = DateTime(2026, 1, 1);
    await slotRepo.create(
      Slot(id: 's-2', rackId: 'r-1', name: 'A2', createdAt: now, updatedAt: now),
    );
    final created = await boardRepo.create(
      slotId: 's-1',
      decorId: _decorH3303,
      length: 2800,
      width: 2070,
      thickness: 18,
    );

    final badMove = await boardRepo.moveBoard(
      boardId: created.data.id,
      toSlotId: 'does-not-exist',
    );
    expect(badMove.isFailure, isTrue);

    final goodMove = await boardRepo.moveBoard(
      boardId: created.data.id,
      toSlotId: 's-2',
    );
    expect(goodMove.isSuccess, isTrue);
    expect(goodMove.data.slotId, 's-2');

    final ledger = await boardRepo.getLedgerForBoard(created.data.id);
    expect(ledger.data.map((e) => e.eventType), containsAll(['created', 'moved']));
  });

  test('archive() excludes from getAll by default, keeps ledger and'
      ' getById intact', () async {
    final created = await boardRepo.create(
      slotId: 's-1',
      decorId: _decorH3303,
      length: 2800,
      width: 2070,
      thickness: 18,
    );

    final archiveResult = await boardRepo.archive(created.data.id);
    expect(archiveResult.isSuccess, isTrue);

    final defaultList = await boardRepo.getAll();
    expect(defaultList.data, isEmpty);

    final withArchived = await boardRepo.getAll(includeArchived: true);
    expect(withArchived.data, hasLength(1));

    final byId = await boardRepo.getById(created.data.id);
    expect(byId.isSuccess, isTrue);
  });

  test('getByRack and getByWarehouse resolve via JOIN correctly', () async {
    final now = DateTime(2026, 1, 1);
    await warehouseRepo.create(
      Warehouse(id: 'wh-b', organizationId: defaultOrganizationId, name: 'Warehouse B', createdAt: now, updatedAt: now),
    );
    await rackRepo.create(
      Rack(id: 'r-2', warehouseId: 'wh-b', name: 'B', createdAt: now, updatedAt: now),
    );
    await slotRepo.create(
      Slot(id: 's-3', rackId: 'r-2', name: 'B1', createdAt: now, updatedAt: now),
    );

    await boardRepo.create(
      slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18,
    );
    await boardRepo.create(
      slotId: 's-3', decorId: _decorU702, length: 2800, width: 2070, thickness: 18,
    );

    final byRack = await boardRepo.getByRack('r-1');
    expect(byRack.data, hasLength(1));
    expect(byRack.data.first.decorId, _decorH3303);

    final byWarehouse = await boardRepo.getByWarehouse('wh-b');
    expect(byWarehouse.data, hasLength(1));
    expect(byWarehouse.data.first.decorId, _decorU702);
  });

  test('getByQrCode finds a board by its printed code', () async {
    final created = await boardRepo.create(
      slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18,
    );

    final result = await boardRepo.getByQrCode(created.data.qrCode);
    expect(result.isSuccess, isTrue);
    expect(result.data.id, created.data.id);
  });
}
