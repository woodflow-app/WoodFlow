import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:woodflow/core/errors/failures.dart';
import 'package:woodflow/core/services/service_locator.dart';
import 'package:woodflow/domain/entities/organization.dart';
import 'package:woodflow/domain/entities/warehouse.dart';
import 'package:woodflow/domain/repositories/warehouse_repository.dart';
import 'package:woodflow/domain/usecases/delete_warehouse_use_case.dart';
import 'package:woodflow/l10n/app_localizations.dart';
import 'package:woodflow/presentation/warehouse/warehouse_list_screen.dart';

/// Widget test for the warehouse-deletion confirmation flow.
///
/// Deliberately backed by lightweight in-memory fakes, not the real
/// `WarehouseRepositoryImpl`/`DeleteWarehouseUseCaseImpl` — those are
/// already fully exercised, with a real database, by
/// `delete_warehouse_use_case_test.dart` (transaction atomicity,
/// cascading delete, archive-not-delete for Boards/Offcuts). This
/// file's only job is the widget/interaction behavior: does the
/// confirmation dialog show the right text, does Cancel keep the
/// warehouse, does confirming call through and refresh the list.
/// `sqflite_common_ffi` runs SQLite on a real background isolate;
/// mixing that with `WidgetTester`'s fake-async pump loop produced an
/// unresolvable hang in this environment (confirmed even for the
/// simplest possible case, and unaffected by `tester.runAsync()`) — a
/// fake in-memory repository removes that whole class of problem
/// while still testing exactly what a widget test should own.
class _FakeWarehouseRepository implements WarehouseRepository {
  final Map<String, Warehouse> _rows = {};

  @override
  Future<Result<Warehouse>> getById(String id) async {
    final w = _rows[id];
    if (w == null) return Result.failure(NotFoundFailure('Warehouse $id'));
    return Result.success(w);
  }

  @override
  Future<Result<List<Warehouse>>> getAll() async {
    final list = _rows.values.toList()..sort((a, b) => a.name.compareTo(b.name));
    return Result.success(list);
  }

  @override
  Future<Result<Warehouse>> create(Warehouse entity) async {
    _rows[entity.id] = entity;
    return Result.success(entity);
  }

  @override
  Future<Result<Warehouse>> update(Warehouse entity) async {
    _rows[entity.id] = entity;
    return Result.success(entity);
  }

  @override
  Future<Result<void>> delete(String id) async {
    _rows.remove(id);
    return Result.success(null);
  }

  @override
  Future<Result<List<Warehouse>>> searchByName(String query) async =>
      throw UnimplementedError('not exercised by WarehouseListScreen');

  @override
  Future<Result<Warehouse>> getByQrCode(String qrCode) async =>
      throw UnimplementedError('not exercised by WarehouseListScreen');

  @override
  Future<Result<Warehouse>> regenerateQrCode(String id) async =>
      throw UnimplementedError('not exercised by WarehouseListScreen');
}

class _FakeDeleteWarehouseUseCase implements DeleteWarehouseUseCase {
  _FakeDeleteWarehouseUseCase(this._repo);
  final _FakeWarehouseRepository _repo;

  @override
  Future<Result<void>> call(String warehouseId) => _repo.delete(warehouseId);
}

void main() {
  late _FakeWarehouseRepository warehouseRepo;

  setUp(() {
    warehouseRepo = _FakeWarehouseRepository();

    if (sl.isRegistered<WarehouseRepository>()) {
      sl.unregister<WarehouseRepository>();
    }
    if (sl.isRegistered<DeleteWarehouseUseCase>()) {
      sl.unregister<DeleteWarehouseUseCase>();
    }
    sl.registerLazySingleton<WarehouseRepository>(() => warehouseRepo);
    sl.registerLazySingleton<DeleteWarehouseUseCase>(
      () => _FakeDeleteWarehouseUseCase(warehouseRepo),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  Future<void> _seedWarehouse(String id, String name) async {
    final now = DateTime.now();
    await warehouseRepo.create(Warehouse(
      id: id, organizationId: defaultOrganizationId,
      name: name, createdAt: now, updatedAt: now,
    ));
  }

  Future<void> _pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
      home: WarehouseListScreen(),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('delete icon opens a confirmation dialog; Cancel keeps the warehouse',
      (tester) async {
    await _seedWarehouse('wh-1', 'Test Warehouse');
    await _pumpScreen(tester);

    expect(find.text('Test Warehouse'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.text('Delete warehouse "Test Warehouse"?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Test Warehouse'), findsOneWidget);
  });

  testWidgets('confirming deletion removes the warehouse from the list', (tester) async {
    await _seedWarehouse('wh-1', 'Test Warehouse');
    await _pumpScreen(tester);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Test Warehouse'), findsNothing);

    final result = await warehouseRepo.getById('wh-1');
    expect(result.isFailure, isTrue);
  });

  testWidgets('deleting one warehouse leaves other warehouses in the list',
      (tester) async {
    await _seedWarehouse('wh-1', 'Delete me');
    await _seedWarehouse('wh-2', 'Keep me');
    await _pumpScreen(tester);

    // getAll() orders by name ASC, so "Delete me" sorts before "Keep
    // me" — its row (and delete icon) is the first one in the list.
    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();

    expect(find.text('Delete warehouse "Delete me"?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Delete me'), findsNothing);
    expect(find.text('Keep me'), findsOneWidget);
  });
}
