import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:woodflow/core/logging/app_logger.dart';
import 'package:woodflow/data/database/database_service.dart';
import 'package:woodflow/data/decor_seeds/egger_decor_seed.dart';
import 'package:woodflow/data/repositories/decor_repository_impl.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('eggerDecorSeed — pure data, no database', () {
    test('has exactly 421 verified entries', () {
      expect(eggerDecorSeed.length, 421);
    });

    test('every code is unique — a duplicate here would break v7\'s'
        ' UNIQUE(code) insert with a silent-looking DatabaseException', () {
      final codes = eggerDecorSeed.map((e) => e.$1).toList();
      expect(codes.toSet().length, codes.length);
    });

    test('no entry has an empty code or name', () {
      for (final (code, name) in eggerDecorSeed) {
        expect(code.trim(), isNotEmpty);
        expect(name.trim(), isNotEmpty);
      }
    });
  });

  group('v7 migration — imports the catalog into a real database', () {
    late DatabaseService dbService;

    setUp(() {
      dbService = DatabaseService(const AppLogger(), inMemory: true);
    });

    tearDown(() async {
      await dbService.close();
    });

    test('decors table contains all 421 EGGER rows after migration', () async {
      final db = await dbService.open();
      // Matched by exact code, not just manufacturer='EGGER' — v4's 4
      // test fixtures also carry manufacturer='EGGER' (bare codes
      // like 'H3303', no texture suffix), so counting by manufacturer
      // alone would overcount by those 4 rows.
      final seedCodes = eggerDecorSeed.map((e) => e.$1).toSet();
      final rows = await db.query('decors');
      final matched = rows.where((r) => seedCodes.contains(r['code'])).length;
      expect(matched, 421);
    });

    test('getByCode resolves a real catalog entry by its full code'
        ' (code + texture, e.g. "H3303 ST10")', () async {
      final decorRepo = DecorRepositoryImpl(dbService, const AppLogger());
      final result = await decorRepo.getByCode('H3303 ST10');
      expect(result.isSuccess, isTrue);
      expect(result.data.name, 'Natural Hamilton Oak');
      expect(result.data.manufacturer, 'EGGER');
    });

    test('a decor with a name shared by multiple textures is not'
        ' collapsed — every texture variant is its own row (e.g. Light'
        ' Grey exists at U708 PM, U708 PT, U708 PG, U708 ST9)', () async {
      final decorRepo = DecorRepositoryImpl(dbService, const AppLogger());
      for (final code in ['U708 PM', 'U708 PT', 'U708 PG', 'U708 ST9']) {
        final result = await decorRepo.getByCode(code);
        expect(result.isSuccess, isTrue, reason: '$code should resolve');
        expect(result.data.name, 'Light Grey');
      }
    });
  });
}
