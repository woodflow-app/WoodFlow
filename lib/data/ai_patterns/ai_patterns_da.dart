import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Danish — "needs review" confidence tier, see
/// `docs/LANGUAGE_QUALITY.md`.
const aiPatternsDa = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'hvad kan erstatte', 'passende afskær', 'alternativ til', 'erstatning for',
    ],
    AiQueryIntentType.staleMaterials: [
      'liggende materiale', 'gammel lagerbeholdning', 'materiale der har ligget længe',
    ],
    AiQueryIntentType.location: [
      'hvor er', 'hvor befinder', 'placering af',
    ],
    AiQueryIntentType.dimensions: [
      'hvilke mål har', 'mål for', 'hvilken størrelse',
    ],
    AiQueryIntentType.stockQuantity: [
      'hvor meget har jeg', 'aktuel lagerbeholdning', 'lagerniveau',
    ],
  },
  mmWords: ['mm', 'millimeter'],
  cmWords: ['cm', 'centimeter'],
  mWords: ['m', 'meter'],
);
