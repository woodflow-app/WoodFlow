/// Immutable, append-only audit record. Never edited or deleted
/// after being written. Generic (`entityType`/`entityId`) so future
/// entities (Offcut, Project...) can log into this same table
/// without a schema change.
class LedgerEntry {
  final String id;
  final String transactionId;
  final String entityType;
  final String entityId;
  final String eventType;
  final DateTime occurredAt;
  final String? userId;
  final String payloadJson;

  const LedgerEntry({
    required this.id,
    required this.transactionId,
    required this.entityType,
    required this.entityId,
    required this.eventType,
    required this.occurredAt,
    this.userId,
    required this.payloadJson,
  });
}
