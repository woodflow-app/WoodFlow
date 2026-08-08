/// What a single Ledger entry actually looks like to a person reading
/// history — not the raw `eventType` string ("moved") that was being
/// shown before, but something built FROM the payload that was
/// always being stored and never read back.
class LedgerEntryDescription {
  final String title; // localized event name, e.g. "Przeniesiono"
  final String? detail; // e.g. "A1 → A2", or null if nothing to add

  const LedgerEntryDescription({required this.title, this.detail});
}
