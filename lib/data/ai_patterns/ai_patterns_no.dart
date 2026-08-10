import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Norwegian — "needs review" confidence tier, see
/// `docs/LANGUAGE_QUALITY.md`.
const aiPatternsNo = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'hva kan erstatte', 'passende avkapp', 'alternativ til', 'erstatning for',
    ],
    AiQueryIntentType.staleMaterials: [
      'liggende materiale', 'gammel lagerbeholdning', 'materiale som har ligget lenge',
    ],
    AiQueryIntentType.location: [
      'hvor er', 'hvor befinner', 'plassering av',
    ],
    AiQueryIntentType.dimensions: [
      'hvilke mål har', 'mål for', 'hvilken størrelse',
    ],
    AiQueryIntentType.stockQuantity: [
      'hvor mye har jeg', 'nåværende lagerbeholdning', 'lagernivå',
    ],
  },
  mmWords: ['mm', 'millimeter'],
  cmWords: ['cm', 'centimeter'],
  mWords: ['m', 'meter'],
);
