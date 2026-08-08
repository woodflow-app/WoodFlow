/// Own transaction type for Offcut, deliberately not reusing
/// BoardTransaction — per ADR-022, nothing about Offcut's lifecycle
/// is shared code with Board beyond the general Result<T>/atomic
/// transaction+ledger PATTERN, not the types themselves.
class OffcutTransaction {
  final String id;
  final String offcutId;
  final OffcutTransactionType type;
  final String? fromSlotId;
  final String? toSlotId;
  final DateTime occurredAt;
  final String? userId;
  final String? note;

  const OffcutTransaction({
    required this.id,
    required this.offcutId,
    required this.type,
    this.fromSlotId,
    this.toSlotId,
    required this.occurredAt,
    this.userId,
    this.note,
  });
}

enum OffcutTransactionType {
  /// The ONLY creation path for an Offcut — it never exists without
  /// having been cut from a Board. Named `cut`, not `created`, to be
  /// explicit that this is a different kind of origin than Board's
  /// `created` (Board originates from a delivery, Offcut from an
  /// operation on another entity).
  cut,
  moved,
  archived,
  qrRegenerated;

  String get dbValue => name;

  static OffcutTransactionType fromDb(String value) =>
      OffcutTransactionType.values.firstWhere((t) => t.dbValue == value);
}
