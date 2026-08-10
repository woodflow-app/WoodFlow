# Changelog — WoodFlow (przebudowa)

Log zmian dla obecnej architektury WoodFlow (Warehouse → Rack → Slot →
Board/Offcut, get_it, Result<T>), śledzonej krokami ("Krok N") — nie
mylić z `/CHANGELOG.md` w katalogu głównym, który jest **zamrożonym
dokumentem v1.0** opisującym poprzednią, przed-przebudową wersję
aplikacji ("Offcut Manager") i nie jest już aktualizowany.

Ten plik zaczyna się od Kroku 10 — wcześniejsze kroki (1–9) nie są tu
retroaktywnie odtwarzane w formie wpisów zmian, żeby nie
zgadywać/nie fabrykować treści, której nie mam potwierdzonej. Pełna
lista wszystkich 15 kroków (potwierdzona przez Piotra) jest poniżej —
to jest odniesienie do statusu, nie log zmian dla 1–9.

## Roadmapa Etapu 1 / FREE (15 kroków)

1. Organization ✅
2. Warehouse ✅
3. Rack ✅
4. Slot ✅
5. Board ✅
6. Offcut ✅
7. QR (7.1 generowanie, 7.2 skanowanie, 7.3 etykiety PDF) ✅
8. Historia/Ledger ✅
9. Dashboard właściciela ✅
10. Eksport PDF/CSV/RTF ✅
11. Kalkulatory ✅
12. Baza dekorów ✅
13. Lista zakupów + niski stan ✅
14. AI v1 ✅
15. Cut Optimizer ⬜

## [Krok 10] — 2026-08-09

### Dodano — Eksport PDF/CSV/RTF
- `ExportRow` (`domain/entities/`) — samoopisujący się wiersz
  eksportu (`Map<String, String> cells`).
- `ExportGenerator` (`domain/services/`) — interfejs + `ExportFormat`
  (pdf/csv/rtf), z trzema implementacjami w `data/export/`
  (`PdfExportGenerator`, `CsvExportGenerator`, `RtfExportGenerator`),
  rejestrowanymi w `service_locator.dart` jako nazwane instancje
  get_it (`export_pdf`/`export_csv`/`export_rtf`) — `presentation/`
  nie importuje `data/` bezpośrednio.
- `ExportDataBuilder` (`domain/services/`) — czysty mapper
  Board/Offcut → `ExportRow`, typowany jak `LabelDataBuilder`.
- `ExportScreen` (`presentation/export/`) — wybór magazynu i formatu,
  eksport pełnego stanu inwentarza (płyty + ścinki, z lokalizacją,
  dekorem i statusem) przez systemowy share sheet
  (`share_plus` `SharePlus.instance.share(ShareParams(...))`,
  `XFile.fromData` — bez zapisu na dysk, działa też na web).
  Dostępny z ikony w `WarehouseListScreen`.
- 12 nowych kluczy l10n przetłumaczonych we wszystkich 21 językach.

### Naprawiono
- PDF eksportu renderował się domyślną czcionką `pdf` package
  (Helvetica, Base-14) — bez glifów dla polskich znaków
  diakrytycznych i cyrylicy, więc większość z 21 języków aplikacji
  wypadała z pustymi/błędnymi znakami w wygenerowanym PDF. Naprawione
  przez dołączenie czcionki Noto Sans (`assets/fonts/`, licencja SIL
  OFL 1.1) i podłączenie jej w `PdfExportGenerator`.
- Zweryfikowano manualnie: PDF, CSV i RTF wygenerowane dla jednego
  magazynu (2 płyty + 1 zarchiwizowany ścinek) — PDF odczytany
  wizualnie, CSV sprawdzony bajt-po-bajcie (BOM + separator `;`), RTF
  wczytany przez rzeczywisty parser (.NET `RichTextBox`).

## [Krok 11] — 2026-08-10

### Dodano — Kalkulatory
- `BoardMeasurementCalculator` (`domain/services/`) — powierzchnia
  (m²) i objętość (m³) z długości/szerokości/grubości (mm), ten sam
  wzorzec czystej, bezstanowej klasy co `LedgerEntryFormatter`.
