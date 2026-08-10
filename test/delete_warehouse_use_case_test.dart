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
import 'package:woodflow/data/usecases/delete_warehouse_use_case_impl.dart';
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
  late DeleteWarehouseUseCaseImpl useCase;
  late WarehouseRepositoryImpl warehouseRepo;
  late RackRepositoryImpl rackRepo;
  late SlotRepositoryImpl slotRepo;
  late BoardRepositoryImpl boardRepo;
  late OffcutRepositoryImpl offcutRepo;

  setUp(() async {
    dbService = DatabaseService(const AppLogger(), inMemory: true);
    final events = InMemoryEventPublisher();
    warehouseRepo = WarehouseRepositoryImpl(dbService, const AppLogger());
    rackRepo = RackRepositoryImpl(dbService, const AppLogger());
    slotRepo = SlotRepositoryImpl(dbService, const AppLogger());
    final decorRepo = DecorRepositoryImpl(dbService, const AppLogger());
    boardRepo = BoardRepositoryImpl(dbService, const AppLogger(), events, slotRepo, decorRepo);
    offcutRepo = OffcutRepositoryImpl(dbService, const AppLogger(), events, boardRepo, slotRepo);
    useCase = DeleteWarehouseUseCaseImpl(dbService, const AppLogger(), events);
    await dbService.open();
  });

  tearDown(() async {
    await dbService.close();
  });

  Future<String> _seedWarehouseWithContents() async {
    final now = DateTime.now();
    final warehouse = await warehouseRepo.create(Warehouse(
      id: 'wh-del', organizationId: defaultOrganizationId,
      name: 'To delete', createdAt: now, updatedAt: now,
    ));
    await rackRepo.create(
      Rack(id: 'r-del', warehouseId: warehouse.data.id, name: 'A', createdAt: now, updatedAt: now),
    );
    await slotRepo.create(
      Slot(id: 's-del', rackId: 'r-del', name: 'A1', capacity: 20, createdAt: now, updatedAt: now),
    );
    return warehouse.data.id;
  }

  test('deletes the warehouse, its rack, and its slot', () async {
    final warehouseId = await _seedWarehouseWithContents();

    final result = await useCase(warehouseId);
    expect(result.isSuccess, isTrue);

    expect((await warehouseRepo.getById(warehouseId)).isFailure, isTrue);
    expect((await rackRepo.getById('r-del')).isFailure, isTrue);
    expect((await slotRepo.getById('s-del')).isFailure, isTrue);
  });

  test('active boards and offcuts inside are ARCHIVED, never deleted — '
      'the row still exists with status=archived, preserving the ledger', () async {
    final warehouseId = await _seedWarehouseWithContents();
    final board = await boardRepo.create(
        slotId: 's-del', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);
    final offcut = await offcutRepo.cutFromBoard(
        parentBoardId: board.data.id, slotId: 's-del', length: 400, width: 300, thickness: 18);

    final result = await useCase(warehouseId);
    expect(result.isSuccess, isTrue);

    // getById() with no includeArchived filter still finds archived rows —
    // matches BoardRepository/OffcutRepository's own getAll(includeArchived) shape.
    final boardAfter = await boardRepo.getById(board.data.id);
    expect(boardAfter.isSuccess, isTrue);
    expect(boardAfter.data.status, BoardStatus.archived);

    final offcutAfter = await offcutRepo.getById(offcut.data.id);
    expect(offcutAfter.isSuccess, isTrue);
    expect(offcutAfter.data.status, OffcutStatus.archived);

    // The ledger entry for the archive event must exist — this is the
    // whole point of archiving instead of deleting.
    final boardLedger = await boardRepo.getLedgerForBoard(board.data.id);
    expect(boardLedger.isSuccess, isTrue);
    expect(boardLedger.data.any((e) => e.eventType == 'archived'), isTrue);
  });

  test('a board already archived before warehouse deletion is left as-is', () async {
    final warehouseId = await _seedWarehouseWithContents();
    final board = await boardRepo.create(
        slotId: 's-del', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);
    await boardRepo.archive(board.data.id);

    final result = await useCase(warehouseId);
    expect(result.isSuccess, isTrue);

    final boardAfter = await boardRepo.getById(board.data.id);
    expect(boardAfter.data.status, BoardStatus.archived);
  });

  test('boards/racks/slots in OTHER warehouses are untouched', () async {
    final warehouseId = await _seedWarehouseWithContents();
    final now = DateTime.now();
    await warehouseRepo.create(Warehouse(
      id: 'wh-keep', organizationId: defaultOrganizationId,
      name: 'Keep me', createdAt: now, updatedAt: now,
    ));
    await rackRepo.create(
      Rack(id: 'r-keep', warehouseId: 'wh-keep', name: 'B', createdAt: now, updatedAt: now),
    );

    final result = await useCase(warehouseId);
    expect(result.isSuccess, isTrue);

    expect((await warehouseRepo.getById('wh-keep')).isSuccess, isTrue);
    expect((await rackRepo.getById('r-keep')).isSuccess, isTrue);
  });

  test('deleting a nonexistent warehouse fails and changes nothing', () async {
    final warehouseId = await _seedWarehouseWithContents();

    final result = await useCase('does-not-exist');
    expect(result.isFailure, isTrue);

    // The atomic transaction must not have touched the real warehouse.
    expect((await warehouseRepo.getById(warehouseId)).isSuccess, isTrue);
    expect((await rackRepo.getById('r-del')).isSuccess, isTrue);
    expect((await slotRepo.getById('s-del')).isSuccess, isTrue);
  });
}
