import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:woodflow/core/logging/app_logger.dart';
import 'package:woodflow/data/database/database_service.dart';
import 'package:woodflow/data/repositories/warehouse_repository_impl.dart';
import 'package:woodflow/domain/entities/warehouse.dart';
import 'package:woodflow/domain/entities/organization.dart';

void main() {
  // sqflite needs an FFI backend to run outside a real device/emulator.
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseService dbService;
  late WarehouseRepositoryImpl repo;

  setUp(() async {
    // In-memory DB — fresh schema every test, no leftover state.
    dbService = DatabaseService(const AppLogger(), inMemory: true);
    repo = WarehouseRepositoryImpl(dbService, const AppLogger());
  });

  tearDown(() async {
    await dbService.close();
  });

  test('migration creates the warehouses table with expected columns'
      ' (organization_id backfilled by v3, qr_code added by Krok 7.1)',
      () async {
    final db = await dbService.open();
    final columns = await db.rawQuery('PRAGMA table_info(warehouses)');
    final columnNames = columns.map((c) => c['name']).toSet();

    expect(
      columnNames,
      {'id', 'organization_id', 'name', 'address', 'qr_code', 'created_at', 'updated_at'},
    );
  });

  test('create then getById returns the same warehouse', () async {
    final warehouse = Warehouse(
      id: 'wh-1',
      organizationId: defaultOrganizationId,
      name: 'Main Workshop',
      address: 'West Bromwich',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

    final createResult = await repo.create(warehouse);
    expect(createResult.isSuccess, isTrue);

    final fetched = await repo.getById('wh-1');
    expect(fetched.isSuccess, isTrue);
    expect(fetched.data.name, 'Main Workshop');
    expect(fetched.data.organizationId, defaultOrganizationId);
  });

  test('getById on missing id returns a NotFoundFailure', () async {
    final result = await repo.getById('does-not-exist');
    expect(result.isFailure, isTrue);
  });

  test('searchByName filters case-insensitively by substring', () async {
    await repo.create(Warehouse(
      id: 'wh-1',
      organizationId: defaultOrganizationId,
      name: 'Birmingham Workshop',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ));
    await repo.create(Warehouse(
      id: 'wh-2',
      organizationId: defaultOrganizationId,
      name: 'London Storage',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ));

    final result = await repo.searchByName('Workshop');
    expect(result.isSuccess, isTrue);
    expect(result.data, hasLength(1));
    expect(result.data.first.id, 'wh-1');
  });

  test('delete removes the row; second delete returns NotFoundFailure',
      () async {
    await repo.create(Warehouse(
      id: 'wh-1',
      organizationId: defaultOrganizationId,
      name: 'Temp',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    ));

    final firstDelete = await repo.delete('wh-1');
    expect(firstDelete.isSuccess, isTrue);

    final secondDelete = await repo.delete('wh-1');
    expect(secondDelete.isFailure, isTrue);
  });
}
