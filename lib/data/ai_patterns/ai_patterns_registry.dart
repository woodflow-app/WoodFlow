import '../../domain/services/ai_query_parser.dart';
import 'ai_patterns_cs.dart';
import 'ai_patterns_cy.dart';
import 'ai_patterns_da.dart';
import 'ai_patterns_de.dart';
import 'ai_patterns_en.dart';
import 'ai_patterns_es.dart';
import 'ai_patterns_fr.dart';
import 'ai_patterns_ga.dart';
import 'ai_patterns_gd.dart';
import 'ai_patterns_hr.dart';
import 'ai_patterns_hu.dart';
import 'ai_patterns_it.dart';
import 'ai_patterns_lt.dart';
import 'ai_patterns_lv.dart';
import 'ai_patterns_nl.dart';
import 'ai_patterns_no.dart';
import 'ai_patterns_pl.dart';
import 'ai_patterns_ru.dart';
import 'ai_patterns_sk.dart';
import 'ai_patterns_sl.dart';
import 'ai_patterns_sv.dart';

/// One entry per app language (`LocaleProvider.supportedLocales`),
/// same "one file per X + one lookup table" shape as
/// `migration_runner.dart`'s migration list. `AiQueryParser` falls
/// back to `'en'` if a language code somehow isn't here — defensive
/// only, every supported locale has a file, so that branch should
/// never actually trigger.
final Map<String, AiLanguagePatterns> aiPatternsRegistry = {
  'pl': aiPatternsPl,
  'en': aiPatternsEn,
  'de': aiPatternsDe,
  'fr': aiPatternsFr,
  'it': aiPatternsIt,
  'es': aiPatternsEs,
  'ru': aiPatternsRu,
  'nl': aiPatternsNl,
  'sv': aiPatternsSv,
  'da': aiPatternsDa,
  'cs': aiPatternsCs,
  'sk': aiPatternsSk,
  'hu': aiPatternsHu,
  'hr': aiPatternsHr,
  'sl': aiPatternsSl,
  'lv': aiPatternsLv,
  'lt': aiPatternsLt,
  'ga': aiPatternsGa,
  'no': aiPatternsNo,
  'cy': aiPatternsCy,
  'gd': aiPatternsGd,
};
