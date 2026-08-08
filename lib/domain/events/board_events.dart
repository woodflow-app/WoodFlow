import '../../core/events/domain_event.dart';

class BoardCreated extends DomainEvent {
  final String boardId;
  final String slotId;

  BoardCreated({
    required this.boardId,
    required this.slotId,
    required DateTime occurredAt,
  }) : super(occurredAt);
}

class BoardMoved extends DomainEvent {
  final String boardId;
  final String fromSlotId;
  final String toSlotId;

  BoardMoved({
    required this.boardId,
    required this.fromSlotId,
    required this.toSlotId,
    required DateTime occurredAt,
  }) : super(occurredAt);
}

class BoardArchived extends DomainEvent {
  final String boardId;

  BoardArchived({
    required this.boardId,
    required DateTime occurredAt,
  }) : super(occurredAt);
}
