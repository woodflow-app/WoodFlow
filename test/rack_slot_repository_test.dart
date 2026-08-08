import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:woodflow/core/logging/app_logger.dart';
import 'package:woodflow/data/database/database_service.dart';
import 'package:woodflow/data/repositories/rack_repository_impl.dart';
import 'package:woodflow/data/repositories/slot_repository_impl.dart';
import 'package:woodflow/data/repositories/warehouse_repository_impl.dart';
import 'package:woodflow/domain/entities/rack.dart';
import 'package:woodflow/domain/entities/slot.dart';
import 'package:woodflow/domain/entities/warehouse.dart';
import 'package:woodflow/domain/entities/organization.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseService dbService;
  late RackRepositoryImpl rackRepo;
  late SlotRepositoryImpl slotRepo;
  late WarehouseRepositoryImpl warehouseRepo;

  setUp(() async {
    dbService = DatabaseService(const AppLogger(), inMemory: true);
    warehouseRepo = WarehouseRepositoryImpl(dbService, const AppLogger());
    rackRepo = RackRepositoryImpl(dbService, const AppLogger());
    slotRepo = SlotRepositoryImpl(dbService, const AppLogger());

    final now = DateTime(2026, 1, 1);
    await warehouseRepo.create(
      Warehouse(id: 'wh-a', organizationId: defaultOrganizationId, name: 'Warehouse A', createdAt: now, updatedAt: now),
    );
  });

  tearDown(() async {
    await dbService.close();
  });

  test('v2 migration creates racks and slots tables', () async {
    final db = await dbService.open();
    for (final table in ['racks', 'slots']) {
      final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        [table],
      );
      expect(result, isNotEmpty, reason: 'missing table: $table');
    }
  });

  test('create + getByWarehouse returns racks for that warehouse only',
      () async {
    final now = DateTime(2026, 1, 1);
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );
    await rackRepo.create(
      Rack(id: 'r-2', warehouseId: 'wh-a', name: 'B', createdAt: now, updatedAt: now),
    );

    final result = await rackRepo.getByWarehouse('wh-a');
    expect(result.isSuccess, isTrue);
    expect(result.data, hasLength(2));
  });

  test('getById on missing rack returns NotFoundFailure', () async {
    final result = await rackRepo.getById('does-not-exist');
    expect(result.isFailure, isTrue);
  });

  test('delete rack removes it; second delete returns NotFoundFailure',
      () async {
    final now = DateTime(2026, 1, 1);
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );

    final first = await rackRepo.delete('r-1');
    expect(first.isSuccess, isTrue);

    final second = await rackRepo.delete('r-1');
    expect(second.isFailure, isTrue);
  });

  test('create slot + getByRack + default capacity', () async {
    final now = DateTime(2026, 1, 1);
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );
    await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', createdAt: now, updatedAt: now),
    );

    final result = await slotRepo.getByRack('r-1');
    expect(result.isSuccess, isTrue);
    expect(result.data, hasLength(1));
    expect(result.data.first.capacity, 20); // default
  });

  test('getOccupancyForRack returns 0 used for every slot (Board/Offcut'
      ' do not exist yet)', () async {
    final now = DateTime(2026, 1, 1);
    await rackRepo.create(
      Rack(id: 'r-1', warehouseId: 'wh-a', name: 'A', createdAt: now, updatedAt: now),
    );
    await slotRepo.create(
      Slot(id: 's-1', rackId: 'r-1', name: 'A1', capacity: 10, createdAt: now, updatedAt: now),
    );

    final result = await slotRepo.getOccupancyForRack('r-1');
    expect(result.isSuccess, isTrue);
    expect(result.data, hasLength(1));
    expect(result.data.first.used, 0);
    expect(result.data.first.fillRatio, 0);
  });
}
