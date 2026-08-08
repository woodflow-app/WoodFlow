import 'package:flutter_test/flutter_test.dart';

import 'package:woodflow/domain/entities/board.dart';
import 'package:woodflow/domain/entities/decor.dart';
import 'package:woodflow/domain/entities/label_layout.dart';
import 'package:woodflow/domain/entities/offcut.dart';
import 'package:woodflow/domain/services/label_data_builder.dart';

void main() {
  final now = DateTime(2026, 1, 1);

  group('LabelDataBuilder.fromBoard — pure, no repository access', () {
    final board = Board(
      id: 'b-1',
      slotId: 's-1',
      decorId: 'decor-h3303',
      length: 2800,
      width: 2070,
      thickness: 18,
      qrCode: 'WF-B-8F4C29A1',
      createdAt: now,
      updatedAt: now,
    );

    test('uses decor code/name when decor is resolved', () {
      final decor = Decor(
        id: 'decor-h3303',
        code: 'H3303',
        name: 'Natural Hamilton Oak',
        manufacturer: 'EGGER',
        createdAt: now,
        updatedAt: now,
      );

      final label = LabelDataBuilder.fromBoard(
        board: board,
        decor: decor,
        locationBreadcrumb: 'Warehouse A > Rack A > A1',
        statusText: 'in stock',
      );

      expect(label.qrCode, 'WF-B-8F4C29A1');
      expect(label.title, 'H3303');
      expect(label.subtitle, 'Natural Hamilton Oak');
      expect(label.dimensions, '2800×2070×18 mm');
      expect(label.location, 'Warehouse A > Rack A > A1');
      expect(label.status, 'in stock');
    });

    test('falls back to raw decorId when decor is null (unresolved)', () {
      final label = LabelDataBuilder.fromBoard(
        board: board,
        decor: null,
        locationBreadcrumb: null,
        statusText: 'in stock',
      );

      expect(label.title, 'decor-h3303');
      expect(label.subtitle, '');
      expect(label.location, isNull);
    });
  });

  group('LabelDataBuilder.fromOffcut — pure, no repository access', () {
    final offcut = Offcut(
      id: 'o-1',
      parentBoardId: 'b-1',
      slotId: 's-1',
      decorId: 'decor-h3303',
      length: 400,
      width: 300,
      thickness: 18,
      qrCode: 'WF-O-51D02F8E',
      createdAt: now,
      updatedAt: now,
    );

    test('uses decor code/name when decor is resolved', () {
      final decor = Decor(
        id: 'decor-h3303',
        code: 'H3303',
        name: 'Natural Hamilton Oak',
        manufacturer: 'EGGER',
        createdAt: now,
        updatedAt: now,
      );

      final label = LabelDataBuilder.fromOffcut(
        offcut: offcut,
        decor: decor,
        locationBreadcrumb: 'Warehouse A > Rack A > A1',
        statusText: 'available',
      );

      expect(label.qrCode, 'WF-O-51D02F8E');
      expect(label.title, 'H3303');
      expect(label.dimensions, '400×300×18 mm');
      expect(label.status, 'available');
    });
  });

  group('LabelLayout', () {
    test('a4Grid3x8 has 24 labels per sheet', () {
      expect(LabelLayout.a4Grid3x8.labelsPerSheet, 24);
    });

    test('layout size is decoupled from any output format — plain'
        ' data, no PDF/Zebra-specific fields', () {
      const layout = LabelLayout(
        name: 'test',
        sheetWidthMm: 100,
        sheetHeightMm: 50,
        columns: 2,
        rows: 3,
      );
      expect(layout.labelsPerSheet, 6);
    });
  });
}
