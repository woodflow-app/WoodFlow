import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Swedish — "needs review" confidence tier, see
/// `docs/LANGUAGE_QUALITY.md`.
const aiPatternsSv = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'vad kan ersätta', 'passande kapbit', 'alternativ för', 'ersättning för',
    ],
    AiQueryIntentType.staleMaterials: [
      'liggande material', 'gammalt lager', 'material som legat länge',
    ],
    AiQueryIntentType.location: [
      'var finns', 'var är', 'plats för',
    ],
    AiQueryIntentType.dimensions: [
      'vilka mått har', 'mått för', 'vilken storlek',
    ],
    AiQueryIntentType.stockQuantity: [
      'hur mycket har jag', 'aktuellt lager', 'lagernivå',
    ],
  },
  mmWords: ['mm', 'millimeter'],
  cmWords: ['cm', 'centimeter'],
  mWords: ['m', 'meter'],
);
