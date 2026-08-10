import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Slovenian — "needs review" confidence tier, see
/// `docs/LANGUAGE_QUALITY.md`.
const aiPatternsSl = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      's čim zamenjati', 'ustrezen odrezek', 'alternativa za', 'zamenjava za',
    ],
    AiQueryIntentType.staleMaterials: [
      'zaostali material', 'stara zaloga', 'material ki dolgo stoji',
    ],
    AiQueryIntentType.location: [
      'kje je', 'kje se nahaja', 'lokacija',
    ],
    AiQueryIntentType.dimensions: [
      'kakšne so dimenzije', 'dimenzije', 'kakšna velikost',
    ],
    AiQueryIntentType.stockQuantity: [
      'koliko imam', 'trenutna zaloga', 'stanje zaloge',
    ],
  },
  mmWords: ['mm', 'milimeter'],
  cmWords: ['cm', 'centimeter'],
  mWords: ['m', 'meter'],
);
