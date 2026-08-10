import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Lithuanian — "needs review" confidence tier, see
/// `docs/LANGUAGE_QUALITY.md`.
const aiPatternsLt = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'kuo pakeisti', 'tinkama atraiža', 'alternatyva', 'pakaitalas',
    ],
    AiQueryIntentType.staleMaterials: [
      'gulinti medžiaga', 'senos atsargos', 'medžiaga ilgai gulinti',
    ],
    AiQueryIntentType.location: [
      'kur yra', 'kur randasi', 'vieta',
    ],
    AiQueryIntentType.dimensions: [
      'kokie matmenys', 'matmenys', 'koks dydis',
    ],
    AiQueryIntentType.stockQuantity: [
      'kiek turiu', 'esamos atsargos', 'atsargų lygis',
    ],
  },
  mmWords: ['mm', 'milimetras'],
  cmWords: ['cm', 'centimetras'],
  mWords: ['m', 'metras'],
);
