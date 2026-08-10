import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Croatian — "needs review" confidence tier, see
/// `docs/LANGUAGE_QUALITY.md`.
const aiPatternsHr = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'čime zamijeniti', 'odgovarajući otpadak', 'alternativa za', 'zamjena za',
    ],
    AiQueryIntentType.staleMaterials: [
      'zaostali materijal', 'stara zaliha', 'materijal koji dugo stoji',
    ],
    AiQueryIntentType.location: [
      'gdje je', 'gdje se nalazi', 'lokacija',
    ],
    AiQueryIntentType.dimensions: [
      'koje su dimenzije', 'dimenzije', 'koja veličina',
    ],
    AiQueryIntentType.stockQuantity: [
      'koliko imam', 'trenutna zaliha', 'stanje zalihe',
    ],
  },
  mmWords: ['mm', 'milimetar'],
  cmWords: ['cm', 'centimetar'],
  mWords: ['m', 'metar'],
);
