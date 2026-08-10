import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Latvian — "needs review" confidence tier, see
/// `docs/LANGUAGE_QUALITY.md`.
const aiPatternsLv = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'ar ko aizstāt', 'piemērots atgriezums', 'alternatīva', 'aizstājējs',
    ],
    AiQueryIntentType.staleMaterials: [
      'guļošs materiāls', 'vecs krājums', 'materiāls kas ilgi guļ',
    ],
    AiQueryIntentType.location: [
      'kur atrodas', 'kur ir', 'atrašanās vieta',
    ],
    AiQueryIntentType.dimensions: [
      'kādi ir izmēri', 'izmēri', 'kāds izmērs',
    ],
    AiQueryIntentType.stockQuantity: [
      'cik man ir', 'pašreizējais krājums', 'krājuma līmenis',
    ],
  },
  mmWords: ['mm', 'milimetrs'],
  cmWords: ['cm', 'centimetrs'],
  mWords: ['m', 'metrs'],
);
