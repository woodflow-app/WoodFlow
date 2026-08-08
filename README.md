# WoodFlow — stan projektu

Kod odzwierciedla dosłownie to, co jest w `lib/` dzisiaj — nie
historię decyzji po drodze (ta żyje w `docs/`).

## Uruchomienie

```bash
flutter pub get
flutter run
```

## Zbudowane (Etap 1 / FREE, kroki 1-7.2 z 15)

**⚠️ Status ✅ poniżej oznacza "implementacja kompletna", nie
"zweryfikowane uruchomieniem".** Żaden z tych kroków nie przeszedł
jeszcze realnego `flutter pub get && flutter test && flutter run` —
architektura i logika są sprawdzone (testy jednostkowe, symulacje
kluczowej logiki w Pythonie, ręczne sweep'y kodu), ale kompilacja i
uruchomienie na prawdziwym Flutterze to osobny, nadal otwarty krok.

```
1. Backend Foundation  ✅  Result<T>, get_it, Logger, MigrationRunner
2. Warehouse            ✅
3. Rack                 ✅
4. Slot                 ✅
5. Board                ✅  slotId jako jedyny klucz lokalizacji
6. Offcut                ✅  decorId denormalizowane z Board przy cięciu
7.1 QR — generowanie     ✅  WF-{TYP}-{8 hex z id}, case-insensitive
7.2 QR — skanowanie      ✅  ScanScreen → QrResolver → ekran
7.3 QR — etykiety PDF     ✅  LabelData → LabelGenerator → PdfLabelGenerator
8. Historia              ✅  LedgerEntryFormatter — czytelne opisy z payload
9. Dashboard właściciela ✅  DashboardService (agreguje) → DashboardSnapshot → ekran tylko renderuje. Wycena i oszczędności odłożone — brak pola ceny w schemacie.
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
