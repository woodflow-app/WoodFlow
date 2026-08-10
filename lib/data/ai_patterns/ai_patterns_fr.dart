import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// French — "strong" confidence tier, see `docs/LANGUAGE_QUALITY.md`.
const aiPatternsFr = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'par quoi remplacer', 'chute de remplacement', 'alternative pour', 'remplacement pour',
    ],
    AiQueryIntentType.staleMaterials: [
      'matériaux dormants', 'stock ancien', 'matériaux en attente depuis longtemps',
    ],
    AiQueryIntentType.location: [
      'où se trouve', 'où est', 'emplacement de', 'où sont',
    ],
    AiQueryIntentType.dimensions: [
      "quelles sont les dimensions", 'dimensions de', 'quelle taille',
    ],
    AiQueryIntentType.stockQuantity: [
      "combien j'ai", 'combien ai-je', 'stock actuel', 'niveau de stock',
    ],
  },
  mmWords: ['mm', 'millimètre', 'millimètres'],
  cmWords: ['cm', 'centimètre', 'centimètres'],
  mWords: ['m', 'mètre', 'mètres'],
);
