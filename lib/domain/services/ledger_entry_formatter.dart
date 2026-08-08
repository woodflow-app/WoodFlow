import 'dart:convert';

import '../entities/ledger_entry.dart';
import '../entities/ledger_entry_description.dart';

/// Turns a raw `LedgerEntry` into something a person can actually
/// read. The payload JSON (`fromSlotId`/`toSlotId`/`slotId`/
/// `newQrCode`) has been written on every event since Board/Offcut
/// were built — this is the first code that reads it back.
///
/// Pure, like `LabelDataBuilder`: no repository access, no async.
/// [slotNames] is a pre-resolved lookup (slotId → display name) the
/// caller builds once per screen (batched, not one query per entry)
/// — this function only formats, it never fetches.
///
/// TODO(Launch Gate — nie zmieniać teraz): `entry.eventType` i te
/// literały ('created'/'moved'/'archived'/'cut'/'qrRegenerated') są
/// dziś zwykłymi stringami — powielonymi z `BoardTransactionType`/
/// `OffcutTransactionType.dbValue` w czterech różnych plikach. Jeśli
/// ktoś kiedyś doda 'move' zamiast 'moved' w jednym miejscu, historia
/// po cichu przestanie rozpoznawać to zdarzenie (fallback na surowy
/// string jako tytuł, bez crasha, ale też bez ostrzeżenia). Warte
/// przejścia na wspólną stałą/enum, gdy pojawi się drugi powód do
/// dotknięcia tego kodu — nie teraz, tylko dla tej jednej poprawki.
class LedgerEntryFormatter {
  LedgerEntryFormatter._();

  static LedgerEntryDescription format(
    LedgerEntry entry, {
    required Map<String, String> eventLabels,
    Map<String, String> slotNames = const {},
  }) {
    final title = eventLabels[entry.eventType] ?? entry.eventType;
    Map<String, dynamic> payload;
    try {
      payload = jsonDecode(entry.payloadJson) as Map<String, dynamic>;
    } catch (_) {
      // Malformed/empty payload (e.g. archive events store `{}`) —
      // degrade to a title-only entry rather than throwing.
      return LedgerEntryDescription(title: title);
    }

    String? detail;
    switch (entry.eventType) {
      case 'moved':
        final from = _resolveSlot(payload['fromSlotId'], slotNames);
        final to = _resolveSlot(payload['toSlotId'], slotNames);
        if (from != null && to != null) detail = '$from → $to';
        break;
      case 'created':
      case 'cut':
        detail = _resolveSlot(payload['slotId'], slotNames);
        break;
      case 'qrRegenerated':
      case 'archived':
        detail = null; // nothing meaningful to add beyond the title
        break;
    }

    return LedgerEntryDescription(title: title, detail: detail);
  }

  static String? _resolveSlot(Object? slotId, Map<String, String> slotNames) {
    if (slotId is! String) return null;
    return slotNames[slotId] ?? slotId;
  }
}
