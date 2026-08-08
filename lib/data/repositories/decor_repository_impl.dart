import 'package:sqflite/sqflite.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/decor.dart';
import '../../domain/repositories/decor_repository.dart';
import '../database/database_service.dart';

const _table = 'decors';

class DecorRepositoryImpl implements DecorRepository {
  DecorRepositoryImpl(this._db, this._logger);

  final DatabaseService _db;
  final AppLogger _logger;

  @override
  Future<Result<Decor>> getById(String id) async {
    try {
      final db = await _db.open();
      final rows = await db.query(_table, where: 'id = ?', whereArgs: [id]);
      if (rows.isEmpty) throw NotFoundException('Decor', id);
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getById failed for decor $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Decor>> getByCode(String code) async {
    try {
      final db = await _db.open();
      final rows =
          await db.query(_table, where: 'code = ?', whereArgs: [code]);
      if (rows.isEmpty) throw NotFoundException('Decor (by code)', code);
      return Result.success(_fromRow(rows.first));
    } catch (e, st) {
      _logger.error('getByCode failed for "$code"',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<List<Decor>>> getAll() async {
    try {
      final db = await _db.open();
      final rows = await db.query(_table, orderBy: 'code ASC');
      return Result.success(rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.error('getAll failed for decors',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Decor>> create(Decor entity) async {
    try {
      await _db.transaction((txn) async {
        await txn.insert(_table, _toRow(entity),
            conflictAlgorithm: ConflictAlgorithm.abort);
      }, label: 'create decor ${entity.id}');
      return Result.success(entity);
    } catch (e, st) {
      _logger.error('create failed for decor ${entity.id}',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<Decor>> update(Decor entity) async {
    try {
      final count = await _db.transaction((txn) async {
        return txn.update(_table, _toRow(entity),
            where: 'id = ?', whereArgs: [entity.id]);
      }, label: 'update decor ${entity.id}');
      if (count == 0) throw NotFoundException('Decor', entity.id);
      return Result.success(entity);
    } catch (e, st) {
      _logger.error('update failed for decor ${entity.id}',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      final count = await _db.transaction((txn) async {
        return txn.delete(_table, where: 'id = ?', whereArgs: [id]);
      }, label: 'delete decor $id');
      if (count == 0) throw NotFoundException('Decor', id);
      return Result.success(null);
    } catch (e, st) {
      _logger.error('delete failed for decor $id',
          tag: 'REPOSITORY', error: e, stackTrace: st);
      return Result.failure(mapExceptionToFailure(e));
    }
  }

  Decor _fromRow(Map<String, Object?> row) => Decor(
        id: row['id'] as String,
        code: row['code'] as String,
        name: row['name'] as String,
        manufacturer: row['manufacturer'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(row['updated_at'] as int),
      );

  Map<String, Object?> _toRow(Decor d) => {
        'id': d.id,
        'code': d.code,
        'name': d.name,
        'manufacturer': d.manufacturer,
        'created_at': d.createdAt.millisecondsSinceEpoch,
        'updated_at': d.updatedAt.millisecondsSinceEpoch,
      };
}
