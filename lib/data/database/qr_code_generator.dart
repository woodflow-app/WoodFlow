import 'package:uuid/uuid.dart';

/// QR generation for WoodFlow entities: `WF-{TYPE}-{8 hex chars}`,
/// e.g. `WF-B-8F4C29A1`.
///
/// ONE SOURCE OF TRUTH at creation, not two independent random
/// values: the initial QR is a display-friendly ENCODING of the
/// entity's own `id` (its first 8 hex characters, uppercased) — not
/// a second, unrelated random value generated alongside it. An
/// entity's `id` and its original `qrCode` are therefore
/// deterministically related.
///
/// Use in every repository's `create()`.
String qrCodeFromEntityId(String typeLetter, String entityId) {
  final cleaned = entityId.replaceAll('-', '').toUpperCase();
  final isValidHex = RegExp(r'^[0-9A-F]+$').hasMatch(cleaned);
  final hex = (isValidHex && cleaned.length >= 8)
      ? cleaned.substring(0, 8)
      : entityId.hashCode.toRadixString(16).toUpperCase().padLeft(8, '0').substring(0, 8);
  return 'WF-$typeLetter-$hex';
}

/// Use ONLY in `regenerateQrCode()`. This is the one deliberate
/// exception to "derive from id": regeneration exists specifically
/// to produce a code DIFFERENT from the original (e.g. a damaged/
/// lost label needs a new sticker whose old code must stop
/// resolving). Since `id` never changes, a regenerated code cannot
/// be derived from it — this generates a fresh UUID-backed random
/// suffix instead (same well-tested source of randomness as `id`
/// generation itself, just not tied to this particular entity).
String randomQrCode(String typeLetter) {
  final hex = const Uuid().v4().replaceAll('-', '').substring(0, 8).toUpperCase();
  return 'WF-$typeLetter-$hex';
}

/// Type letters used across the app — kept in one place so a future
/// reader doesn't have to hunt through five repositories to find
/// them all.
class QrTypeLetters {
  QrTypeLetters._();
  static const warehouse = 'W';
  static const rack = 'R';
  static const slot = 'S';
  static const board = 'B';
  static const offcut = 'O';
}
