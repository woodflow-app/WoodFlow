import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Scottish Gaelic — "requires review before any production use"
/// confidence tier; the weakest of all 21 per `docs/LANGUAGE_QUALITY.md`.
/// Deliberately minimal, same honesty tradeoff as the Irish/Welsh
/// files in this tier — not padded with unverified variants.
const aiPatternsGd = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'dè a chuireas na àite', 'roghainn eile airson',
    ],
    AiQueryIntentType.staleMaterials: [
      'stuth na laighe', 'seann stoc',
    ],
    AiQueryIntentType.location: [
      'càite bheil',
    ],
    AiQueryIntentType.dimensions: [
      'dè na tomhasan', 'tomhasan',
    ],
    AiQueryIntentType.stockQuantity: [
      'dè na tha agam', 'stoc an-dràsta',
    ],
  },
  mmWords: ['mm', 'millemeatair'],
  cmWords: ['cm', 'ceudameatair'],
  mWords: ['m', 'meatair'],
);
