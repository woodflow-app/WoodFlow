import 'exceptions.dart';

/// User-facing failure types. Repositories return these instead of
/// throwing — the UI layer just checks `result.isSuccess` and shows
/// `failure.message`, it never needs a try/catch of its own.
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class DatabaseFailure extends Failure {
  DatabaseFailure(super.message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(super.message);
}

class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}

/// Generic result wrapper. Use this as the return type of every
/// repository method instead of throwing.
///
/// Example:
///   Future<Result<Board>> getBoard(String id) async { ... }
class Result<T> {
  final T? _data;
  final Failure? _failure;

  const Result._success(this._data) : _failure = null;
  const Result._failure(this._failure) : _data = null;

  factory Result.success(T data) => Result._success(data);
  factory Result.failure(Failure failure) => Result._failure(failure);

  bool get isSuccess => _failure == null;
  bool get isFailure => _failure != null;

  T get data {
    if (_failure != null) {
      throw StateError('Tried to read data from a failed Result: '
          '${_failure.message}');
    }
    return _data as T;
  }

  Failure get failure {
    if (_failure == null) {
      throw StateError('Tried to read failure from a successful Result');
    }
    return _failure;
  }

  /// Pattern-match without exposing the internals above.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return _failure != null ? failure(_failure) : success(_data as T);
  }

  /// Transforms the success value, leaving a failure untouched.
  /// Use when the repository returns Result<BoardRow> but the caller
  /// wants Result<Board> — no need to unwrap/rewrap manually.
  Result<R> map<R>(R Function(T data) transform) {
    if (_failure != null) return Result.failure(_failure);
    return Result.success(transform(_data as T));
  }

  /// Chains a Result-returning operation onto a successful Result.
  /// Use for sequential steps that can each fail — e.g. "load board,
  /// then compute its ledger balance" — without nested when() calls.
  Future<Result<R>> flatMap<R>(
      Future<Result<R>> Function(T data) next) async {
    if (_failure != null) return Result.failure(_failure);
    return next(_data as T);
  }
}

/// Converts a raw exception (thrown deep in the data layer) into a
/// [Failure]. This is the ONLY place that should ever map exception
/// types to failure types — call it from the repository's catch block.
Failure mapExceptionToFailure(Object error) {
  return switch (error) {
    DatabaseException e => DatabaseFailure(e.message),
    MigrationException e => DatabaseFailure(e.toString()),
    NotFoundException e => NotFoundFailure(e.toString()),
    ValidationException e => ValidationFailure(e.message),
    _ => UnknownFailure(error.toString()),
  };
}
