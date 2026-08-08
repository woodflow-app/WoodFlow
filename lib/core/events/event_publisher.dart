import 'dart:async';

import 'domain_event.dart';

/// Contract repositories will depend on once the first real domain
/// event exists. Kept as an interface (not a concrete class directly)
/// so the in-memory implementation below can be swapped for something
/// that also pushes to a sync queue, without touching call sites.
abstract class EventPublisher {
  Future<void> publish(DomainEvent event);
  Stream<DomainEvent> get events;
}

/// Minimal in-memory pub/sub. No persistence, no retry, no delivery
/// guarantees — deliberately, because nothing consumes events yet.
/// If/when the AI module or sync needs "replay events since last
/// checkpoint", that's a new, more capable implementation of this
/// same interface, not a change to this one.
class InMemoryEventPublisher implements EventPublisher {
  final _controller = StreamController<DomainEvent>.broadcast();

  @override
  Future<void> publish(DomainEvent event) async {
    _controller.add(event);
  }

  @override
  Stream<DomainEvent> get events => _controller.stream;
}
