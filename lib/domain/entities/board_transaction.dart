/// Domain-specific record of a business operation on a Board.
/// Named `BoardTransaction`, not `Transaction`, to avoid colliding
/// with sqflite's own `Transaction` class.
class BoardTransaction {
  final String id;
  final String boardId;
  final BoardTransactionType type;
  final String? fromSlotId;
  final String? toSlotId;
  final DateTime occurredAt;
  final String? userId; // nullable — no auth yet
  final String? note;

  const BoardTransaction({
    required this.id,
    required this.boardId,
    required this.type,
    this.fromSlotId,
    this.toSlotId,
    required this.occurredAt,
    this.userId,
    this.note,
  });
}

enum BoardTransactionType {
  created,
  moved,
  archived,
  qrRegenerated;

  String get dbValue => name;

  static BoardTransactionType fromDb(String value) =>
      BoardTransactionType.values.firstWhere((t) => t.dbValue == value);
}
