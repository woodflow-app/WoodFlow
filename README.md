# WoodFlow — stan projektu

Kod odzwierciedla dosłownie to, co jest w `lib/` dzisiaj — nie
historię decyzji po drodze (ta żyje w `docs/`).

## Uruchomienie

```bash
flutter pub get
flutter run
```

## Roadmapa Etapu 1 / FREE (15 kroków, potwierdzona przez Piotra)

**⚠️ Status ✅ dla kroków 1-11 oznacza dziś: zaimplementowane I
zweryfikowane** — `flutter analyze` (0 błędów), `flutter test` (87
testów, w tym `arb_consistency_test.dart`), build APK na Androidzie
(fizyczne urządzenie). iOS nie był budowany na tej maszynie — wymaga
macOS/Xcode (patrz `docs/CHANGELOG.md`, sekcja "Poprawka iOS", i brak
`ios/Podfile`).

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
12. Baza dekorów                    ⬜  encja/repozytorium już istnieją (katalog EGGER częściowy, bez autouzupełniania w dedykowanym ekranie); pełny katalog 421 kodów + UI zarządzania jeszcze nie
13. Lista zakupów + niski stan      ⬜
14. AI v1                           ⬜
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
