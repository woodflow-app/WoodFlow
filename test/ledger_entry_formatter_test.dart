import 'package:flutter_test/flutter_test.dart';

import 'package:woodflow/domain/entities/ledger_entry.dart';
import 'package:woodflow/domain/services/ledger_entry_formatter.dart';

void main() {
  const eventLabels = {
    'created': 'Utworzono',
    'moved': 'Przeniesiono',
    'archived': 'Zarchiwizowano',
    'cut': 'Wycięto',
    'qrRegenerated': 'Zregenerowano QR',
  };

  final now = DateTime(2026, 1, 1);

  LedgerEntry entryWith(String eventType, String payloadJson) => LedgerEntry(
        id: 'l-1',
        transactionId: 't-1',
        entityType: 'board',
        entityId: 'b-1',
        eventType: eventType,
        occurredAt: now,
        userId: null,
        payloadJson: payloadJson,
      );

  test('moved: shows resolved slot names when both are known', () {
    final entry = entryWith('moved', '{"fromSlotId":"s-1","toSlotId":"s-2"}');
    final result = LedgerEntryFormatter.format(
      entry,
      eventLabels: eventLabels,
      slotNames: {'s-1': 'A1', 's-2': 'A2'},
    );
    expect(result.title, 'Przeniesiono');
    expect(result.detail, 'A1 → A2');
  });

  test('moved: falls back to raw id when a slot name is unknown', () {
    final entry = entryWith('moved', '{"fromSlotId":"s-1","toSlotId":"s-2"}');
    final result = LedgerEntryFormatter.format(entry, eventLabels: eventLabels);
    expect(result.detail, 's-1 → s-2');
  });

  test('moved: only fromSlotId present (partially-shaped payload) —'
      ' no detail shown, since "→ ?" would be worse than nothing',
      () {
    final entry = entryWith('moved', '{"fromSlotId":"s-1"}');
    final result = LedgerEntryFormatter.format(
      entry,
      eventLabels: eventLabels,
      slotNames: {'s-1': 'A1'},
    );
    expect(result.title, 'Przeniesiono');
    expect(result.detail, isNull);
  });

  test('moved: only toSlotId present (partially-shaped payload) — no'
      ' detail shown', () {
    final entry = entryWith('moved', '{"toSlotId":"s-2"}');
    final result = LedgerEntryFormatter.format(
      entry,
      eventLabels: eventLabels,
      slotNames: {'s-2': 'A2'},
    );
    expect(result.title, 'Przeniesiono');
    expect(result.detail, isNull);
  });

  test('created: shows the resolved slot it was created in', () {
    final entry = entryWith('created', '{"slotId":"s-1"}');
    final result = LedgerEntryFormatter.format(
      entry,
      eventLabels: eventLabels,
      slotNames: {'s-1': 'A1'},
    );
    expect(result.title, 'Utworzono');
    expect(result.detail, 'A1');
  });

  test('created: payload missing slotId entirely (partially-shaped'
      ' payload) degrades to title-only, does not throw', () {
    final entry = entryWith('created', '{"createdBy":"user"}');
    final result = LedgerEntryFormatter.format(entry, eventLabels: eventLabels);
    expect(result.title, 'Utworzono');
    expect(result.detail, isNull);
  });

  test('cut: shows the resolved slot it was cut into', () {
    final entry = entryWith('cut', '{"parentBoardId":"b-1","slotId":"s-1"}');
    final result = LedgerEntryFormatter.format(
      entry,
      eventLabels: eventLabels,
      slotNames: {'s-1': 'A1'},
    );
    expect(result.title, 'Wycięto');
    expect(result.detail, 'A1');
  });

  test('archived: title only, no detail', () {
    final entry = entryWith('archived', '{}');
    final result = LedgerEntryFormatter.format(entry, eventLabels: eventLabels);
    expect(result.title, 'Zarchiwizowano');
    expect(result.detail, isNull);
  });

  test('qrRegenerated: title only, no detail (does not leak the new'
      ' QR code into a casual history glance)', () {
    final entry = entryWith('qrRegenerated', '{"newQrCode":"WF-B-DEADBEEF"}');
    final result = LedgerEntryFormatter.format(entry, eventLabels: eventLabels);
    expect(result.title, 'Zregenerowano QR');
    expect(result.detail, isNull);
  });

  test('malformed payload degrades to title-only instead of throwing', () {
    final entry = entryWith('moved', 'not valid json');
    final result = LedgerEntryFormatter.format(entry, eventLabels: eventLabels);
    expect(result.title, 'Przeniesiono');
    expect(result.detail, isNull);
  });

  test('unknown eventType falls back to the raw string as title', () {
    final entry = entryWith('somethingNew', '{}');
    final result = LedgerEntryFormatter.format(entry, eventLabels: eventLabels);
    expect(result.title, 'somethingNew');
  });
}