- `EdgeBandingCalculator` (`domain/services/`) — długość okleiny z
  rolki (metry) ze średnicy zewnętrznej/rdzenia i grubości tasiemki,
  wzór przekroju pierścieniowego. **Tylko przeliczenie** — bez
  śledzenia stanu rolki jako pozycji magazynowej (świadoma decyzja
  zakresu na Krok 11; matematyka wydzielona jako samodzielna funkcja
  celowo, żeby przyszła encja `EdgeBandingRoll` — pełne śledzenie
  stanu, porównywalne rozmiarem do Board/Offcut — mogła jej użyć bez
  zmiany kształtu kalkulatora).
- `BoardMeasurement`, `EdgeBandingLength` (`domain/entities/`) —
  proste nośniki wyniku, jak `BoardLocation`/`LedgerEntryDescription`.
- `CalculatorsScreen` (`presentation/calculators/`) — dwie zakładki
  (Powierzchnia/objętość, Okleina), dostępny samodzielnie z ikony w
  `WarehouseListScreen` ORAZ jako skrót z `BoardDetailScreen`/
  `OffcutDetailScreen` z gotowo wypełnionymi wymiarami danej
  płyty/ścinka.
- Brak get_it/interfejsu — w odróżnieniu od `ExportGenerator`/
  `LabelGenerator`, nie ma tu realnej potrzeby wymienności w runtime;
  ten sam wybór co przy `DashboardService`.
- 10 nowych kluczy l10n przetłumaczonych we wszystkich 21 językach.
- Testy: `board_measurement_calculator_test.dart`,
  `edge_banding_calculator_test.dart` (razem 87 testów w projekcie).

## [Krok 12] — 2026-08-10

### Dodano — Baza dekorów (EGGER, 421 pozycji)
- **Research rynku przed implementacją**: sprawdzono 11 znaczących
  producentów płyt (EGGER, Kronospan, Pfleiderer, SWISS KRONO, Kaindl,
  Cleaf, Finsa, Kastamonu, Sonae Arauco, Unilin, Alvic) — żaden nie
  udostępnia publicznego API/pliku do automatycznego importu; jedyne
  realnie zweryfikowane dane w repo to istniejący, ręcznie
  przepisany z oficjalnego PDF-u katalog EGGER (421 pozycji, po
  usunięciu 78 duplikatów z 501 wpisów źródłowych). Zdecydowano:
  zaimportować tylko EGGER, nie tworzyć niezweryfikowanych danych dla
  innych producentów.
- `lib/data/decor_seeds/egger_decor_seed.dart` — dane przeniesione z
  dawnego `lib/data/egger_decors_seed.dart` (ta sama weryfikacja, ten
  sam zestaw 421 pozycji), przebudowane z `List<List<String>>` na
  `List<(String code, String name)>` + stała `eggerManufacturer`.
  Stary plik usunięty (zastąpiony, nie duplikat).
- `lib/data/database/migrations/v7_seed_egger_decors.dart` — migracja
  bez zmiany schematu, batch-insert 421 wierszy do żywej tabeli
  `decors` (`AppConstants.dbVersion`: 6 → 7). Nie dotyka 4 testowych
  wierszy z v4 (bare kody typu 'H3303' nigdy nie kolidują z pełnymi
  kodami z teksturą typu 'H3303 ST10').
- **Architektura rozszerzalna** (cel tego kroku): dodanie kolejnego
  producenta w przyszłości = nowy plik `*_decor_seed.dart` + nowa
  migracja `v8_seed_<producent>_decors.dart` (skopiowany szablon v7)
  + dwie linijki rejestracji w `migration_runner.dart` + bump
  `dbVersion` — bez zmian w `Decor`, `DecorRepository`,
  `DecorRepositoryImpl` ani żadnym istniejącym pliku migracji.
  Instrukcja krok po kroku w doc-comment `v7_seed_egger_decors.dart`.
- Testy: `test/egger_decor_catalog_test.dart` (integralność danych +
  weryfikacja żywego importu), zaktualizowany opis testu w
  `test/organization_and_decor_test.dart` (nieaktualny odnośnik do
  "future data-import task").

### Znane ograniczenie
- UI wyboru dekoru (`slot_detail_screen.dart`, dodawanie Board/Offcut)
  to wciąż zwykły `DropdownButtonFormField` — działa z 425 pozycjami,
  ale nie jest to dobry UX na taką skalę. Świadomie poza zakresem tego
  kroku (użytkownik zawężył zakres do bazy danych + architektury);
  `Autocomplete<Decor>` to oczywisty następny krok, nie zrobiony teraz.

