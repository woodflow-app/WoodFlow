import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Hungarian — "needs review" confidence tier, see
/// `docs/LANGUAGE_QUALITY.md`.
const aiPatternsHu = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'mivel helyettesíthető', 'megfelelő hulladékdarab', 'alternatíva erre', 'helyettesítő erre',
    ],
    AiQueryIntentType.staleMaterials: [
      'heverő anyag', 'régi készlet', 'sokáig fekvő anyag',
    ],
    AiQueryIntentType.location: [
      'hol van', 'hol található', 'helye',
    ],
    AiQueryIntentType.dimensions: [
      'milyen méretei vannak', 'méretei', 'milyen méret',
    ],
    AiQueryIntentType.stockQuantity: [
      'mennyi van', 'jelenlegi készlet', 'készletszint',
    ],
  },
  mmWords: ['mm', 'milliméter'],
  cmWords: ['cm', 'centiméter'],
  mWords: ['m', 'méter'],
);
