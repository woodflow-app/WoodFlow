/// The 5 question types Krok 14's deterministic AI query engine can
/// answer — see `AiQueryParser`/`AiQueryEngine`. Deliberately closed at
/// 5: anything not matching one of these is `UnrecognizedQueryAnswer`,
/// never a guess. Extending this set means adding both a new
/// `AiQueryAnswer` variant and a new dispatch branch in
/// `AiQueryEngine.ask()` — the sealed `AiQueryAnswer` makes the
/// compiler enforce that pairing.
enum AiQueryIntentType {
  stockQuantity,
  location,
  dimensions,
  staleMaterials,
  offcutMatch,
}

/// Output of `AiQueryParser.parse()` — a recognized intent plus
/// whatever it managed to extract from the raw text. `decorQueryText`
/// is the raw substring `AiQueryEngine` will resolve against
/// `DecorRepository` (the parser itself never touches a repository —
/// pure text in, structured intent out). The three `requested*Mm`
/// fields are populated only for `offcutMatch`; every other intent
/// leaves them null.
class ParsedAiQuery {
  final AiQueryIntentType intentType;
  final String? decorQueryText;
  final double? requestedLengthMm;
  final double? requestedWidthMm;
  final double? requestedThicknessMm;

  const ParsedAiQuery({
    required this.intentType,
    this.decorQueryText,
    this.requestedLengthMm,
    this.requestedWidthMm,
    this.requestedThicknessMm,
  });
}
