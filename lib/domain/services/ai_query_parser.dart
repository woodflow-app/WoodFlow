import '../entities/ai_query_intent.dart';

/// One language's pattern dictionary for `AiQueryParser` — trigger
/// phrases per intent type, plus the unit words used to interpret
/// numbers found in a query. One `AiLanguagePatterns` instance per
/// app language, defined in `lib/data/ai_patterns/`, mirroring how
/// `lib/data/decor_seeds/` holds one file per manufacturer (Krok 12).
class AiLanguagePatterns {
  final Map<AiQueryIntentType, List<String>> intentTriggers;
  final List<String> mmWords;
  final List<String> cmWords;
  final List<String> mWords;

  const AiLanguagePatterns({
    required this.intentTriggers,
    required this.mmWords,
    required this.cmWords,
    required this.mWords,
  });
}

/// Krok 14's deterministic natural-language query parser. Pure and
/// stateless — no repository access, no I/O, same "pure calculator"
/// shape as `BoardMeasurementCalculator`/`EdgeBandingCalculator`. Takes
/// raw text plus a plain language code (NOT a Flutter `Locale` —
/// `domain/` never imports Flutter anywhere in this codebase; the
/// caller in `presentation/` extracts `.languageCode` before calling
/// in). Never calls an LLM or any network service — matching is
/// entirely phrase-list containment plus a shared numeric/unit
/// extraction, identical logic across all 21 languages, only the
/// dictionaries differ (see `AiLanguagePatterns`).
class AiQueryParser {
  const AiQueryParser(this._patternsByLanguage);

  /// Registered patterns keyed by ISO language code — see
  /// `ai_patterns_registry.dart`. Injected rather than imported
  /// directly so this class stays testable with a minimal fixture
  /// dictionary instead of requiring all 21 real files in every test.
  final Map<String, AiLanguagePatterns> _patternsByLanguage;

  /// Checked in this fixed order so a query matching more than one
  /// intent's trigger phrases resolves deterministically. More
  /// specific/rarer intents first (offcutMatch, staleMaterials) so a
  /// generic word inside a more specific phrase can't shadow it.
  static const _priorityOrder = [
    AiQueryIntentType.offcutMatch,
    AiQueryIntentType.staleMaterials,
    AiQueryIntentType.location,
    AiQueryIntentType.dimensions,
    AiQueryIntentType.stockQuantity,
  ];

  static final _numberPattern = RegExp(r'^\d+(?:[.,]\d+)?$');
  static final _dimensionTokenPattern =
      RegExp(r'^\d+(?:[.,]\d+)?[x×]\d+(?:[.,]\d+)?([x×]\d+(?:[.,]\d+)?)?$');
  static final _trailingPunctuation = RegExp(r'[?!.,;:]+$');

  /// Returns `null` when no intent's trigger phrases match anywhere in
  /// [rawText] — `AiQueryEngine` turns that into `UnrecognizedQueryAnswer`,
  /// never a guess.
  ParsedAiQuery? parse(String rawText, String languageCode) {
    final normalized =
        rawText.trim().toLowerCase().replaceAll(_trailingPunctuation, '').trim();
    if (normalized.isEmpty) return null;

    final patterns = _patternsByLanguage[languageCode] ?? _patternsByLanguage['en'];
    if (patterns == null) return null;

    for (final intentType in _priorityOrder) {
      final triggers = patterns.intentTriggers[intentType] ?? const [];
      for (final trigger in triggers) {
        if (normalized.contains(trigger)) {
          return _buildParsedQuery(intentType, normalized, trigger, patterns);
        }
      }
    }
    return null;
  }

