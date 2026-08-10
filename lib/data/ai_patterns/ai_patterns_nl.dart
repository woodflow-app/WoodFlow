import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Dutch — "needs review" confidence tier (solid first draft, native-
/// speaker review recommended before production use — see
/// `docs/LANGUAGE_QUALITY.md`).
const aiPatternsNl = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'waarmee kan ik vervangen', 'passend reststuk', 'alternatief voor', 'vervanging voor',
    ],
    AiQueryIntentType.staleMaterials: [
      'liggend materiaal', 'oude voorraad', 'materiaal dat lang blijft liggen',
    ],
    AiQueryIntentType.location: [
      'waar is', 'waar bevindt zich', 'locatie van',
    ],
    AiQueryIntentType.dimensions: [
      'wat zijn de afmetingen', 'afmetingen van', 'welke maat',
    ],
    AiQueryIntentType.stockQuantity: [
      'hoeveel heb ik', 'huidige voorraad', 'voorraadniveau',
    ],
  },
  mmWords: ['mm', 'millimeter'],
  cmWords: ['cm', 'centimeter'],
  mWords: ['m', 'meter'],
);
