import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Italian — "strong" confidence tier, see `docs/LANGUAGE_QUALITY.md`.
const aiPatternsIt = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'con cosa posso sostituire', 'ritaglio sostitutivo', 'alternativa per', 'sostituto per',
    ],
    AiQueryIntentType.staleMaterials: [
      'materiali fermi', 'giacenza vecchia', 'materiali in giacenza da tempo',
    ],
    AiQueryIntentType.location: [
      'dove si trova', 'dove è', 'posizione di', 'dove sono',
    ],
    AiQueryIntentType.dimensions: [
      'quali sono le dimensioni', 'dimensioni di', 'che misura',
    ],
    AiQueryIntentType.stockQuantity: [
      'quanto ho', 'quanti ne ho', 'scorta attuale', 'livello di stock',
    ],
  },
  mmWords: ['mm', 'millimetro', 'millimetri'],
  cmWords: ['cm', 'centimetro', 'centimetri'],
  mWords: ['m', 'metro', 'metri'],
);
