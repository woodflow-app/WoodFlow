import 'package:flutter_test/flutter_test.dart';

import 'package:woodflow/data/ai_patterns/ai_patterns_registry.dart';
import 'package:woodflow/domain/entities/ai_query_intent.dart';
import 'package:woodflow/domain/services/ai_query_parser.dart';

void main() {
  final parser = AiQueryParser(aiPatternsRegistry);

  group('AiQueryParser — pure, no repository access — Polish (full intent coverage)', () {
    test('stock quantity', () {
      final result = parser.parse('Ile mam H3303?', 'pl');
      expect(result, isNotNull);
      expect(result!.intentType, AiQueryIntentType.stockQuantity);
      expect(result.decorQueryText, contains('h3303'));
    });

    test('location', () {
      final result = parser.parse('Gdzie jest H3303?', 'pl');
      expect(result!.intentType, AiQueryIntentType.location);
      expect(result.decorQueryText, contains('h3303'));
    });

    test('dimensions — a filler word between the trigger and the decor'
        ' ("...ma H3303") must not break decor extraction', () {
      final result = parser.parse('Jakie wymiary ma H3303?', 'pl');
      expect(result!.intentType, AiQueryIntentType.dimensions);
      expect(result.decorQueryText, contains('h3303'));
    });

    test('stale materials — no decor named is valid ("show everything stale")', () {
      final result = parser.parse('Pokaż zalegające materiały', 'pl');
      expect(result!.intentType, AiQueryIntentType.staleMaterials);
    });

    test('offcut match — extracts an "x"-joined dimension pair and leaves'
        ' the decor code untouched by the embedded digits inside it', () {
      final result = parser.parse('Czym zastąpić H3303 600x400?', 'pl');
      expect(result!.intentType, AiQueryIntentType.offcutMatch);
      expect(result.decorQueryText, contains('h3303'));
      expect(result.requestedLengthMm, 600);
      expect(result.requestedWidthMm, 400);
      expect(result.requestedThicknessMm, isNull);
    });

    test('unrelated text matches no intent', () {
      expect(parser.parse('Dzień dobry, jak się masz?', 'pl'), isNull);
    });

    test('empty/whitespace-only text matches no intent', () {
      expect(parser.parse('   ', 'pl'), isNull);
    });
  });

  group('AiQueryParser — English', () {
    test('stock quantity', () {
      final result = parser.parse('How much do I have of H3303?', 'en');
      expect(result!.intentType, AiQueryIntentType.stockQuantity);
      expect(result.decorQueryText, contains('h3303'));
    });

    test('offcut match with space-separated unit words ("600 mm")', () {
      final result = parser.parse('find alternative H3303 600 mm 400 mm', 'en');
      expect(result!.intentType, AiQueryIntentType.offcutMatch);
      expect(result.requestedLengthMm, 600);
      expect(result.requestedWidthMm, 400);
    });
  });

  group('AiQueryParser — unit conversion (Polish patterns, language-agnostic logic)', () {
    test('cm converts to mm', () {
      final result = parser.parse('czym zastąpić H3303 60 cm 40 cm', 'pl');
      expect(result!.requestedLengthMm, 600);
      expect(result.requestedWidthMm, 400);
    });

    test('m converts to mm', () {
      final result = parser.parse('czym zastąpić H3303 1 m', 'pl');
      expect(result!.requestedLengthMm, 1000);
    });

    test('a bare number with no recognized unit word defaults to mm', () {
      final result = parser.parse('czym zastąpić H3303 600 400', 'pl');
      expect(result!.requestedLengthMm, 600);
      expect(result.requestedWidthMm, 400);
    });
  });

  group('AiQueryParser — spot checks across the other 19 languages', () {
    test('German stock quantity', () {
      final result = parser.parse('Wie viel habe ich von H3303?', 'de');
      expect(result!.intentType, AiQueryIntentType.stockQuantity);
    });

    test('French location', () {
      final result = parser.parse('Où se trouve H3303 ?', 'fr');
      expect(result!.intentType, AiQueryIntentType.location);
    });

    test('Scottish Gaelic (weakest confidence tier) still matches its'
        ' one location trigger phrase', () {
      final result = parser.parse('Càite bheil H3303?', 'gd');
      expect(result!.intentType, AiQueryIntentType.location);
    });
  });

  group('AiQueryParser — unregistered language code', () {
    test('falls back to English rather than failing to parse', () {
      final result = parser.parse('how much do i have H3303', 'xx');
      expect(result!.intentType, AiQueryIntentType.stockQuantity);
    });
  });
}
