import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Czech — "needs review" confidence tier, see
/// `docs/LANGUAGE_QUALITY.md`.
const aiPatternsCs = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'čím nahradit', 'vhodný odřezek', 'alternativa za', 'náhrada za',
    ],
    AiQueryIntentType.staleMaterials: [
      'ležící materiál', 'starý sklad', 'materiál dlouho neskladem',
    ],
    AiQueryIntentType.location: [
      'kde je', 'kde se nachází', 'umístění',
    ],
    AiQueryIntentType.dimensions: [
      'jaké má rozměry', 'rozměry', 'jaká velikost',
    ],
    AiQueryIntentType.stockQuantity: [
      'kolik mám', 'aktuální zásoba', 'stav skladu',
    ],
  },
  mmWords: ['mm', 'milimetr'],
  cmWords: ['cm', 'centimetr'],
  mWords: ['m', 'metr'],
);
