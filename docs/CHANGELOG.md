# Changelog — WoodFlow (przebudowa)

Log zmian dla obecnej architektury WoodFlow (Warehouse → Rack → Slot →
Board/Offcut, get_it, Result<T>), śledzonej krokami ("Krok N") — nie
mylić z `/CHANGELOG.md` w katalogu głównym, który jest **zamrożonym
dokumentem v1.0** opisującym poprzednią, przed-przebudową wersję
aplikacji ("Offcut Manager") i nie jest już aktualizowany.

Ten plik zaczyna się od Kroku 10 — wcześniejsze kroki (7.1–9) nie są
tu retroaktywnie odtwarzane, żeby nie zgadywać/nie fabrykować treści,
której nie mam potwierdzonej.

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
