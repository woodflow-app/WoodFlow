import 'package:flutter_test/flutter_test.dart';

import 'package:woodflow/domain/entities/offcut.dart';
import 'package:woodflow/domain/services/offcut_match_finder.dart';

Offcut _offcut({
  required String id,
  required double length,
  required double width,
  double thickness = 18,
}) {
  final now = DateTime(2026, 1, 1);
  return Offcut(
    id: id,
    parentBoardId: 'board-1',
    slotId: 'slot-1',
    decorId: 'decor-1',
    length: length,
    width: width,
    thickness: thickness,
    qrCode: 'qr-$id',
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  const finder = OffcutMatchFinder();

  group('OffcutMatchFinder — pure, no repository access', () {
    test('excludes offcuts smaller than the requested size in any dimension', () {
      final candidates = [
        _offcut(id: 'too-short', length: 500, width: 500),
        _offcut(id: 'too-narrow', length: 700, width: 300),
        _offcut(id: 'fits', length: 700, width: 500),
      ];

      final result =
          finder.findAlternatives(candidates: candidates, minLengthMm: 600, minWidthMm: 400);

      expect(result, hasLength(1));
      expect(result.single.offcut.id, 'fits');
    });

    test('sorts matches by smallest sufficient area first (least waste)', () {
      final candidates = [
        _offcut(id: 'big', length: 1000, width: 1000),
        _offcut(id: 'exact', length: 600, width: 400),
        _offcut(id: 'medium', length: 700, width: 500),
      ];

      final result =
          finder.findAlternatives(candidates: candidates, minLengthMm: 600, minWidthMm: 400);

      expect(result.map((c) => c.offcut.id), ['exact', 'medium', 'big']);
      expect(result.first.wasteAreaMm2, 0);
    });

    test('thickness filter is optional — omitting it accepts any thickness', () {
      final candidates = [_offcut(id: 'thin', length: 700, width: 500, thickness: 10)];

      final withoutThickness =
          finder.findAlternatives(candidates: candidates, minLengthMm: 600, minWidthMm: 400);
      expect(withoutThickness, hasLength(1));

      final withThickness = finder.findAlternatives(
        candidates: candidates,
        minLengthMm: 600,
        minWidthMm: 400,
        minThicknessMm: 18,
      );
      expect(withThickness, isEmpty);
    });

    test('empty candidate list returns an empty result, not a crash', () {
      final result =
          finder.findAlternatives(candidates: const [], minLengthMm: 600, minWidthMm: 400);
      expect(result, isEmpty);
    });
  });
}
