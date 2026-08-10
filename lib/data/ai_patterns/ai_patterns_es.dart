import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Spanish — "strong" confidence tier, see `docs/LANGUAGE_QUALITY.md`.
const aiPatternsEs = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'con qué puedo reemplazar', 'recorte alternativo', 'alternativa para', 'reemplazo para',
    ],
    AiQueryIntentType.staleMaterials: [
      'materiales estancados', 'stock antiguo', 'materiales sin usar desde hace tiempo',
    ],
    AiQueryIntentType.location: [
      'dónde está', 'dónde se encuentra', 'ubicación de', 'dónde están',
    ],
    AiQueryIntentType.dimensions: [
      'cuáles son las dimensiones', 'dimensiones de', 'qué tamaño',
    ],
    AiQueryIntentType.stockQuantity: [
      'cuánto tengo', 'cuántos tengo', 'stock actual', 'nivel de stock',
    ],
  },
  mmWords: ['mm', 'milímetro', 'milímetros'],
  cmWords: ['cm', 'centímetro', 'centímetros'],
  mWords: ['m', 'metro', 'metros'],
);
