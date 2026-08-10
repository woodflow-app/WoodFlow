import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Welsh (Cymraeg) — "requires review before any production use"
/// confidence tier, see `docs/LANGUAGE_QUALITY.md`. Deliberately
/// minimal, same honesty tradeoff as the Irish/Scottish Gaelic files
/// in this tier.
const aiPatternsCy = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'beth all gymryd lle', 'dewis arall ar gyfer',
    ],
    AiQueryIntentType.staleMaterials: [
      'deunydd yn gorwedd', 'hen stoc',
    ],
    AiQueryIntentType.location: [
      'ble mae',
    ],
    AiQueryIntentType.dimensions: [
      "beth yw'r dimensiynau", 'dimensiynau',
    ],
    AiQueryIntentType.stockQuantity: [
      'faint sydd gennyf', 'stoc presennol',
    ],
  },
  mmWords: ['mm', 'milimetr'],
  cmWords: ['cm', 'centimetr'],
  mWords: ['m', 'metr'],
);
