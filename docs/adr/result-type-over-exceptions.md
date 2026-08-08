# ADR: Result<T> zamiast wyjątków na granicy warstw

## Status
Zaakceptowane

## Kontekst
Warstwy `data/` i `domain/` muszą sygnalizować błędy (rekord nie
istnieje, naruszenie unikalności, awaria zapytania SQL) w sposób,
który UI/ViewModel może obsłużyć bez `try/catch` rozsianego po
dziesiątkach plików. Klasyczne podejście z wyjątkami przenoszonymi
przez wszystkie warstwy prowadzi do tego, że każdy wywołujący musi
wiedzieć, jakie konkretne wyjątki może złapać dana metoda — a to
się rozjeżdża, gdy dokłada się kolejne repozytoria.

## Decyzja
- Wyjątki (`DatabaseException`, `NotFoundException`,
  `MigrationException`, `ValidationException`) są rzucane WYŁĄCZNIE
  wewnątrz `data/` (datasources, `DatabaseService`).
- Każda metoda repozytorium łapie je w jednym miejscu i zamienia na
  `Failure` przez `mapExceptionToFailure()`.
- Zwracany typ każdej metody repozytorium to `Result<T>`
  (`core/errors/failures.dart`), nigdy goły `T` z możliwością rzutu.
- UI/ViewModel korzysta z `result.when(success:, failure:)` — nigdy
  nie pisze `try/catch` samodzielnie.

## Konsekwencje
**Plusy:**
- Sygnatura metody (`Future<Result<Warehouse>>`) od razu mówi, że coś
  może pójść nie tak — nie trzeba czytać implementacji ani
  dokumentacji, żeby to wiedzieć.
- UI nie może "zapomnieć" obsłużyć błędu — `when()` wymaga obu gałęzi.
- Łatwe testowanie: `result.isFailure` / `result.data` bez mockowania
  wyjątków.

**Minusy / kompromisy:**
- Dodatkowa warstwa opakowania (`Result<T>`) w każdej sygnaturze —
  nieco więcej boilerplate niż `Future<T>` + `throws`.
- Zespół (nawet jednoosobowy) musi pamiętać regułę: nowy typ wyjątku
  → dopisać gałąź w `mapExceptionToFailure()`, inaczej wpadnie w
  `UnknownFailure` z mniej użytecznym komunikatem.

## Alternatywy rozważane
- **Rzucanie wyjątków aż do UI, łapanie w widgetach** — odrzucone:
  prowadzi do rozproszonego error handlingu, trudnego do utrzymania
  spójności komunikatów dla użytkownika.
- **`Either<Failure, T>` z pakietu `dartz`** — funkcjonalnie
  równoważne, ale dodaje zewnętrzną zależność i mniej czytelne API
  (`fold` zamiast `when`) dla kogoś niezaznajomionego z FP. Własny
  `Result<T>` jest równie skuteczny i prostszy do zrozumienia.
