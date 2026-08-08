/// Exceptions are INTERNAL — they are thrown inside datasources/database
/// code and caught at the repository boundary, then converted into a
/// [Failure] (see failures.dart). Nothing above the repository layer
/// should ever catch a raw exception.

class DatabaseException implements Exception {
  final String message;
  final Object? cause;

  DatabaseException(this.message, {this.cause});

  @override
  String toString() => 'DatabaseException: $message'
      '${cause != null ? ' (cause: $cause)' : ''}';
}

class MigrationException implements Exception {
  final int fromVersion;
  final int toVersion;
  final String message;

  MigrationException(this.fromVersion, this.toVersion, this.message);

  @override
  String toString() =>
      'MigrationException v$fromVersion→v$toVersion: $message';
}

class NotFoundException implements Exception {
  final String entity;
  final Object id;

  NotFoundException(this.entity, this.id);

  @override
  String toString() => 'NotFoundException: $entity with id "$id" not found';
}

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}
