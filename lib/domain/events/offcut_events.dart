import '../../core/events/domain_event.dart';

class OffcutCut extends DomainEvent {
  final String offcutId;
  final String parentBoardId;
  final String slotId;

  OffcutCut({
    required this.offcutId,
    required this.parentBoardId,
    required this.slotId,
    required DateTime occurredAt,
  }) : super(occurredAt);
}

class OffcutMoved extends DomainEvent {
  final String offcutId;
  final String fromSlotId;
  final String toSlotId;

  OffcutMoved({
    required this.offcutId,
    required this.fromSlotId,
    required this.toSlotId,
    required DateTime occurredAt,
  }) : super(occurredAt);
}

class OffcutArchived extends DomainEvent {
  final String offcutId;

  OffcutArchived({
    required this.offcutId,
    required DateTime occurredAt,
  }) : super(occurredAt);
}
