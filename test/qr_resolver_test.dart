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
import 'package:woodflow/domain/services/qr_resolution.dart';
import 'package:woodflow/domain/services/qr_resolver.dart';

const _decorH3303 = 'decor-h3303';

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
  late QrResolver resolver;

  setUp(() async {
    dbService = DatabaseService(const AppLogger(), inMemory: true);
    final events = InMemoryEventPublisher();
    warehouseRepo = WarehouseRepositoryImpl(dbService, const AppLogger());
    rackRepo = RackRepositoryImpl(dbService, const AppLogger());
    slotRepo = SlotRepositoryImpl(dbService, const AppLogger());
    final decorRepo = DecorRepositoryImpl(dbService, const AppLogger());
    boardRepo = BoardRepositoryImpl(dbService, const AppLogger(), events, slotRepo, decorRepo);
    offcutRepo = OffcutRepositoryImpl(dbService, const AppLogger(), events, boardRepo, slotRepo);
    resolver = QrResolver(warehouseRepo, rackRepo, slotRepo, boardRepo, offcutRepo);
    await dbService.open();
  });

  tearDown(() async {
    await dbService.close();
  });

  test('resolves a Warehouse code to WarehouseFound', () async {
    final now = DateTime(2026, 1, 1);
    final wh = await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'Warehouse A', createdAt: now, updatedAt: now,
    ));

    final resolution = await resolver.resolve(wh.data.qrCode);
    expect(resolution, isA<WarehouseFound>());
    expect((resolution as WarehouseFound).warehouse.id, 'wh-a');
  });

  test('resolves a Rack code to RackFound', () async {
    final now = DateTime(2026, 1, 1);
    await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: now, updatedAt: now,
    ));
    final rack = await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );

    final resolution = await resolver.resolve(rack.data.qrCode);
    expect(resolution, isA<RackFound>());
    expect((resolution as RackFound).rack.id, 'r-1');
  });

  test('resolves a Slot code to SlotFound', () async {
    final now = DateTime(2026, 1, 1);
    await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: now, updatedAt: now,
    ));
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );
    final slot = await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', createdAt: now, updatedAt: now),
    );

    final resolution = await resolver.resolve(slot.data.qrCode);
    expect(resolution, isA<SlotFound>());
    expect((resolution as SlotFound).slot.id, 's-1');
  });

  test('resolves a Board code to BoardFound', () async {
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

    final resolution = await resolver.resolve(board.data.qrCode);
    expect(resolution, isA<BoardFound>());
    expect((resolution as BoardFound).board.id, board.data.id);
  });

  test('resolves an Offcut code to OffcutFound', () async {
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
    final offcut = await offcutRepo.cutFromBoard(
      parentBoardId: board.data.id, slotId: 's-1', length: 400, width: 300, thickness: 18,
    );

    final resolution = await resolver.resolve(offcut.data.qrCode);
    expect(resolution, isA<OffcutFound>());
    expect((resolution as OffcutFound).offcut.id, offcut.data.id);
  });

  test('a well-formed but unknown code resolves to QrNotFound', () async {
    final resolution = await resolver.resolve('WF-B-DEADBEEF');
    expect(resolution, isA<QrNotFound>());
  });

  test('a malformed code (wrong format entirely) resolves to QrNotFound,'
      ' never throws', () async {
    final resolution = await resolver.resolve('not-a-woodflow-code');
    expect(resolution, isA<QrNotFound>());
  });

  test('an unknown type letter resolves to QrNotFound', () async {
    final resolution = await resolver.resolve('WF-Z-12345678');
    expect(resolution, isA<QrNotFound>());
  });

  test('whitespace around a valid code is trimmed before resolving',
      () async {
    final now = DateTime(2026, 1, 1);
    final wh = await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: now, updatedAt: now,
    ));

    final resolution = await resolver.resolve('  ${wh.data.qrCode}  ');
    expect(resolution, isA<WarehouseFound>());
  });

  test('DECISION: matching is case-INSENSITIVE — lowercase and mixed-case'
      ' input resolve exactly the same as the canonical uppercase code'
      ' (see qr_resolver.dart doc comment for why)', () async {
    final now = DateTime(2026, 1, 1);
    final wh = await warehouseRepo.create(Warehouse(
      id: 'wh-a', organizationId: defaultOrganizationId,
      name: 'A', createdAt: now, updatedAt: now,
    ));
    final canonical = wh.data.qrCode; // e.g. WF-W-AAAAAAAA

    final lowercase = await resolver.resolve(canonical.toLowerCase());
    expect(lowercase, isA<WarehouseFound>());
    expect((lowercase as WarehouseFound).warehouse.id, 'wh-a');

    final mixedCase = await resolver.resolve('wf-W-${canonical.split('-')[2].toLowerCase()}');
    expect(mixedCase, isA<WarehouseFound>());
    expect((mixedCase as WarehouseFound).warehouse.id, 'wh-a');
  });
}
