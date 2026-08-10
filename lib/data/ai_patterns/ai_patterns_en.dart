import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// English — "strong" confidence tier, see `docs/LANGUAGE_QUALITY.md`.
const aiPatternsEn = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'what can replace', 'find alternative', 'matching offcut', 'replacement for', 'alternative for',
    ],
    AiQueryIntentType.staleMaterials: [
      'stale materials', 'materials sitting', 'old stock', 'aging materials',
    ],
    AiQueryIntentType.location: [
      'where is', 'where are', 'location of', 'find location',
    ],
    AiQueryIntentType.dimensions: [
      'what are the dimensions', 'dimensions of', 'what size', 'size of',
    ],
    AiQueryIntentType.stockQuantity: [
      'how much do i have', 'how many do i have', 'current stock', 'stock level',
    ],
  },
  mmWords: ['mm', 'millimeter', 'millimeters', 'millimetre', 'millimetres'],
  cmWords: ['cm', 'centimeter', 'centimeters', 'centimetre', 'centimetres'],
  mWords: ['m', 'meter', 'meters', 'metre', 'metres'],
);