## [Krok 13] — 2026-08-10

### Dodano — Lista zakupów + niski stan
- `Decor.minimumStockQuantity` (nullable `int`) — próg poniżej
  którego dekor trafia na listę zakupów. `null` = brak progu, nigdy
  nie alarmuje. Globalny per dekor (nie per magazyn) — świadoma
  decyzja zakresu, udokumentowana w doc-comment `Decor` jako punkt
  rozszerzenia na przyszłość (próg per (decorId, warehouseId) byłby
  nową encją, nie zmianą tego pola).
- `lib/data/database/migrations/v8_add_decor_minimum_stock.dart` —
  `ALTER TABLE decors ADD COLUMN minimum_stock_quantity INTEGER`
  (`AppConstants.dbVersion`: 7 → 8), bez wartości domyślnej innej niż
  NULL — migracja świadomie nie wymyśla progów, których nikt nie
  ustawił.
- `ShoppingListService` (`domain/services/`) — agreguje stan
  (Board+Offcut, bez zarchiwizowanych) per `decorId`, porównuje z
  progiem, zwraca posortowaną (najpilniejsze pierwsze) listę
  `ShoppingListItem`. Konkretna klasa, nie interfejs+impl — ta sama
  logika co `DashboardService` (jeden sensowny sposób liczenia,
  nic do podmiany w runtime).
- `ShoppingListScreen` (`presentation/shopping_list/`) — lista
  dekorów poniżej progu (ikona w `WarehouseListScreen`); FAB otwiera
  wyszukiwarkę dekoru (filtr po kodzie/nazwie w pamięci, wzorem
  `egger_colours.dart`'s `searchEggerColours()`) i dialog do
  ustawienia/wyczyszczenia progu — jedyne miejsce w aplikacji, gdzie
  próg jest edytowalny (nie ma osobnego ekranu zarządzania dekorami).
- 10 nowych kluczy l10n przetłumaczonych we wszystkich 21 językach.
- Testy: `test/shopping_list_service_test.dart` (7 przypadków: brak
  progu, poniżej/na poziomie progu, board+offcut liczone razem,
  zarchiwizowane wykluczone, sortowanie, czyszczenie progu).

## [Krok 14] — 2026-08-10

### Dodano — AI v1 (deterministyczny silnik zapytań NL)
- **Zakres ustalony wprost przed implementacją** (roadmapa nie
  precyzowała go): interfejs pytań w języku naturalnym, w pełni
  deterministyczny (dopasowywanie wzorców, **bez LLM/wywołań
  sieciowych**), nad *istniejącymi* repozytoriami/serwisami domenowymi.
  5 typów zapytań: stan/ilość, lokalizacja, wymiary, materiały
  zalegające (>1 rok, ta sama definicja co Dashboard), dopasowanie
  zalegającego ścinka do nowego zapotrzebowania na wymiar/dekor —
  przygotowanie pod Cut Optimizer (Krok 15), nie jego namiastka. Poza
  zakresem: rekomendacje zakupowe z analizą historii, automatyczne
  insighty na Dashboardzie, wszelka logika predykcyjna/ucząca się (to
  `docs/adr/smart-offcut-scoring-engine.md`, v2.x/v3.0, nie Krok 14).
- **Granica architektoniczna** (ten sam test co przy
  `PdfLabelGenerator`/`ExportGenerator`): `AiQueryEngine`
  (`domain/services/`) to jedyna klasa modułu AI dotykająca
  repozytoriów — orkiestruje `DecorRepository`/`BoardRepository`/
  `OffcutRepository`/`DashboardService`/`ShoppingListService`, nigdy
  nie odpytuje bazy bezpośrednio i nigdy nie duplikuje agregacji, którą
  ma już inny serwis. `ShoppingListService.build()`'s liczenie stanu
  wydzielone do publicznej `currentStockByDecor()`, reużywanej zamiast
  ponownie liczonej.
- `AiQueryParser` (`domain/services/`) — czysty, bezstanowy parser
  (ten sam wzorzec co `BoardMeasurementCalculator`): dopasowywanie
  fraz-wyzwalaczy per język + wyodrębnianie liczb/jednostek
  (mm/cm/m), zero LLM. Przyjmuje kod języka (`String`), nie Flutterowy
  `Locale` — `domain/` nigdze w tym repo nie importuje Fluttera.
- `OffcutMatchFinder` (`domain/services/`) — jedyna naprawdę nowa
  logika decyzyjna Kroku 14: czyste porównanie geometryczne (ten sam
  dekor, wszystkie wymiary ≥ żądane), posortowane od najmniejszego
  nadmiaru — świadomie NIE pełny Cut Optimizer.
- `sealed class AiQueryAnswer` (`domain/entities/ai_query_answer.dart`)
  — **pierwsze użycie `sealed` w tym repo** (Dart SDK `>=3.3.0`
  pozwala). 6 wariantów (5 odpowiedzi + `UnrecognizedQueryAnswer`)
  zamiast jednej klasy z polami nullable — wymusza wyczerpujący
  `switch` w `AiQueryScreen`, nowy wariant bez obsługi nie skompiluje
  się nigdzie w UI.
- `lib/data/ai_patterns/` — 21 plików (jeden per język aplikacji) +
  `ai_patterns_registry.dart`, dokładnie ten sam wzorzec "jeden plik
  per X + tabela rejestracji" co katalogi dekorów per producent (Krok
  12)/`migration_runner.dart`. **Wszystkie 21 języków w pełni
  funkcjonalne od dnia pierwszego** (świadoma decyzja Piotra — nie
  tylko polski, nie "architektura gotowa, dane later"). Te same trzy
  warstwy pewności co pliki ARB (`docs/LANGUAGE_QUALITY.md`,
  zaktualizowany o osobną sekcję dla tych plików) — warstwa "wymaga
  przeglądu" (ga/cy/gd) celowo minimalna (1–2 frazy), żeby nie udawać
  pewności, której nie ma.
