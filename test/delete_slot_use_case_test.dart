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
import 'package:woodflow/data/usecases/delete_slot_use_case_impl.dart';
import 'package:woodflow/domain/entities/board.dart';
import 'package:woodflow/domain/entities/offcut.dart';
import 'package:woodflow/domain/entities/organization.dart';
import 'package:woodflow/domain/entities/rack.dart';
import 'package:woodflow/domain/entities/slot.dart';
import 'package:woodflow/domain/entities/warehouse.dart';

const _decorH3303 = 'decor-h3303'; // seeded by v4, manufacturer EGGER

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseService dbService;
  late DeleteSlotUseCaseImpl useCase;
  late RackRepositoryImpl rackRepo;
  late SlotRepositoryImpl slotRepo;
  late BoardRepositoryImpl boardRepo;
  late OffcutRepositoryImpl offcutRepo;

  setUp(() async {
    dbService = DatabaseService(const AppLogger(), inMemory: true);
    final events = InMemoryEventPublisher();
    final warehouseRepo = WarehouseRepositoryImpl(dbService, const AppLogger());
    rackRepo = RackRepositoryImpl(dbService, const AppLogger());
    slotRepo = SlotRepositoryImpl(dbService, const AppLogger());
    final decorRepo = DecorRepositoryImpl(dbService, const AppLogger());
    boardRepo = BoardRepositoryImpl(dbService, const AppLogger(), events, slotRepo, decorRepo);
    offcutRepo = OffcutRepositoryImpl(dbService, const AppLogger(), events, boardRepo, slotRepo);
    useCase = DeleteSlotUseCaseImpl(dbService, const AppLogger(), events);
    await dbService.open();

    final now = DateTime.now();
    await warehouseRepo.create(Warehouse(
      id: 'wh-1', organizationId: defaultOrganizationId,
      name: 'WH', createdAt: now, updatedAt: now,
    ));
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-1', name: 'A', createdAt: now, updatedAt: now),
    );
  });

  tearDown(() async {
    await dbService.close();
  });

  Future<void> _seedSlot(String id, {String rackId = 'r-1'}) async {
    final now = DateTime.now();
    await slotRepo.create(
      Slot(id: id, rackId: rackId, name: 'Slot $id', capacity: 20, createdAt: now, updatedAt: now),
    );
  }

  test('deletes the slot', () async {
    await _seedSlot('s-del');

    final result = await useCase('s-del');
    expect(result.isSuccess, isTrue);
    expect((await slotRepo.getById('s-del')).isFailure, isTrue);
  });

  test('active boards and offcuts inside are ARCHIVED, never deleted — '
      'the row still exists with status=archived, preserving the ledger', () async {
    await _seedSlot('s-del');
    final board = await boardRepo.create(
        slotId: 's-del', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);
    final offcut = await offcutRepo.cutFromBoard(
        parentBoardId: board.data.id, slotId: 's-del', length: 400, width: 300, thickness: 18);

    final result = await useCase('s-del');
    expect(result.isSuccess, isTrue);

    final boardAfter = await boardRepo.getById(board.data.id);
    expect(boardAfter.isSuccess, isTrue);
    expect(boardAfter.data.status, BoardStatus.archived);

    final offcutAfter = await offcutRepo.getById(offcut.data.id);
    expect(offcutAfter.isSuccess, isTrue);
    expect(offcutAfter.data.status, OffcutStatus.archived);

    final boardLedger = await boardRepo.getLedgerForBoard(board.data.id);
    expect(boardLedger.isSuccess, isTrue);
    expect(boardLedger.data.any((e) => e.eventType == 'archived'), isTrue);
  });

  test('a board already archived before slot deletion is left as-is', () async {
    await _seedSlot('s-del');
    final board = await boardRepo.create(
        slotId: 's-del', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);
    await boardRepo.archive(board.data.id);

    final result = await useCase('s-del');
    expect(result.isSuccess, isTrue);

    final boardAfter = await boardRepo.getById(board.data.id);
    expect(boardAfter.data.status, BoardStatus.archived);
  });

  test('boards/offcuts in OTHER slots are untouched', () async {
    await _seedSlot('s-del');
    await _seedSlot('s-keep');
    final board = await boardRepo.create(
        slotId: 's-keep', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);

    final result = await useCase('s-del');
    expect(result.isSuccess, isTrue);

    expect((await slotRepo.getById('s-keep')).isSuccess, isTrue);
    final boardAfter = await boardRepo.getById(board.data.id);
    expect(boardAfter.data.status, BoardStatus.inStock);
  });

  test('deleting a nonexistent slot fails and changes nothing', () async {
    await _seedSlot('s-del');

    final result = await useCase('does-not-exist');
    expect(result.isFailure, isTrue);

    expect((await slotRepo.getById('s-del')).isSuccess, isTrue);
  });
}
