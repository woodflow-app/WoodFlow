import '../entities/board.dart';
import '../entities/offcut.dart';
import '../entities/rack.dart';
import '../entities/slot.dart';
import '../entities/warehouse.dart';

/// What a scanned QR code resolved to. `sealed` so the UI's `switch`
/// is exhaustive — the compiler catches a missing case if a 6th
/// entity type is ever added, instead of silently falling through.
sealed class QrResolution {
  const QrResolution();
}

class WarehouseFound extends QrResolution {
  final Warehouse warehouse;
  const WarehouseFound(this.warehouse);
}

class RackFound extends QrResolution {
  final Rack rack;
  const RackFound(this.rack);
}

class SlotFound extends QrResolution {
  final Slot slot;
  const SlotFound(this.slot);
}

class BoardFound extends QrResolution {
  final Board board;
  const BoardFound(this.board);
}

class OffcutFound extends QrResolution {
  final Offcut offcut;
  const OffcutFound(this.offcut);
}

/// Per Piotr: never show a bare "not found" — the calling screen is
/// responsible for the friendlier "ten kod nie istnieje lub został
/// usunięty" + "Wyszukaj ręcznie" UX. This type just signals the case.
class QrNotFound extends QrResolution {
  const QrNotFound();
}