- `AiQueryScreen` (`presentation/ai_query/`) — pole tekstowe + historia
  pytań/odpowiedzi w ramach sesji (bez zapisu), `switch` po
  `AiQueryAnswer`, tap-through do istniejących `BoardDetailScreen`/
  `OffcutDetailScreen`. Dostępny z ikony w `WarehouseListScreen`, ten
  sam wzorzec co Calculators/Export/Shopping List.
- 16 nowych kluczy l10n przetłumaczonych we wszystkich 21 językach.
- Testy: `ai_query_parser_test.dart` (pełne pokrycie PL, punktowo
  kilka innych języków), `offcut_match_finder_test.dart` (czysta
  geometria), `ai_query_engine_test.dart` (baza in-memory, wszystkie 5
  typów zapytań end-to-end), plus jeden nowy przypadek w
  `shopping_list_service_test.dart` dla `currentStockByDecor()` —
  razem 130 testów w projekcie.

### Backlog/ADR (poza zakresem tego kroku, nie modyfikują roadmapy Etapu 1)
- `docs/BACKLOG.md` — 9 pozycji (Demo Mode, WoodFlow Academy,
  Installation Wizard, Health Check, Diagnostics, Works with WoodFlow,
  Feature Preview, Confidence Level, Explain AI), każda z priorytetem/
  problemem/wartością/zależnościami/kryteriami akceptacji.
- `docs/adr/printer-integration.md` — drukowanie jako opcjonalna
  warstwa (`PrinterService`, nigdy zależność), marki startowe: Zebra/
  Brother/Epson/PDF Export.
- `docs/adr/smart-offcut-scoring-engine.md` — silnik oceny ścinków,
  v1.0 (zbieranie danych) → v2.x (deterministyczne reguły,
  konfigurowalne) → v3.0 (uczenie się z historii decyzji).

## [Poprawka iOS] — 2026-08-10

### Naprawiono
- `ios/Runner/Info.plist`: brakujący `NSCameraUsageDescription`,
  wymagany przez `mobile_scanner` (używany już w `ScanScreen` do
  skanowania QR) — bez tego klucza iOS crashuje aplikację przy
  próbie użycia kamery, nie tylko odmawia uprawnienia. Znalezione przy
  przeglądzie konfiguracji iOS pod kątem Kroku 10; niezależne od
  samego eksportu.
- Zidentyfikowano (nienaprawione — wymaga macOS/Xcode): brak
  `ios/Podfile` w repozytorium. Normalnie plik commitowany (w
  odróżnieniu od efemerycznego `GeneratedPluginRegistrant.*`,
  wygenerowanego lokalnie poprawnie z `FPPSharePlusPlugin`). Powinien
  zostać wygenerowany automatycznie przy pierwszym
  `flutter build ios`/`pod install` na Macu.
