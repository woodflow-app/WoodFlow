// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get warehousesTitle => 'Sklady';

  @override
  String get boardTitle => 'Deska';

  @override
  String get offcutTitle => 'Odrezok';

  @override
  String get historyLabel => 'História';

  @override
  String get noEntries => 'Žiadne záznamy.';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get save => 'Uložiť';

  @override
  String get archive => 'Archivovať';

  @override
  String get move => 'Presunúť';

  @override
  String get moveToLabel => 'Presunúť do:';

  @override
  String get cut => 'Rezať';

  @override
  String get cutOffcut => 'Odrezať odrezok';

  @override
  String get retry => 'Skúsiť znova';

  @override
  String get searchManually => 'Vyhľadať manuálne';

  @override
  String get scanAgain => 'Naskenovať znova';

  @override
  String get scanQrCode => 'Naskenovať QR kód';

  @override
  String get viewSourceBoard => 'Zobraziť zdrojovú desku';

  @override
  String get addBoard => 'Pridať desku';

  @override
  String get addRack => 'Pridať regál';

  @override
  String get addSlot => 'Pridať priehradku';

  @override
  String get newBoardTitle => 'Nová deska';

  @override
  String get newRackTitle => 'Nový regál';

  @override
  String get newSlotTitle => 'Nová priehradka';

  @override
  String get deleteSlotQuestion => 'Odstrániť túto priehradku?';

  @override
  String get archiveBoardQuestion => 'Archivovať túto desku?';

  @override
  String get archiveOffcutQuestion => 'Archivovať tento odrezok?';

  @override
  String get historyStaysVisible => 'História (Ledger) zostane viditeľná.';

  @override
  String get deleteSlotWarning =>
      'Túto akciu nie je možné vrátiť späť. Dosky a odrezky v tejto priehradke budú archivované (nie odstránené) — ich história zostane viditeľná.';

  @override
  String get fillDimensionsCorrectly => 'Vyplňte rozmery správne.';

  @override
  String get noDecorsInCatalog =>
      'V katalógu nie sú žiadne dekory — pridajte aspoň jeden.';

  @override
  String get noOtherSlotInRack =>
      'V tomto regáli nie je žiadna iná priehradka.';

  @override
  String get noWarehousesYet =>
      'Zatiaľ žiadne sklady. Pridajte prvý tlačidlom +.';

  @override
  String get nameLabel => 'Názov';

  @override
  String get nameHintSlot => 'Názov (napr. A1)';

  @override
  String get nameHintRack => 'Názov regálu (napr. A, SKLAD-1)';

  @override
  String get addressOptional => 'Adresa (nepovinné)';

  @override
  String get decorLabel => 'Dekor';

  @override
  String get lengthMm => 'Dĺžka (mm)';

  @override
  String get widthMm => 'Šírka (mm)';

  @override
  String get thicknessMm => 'Hrúbka (mm)';

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
  String get statusInStock => 'na sklade';

  @override
  String get statusAvailable => 'dostupný';

  @override
  String get statusArchived => 'archivované';

  @override
  String get newWarehouseTitle => 'Nový sklad';

  @override
  String get noItemsInSlot =>
      'V tejto priehradke nie sú žiadne dosky ani odrezky.';

  @override
  String get noRacksYet =>
      'V tomto sklade nie sú žiadne regály.\nPridajte prvý, aby ste mohli organizovať umiestnenia.';

  @override
  String get noSlotsYet =>
      'V tomto regáli nie sú žiadne priehradky.\nPridajte prvú, aby ste mohli priraďovať dosky a odrezky.';

  @override
  String get boardsSectionLabel => 'DOSKY';

  @override
  String get offcutsSectionLabel => 'ODREZKY';

  @override
  String get qrCodeNotFound => 'Tento kód neexistuje alebo bol odstránený.';

  @override
  String get delete => 'Odstrániť';

  @override
  String get deleteSlotButton => 'Odstrániť priehradku';

  @override
  String cutFromBoardNote(String decor) {
    return 'Z dosky ($decor) — zostáva v tej istej priehradke.';
  }

  @override
  String statusLabel(String value) {
    return 'Stav: $value';
  }

  @override
  String get printLabelsForSlot => 'Tlač štítkov';

  @override
  String get eventCreated => 'Vytvorené';

  @override
  String get eventMoved => 'Presunuté';

  @override
  String get eventArchived => 'Archivované';

  @override
  String get eventCut => 'Narezané';

  @override
  String get eventQrRegenerated => 'QR obnovené';

  @override
  String get ownerDashboardTitle => 'Panel majiteľa';

  @override
  String get totalBoardsLabel => 'Dosky';

  @override
  String get totalOffcutsLabel => 'Odrezky';

  @override
  String get overallFillRateLabel => 'Naplnenosť';

  @override
  String get totalRacksSlotsLabel => 'Regály / Priehradky';

  @override
  String get staleItemsSectionTitle => 'Ležiace materiály';

  @override
  String get staleItemsSectionSubtitle => 'Nepoužité viac ako rok';

  @override
  String get noStaleItems => 'Žiadne ležiace materiály.';

  @override
  String get locationUnknown => 'Umiestnenie neznáme';

  @override
  String daysAgo(int days) {
    return 'pred $days dňami';
  }

  @override
  String get exportTitle => 'Export';

  @override
  String get exportWarehouseLabel => 'Sklad';

  @override
  String get exportButton => 'Exportovať';

  @override
  String get exportEmptyWarehouse =>
      'Tento sklad nemá žiadne dosky ani odrezky na export.';

  @override
  String get exportColumnType => 'Typ';

  @override
  String get exportColumnQrCode => 'QR kód';

  @override
  String get exportColumnDecorCode => 'Kód dekoru';

  @override
  String get exportColumnDecorName => 'Názov dekoru';

  @override
  String get exportColumnLocation => 'Umiestnenie';

  @override
  String get exportColumnStatus => 'Stav';

  @override
  String get exportColumnCreatedAt => 'Vytvorené';

  @override
  String exportFailedMessage(String message) {
    return 'Export sa nepodaril: $message';
  }

  @override
  String get calculatorsTitle => 'Kalkulátory';

  @override
  String get calculatorAreaVolumeTab => 'Plocha / objem';

  @override
  String get calculatorEdgeBandingTab => 'Olepovacia páska';

  @override
  String get areaM2Label => 'Plocha (m²)';

  @override
  String get volumeM3Label => 'Objem (m³)';

  @override
  String get outerDiameterMmLabel => 'Vonkajší priemer (mm)';

  @override
  String get coreDiameterMmLabel => 'Priemer jadra (mm)';

  @override
  String get tapeThicknessMmLabel => 'Hrúbka pásky (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Dĺžka pásky (m)';

  @override
  String get calculateButton => 'Prepočítať';

  @override
  String get shoppingListTitle => 'Nákupný zoznam';

  @override
  String get shoppingListNoThresholds =>
      'Zatiaľ nie sú nastavené žiadne prahy minimálneho stavu. Klepnutím na + nastavte prvý.';

  @override
  String get shoppingListAllSufficient =>
      'Všetky nastavené prahy sú dodržané — žiadny stav nie je nízky.';

  @override
  String get currentStockLabel => 'Na sklade';

  @override
  String get minimumStockLabel => 'Minimálny prah';

  @override
  String get setThresholdTitle => 'Nastaviť prah minimálneho stavu';

  @override
  String get searchDecorHint => 'Hľadať dekor (kód alebo názov)';

  @override
  String get minimumStockQuantityLabel => 'Minimálny stav (ks)';

  @override
  String get clearThresholdButton => 'Odstrániť prah';

  @override
  String get invalidQuantityMessage => 'Zadajte celé číslo, 0 alebo viac.';

  @override
  String get aiQueryTitle => 'Opýtať sa AI';

  @override
  String get aiQueryInputHint =>
      'Opýtajte sa na sklad, napr. \"Koľko mám H3303?\"';

  @override
  String get aiQuerySendTooltip => 'Odoslať';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Nerozumiem otázke: „$query“. Skúste napr. „Koľko mám H3303?“';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity ks skladom';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Umiestnenia — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Žiadne dosky tohto dekoru aktuálne skladom.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Rozmery — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Žiadny materiál tohto dekoru aktuálne skladom.';

  @override
  String get aiQueryStaleHeader => 'Ležiaci materiál';

  @override
  String get aiQueryStaleEmpty => 'Žiadny ležiaci materiál.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Vhodné odrezky — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty => 'Žiadny vhodný odrezok tohto dekoru.';

  @override
  String get aiQueryBoardTypeLabel => 'Doska';

  @override
  String get aiQueryOffcutTypeLabel => 'Odrezok';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Prebytok: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Odstrániť sklad „$name“?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Túto akciu nemožno vrátiť späť. Všetky regály a police v tomto sklade budú odstránené. Dosky a odrezky v nich budú archivované (nie odstránené) — ich história zostane viditeľná.';

  @override
  String deleteRackQuestion(String name) {
    return 'Odstrániť regál „$name“?';
  }

  @override
  String get deleteRackWarning =>
      'Túto akciu nemožno vrátiť späť. Všetky priehradky v tomto regáli budú odstránené. Dosky a odrezky v nich budú archivované (nie odstránené) — ich história zostane viditeľná.';

  @override
  String get decorCatalogBreadcrumb => 'Sklad';

  @override
  String get decorCatalogTitle => 'Katalóg dekorov';

  @override
  String get decorCatalogSearchHint => 'Hľadať kód alebo názov…';

  @override
  String get decorFilterAll => 'Všetky';

  @override
  String get decorFilterBoard => 'Dosky';

  @override
  String get decorFilterWorktop => 'Pracovné dosky';

  @override
  String get decorFilterEdging => 'Hrany';

  @override
  String get decorTypeBoard => 'Doska';

  @override
  String get decorTypeWorktop => 'Pracovná doska';

  @override
  String get decorTypeEdging => 'Hrana';

  @override
  String get decorEmptyNoData => 'V databáze nie sú žiadne dekory';

  @override
  String decorEmptyNoResults(String query) {
    return 'Žiadne dekory nezodpovedajú výrazu „$query“';
  }

  @override
  String get decorRetry => 'Skúsiť znova';

  @override
  String get decorApproxColorLabel => 'orientačná farba';

  @override
  String get decorSeeRealPhoto => 'Zobraziť fotografiu dekoru';

  @override
  String decorImageSourceNote(String domain) {
    return 'otvorí oficiálnu webovú stránku $domain';
  }

  @override
  String get decorNoImageLinkSnackbar =>
      'Pre tento dekor nie je k dispozícii odkaz na obrázok';

  @override
  String get decorFailedToOpenLinkSnackbar => 'Odkaz sa nepodarilo otvoriť';
}
