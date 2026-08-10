// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get warehousesTitle => 'Magazyny';

  @override
  String get boardTitle => 'Płyta';

  @override
  String get offcutTitle => 'Ścinek';

  @override
  String get historyLabel => 'Historia';

  @override
  String get noEntries => 'Brak wpisów.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get save => 'Zapisz';

  @override
  String get archive => 'Archiwizuj';

  @override
  String get move => 'Przenieś';

  @override
  String get moveToLabel => 'Przenieś do:';

  @override
  String get cut => 'Wytnij';

  @override
  String get cutOffcut => 'Wytnij ścinek';

  @override
  String get retry => 'Ponów';

  @override
  String get searchManually => 'Wyszukaj ręcznie';

  @override
  String get scanAgain => 'Skanuj ponownie';

  @override
  String get scanQrCode => 'Skanuj kod QR';

  @override
  String get viewSourceBoard => 'Zobacz płytę źródłową';

  @override
  String get addBoard => 'Dodaj płytę';

  @override
  String get addRack => 'Dodaj regał';

  @override
  String get addSlot => 'Dodaj półkę';

  @override
  String get newBoardTitle => 'Nowa płyta';

  @override
  String get newRackTitle => 'Nowy regał';

  @override
  String get newSlotTitle => 'Nowa półka';

  @override
  String get deleteSlotQuestion => 'Usunąć półkę?';

  @override
  String get archiveBoardQuestion => 'Zarchiwizować płytę?';

  @override
  String get archiveOffcutQuestion => 'Zarchiwizować ścinek?';

  @override
  String get historyStaysVisible => 'Historia (Ledger) pozostanie widoczna.';

  @override
  String get deleteSlotWarning =>
      'Ta operacja jest nieodwracalna. Płyty i ścinki przypisane do tej półki nie zostaną usunięte, tylko stracą przypisaną lokalizację (slot_id wskaże na nieistniejący rekord — kolejny krok porządkowy, gdy zajdzie taka potrzeba).';

  @override
  String get fillDimensionsCorrectly => 'Uzupełnij wymiary poprawnie.';

  @override
  String get noDecorsInCatalog =>
      'Brak dekorów w katalogu — dodaj przynajmniej jeden.';

  @override
  String get noOtherSlotInRack => 'Brak innej półki w tym regale.';

  @override
  String get noWarehousesYet => 'Brak magazynów. Dodaj pierwszy przyciskiem +.';

  @override
  String get nameLabel => 'Nazwa';

  @override
  String get nameHintSlot => 'Nazwa (np. A1)';

  @override
  String get nameHintRack => 'Nazwa regału (np. A, MAGAZYN-1)';

  @override
  String get addressOptional => 'Adres (opcjonalnie)';

  @override
  String get decorLabel => 'Dekor';

  @override
  String get lengthMm => 'Dł. (mm)';

  @override
  String get widthMm => 'Szer. (mm)';

  @override
  String get thicknessMm => 'Grub. (mm)';

  @override
  String get capacityLabel => 'Pojemność';

  @override
  String get capacityPcsLabel => 'Pojemność (szt.)';

  @override
  String errorPrefix(String message) {
    return 'Błąd: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Regał $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Regały — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity szt.';
  }

  @override
  String get statusInStock => 'w magazynie';

  @override
  String get statusAvailable => 'dostępny';

  @override
  String get statusArchived => 'zarchiwizowany';

  @override
  String get newWarehouseTitle => 'Nowy magazyn';

  @override
  String get noItemsInSlot => 'Brak płyt ani ścinków w tej półce.';

  @override
  String get noRacksYet =>
      'Brak regałów w tym magazynie.\nDodaj pierwszy, żeby zacząć organizować lokalizacje.';

  @override
  String get noSlotsYet =>
      'Brak półek w tym regale.\nDodaj pierwszą, żeby móc przypisywać do niej płyty i ścinki.';

  @override
  String get boardsSectionLabel => 'PŁYTY';

  @override
  String get offcutsSectionLabel => 'ŚCINKI';

  @override
  String get qrCodeNotFound => 'Ten kod nie istnieje lub został usunięty.';

  @override
  String get delete => 'Usuń';

  @override
  String get deleteSlotButton => 'Usuń półkę';

  @override
  String cutFromBoardNote(String decor) {
    return 'Ze płyty ($decor) — zostaje w tej samej półce.';
  }

  @override
  String statusLabel(String value) {
    return 'Status: $value';
  }

  @override
  String get printLabelsForSlot => 'Drukuj etykiety';

  @override
  String get eventCreated => 'Utworzono';

  @override
  String get eventMoved => 'Przeniesiono';

  @override
  String get eventArchived => 'Zarchiwizowano';

  @override
  String get eventCut => 'Wycięto';

  @override
  String get eventQrRegenerated => 'Zregenerowano QR';

  @override
  String get ownerDashboardTitle => 'Panel właściciela';

  @override
  String get totalBoardsLabel => 'Płyty';

  @override
  String get totalOffcutsLabel => 'Ścinki';

  @override
  String get overallFillRateLabel => 'Zapełnienie';

  @override
  String get totalRacksSlotsLabel => 'Regały / Sloty';

  @override
  String get staleItemsSectionTitle => 'Materiały zalegające';

  @override
  String get staleItemsSectionSubtitle => 'Nieużywane dłużej niż rok';

  @override
  String get noStaleItems => 'Brak materiałów zalegających.';

  @override
  String get locationUnknown => 'Lokalizacja nieznana';

  @override
  String daysAgo(int days) {
    return '$days dni temu';
  }

  @override
  String get exportTitle => 'Eksport';

  @override
  String get exportWarehouseLabel => 'Magazyn';

  @override
  String get exportButton => 'Eksportuj';

  @override
  String get exportEmptyWarehouse =>
      'Ten magazyn nie ma płyt ani ścinków do eksportu.';

  @override
  String get exportColumnType => 'Typ';

  @override
  String get exportColumnQrCode => 'Kod QR';

  @override
  String get exportColumnDecorCode => 'Kod dekoru';

  @override
  String get exportColumnDecorName => 'Nazwa dekoru';

  @override
  String get exportColumnLocation => 'Lokalizacja';

  @override
  String get exportColumnStatus => 'Status';

  @override
  String get exportColumnCreatedAt => 'Utworzono';

  @override
  String exportFailedMessage(String message) {
    return 'Eksport nie powiódł się: $message';
  }

  @override
  String get calculatorsTitle => 'Kalkulatory';

  @override
  String get calculatorAreaVolumeTab => 'Powierzchnia / objętość';

  @override
  String get calculatorEdgeBandingTab => 'Okleina';

  @override
  String get areaM2Label => 'Powierzchnia (m²)';

  @override
  String get volumeM3Label => 'Objętość (m³)';

  @override
  String get outerDiameterMmLabel => 'Średnica zewnętrzna (mm)';

  @override
  String get coreDiameterMmLabel => 'Średnica rdzenia (mm)';

  @override
  String get tapeThicknessMmLabel => 'Grubość tasiemki (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Długość okleiny (m)';

  @override
  String get calculateButton => 'Przelicz';

  @override
  String get shoppingListTitle => 'Lista zakupów';

  @override
  String get shoppingListNoThresholds =>
      'Nie ustawiono jeszcze żadnych progów minimalnego stanu. Dotknij +, aby ustawić pierwszy.';

  @override
  String get shoppingListAllSufficient =>
      'Wszystkie ustawione progi są zachowane — brak niskich stanów.';

  @override
  String get currentStockLabel => 'W magazynie';

  @override
  String get minimumStockLabel => 'Próg minimalny';

  @override
  String get setThresholdTitle => 'Ustaw próg minimalnego stanu';

  @override
  String get searchDecorHint => 'Szukaj dekoru (kod lub nazwa)';

  @override
  String get minimumStockQuantityLabel => 'Minimalny stan (szt.)';

  @override
  String get clearThresholdButton => 'Usuń próg';

  @override
  String get invalidQuantityMessage => 'Podaj liczbę całkowitą, 0 lub więcej.';

  @override
  String get aiQueryTitle => 'Zapytaj AI';

  @override
  String get aiQueryInputHint => 'Zapytaj o magazyn, np. \"Ile mam H3303?\"';

  @override
  String get aiQuerySendTooltip => 'Wyślij';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Nie rozumiem pytania: „$query”. Spróbuj np. „Ile mam H3303?”';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity szt. w magazynie';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Lokalizacje — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Brak płyt tego dekoru obecnie w magazynie.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Wymiary — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Brak materiału tego dekoru obecnie w magazynie.';

  @override
  String get aiQueryStaleHeader => 'Materiały zalegające';

  @override
  String get aiQueryStaleEmpty => 'Brak zalegających materiałów.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Pasujące ścinki — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty => 'Brak pasującego ścinka tego dekoru.';

  @override
  String get aiQueryBoardTypeLabel => 'Płyta';

  @override
  String get aiQueryOffcutTypeLabel => 'Ścinek';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Nadmiar: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Usunąć magazyn „$name”?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Ta operacja jest nieodwracalna. Wszystkie regały i półki w tym magazynie zostaną usunięte. Płyty i ścinki w nich zostaną zarchiwizowane (nie usunięte) — historia pozostanie widoczna.';
}
