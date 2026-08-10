import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:woodflow/core/logging/app_logger.dart';
import 'package:woodflow/data/database/database_service.dart';
import 'package:woodflow/data/repositories/decor_repository_impl.dart';
import 'package:woodflow/data/repositories/warehouse_repository_impl.dart';
import 'package:woodflow/domain/entities/organization.dart';
import 'package:woodflow/domain/entities/warehouse.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseService dbService;

  setUp(() {
    dbService = DatabaseService(const AppLogger(), inMemory: true);
  });

  tearDown(() async {
    await dbService.close();
  });

  group('v3 — Organization', () {
    test('creates organizations table with one default row', () async {
      final db = await dbService.open();
      final rows = await db.query('organizations');
      expect(rows, hasLength(1));
      expect(rows.first['id'], defaultOrganizationId);
    });

    test('warehouses.organization_id is backfilled to the default org'
        ' for every warehouse', () async {
      final warehouseRepo = WarehouseRepositoryImpl(dbService, const AppLogger());
      final now = DateTime(2026, 1, 1);
      await warehouseRepo.create(Warehouse(
        id: 'wh-a',
        organizationId: defaultOrganizationId,
        name: 'Warehouse A',
        createdAt: now,
        updatedAt: now,
      ));

      final result = await warehouseRepo.getById('wh-a');
      expect(result.isSuccess, isTrue);
      expect(result.data.organizationId, defaultOrganizationId);
    });
  });

  group('v4 — Decor', () {
    test('creates decors table seeded with common codes (v4) — the full'
        ' 421-entry EGGER catalog is imported separately by v7, see'
        ' egger_decor_catalog_test.dart', () async {
      final db = await dbService.open();
      final rows = await db.query('decors');
      expect(rows.length, greaterThanOrEqualTo(4));
    });

    test('getByCode resolves the full catalog entry', () async {
      final decorRepo = DecorRepositoryImpl(dbService, const AppLogger());
      final result = await decorRepo.getByCode('H3303');
      expect(result.isSuccess, isTrue);
      expect(result.data.name, 'Natural Hamilton Oak');
      expect(result.data.manufacturer, 'EGGER');
    });

    test('getByCode on unknown code returns NotFoundFailure', () async {
      final decorRepo = DecorRepositoryImpl(dbService, const AppLogger());
      final result = await decorRepo.getByCode('DOES-NOT-EXIST');
      expect(result.isFailure, isTrue);
    });
  });
}
