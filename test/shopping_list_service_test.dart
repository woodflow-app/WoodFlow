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
import 'package:woodflow/domain/entities/rack.dart';
import 'package:woodflow/domain/entities/slot.dart';
import 'package:woodflow/domain/services/shopping_list_service.dart';

const _decorH3303 = 'decor-h3303'; // seeded by v4, manufacturer EGGER
const _decorU702 = 'decor-u702'; // seeded by v4, manufacturer EGGER

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseService dbService;
  late ShoppingListService shoppingListService;
  late RackRepositoryImpl rackRepo;
  late SlotRepositoryImpl slotRepo;
  late BoardRepositoryImpl boardRepo;
  late OffcutRepositoryImpl offcutRepo;
  late DecorRepositoryImpl decorRepo;

  setUp(() async {
    dbService = DatabaseService(const AppLogger(), inMemory: true);
    final events = InMemoryEventPublisher();
    rackRepo = RackRepositoryImpl(dbService, const AppLogger());
    slotRepo = SlotRepositoryImpl(dbService, const AppLogger());
    decorRepo = DecorRepositoryImpl(dbService, const AppLogger());
    boardRepo = BoardRepositoryImpl(dbService, const AppLogger(), events, slotRepo, decorRepo);
    offcutRepo = OffcutRepositoryImpl(dbService, const AppLogger(), events, boardRepo, slotRepo);
    shoppingListService = ShoppingListService(decorRepo, boardRepo, offcutRepo);
    await dbService.open();

    final now = DateTime.now();
    await rackRepo.create(Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now));
    await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', capacity: 50, createdAt: now, updatedAt: now),
    );
  });

  tearDown(() async {
    await dbService.close();
  });

  test('a decor with no threshold never appears, regardless of stock', () async {
    final result = await shoppingListService.build();
    expect(result.isSuccess, isTrue);
    expect(result.data, isEmpty);
  });

  test('a decor below its threshold appears with the correct shortage', () async {
    final decorResult = await decorRepo.getById(_decorH3303);
    await decorRepo.update(decorResult.data.copyWith(minimumStockQuantity: 5));

    // Only 2 boards in stock — below the threshold of 5.
    await boardRepo.create(slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);
    await boardRepo.create(slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);

    final result = await shoppingListService.build();
    expect(result.isSuccess, isTrue);
    expect(result.data, hasLength(1));
    expect(result.data.first.decor.id, _decorH3303);
    expect(result.data.first.currentStock, 2);
    expect(result.data.first.shortageQuantity, 3);
  });

  test('a decor at or above its threshold does not appear', () async {
    final decorResult = await decorRepo.getById(_decorH3303);
    await decorRepo.update(decorResult.data.copyWith(minimumStockQuantity: 2));

    await boardRepo.create(slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);
    await boardRepo.create(slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);

    final result = await shoppingListService.build();
    expect(result.isSuccess, isTrue);
    expect(result.data, isEmpty);
  });

  test('boards and offcuts of the same decor both count toward current stock', () async {
    final decorResult = await decorRepo.getById(_decorH3303);
    await decorRepo.update(decorResult.data.copyWith(minimumStockQuantity: 3));

    final board = await boardRepo.create(
        slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);
    await offcutRepo.cutFromBoard(
        parentBoardId: board.data.id, slotId: 's-1', length: 400, width: 300, thickness: 18);

    final result = await shoppingListService.build();
    // 1 board + 1 offcut = 2, below threshold of 3.
    expect(result.data.first.currentStock, 2);
    expect(result.data.first.shortageQuantity, 1);
  });

  test('archived boards do not count toward current stock — matches'
      ' getAll()\'s default excludeArchived behavior', () async {
    final decorResult = await decorRepo.getById(_decorH3303);
    await decorRepo.update(decorResult.data.copyWith(minimumStockQuantity: 1));

    final board = await boardRepo.create(
        slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);
    await boardRepo.archive(board.data.id);

    final result = await shoppingListService.build();
    expect(result.data.first.currentStock, 0);
    expect(result.data.first.shortageQuantity, 1);
  });

  test('items are sorted by shortage, most urgent first', () async {
    final h3303 = await decorRepo.getById(_decorH3303);
    await decorRepo.update(h3303.data.copyWith(minimumStockQuantity: 10)); // shortage 10
    final u702 = await decorRepo.getById(_decorU702);
    await decorRepo.update(u702.data.copyWith(minimumStockQuantity: 2)); // shortage 2
    await boardRepo.create(slotId: 's-1', decorId: _decorU702, length: 2800, width: 2070, thickness: 18);

    final result = await shoppingListService.build();
    expect(result.data.map((i) => i.decor.id), [_decorH3303, _decorU702]);
  });

  test('clearing a threshold (copyWith explicit null) removes the decor'
      ' from the list', () async {
    final decorResult = await decorRepo.getById(_decorH3303);
    await decorRepo.update(decorResult.data.copyWith(minimumStockQuantity: 5));
    expect((await shoppingListService.build()).data, isNotEmpty);

    final withThreshold = await decorRepo.getById(_decorH3303);
    await decorRepo.update(withThreshold.data.copyWith(minimumStockQuantity: null));

    final result = await shoppingListService.build();
    expect(result.data, isEmpty);
  });
}
