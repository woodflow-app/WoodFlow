# WoodFlow — stan projektu

Kod odzwierciedla dosłownie to, co jest w `lib/` dzisiaj — nie
historię decyzji po drodze (ta żyje w `docs/`).

## Uruchomienie

```bash
flutter pub get
flutter run
```

## Roadmapa Etapu 1 / FREE (15 kroków, potwierdzona przez Piotra)

**⚠️ Status ✅ dla kroków 1-14 oznacza dziś: zaimplementowane I
zweryfikowane** — `flutter analyze` (0 błędów), `flutter test` (130
testów, w tym `arb_consistency_test.dart`). Build APK na Androidzie
zweryfikowany dla kroków 1-13 (fizyczne urządzenie) — Krok 14 nie był
jeszcze budowany jako APK na tej maszynie od czasu jego dodania, tylko
`flutter analyze`/`flutter test`. iOS nie był budowany na tej maszynie
— wymaga macOS/Xcode (patrz `docs/CHANGELOG.md`, sekcja "Poprawka
iOS", i brak `ios/Podfile`).

```
1. Organization                     ✅
2. Warehouse                        ✅
3. Rack                             ✅
4. Slot                             ✅
5. Board                            ✅  slotId jako jedyny klucz lokalizacji
6. Offcut                           ✅  decorId denormalizowane z Board przy cięciu
7. QR                               ✅  7.1 generowanie, 7.2 skanowanie, 7.3 etykiety PDF
8. Historia/Ledger                  ✅  LedgerEntryFormatter — czytelne opisy z payload
9. Dashboard właściciela            ✅  DashboardService (agreguje) → DashboardSnapshot → ekran tylko renderuje. Wycena i oszczędności odłożone — brak pola ceny w schemacie.
10. Eksport PDF/CSV/RTF             ✅  ExportRow/ExportGenerator (PDF/CSV/RTF)/ExportDataBuilder/ExportScreen
11. Kalkulatory                     ✅  BoardMeasurementCalculator (pow./obj.) + EdgeBandingCalculator (wzór przekroju pierścieniowego), CalculatorsScreen (2 zakładki), skrót z detali Board/Offcut z gotowymi wymiarami. Tylko przeliczenie — bez śledzenia stanu rolki (świadomie odłożone, patrz komentarz w edge_banding_calculator.dart)
12. Baza dekorów                    ✅  Pełny, zweryfikowany katalog EGGER (421 pozycji, migracja v7) zaimportowany do żywej tabeli `decors`. Architektura rozszerzalna: kolejny producent = nowy plik danych (`lib/data/decor_seeds/`) + nowa migracja, bez zmian w `Decor`/`DecorRepository`/istniejących migracjach. ⚠️ UI wyboru dekoru w `slot_detail_screen.dart` to wciąż zwykły `DropdownButtonFormField` — z 425 pozycjami działa, ale nie jest to dobry UX; autocomplete odłożone jako osobna decyzja, nie część tego kroku.
13. Lista zakupów + niski stan      ✅  `Decor.minimumStockQuantity` (nullable, migracja v8) + `ShoppingListService` (agreguje Board+Offcut per dekor, porównuje z progiem) + `ShoppingListScreen` (lista niskich stanów + wyszukiwarka dekoru + edycja/usuwanie progu). Próg per dekor, globalny (nie per magazyn) — architektura opisuje punkt rozszerzenia w doc-comment `ShoppingListService`/`Decor`
14. AI v1                           ✅  `AiQueryEngine` (orkiestruje istniejące repozytoria/serwisy, nigdy bezpośredni dostęp do bazy) + `AiQueryParser` (deterministyczne dopasowywanie wzorców, bez LLM, wzorce dla wszystkich 21 języków w `lib/data/ai_patterns/`) + `OffcutMatchFinder` (jedyna nowa logika decyzyjna — czyste dopasowanie geometryczne). 5 typów zapytań: stan, lokalizacja, wymiary, materiały zalegające, dopasowanie ścinka (przygotowanie pod Cut Optimizer, nie jego namiastka). `AiQueryScreen` dostępny z ikony w `WarehouseListScreen`. Zakres i granica architektoniczna: `docs/CHANGELOG.md` sekcja [Krok 14].
15. Cut Optimizer                   ⬜
```

**Znane ograniczenie Kroku 9:** lokalizacja pokazuje się w liście
"materiałów zalegających" tylko dla płyt, nie dla ścinków — `Offcut`
nie ma jeszcze własnego `getFullLocation()` (świadomy YAGNI, ten sam
kompromis co w `OffcutDetailScreen`). To nie błąd, tylko obecny
zakres.

## Infrastructure (poza numeracją 15 kroków — przekrojowe, nie część żadnego pojedynczego kroku)

```
Result<T>, get_it, Logger, MigrationRunner   ✅  Backend Foundation
i18n — 21 języków                             ✅  patrz docs/LANGUAGE_QUALITY.md
```

## Struktura

```
lib/
  core/           — Result<T>, wyjątki, logger, service locator, migracje QR
  data/           — migracje SQLite (v1-v6), implementacje repozytoriów
  domain/         — encje, kontrakty repozytoriów, QrResolver
  presentation/   — ekrany (Warehouse, Rack, Slot, Board, Offcut, Scan)
  main.dart       — punkt wejścia
```

## Model lokalizacji (kluczowa decyzja)

`Board`/`Offcut` znają WYŁĄCZNIE `slotId`. `Warehouse`/`Rack` są
zawsze wyprowadzane przez JOIN `slot → rack → warehouse`
(`BoardRepository.getFullLocation()`), nigdy przechowywane
redundantnie. Patrz `docs/PRE_BUILD_AUDIT.md`.

## Dokumentacja

- `docs/FULL_CODEBASE_AUDIT.md` — ostatni pełny przegląd całości
- `docs/INVARIANTS.md`, `docs/QR_CODES.md` — reguły domenowe
- `docs/adr/` — decyzje architektoniczne wciąż w mocy (get_it,
  MigrationRunner, Result<T>)
- `docs/adr/_archived_not_official/` — notatki z etapu, który został
  wycofany przy resecie do zamrożonej roadmapy; nie opisują
  dzisiejszego kodu

## Testy

```bash
flutter test
```

10 plików w `test/` — repozytoria (Warehouse, Rack/Slot, Board,
Offcut, Organization/Decor), generowanie QR, `QrResolver`,
`LabelDataBuilder`, `LedgerEntryFormatter`, spójność ARB
(`arb_consistency_test.dart`).