  ParsedAiQuery _buildParsedQuery(
    AiQueryIntentType intentType,
    String normalized,
    String matchedTrigger,
    AiLanguagePatterns patterns,
  ) {
    final remainder = normalized.replaceFirst(matchedTrigger, ' ').trim();

    if (intentType == AiQueryIntentType.offcutMatch) {
      final (lengthMm, widthMm, thicknessMm) = _extractDimensions(remainder, patterns);
      final decorText = _stripDimensionTokens(remainder, patterns);
      return ParsedAiQuery(
        intentType: intentType,
        decorQueryText: decorText.isEmpty ? null : decorText,
        requestedLengthMm: lengthMm,
        requestedWidthMm: widthMm,
        requestedThicknessMm: thicknessMm,
      );
    }

    return ParsedAiQuery(
      intentType: intentType,
      decorQueryText: remainder.isEmpty ? null : remainder,
    );
  }

  /// Reads up to 3 numbers in appearance order as length/width/
  /// thickness (mm). Works token-by-token (split on whitespace), NOT
  /// a scan for digits anywhere in the string — a digit sequence
  /// embedded inside a word (e.g. the "3303" inside decor code
  /// "h3303") must never be misread as a dimension. Two token shapes
  /// are recognized: an "x"/"×"-joined group ("600x400x18", assumed
  /// mm, no separate unit word possible) or a bare number optionally
  /// followed by its own unit-word token ("600 mm"); a bare number
  /// with no recognized unit word next to it defaults to mm, matching
  /// how Board/Offcut already store raw millimetre values with no
  /// unit shown in most of the app's UI. A number glued directly to
  /// its unit with no space ("600mm") is deliberately NOT supported —
  /// out of scope for this deterministic v1 parser.
  (double?, double?, double?) _extractDimensions(String text, AiLanguagePatterns patterns) {
    final tokens = text.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
    final values = <double>[];

    var i = 0;
    while (i < tokens.length) {
      final token = tokens[i];

      if (_dimensionTokenPattern.hasMatch(token)) {
        for (final part in token.split(RegExp(r'[x×]'))) {
          final value = double.tryParse(part.replaceAll(',', '.'));
          if (value != null) values.add(value);
        }
        i++;
        continue;
      }

      if (_numberPattern.hasMatch(token)) {
        final value = double.parse(token.replaceAll(',', '.'));
        final nextToken = i + 1 < tokens.length ? tokens[i + 1] : '';
        final (multiplier, consumed) = _unitWordMultiplier(nextToken, patterns);
        values.add(value * multiplier);
        i += consumed;
        continue;
      }

      i++;
    }

    return (
      values.isNotEmpty ? values[0] : null,
      values.length > 1 ? values[1] : null,
      values.length > 2 ? values[2] : null,
    );
  }

  /// `consumed` is 2 when [nextToken] is itself a recognized unit word
  /// (so the caller's token loop skips past it, having folded it into
  /// the multiplier), 1 when it's just a bare number defaulting to mm.
  (double, int) _unitWordMultiplier(String nextToken, AiLanguagePatterns patterns) {
    if (patterns.mmWords.contains(nextToken)) return (1.0, 2);
    if (patterns.cmWords.contains(nextToken)) return (10.0, 2);
    if (patterns.mWords.contains(nextToken)) return (1000.0, 2);
    return (1.0, 1);
  }

  /// Whatever is left of [text] after removing number tokens (with an
  /// optional unit word) and "x"/"×" separators is treated as the
  /// decor name/code the user meant — handed to `AiQueryEngine` for
  /// resolution against `DecorRepository`, never matched here.
  String _stripDimensionTokens(String text, AiLanguagePatterns patterns) {
    final allUnitWords = {...patterns.mmWords, ...patterns.cmWords, ...patterns.mWords};
    final kept = <String>[];
    for (final token in text.split(RegExp(r'\s+'))) {
      if (token.isEmpty) continue;
      if (token == 'x' || token == '×') continue;
      if (_numberPattern.hasMatch(token) && double.tryParse(token.replaceAll(',', '.')) != null) {
        continue;
      }
      if (_dimensionTokenPattern.hasMatch(token)) continue;
      if (allUnitWords.contains(token)) continue;
      kept.add(token);
    }
    return kept.join(' ').trim();
  }
}
