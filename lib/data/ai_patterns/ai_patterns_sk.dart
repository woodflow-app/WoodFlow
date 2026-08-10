import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Slovak — "needs review" confidence tier, see
/// `docs/LANGUAGE_QUALITY.md`.
const aiPatternsSk = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'čím nahradiť', 'vhodný odrezok', 'alternatíva za', 'náhrada za',
    ],
    AiQueryIntentType.staleMaterials: [
      'ležiaci materiál', 'starý sklad', 'materiál dlho neskladom',
    ],
    AiQueryIntentType.location: [
      'kde je', 'kde sa nachádza', 'umiestnenie',
    ],
    AiQueryIntentType.dimensions: [
      'aké má rozmery', 'rozmery', 'aká veľkosť',
    ],
    AiQueryIntentType.stockQuantity: [
      'koľko mám', 'aktuálna zásoba', 'stav skladu',
    ],
  },
  mmWords: ['mm', 'milimeter'],
  cmWords: ['cm', 'centimeter'],
  mWords: ['m', 'meter'],
);
