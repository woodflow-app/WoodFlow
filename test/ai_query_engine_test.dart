import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:woodflow/core/logging/app_logger.dart';
import 'package:woodflow/core/events/event_publisher.dart';
import 'package:woodflow/data/ai_patterns/ai_patterns_registry.dart';
import 'package:woodflow/data/database/database_service.dart';
import 'package:woodflow/data/repositories/board_repository_impl.dart';
import 'package:woodflow/data/repositories/decor_repository_impl.dart';
import 'package:woodflow/data/repositories/offcut_repository_impl.dart';
import 'package:woodflow/data/repositories/rack_repository_impl.dart';
import 'package:woodflow/data/repositories/slot_repository_impl.dart';
import 'package:woodflow/data/repositories/warehouse_repository_impl.dart';
import 'package:woodflow/domain/entities/ai_query_answer.dart';
import 'package:woodflow/domain/entities/organization.dart';
import 'package:woodflow/domain/entities/rack.dart';
import 'package:woodflow/domain/entities/slot.dart';
import 'package:woodflow/domain/entities/warehouse.dart';
import 'package:woodflow/domain/services/ai_query_engine.dart';
import 'package:woodflow/domain/services/ai_query_parser.dart';
import 'package:woodflow/domain/services/dashboard_service.dart';
import 'package:woodflow/domain/services/offcut_match_finder.dart';
import 'package:woodflow/domain/services/shopping_list_service.dart';

const _decorH3303 = 'decor-h3303'; // seeded by v4, manufacturer EGGER
const _decorU702 = 'decor-u702'; // seeded by v4, manufacturer EGGER

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseService dbService;
  late AiQueryEngine engine;
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
    final dashboardService = DashboardService(
      warehouseRepo, rackRepo, slotRepo, boardRepo, offcutRepo, decorRepo,
    );
    final shoppingListService = ShoppingListService(decorRepo, boardRepo, offcutRepo);
    engine = AiQueryEngine(
      AiQueryParser(aiPatternsRegistry),
      decorRepo,
      boardRepo,
      offcutRepo,
      dashboardService,
      shoppingListService,
      const OffcutMatchFinder(),
    );
    await dbService.open();

    final now = DateTime.now();
    await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'Warsztat główny', createdAt: now, updatedAt: now,
    ));
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );
    await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', capacity: 50, createdAt: now, updatedAt: now),
    );
  });

  tearDown(() async {
    await dbService.close();
  });

  test('stock quantity: counts boards and offcuts of the named decor', () async {
    await boardRepo.create(slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);
    await boardRepo.create(slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);

    final result = await engine.ask('Ile mam H3303?', 'pl');
    expect(result.isSuccess, isTrue);
    final answer = result.data as StockQuantityAnswer;
    expect(answer.decor.id, _decorH3303);
    expect(answer.quantity, 2);
  });

  test('location: resolves the full warehouse > rack > slot breadcrumb'
      ' for each matching board', () async {
    await boardRepo.create(slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);

    final result = await engine.ask('Gdzie jest H3303?', 'pl');
    expect(result.isSuccess, isTrue);
    final answer = result.data as LocationAnswer;
    expect(answer.locations, hasLength(1));
    expect(answer.locations.single.location.breadcrumb, contains('Warsztat główny'));
  });

  test('location: a decor with no boards in stock answers with an empty'
      ' list, not Unrecognized — the decor WAS found', () async {
    final result = await engine.ask('Gdzie jest H3303?', 'pl');
    expect(result.isSuccess, isTrue);
    final answer = result.data as LocationAnswer;
    expect(answer.locations, isEmpty);
  });

  test('dimensions: covers both boards and offcuts of the named decor', () async {
    final board = await boardRepo.create(
        slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);
    await offcutRepo.cutFromBoard(
        parentBoardId: board.data.id, slotId: 's-1', length: 400, width: 300, thickness: 18);

    final result = await engine.ask('Jakie wymiary ma H3303?', 'pl');
    expect(result.isSuccess, isTrue);
    final answer = result.data as DimensionsAnswer;
    expect(answer.hits, hasLength(2));
  });

  test('stale materials: reuses DashboardService\'s own >1-year definition,'
      ' unfiltered when no decor is named', () async {
    final longAgo = DateTime.now().subtract(const Duration(days: 400));
    final db = await dbService.open();
    await db.insert('boards', {
      'id': 'old-board',
      'slot_id': 's-1',
      'decor_id': _decorH3303,
      'length': 2800.0, 'width': 2070.0, 'thickness': 18.0,
      'qr_code': 'WF-B-OLDOLD01',
      'status': 'inStock',
      'created_at': longAgo.millisecondsSinceEpoch,
      'updated_at': longAgo.millisecondsSinceEpoch,
    });

    final result = await engine.ask('Pokaż zalegające materiały', 'pl');
    expect(result.isSuccess, isTrue);
    final answer = result.data as StaleMaterialsAnswer;
    expect(answer.items.any((i) => i.entityId == 'old-board'), isTrue);
  });

  test('stale materials: filters to the named decor when one is given', () async {
    final longAgo = DateTime.now().subtract(const Duration(days: 400));
    final db = await dbService.open();
    await db.insert('boards', {
      'id': 'old-h3303',
      'slot_id': 's-1',
      'decor_id': _decorH3303,
      'length': 2800.0, 'width': 2070.0, 'thickness': 18.0,
      'qr_code': 'WF-B-OLDH3303',
      'status': 'inStock',
      'created_at': longAgo.millisecondsSinceEpoch,
      'updated_at': longAgo.millisecondsSinceEpoch,
    });
    await db.insert('boards', {
      'id': 'old-u702',
      'slot_id': 's-1',
      'decor_id': _decorU702,
      'length': 2800.0, 'width': 2070.0, 'thickness': 18.0,
      'qr_code': 'WF-B-OLDU7020',
      'status': 'inStock',
      'created_at': longAgo.millisecondsSinceEpoch,
      'updated_at': longAgo.millisecondsSinceEpoch,
    });

    final result = await engine.ask('Pokaż zalegające materiały H3303', 'pl');
    expect(result.isSuccess, isTrue);
    final answer = result.data as StaleMaterialsAnswer;
    expect(answer.items.map((i) => i.entityId), ['old-h3303']);
  });

  test('offcut match: finds a same-decor offcut big enough for the'
      ' requested size, computing its waste area', () async {
    final board = await boardRepo.create(
        slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18);
    await offcutRepo.cutFromBoard(
        parentBoardId: board.data.id, slotId: 's-1', length: 700, width: 500, thickness: 18);

    final result = await engine.ask('Czym zastąpić H3303 600x400?', 'pl');
    expect(result.isSuccess, isTrue);
    final answer = result.data as OffcutMatchAnswer;
    expect(answer.candidates, hasLength(1));
    expect(answer.candidates.single.wasteAreaMm2, (700 * 500) - (600 * 400));
  });

  test('unrecognized: text matching no trigger phrase never guesses', () async {
    final result = await engine.ask('Dzień dobry, co słychać?', 'pl');
    expect(result.isSuccess, isTrue);
    final answer = result.data as UnrecognizedQueryAnswer;
    expect(answer.rawText, 'Dzień dobry, co słychać?');
  });

  test('unrecognized: intent matched but the named decor does not exist', () async {
    final result = await engine.ask('Ile mam ZZZZ999?', 'pl');
    expect(result.isSuccess, isTrue);
    expect(result.data, isA<UnrecognizedQueryAnswer>());
  });
}
