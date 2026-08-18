// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get warehousesTitle => 'Lager';

  @override
  String get boardTitle => 'Skiva';

  @override
  String get offcutTitle => 'Kapbit';

  @override
  String get historyLabel => 'Historik';

  @override
  String get noEntries => 'Inga poster.';

  @override
  String get cancel => 'Avbryt';

  @override
  String get save => 'Spara';

  @override
  String get archive => 'Arkivera';

  @override
  String get move => 'Flytta';

  @override
  String get moveToLabel => 'Flytta till:';

  @override
  String get cut => 'Kapa';

  @override
  String get cutOffcut => 'Kapa en bit';

  @override
  String get retry => 'Försök igen';

  @override
  String get searchManually => 'Sök manuellt';

  @override
  String get scanAgain => 'Skanna igen';

  @override
  String get scanQrCode => 'Skanna QR-kod';

  @override
  String get viewSourceBoard => 'Visa ursprunglig skiva';

  @override
  String get addBoard => 'Lägg till skiva';

  @override
  String get addRack => 'Lägg till hyllställ';

  @override
  String get addSlot => 'Lägg till fack';

  @override
  String get newBoardTitle => 'Ny skiva';

  @override
  String get newRackTitle => 'Nytt hyllställ';

  @override
  String get newSlotTitle => 'Nytt fack';

  @override
  String get deleteSlotQuestion => 'Ta bort detta fack?';

  @override
  String get archiveBoardQuestion => 'Arkivera denna skiva?';

  @override
  String get archiveOffcutQuestion => 'Arkivera denna kapbit?';

  @override
  String get historyStaysVisible => 'Historiken (Ledger) förblir synlig.';

  @override
  String get deleteSlotWarning =>
      'Denna åtgärd kan inte ångras. Skivor och kapbitar i detta fack arkiveras (tas inte bort) — deras historik förblir synlig.';

  @override
  String get fillDimensionsCorrectly => 'Fyll i måtten korrekt.';

  @override
  String get noDecorsInCatalog =>
      'Inga dekorer i katalogen — lägg till minst en.';

  @override
  String get noOtherSlotInRack => 'Inget annat fack i detta hyllställ.';

  @override
  String get noWarehousesYet =>
      'Inga lager ännu. Lägg till det första med +-knappen.';

  @override
  String get nameLabel => 'Namn';

  @override
  String get nameHintSlot => 'Namn (t.ex. A1)';

  @override
  String get nameHintRack => 'Hyllställnamn (t.ex. A, LAGER-1)';

  @override
  String get addressOptional => 'Adress (valfritt)';

  @override
  String get decorLabel => 'Dekor';

  @override
  String get lengthMm => 'Längd (mm)';

  @override
  String get widthMm => 'Bredd (mm)';

  @override
  String get thicknessMm => 'Tjocklek (mm)';

  @override
  String get capacityLabel => 'Kapacitet';

  @override
  String get capacityPcsLabel => 'Kapacitet (st)';

  @override
  String errorPrefix(String message) {
    return 'Fel: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Hyllställ $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Hyllställ — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity st';
  }

  @override
  String get statusInStock => 'i lager';

  @override
  String get statusAvailable => 'tillgänglig';

  @override
  String get statusArchived => 'arkiverad';

  @override
  String get newWarehouseTitle => 'Nytt lager';

  @override
  String get noItemsInSlot => 'Inga skivor eller kapbitar i detta fack.';

  @override
  String get noRacksYet =>
      'Inga hyllställ i detta lager.\nLägg till det första för att börja organisera platser.';

  @override
  String get noSlotsYet =>
      'Inga fack i detta hyllställ.\nLägg till det första för att kunna tilldela skivor och kapbitar.';

  @override
  String get boardsSectionLabel => 'SKIVOR';

  @override
  String get offcutsSectionLabel => 'KAPBITAR';

  @override
  String get qrCodeNotFound => 'Denna kod finns inte eller har tagits bort.';

  @override
  String get delete => 'Ta bort';

  @override
  String get deleteSlotButton => 'Ta bort fack';

  @override
  String cutFromBoardNote(String decor) {
    return 'Från skiva ($decor) — stannar i samma fack.';
  }

  @override
  String statusLabel(String value) {
    return 'Status: $value';
  }

  @override
  String get printLabelsForSlot => 'Skriv ut etiketter';

  @override
  String get eventCreated => 'Skapad';

  @override
  String get eventMoved => 'Flyttad';

  @override
  String get eventArchived => 'Arkiverad';

  @override
  String get eventCut => 'Kapad';

  @override
  String get eventQrRegenerated => 'QR återgenererad';

  @override
  String get ownerDashboardTitle => 'Ägarpanel';

  @override
  String get totalBoardsLabel => 'Skivor';

  @override
  String get totalOffcutsLabel => 'Kapbitar';

  @override
  String get overallFillRateLabel => 'Fyllnadsgrad';

  @override
  String get totalRacksSlotsLabel => 'Hyllställ / Fack';

  @override
  String get staleItemsSectionTitle => 'Liggande material';

  @override
  String get staleItemsSectionSubtitle => 'Oanvänt i över ett år';

  @override
  String get noStaleItems => 'Inget liggande material.';

  @override
  String get locationUnknown => 'Plats okänd';

  @override
  String daysAgo(int days) {
    return '$days dagar sedan';
  }

  @override
  String get exportTitle => 'Exportera';

  @override
  String get exportWarehouseLabel => 'Lager';

  @override
  String get exportButton => 'Exportera';

  @override
  String get exportEmptyWarehouse =>
      'Detta lager har inga skivor eller kapbitar att exportera.';

  @override
  String get exportColumnType => 'Typ';

  @override
  String get exportColumnQrCode => 'QR-kod';

  @override
  String get exportColumnDecorCode => 'Dekorkod';

  @override
  String get exportColumnDecorName => 'Dekornamn';

  @override
  String get exportColumnLocation => 'Plats';

  @override
  String get exportColumnStatus => 'Status';

  @override
  String get exportColumnCreatedAt => 'Skapad';

  @override
  String exportFailedMessage(String message) {
    return 'Export misslyckades: $message';
  }

  @override
  String get calculatorsTitle => 'Kalkylatorer';

  @override
  String get calculatorAreaVolumeTab => 'Yta / volym';

  @override
  String get calculatorEdgeBandingTab => 'Kantband';

  @override
  String get areaM2Label => 'Yta (m²)';

  @override
  String get volumeM3Label => 'Volym (m³)';

  @override
  String get outerDiameterMmLabel => 'Ytterdiameter (mm)';

  @override
  String get coreDiameterMmLabel => 'Kärndiameter (mm)';

  @override
  String get tapeThicknessMmLabel => 'Tjocklek kantband (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Längd kantband (m)';

  @override
  String get calculateButton => 'Beräkna';

  @override
  String get shoppingListTitle => 'Inköpslista';

  @override
  String get shoppingListNoThresholds =>
      'Inga minimilagernivåer inställda än. Tryck på + för att ställa in den första.';

  @override
  String get shoppingListAllSufficient =>
      'Alla inställda nivåer är uppfyllda — inget lager är lågt.';

  @override
  String get currentStockLabel => 'I lager';

  @override
  String get minimumStockLabel => 'Minimigräns';

  @override
  String get setThresholdTitle => 'Ställ in minimilagernivå';

  @override
  String get searchDecorHint => 'Sök dekor (kod eller namn)';

  @override
  String get minimumStockQuantityLabel => 'Minimilager (st)';

  @override
  String get clearThresholdButton => 'Ta bort gräns';

  @override
  String get invalidQuantityMessage => 'Ange ett heltal, 0 eller mer.';

  @override
  String get aiQueryTitle => 'Fråga AI';

  @override
  String get aiQueryInputHint =>
      'Ställ en fråga om lagret, t.ex. \"Hur mycket H3303 har jag?\"';

  @override
  String get aiQuerySendTooltip => 'Skicka';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Jag förstår inte frågan: ”$query”. Prova t.ex. ”Hur mycket H3303 har jag?”';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity st i lager';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Platser — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Inga skivor av denna dekor i lager just nu.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Mått — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Inget material av denna dekor i lager just nu.';

  @override
  String get aiQueryStaleHeader => 'Liggande material';

  @override
  String get aiQueryStaleEmpty => 'Inget liggande material.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Passande kapbitar — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty => 'Ingen passande kapbit av denna dekor.';

  @override
  String get aiQueryBoardTypeLabel => 'Skiva';

  @override
  String get aiQueryOffcutTypeLabel => 'Kapbit';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Överskott: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Ta bort lagret ”$name”?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Denna åtgärd kan inte ångras. Alla hyllor och platser i detta lager kommer att tas bort. Skivor och kapbitar i dem arkiveras (tas inte bort) — deras historik förblir synlig.';

  @override
  String deleteRackQuestion(String name) {
    return 'Ta bort hyllstället ”$name”?';
  }

  @override
  String get deleteRackWarning =>
      'Denna åtgärd kan inte ångras. Alla fack i detta hyllställ kommer att tas bort. Skivor och kapbitar i dem arkiveras (tas inte bort) — deras historik förblir synlig.';

  @override
  String get decorCatalogBreadcrumb => 'Lager';

  @override
  String get decorCatalogTitle => 'Dekorkatalog';

  @override
  String get decorCatalogSearchHint => 'Sök efter kod eller namn…';

  @override
  String get decorFilterAll => 'Alla';

  @override
  String get decorFilterBoard => 'Skivor';

  @override
  String get decorFilterWorktop => 'Bänkskivor';

  @override
  String get decorFilterEdging => 'Kantband';

  @override
  String get decorTypeBoard => 'Skiva';

  @override
  String get decorTypeWorktop => 'Bänkskiva';

  @override
  String get decorTypeEdging => 'Kantband';

  @override
  String get decorEmptyNoData => 'Inga dekorer i databasen';

  @override
  String decorEmptyNoResults(String query) {
    return 'Inga dekorer som matchar ”$query”';
  }

  @override
  String get decorRetry => 'Försök igen';

  @override
  String get decorApproxColorLabel => 'ungefärlig färg';

  @override
  String get decorSeeRealPhoto => 'Visa foto av dekoren';

  @override
  String decorImageSourceNote(String domain) {
    return 'öppnar den officiella webbplatsen för $domain';
  }

  @override
  String get decorNoImageLinkSnackbar => 'Ingen bildlänk för denna dekor';

  @override
  String get decorFailedToOpenLinkSnackbar => 'Det gick inte att öppna länken';
}
