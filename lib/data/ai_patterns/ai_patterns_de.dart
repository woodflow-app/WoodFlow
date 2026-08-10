import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// German — "strong" confidence tier, see `docs/LANGUAGE_QUALITY.md`.
const aiPatternsDe = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'was kann ich ersetzen', 'passender verschnitt', 'ersatz für', 'alternative für',
    ],
    AiQueryIntentType.staleMaterials: [
      'liegen gebliebenes material', 'altbestand', 'veraltetes material', 'lagerhüter',
    ],
    AiQueryIntentType.location: [
      'wo ist', 'wo sind', 'standort von', 'wo befindet sich',
    ],
    AiQueryIntentType.dimensions: [
      'welche abmessungen', 'wie groß ist', 'maße von', 'abmessungen von',
    ],
    AiQueryIntentType.stockQuantity: [
      'wie viel habe ich', 'wie viele habe ich', 'aktueller bestand', 'lagerbestand',
    ],
  },
  mmWords: ['mm', 'millimeter'],
  cmWords: ['cm', 'zentimeter'],
  mWords: ['m', 'meter'],
);
