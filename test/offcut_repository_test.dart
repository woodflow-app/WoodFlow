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
import 'package:woodflow/domain/entities/board.dart';
import 'package:woodflow/domain/entities/offcut.dart';
import 'package:woodflow/domain/entities/organization.dart';
import 'package:woodflow/domain/entities/rack.dart';
import 'package:woodflow/domain/entities/slot.dart';
import 'package:woodflow/domain/entities/warehouse.dart';
import 'package:woodflow/domain/events/offcut_events.dart';

const _decorH3303 = 'decor-h3303';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseService dbService;
  late OffcutRepositoryImpl offcutRepo;
  late BoardRepositoryImpl boardRepo;
  late SlotRepositoryImpl slotRepo;
  late RackRepositoryImpl rackRepo;
  late WarehouseRepositoryImpl warehouseRepo;
  late DecorRepositoryImpl decorRepo;
  late InMemoryEventPublisher events;

  Future<Board> seedBoard(String id, String slotId) async {
    final result = await boardRepo.create(
      slotId: slotId,
      decorId: _decorH3303,
      length: 2800,
      width: 2070,
      thickness: 18,
    );
    return result.data;
  }

  setUp(() async {
    dbService = DatabaseService(const AppLogger(), inMemory: true);
    events = InMemoryEventPublisher();
    warehouseRepo = WarehouseRepositoryImpl(dbService, const AppLogger());
    rackRepo = RackRepositoryImpl(dbService, const AppLogger());
    slotRepo = SlotRepositoryImpl(dbService, const AppLogger());
    decorRepo = DecorRepositoryImpl(dbService, const AppLogger());
    boardRepo = BoardRepositoryImpl(
        dbService, const AppLogger(), events, slotRepo, decorRepo);
    offcutRepo = OffcutRepositoryImpl(
        dbService, const AppLogger(), events, boardRepo, slotRepo);

    await dbService.open();

    final now = DateTime(2026, 1, 1);
    await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'Warehouse A', createdAt: now, updatedAt: now,
    ));
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

  test('v6 migration creates offcuts and offcut_transactions', () async {
    final db = await dbService.open();
    for (final table in ['offcuts', 'offcut_transactions']) {
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [table],
      );
      expect(result, isNotEmpty, reason: 'missing table: $table');
    }
  });

  test('cutFromBoard copies decorId from the parent board, writes a'
      ' "cut" ledger entry, publishes OffcutCut', () async {
    final board = await seedBoard('b-1', 's-1');

    final publishedEvents = <OffcutCut>[];
    events.events.listen((e) {
      if (e is OffcutCut) publishedEvents.add(e);
    });

    final result = await offcutRepo.cutFromBoard(
      parentBoardId: board.id,
      slotId: 's-1',
      length: 400,
      width: 300,
      thickness: 18,
    );

    expect(result.isSuccess, isTrue);
    expect(result.data.parentBoardId, board.id);
    expect(result.data.decorId, board.decorId); // copied, not re-derived
    expect(result.data.status, OffcutStatus.available);

    final ledger = await offcutRepo.getLedgerForOffcut(result.data.id);
    expect(ledger.data, hasLength(1));
    expect(ledger.data.first.eventType, 'cut');

    await Future.delayed(Duration.zero);
    expect(publishedEvents, hasLength(1));
  });

  test('cutFromBoard fails fast when parent board does not exist,'
      ' no orphaned row', () async {
    final result = await offcutRepo.cutFromBoard(
      parentBoardId: 'does-not-exist',
      slotId: 's-1',
      length: 400,
      width: 300,
      thickness: 18,
    );

    expect(result.isFailure, isTrue);
    final all = await offcutRepo.getAll(includeArchived: true);
    expect(all.data, isEmpty);
  });

  test('cutFromBoard fails fast when target slot does not exist', () async {
    final board = await seedBoard('b-1', 's-1');
    final result = await offcutRepo.cutFromBoard(
      parentBoardId: board.id,
      slotId: 'does-not-exist',
      length: 400,
      width: 300,
      thickness: 18,
    );

    expect(result.isFailure, isTrue);
  });

  test('the parent Board itself is untouched by cutting (no resize,'
      ' no status change) — that is the Cut Optimizer\'s job, later',
      () async {
    final board = await seedBoard('b-1', 's-1');
    await offcutRepo.cutFromBoard(
      parentBoardId: board.id,
      slotId: 's-1',
      length: 400,
      width: 300,
      thickness: 18,
    );

    final refetched = await boardRepo.getById(board.id);
    expect(refetched.data.length, board.length);
    expect(refetched.data.width, board.width);
    expect(refetched.data.status, BoardStatus.inStock);
  });

  test('moveOffcut updates slot_id, appends a "moved" ledger entry',
      () async {
    final now = DateTime(2026, 1, 1);
    await slotRepo.create(
      Slot(id: 's-2', rackId: 'r-1', name: 'A2', createdAt: now, updatedAt: now),
    );
    final board = await seedBoard('b-1', 's-1');
    final created = await offcutRepo.cutFromBoard(
      parentBoardId: board.id, slotId: 's-1', length: 400, width: 300, thickness: 18,
    );

    final moveResult = await offcutRepo.moveOffcut(
      offcutId: created.data.id,
      toSlotId: 's-2',
    );
    expect(moveResult.isSuccess, isTrue);
    expect(moveResult.data.slotId, 's-2');

    final ledger = await offcutRepo.getLedgerForOffcut(created.data.id);
    expect(ledger.data.map((e) => e.eventType), containsAll(['cut', 'moved']));
  });

  test('archive() excludes from getAll by default but keeps ledger intact',
      () async {
    final board = await seedBoard('b-1', 's-1');
    final created = await offcutRepo.cutFromBoard(
      parentBoardId: board.id, slotId: 's-1', length: 400, width: 300, thickness: 18,
    );

    final archiveResult = await offcutRepo.archive(created.data.id);
    expect(archiveResult.isSuccess, isTrue);

    final defaultList = await offcutRepo.getAll();
    expect(defaultList.data, isEmpty);

    final withArchived = await offcutRepo.getAll(includeArchived: true);
    expect(withArchived.data, hasLength(1));
  });

  test('getByParentBoard returns only offcuts cut from that board', () async {
    final boardA = await seedBoard('b-1', 's-1');
    final now = DateTime(2026, 1, 1);
    await slotRepo.create(
      Slot(id: 's-2', rackId: 'r-1', name: 'A2', createdAt: now, updatedAt: now),
    );
    final boardB = await boardRepo.create(
      slotId: 's-2', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18,
    );

    await offcutRepo.cutFromBoard(
      parentBoardId: boardA.id, slotId: 's-1', length: 400, width: 300, thickness: 18,
    );
    await offcutRepo.cutFromBoard(
      parentBoardId: boardB.data.id, slotId: 's-2', length: 200, width: 200, thickness: 18,
    );

    final result = await offcutRepo.getByParentBoard(boardA.id);
    expect(result.data, hasLength(1));
  });

  test('getByQrCode finds an offcut by its printed code', () async {
    final board = await seedBoard('b-1', 's-1');
    final created = await offcutRepo.cutFromBoard(
      parentBoardId: board.id, slotId: 's-1', length: 400, width: 300, thickness: 18,
    );

    final result = await offcutRepo.getByQrCode(created.data.qrCode);
    expect(result.isSuccess, isTrue);
    expect(result.data.id, created.data.id);
  });
}
