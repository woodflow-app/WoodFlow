import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Irish (Gaeilge) — "requires review before any production use"
/// confidence tier, see `docs/LANGUAGE_QUALITY.md`. Deliberately
/// minimal (one primary phrase per intent) rather than padded with
/// unverified variants — same honesty tradeoff `docs/LANGUAGE_QUALITY.md`
/// already applies to this tier's UI strings.
const aiPatternsGa = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'cad a chuirfeadh ina ionad', 'malairt do',
    ],
    AiQueryIntentType.staleMaterials: [
      'ábhar ina luí', 'seanstoc',
    ],
    AiQueryIntentType.location: [
      'cá bhfuil',
    ],
    AiQueryIntentType.dimensions: [
      'cad iad na toisí', 'toisí',
    ],
    AiQueryIntentType.stockQuantity: [
      'cé mhéad atá agam', 'stoc reatha',
    ],
  },
  mmWords: ['mm', 'milliméadar'],
  cmWords: ['cm', 'ceintiméadar'],
  mWords: ['m', 'méadar'],
);
