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
13. Lista zakupów + niski stan ⬜
14. AI v1 ⬜
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
