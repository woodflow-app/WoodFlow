import '../../domain/entities/ai_query_intent.dart';
import '../../domain/services/ai_query_parser.dart';

/// Polish — primary, fully-authored language (project's development
/// language). See `docs/LANGUAGE_QUALITY.md` for the translation-
/// confidence tiers applied to the other 20 files in this directory.
const aiPatternsPl = AiLanguagePatterns(
  intentTriggers: {
    AiQueryIntentType.offcutMatch: [
      'czym zastąpić', 'jaki ścinek pasuje', 'zamiennik', 'alternatywa dla', 'pasujący ścinek',
    ],
    AiQueryIntentType.staleMaterials: [
      'zalegające materiały', 'materiały zalegające', 'co zalega', 'stare materiały',
    ],
    AiQueryIntentType.location: [
      'gdzie jest', 'gdzie znajduje się', 'lokalizacja', 'gdzie leży',
    ],
    AiQueryIntentType.dimensions: [
      'jakie wymiary', 'jakie ma wymiary', 'wymiary', 'jaki rozmiar',
    ],
    AiQueryIntentType.stockQuantity: [
      'ile mam', 'ile jest', 'stan magazynowy', 'ile sztuk',
    ],
  },
  mmWords: ['mm', 'milimetr', 'milimetry', 'milimetrów'],
  cmWords: ['cm', 'centymetr', 'centymetry', 'centymetrów'],
  mWords: ['m', 'metr', 'metry', 'metrów'],
);
