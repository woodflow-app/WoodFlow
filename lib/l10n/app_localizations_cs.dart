// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get warehousesTitle => 'Sklady';

  @override
  String get boardTitle => 'Deska';

  @override
  String get offcutTitle => 'Odřezek';

  @override
  String get historyLabel => 'Historie';

  @override
  String get noEntries => 'Žádné záznamy.';

  @override
  String get cancel => 'Zrušit';

  @override
  String get save => 'Uložit';

  @override
  String get archive => 'Archivovat';

  @override
  String get move => 'Přesunout';

  @override
  String get moveToLabel => 'Přesunout do:';

  @override
  String get cut => 'Nařezat';

  @override
  String get cutOffcut => 'Nařezat odřezek';

  @override
  String get retry => 'Zkusit znovu';

  @override
  String get searchManually => 'Vyhledat manuálně';

  @override
  String get scanAgain => 'Naskenovat znovu';

  @override
  String get scanQrCode => 'Naskenovat QR kód';

  @override
  String get viewSourceBoard => 'Zobrazit zdrojovou desku';

  @override
  String get addBoard => 'Přidat desku';

  @override
  String get addRack => 'Přidat regál';

  @override
  String get addSlot => 'Přidat pozici';

  @override
  String get newBoardTitle => 'Nová deska';

  @override
  String get newRackTitle => 'Nový regál';

  @override
  String get newSlotTitle => 'Nová pozice';

  @override
  String get deleteSlotQuestion => 'Smazat tuto pozici?';

  @override
  String get archiveBoardQuestion => 'Archivovat tuto desku?';

  @override
  String get archiveOffcutQuestion => 'Archivovat tento odřezek?';

  @override
  String get historyStaysVisible => 'Historie (Ledger) zůstane viditelná.';

  @override
  String get deleteSlotWarning =>
      'Tuto akci nelze vrátit zpět. Desky a odřezky přiřazené k této pozici nebudou smazány — pouze ztratí přiřazené umístění (slot_id bude odkazovat na neexistující záznam — budoucí úklidový krok, pokud bude potřeba).';

  @override
  String get fillDimensionsCorrectly => 'Vyplňte rozměry správně.';

  @override
  String get noDecorsInCatalog =>
      'V katalogu nejsou žádné dekory — přidejte alespoň jeden.';

  @override
  String get noOtherSlotInRack => 'V tomto regálu není žádná jiná pozice.';

  @override
  String get noWarehousesYet =>
      'Zatím žádné sklady. Přidejte první tlačítkem +.';

  @override
  String get nameLabel => 'Název';

  @override
  String get nameHintSlot => 'Název (např. A1)';

  @override
  String get nameHintRack => 'Název regálu (např. A, SKLAD-1)';

  @override
  String get addressOptional => 'Adresa (nepovinné)';

  @override
  String get decorLabel => 'Dekor';

  @override
  String get lengthMm => 'Délka (mm)';

  @override
  String get widthMm => 'Šířka (mm)';

  @override
  String get thicknessMm => 'Tloušťka (mm)';

  @override
  String get capacityLabel => 'Kapacita';

  @override
  String get capacityPcsLabel => 'Kapacita (ks)';

  @override
  String errorPrefix(String message) {
    return 'Chyba: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Regál $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Regály — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity ks';
  }

  @override
  String get statusInStock => 'na skladě';

  @override
  String get statusAvailable => 'dostupný';

  @override
  String get statusArchived => 'archivováno';

  @override
  String get newWarehouseTitle => 'Nový sklad';

  @override
  String get noItemsInSlot => 'V této pozici nejsou žádné desky ani odřezky.';

  @override
  String get noRacksYet =>
      'V tomto skladu nejsou žádné regály.\nPřidejte první, abyste mohli organizovat umístění.';

  @override
  String get noSlotsYet =>
      'V tomto regálu nejsou žádné pozice.\nPřidejte první, abyste mohli přiřazovat desky a odřezky.';

  @override
  String get boardsSectionLabel => 'DESKY';

  @override
  String get offcutsSectionLabel => 'ODŘEZKY';

  @override
  String get qrCodeNotFound => 'Tento kód neexistuje nebo byl odstraněn.';

  @override
  String get delete => 'Smazat';

  @override
  String get deleteSlotButton => 'Smazat pozici';

  @override
  String cutFromBoardNote(String decor) {
    return 'Z desky ($decor) — zůstává ve stejné pozici.';
  }

  @override
  String statusLabel(String value) {
    return 'Stav: $value';
  }

  @override
  String get printLabelsForSlot => 'Tisk štítků';

  @override
  String get eventCreated => 'Vytvořeno';

  @override
  String get eventMoved => 'Přesunuto';

  @override
  String get eventArchived => 'Archivováno';

  @override
  String get eventCut => 'Nařezáno';

  @override
  String get eventQrRegenerated => 'QR obnoveno';

  @override
  String get ownerDashboardTitle => 'Panel majitele';

  @override
  String get totalBoardsLabel => 'Desky';

  @override
  String get totalOffcutsLabel => 'Odřezky';

  @override
  String get overallFillRateLabel => 'Naplněnost';

  @override
  String get totalRacksSlotsLabel => 'Regály / Pozice';

  @override
  String get staleItemsSectionTitle => 'Ležící materiály';

  @override
  String get staleItemsSectionSubtitle => 'Nepoužité déle než rok';

  @override
  String get noStaleItems => 'Žádné ležící materiály.';

  @override
  String get locationUnknown => 'Umístění neznámé';

  @override
  String daysAgo(int days) {
    return 'před $days dny';
  }

  @override
  String get exportTitle => 'Export';

  @override
  String get exportWarehouseLabel => 'Sklad';

  @override
  String get exportButton => 'Exportovat';

  @override
  String get exportEmptyWarehouse =>
      'Tento sklad nemá žádné desky ani odřezky k exportu.';

  @override
  String get exportColumnType => 'Typ';

  @override
  String get exportColumnQrCode => 'QR kód';

  @override
  String get exportColumnDecorCode => 'Kód dekoru';

  @override
  String get exportColumnDecorName => 'Název dekoru';

  @override
  String get exportColumnLocation => 'Umístění';

  @override
  String get exportColumnStatus => 'Stav';

  @override
  String get exportColumnCreatedAt => 'Vytvořeno';

  @override
  String exportFailedMessage(String message) {
    return 'Export se nezdařil: $message';
  }

  @override
  String get calculatorsTitle => 'Kalkulátory';

  @override
  String get calculatorAreaVolumeTab => 'Plocha / objem';

  @override
  String get calculatorEdgeBandingTab => 'Olepovací páska';

  @override
  String get areaM2Label => 'Plocha (m²)';

  @override
  String get volumeM3Label => 'Objem (m³)';

  @override
  String get outerDiameterMmLabel => 'Vnější průměr (mm)';

  @override
  String get coreDiameterMmLabel => 'Průměr jádra (mm)';

  @override
  String get tapeThicknessMmLabel => 'Tloušťka pásky (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Délka pásky (m)';

  @override
  String get calculateButton => 'Přepočítat';

  @override
  String get shoppingListTitle => 'Nákupní seznam';

  @override
  String get shoppingListNoThresholds =>
      'Zatím nejsou nastaveny žádné prahy minimálního stavu. Klepnutím na + nastavte první.';

  @override
  String get shoppingListAllSufficient =>
      'Všechny nastavené prahy jsou dodrženy — žádný stav není nízký.';

  @override
  String get currentStockLabel => 'Na skladě';

  @override
  String get minimumStockLabel => 'Minimální práh';

  @override
  String get setThresholdTitle => 'Nastavit práh minimálního stavu';

  @override
  String get searchDecorHint => 'Hledat dekor (kód nebo název)';

  @override
  String get minimumStockQuantityLabel => 'Minimální stav (ks)';

  @override
  String get clearThresholdButton => 'Odstranit práh';

  @override
  String get invalidQuantityMessage => 'Zadejte celé číslo, 0 nebo více.';

  @override
  String get aiQueryTitle => 'Zeptat se AI';

  @override
  String get aiQueryInputHint =>
      'Zeptejte se na sklad, např. \"Kolik mám H3303?\"';

  @override
  String get aiQuerySendTooltip => 'Odeslat';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Nerozumím otázce: „$query“. Zkuste např. „Kolik mám H3303?“';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity ks skladem';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Umístění — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Žádné desky tohoto dekoru aktuálně skladem.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Rozměry — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Žádný materiál tohoto dekoru aktuálně skladem.';

  @override
  String get aiQueryStaleHeader => 'Ležící materiál';

  @override
  String get aiQueryStaleEmpty => 'Žádný ležící materiál.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Vhodné odřezky — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty => 'Žádný vhodný odřezek tohoto dekoru.';

  @override
  String get aiQueryBoardTypeLabel => 'Deska';

  @override
  String get aiQueryOffcutTypeLabel => 'Odřezek';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Přebytek: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Smazat sklad „$name“?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Tuto akci nelze vrátit zpět. Všechny regály a police v tomto skladu budou smazány. Desky a odřezky v nich budou archivovány (ne smazány) — jejich historie zůstane viditelná.';
}
