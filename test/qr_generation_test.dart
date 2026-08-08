import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:woodflow/core/logging/app_logger.dart';
import 'package:woodflow/core/events/event_publisher.dart';
import 'package:woodflow/data/database/database_service.dart';
import 'package:woodflow/data/database/qr_code_generator.dart';
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

const _decorH3303 = 'decor-h3303';
final _wfCodePattern = RegExp(r'^WF-[A-Z]-[0-9A-F]{8}$');

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseService dbService;
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
    await dbService.open();
  });

  tearDown(() async {
    await dbService.close();
  });

  test('qrCodeFromEntityId is a pure, deterministic function of the id'
      ' — same id always yields the same code, no randomness, no DB',
      () {
    final code1 = qrCodeFromEntityId('B', '550e8400-e29b-41d4-a716-446655440000');
    final code2 = qrCodeFromEntityId('B', '550e8400-e29b-41d4-a716-446655440000');
    expect(code1, code2);
    expect(code1, 'WF-B-550E8400');
  });

  test('Warehouse gets a "WF-W-######" code derived from its own id'
      ' on creation — ONE source of truth, not a second random value',
      () async {
    final now = DateTime(2026, 1, 1);
    final result = await warehouseRepo.create(Warehouse(
      id: 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
      organizationId: defaultOrganizationId,
      name: 'Warehouse A', createdAt: now, updatedAt: now,
    ));

    expect(result.isSuccess, isTrue);
    expect(result.data.qrCode, matches(_wfCodePattern));
    expect(result.data.qrCode, startsWith('WF-W-'));
    // Deterministically derivable from the id — not independent.
    expect(result.data.qrCode,
        qrCodeFromEntityId('W', 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'));
  });

  test('two different warehouses (different ids) get different codes'
      ' — collision only as likely as two different UUIDs colliding',
      () async {
    final now = DateTime(2026, 1, 1);
    final first = await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: now, updatedAt: now,
    ));
    final second = await warehouseRepo.create(Warehouse(
      id: 'wh-b', organizationId: defaultOrganizationId,
      name: 'B', createdAt: now, updatedAt: now,
    ));

    expect(first.data.qrCode, isNot(second.data.qrCode));
  });

  test('Rack and Slot get their own type-lettered codes ("WF-R-...",'
      ' "WF-S-..."), each derived from their own id', () async {
    final now = DateTime(2026, 1, 1);
    await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: now, updatedAt: now,
    ));
    final rack = await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );
    final slot = await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', createdAt: now, updatedAt: now),
    );

    expect(rack.data.qrCode, qrCodeFromEntityId('R', 'r-1'));
    expect(slot.data.qrCode, qrCodeFromEntityId('S', 's-1'));
  });

  test('Board and Offcut get "WF-B-..."/"WF-O-..." codes derived from'
      ' their own ids, not the old "board:uuid" format', () async {
    final now = DateTime(2026, 1, 1);
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
    expect(board.data.qrCode, qrCodeFromEntityId('B', board.data.id));

    final offcut = await offcutRepo.cutFromBoard(
      parentBoardId: board.data.id, slotId: 's-1', length: 400, width: 300, thickness: 18,
    );
    expect(offcut.data.qrCode, qrCodeFromEntityId('O', offcut.data.id));
  });

  test('getByQrCode resolves Warehouse/Rack/Slot by their generated code',
      () async {
    final now = DateTime(2026, 1, 1);
    final wh = await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: now, updatedAt: now,
    ));
    final rack = await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );
    final slot = await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', createdAt: now, updatedAt: now),
    );

    final whResult = await warehouseRepo.getByQrCode(wh.data.qrCode);
    expect(whResult.isSuccess, isTrue);
    expect(whResult.data.id, 'wh-a');

    final rackResult = await rackRepo.getByQrCode(rack.data.qrCode);
    expect(rackResult.data.id, 'r-1');

    final slotResult = await slotRepo.getByQrCode(slot.data.qrCode);
    expect(slotResult.data.id, 's-1');
  });

  test('getByQrCode on an unknown code returns NotFoundFailure', () async {
    final result = await warehouseRepo.getByQrCode('WF-W-999999');
    expect(result.isFailure, isTrue);
  });

  test('regenerateQrCode: Warehouse gets a NEW, independently-random code'
      ' (NOT derived from id, since id never changes) — old code no'
      ' longer resolves', () async {
    final now = DateTime(2026, 1, 1);
    final wh = await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: now, updatedAt: now,
    ));
    final oldCode = wh.data.qrCode;

    final regenerated = await warehouseRepo.regenerateQrCode('wh-a');
    expect(regenerated.isSuccess, isTrue);
    expect(regenerated.data.qrCode, isNot(oldCode));
    // No longer equal to the id-derived code either — proves this
    // path used randomQrCode(), not qrCodeFromEntityId() again.
    expect(regenerated.data.qrCode, isNot(qrCodeFromEntityId('W', 'wh-a')));

    final oldLookup = await warehouseRepo.getByQrCode(oldCode);
    expect(oldLookup.isFailure, isTrue);

    final newLookup = await warehouseRepo.getByQrCode(regenerated.data.qrCode);
    expect(newLookup.isSuccess, isTrue);
    expect(newLookup.data.id, 'wh-a');
  });

  test('regenerateQrCode for Board writes a ledger entry (auditable even'
      ' without enforced admin permission)', () async {
    final now = DateTime(2026, 1, 1);
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

    final regenerated = await boardRepo.regenerateQrCode(board.data.id);
    expect(regenerated.isSuccess, isTrue);
    expect(regenerated.data.qrCode, isNot(board.data.qrCode));

    final ledger = await boardRepo.getLedgerForBoard(board.data.id);
    expect(ledger.data.map((e) => e.eventType), contains('qrRegenerated'));
  });

  test('QR contains ONLY an identifier, never embedded data — moving a'
      ' board never changes its qrCode', () async {
    final now = DateTime(2026, 1, 1);
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
    await slotRepo.create(
      Slot(id: 's-2', rackId: 'r-1', name: 'A2', createdAt: now, updatedAt: now),
    );
    final board = await boardRepo.create(
      slotId: 's-1', decorId: _decorH3303, length: 2800, width: 2070, thickness: 18,
    );
    final qrBeforeMove = board.data.qrCode;

    final moved = await boardRepo.moveBoard(boardId: board.data.id, toSlotId: 's-2');
    expect(moved.data.qrCode, qrBeforeMove);
  });
}
