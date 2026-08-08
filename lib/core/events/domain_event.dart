/// Marker base class for domain events (BoardCreated, BoardMoved,
/// BoardCut, BoardArchived, OffcutCut, OffcutMoved, OffcutArchived).
///
/// This file exists as the EXTENSION POINT your architecture review
/// asked for. Board and Offcut repositories now publish through it
/// (see board_events.dart, offcut_events.dart) — nothing CONSUMES
/// these yet (no sync/AI/notifications subscriber exists), which is
/// still the intentional, minimal state: build the consumer only
/// when a real feature needs one.
///
/// Keep adding event classes only when a concrete Slice needs to
/// fire one — per the "no abstraction before a second real user"
/// principle already applied to BaseRepository.
abstract class DomainEvent {
  final DateTime occurredAt;
  const DomainEvent(this.occurredAt);
}
