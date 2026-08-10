import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Russian — "strong" confidence tier, see `docs/LANGUAGE_QUALITY.md`.
const aiPatternsRu = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'чем заменить', 'подходящий обрезок', 'замена для', 'альтернатива для',
    ],
    AiQueryIntentType.staleMaterials: [
      'залежавшиеся материалы', 'старый остаток', 'материалы без движения',
    ],
    AiQueryIntentType.location: [
      'где находится', 'где лежит', 'местоположение',
    ],
    AiQueryIntentType.dimensions: [
      'какие размеры', 'размеры', 'какой размер',
    ],
    AiQueryIntentType.stockQuantity: [
      'сколько у меня', 'текущий запас', 'остаток на складе',
    ],
  },
  mmWords: ['мм', 'миллиметр', 'миллиметров'],
  cmWords: ['см', 'сантиметр', 'сантиметров'],
  mWords: ['м', 'метр', 'метров'],
);
