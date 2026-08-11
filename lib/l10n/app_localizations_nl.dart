// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get warehousesTitle => 'Magazijnen';

  @override
  String get boardTitle => 'Plaat';

  @override
  String get offcutTitle => 'Restplaat';

  @override
  String get historyLabel => 'Geschiedenis';

  @override
  String get noEntries => 'Geen items.';

  @override
  String get cancel => 'Annuleren';

  @override
  String get save => 'Opslaan';

  @override
  String get archive => 'Archiveren';

  @override
  String get move => 'Verplaatsen';

  @override
  String get moveToLabel => 'Verplaatsen naar:';

  @override
  String get cut => 'Zagen';

  @override
  String get cutOffcut => 'Restplaat zagen';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get searchManually => 'Handmatig zoeken';

  @override
  String get scanAgain => 'Opnieuw scannen';

  @override
  String get scanQrCode => 'QR-code scannen';

  @override
  String get viewSourceBoard => 'Bronplaat bekijken';

  @override
  String get addBoard => 'Plaat toevoegen';

  @override
  String get addRack => 'Rek toevoegen';

  @override
  String get addSlot => 'Vak toevoegen';

  @override
  String get newBoardTitle => 'Nieuwe plaat';

  @override
  String get newRackTitle => 'Nieuw rek';

  @override
  String get newSlotTitle => 'Nieuw vak';

  @override
  String get deleteSlotQuestion => 'Dit vak verwijderen?';

  @override
  String get archiveBoardQuestion => 'Deze plaat archiveren?';

  @override
  String get archiveOffcutQuestion => 'Deze restplaat archiveren?';

  @override
  String get historyStaysVisible =>
      'De geschiedenis (Ledger) blijft zichtbaar.';

  @override
  String get deleteSlotWarning =>
      'Deze actie kan niet ongedaan worden gemaakt. Platen en restplaten in dit vak worden gearchiveerd (niet verwijderd) — hun geschiedenis blijft zichtbaar.';

  @override
  String get fillDimensionsCorrectly => 'Vul de afmetingen correct in.';

  @override
  String get noDecorsInCatalog =>
      'Geen decors in de catalogus — voeg er minstens één toe.';

  @override
  String get noOtherSlotInRack => 'Geen ander vak in dit rek.';

  @override
  String get noWarehousesYet =>
      'Nog geen magazijnen. Voeg het eerste toe met de +-knop.';

  @override
  String get nameLabel => 'Naam';

  @override
  String get nameHintSlot => 'Naam (bijv. A1)';

  @override
  String get nameHintRack => 'Reknaam (bijv. A, MAGAZIJN-1)';

  @override
  String get addressOptional => 'Adres (optioneel)';

  @override
  String get decorLabel => 'Decor';

  @override
  String get lengthMm => 'Lengte (mm)';

  @override
  String get widthMm => 'Breedte (mm)';

  @override
  String get thicknessMm => 'Dikte (mm)';

  @override
  String get capacityLabel => 'Capaciteit';

  @override
  String get capacityPcsLabel => 'Capaciteit (stuks)';

  @override
  String errorPrefix(String message) {
    return 'Fout: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Rek $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Rekken — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity stuks';
  }

  @override
  String get statusInStock => 'op voorraad';

  @override
  String get statusAvailable => 'beschikbaar';

  @override
  String get statusArchived => 'gearchiveerd';

  @override
  String get newWarehouseTitle => 'Nieuw magazijn';

  @override
  String get noItemsInSlot => 'Geen platen of restplaten in dit vak.';

  @override
  String get noRacksYet =>
      'Geen rekken in dit magazijn.\nVoeg het eerste toe om locaties te organiseren.';

  @override
  String get noSlotsYet =>
      'Geen vakken in dit rek.\nVoeg het eerste toe om platen en restplaten toe te wijzen.';

  @override
  String get boardsSectionLabel => 'PLATEN';

  @override
  String get offcutsSectionLabel => 'RESTPLATEN';

  @override
  String get qrCodeNotFound => 'Deze code bestaat niet of is verwijderd.';

  @override
  String get delete => 'Verwijderen';

  @override
  String get deleteSlotButton => 'Vak verwijderen';

  @override
  String cutFromBoardNote(String decor) {
    return 'Van plaat ($decor) — blijft in hetzelfde vak.';
  }

  @override
  String statusLabel(String value) {
    return 'Status: $value';
  }

  @override
  String get printLabelsForSlot => 'Labels afdrukken';

  @override
  String get eventCreated => 'Aangemaakt';

  @override
  String get eventMoved => 'Verplaatst';

  @override
  String get eventArchived => 'Gearchiveerd';

  @override
  String get eventCut => 'Gezaagd';

  @override
  String get eventQrRegenerated => 'QR opnieuw gegenereerd';

  @override
  String get ownerDashboardTitle => 'Eigenaarsdashboard';

  @override
  String get totalBoardsLabel => 'Platen';

  @override
  String get totalOffcutsLabel => 'Restplaten';

  @override
  String get overallFillRateLabel => 'Bezettingsgraad';

  @override
  String get totalRacksSlotsLabel => 'Rekken / Vakken';

  @override
  String get staleItemsSectionTitle => 'Liggend materiaal';

  @override
  String get staleItemsSectionSubtitle => 'Meer dan een jaar ongebruikt';

  @override
  String get noStaleItems => 'Geen liggend materiaal.';

  @override
  String get locationUnknown => 'Locatie onbekend';

  @override
  String daysAgo(int days) {
    return '$days dagen geleden';
  }

  @override
  String get exportTitle => 'Exporteren';

  @override
  String get exportWarehouseLabel => 'Magazijn';

  @override
  String get exportButton => 'Exporteren';

  @override
  String get exportEmptyWarehouse =>
      'Dit magazijn heeft geen platen of restplaten om te exporteren.';

  @override
  String get exportColumnType => 'Type';

  @override
  String get exportColumnQrCode => 'QR-code';

  @override
  String get exportColumnDecorCode => 'Decorcode';

  @override
  String get exportColumnDecorName => 'Decornaam';

  @override
  String get exportColumnLocation => 'Locatie';

  @override
  String get exportColumnStatus => 'Status';

  @override
  String get exportColumnCreatedAt => 'Aangemaakt';

  @override
  String exportFailedMessage(String message) {
    return 'Exporteren mislukt: $message';
  }

  @override
  String get calculatorsTitle => 'Rekenmodules';

  @override
  String get calculatorAreaVolumeTab => 'Oppervlakte / volume';

  @override
  String get calculatorEdgeBandingTab => 'Kantenband';

  @override
  String get areaM2Label => 'Oppervlakte (m²)';

  @override
  String get volumeM3Label => 'Volume (m³)';

  @override
  String get outerDiameterMmLabel => 'Buitendiameter (mm)';

  @override
  String get coreDiameterMmLabel => 'Kerndiameter (mm)';

  @override
  String get tapeThicknessMmLabel => 'Dikte kantenband (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Lengte kantenband (m)';

  @override
  String get calculateButton => 'Berekenen';

  @override
  String get shoppingListTitle => 'Boodschappenlijst';

  @override
  String get shoppingListNoThresholds =>
      'Nog geen minimumvoorraaddrempels ingesteld. Tik op + om de eerste in te stellen.';

  @override
  String get shoppingListAllSufficient =>
      'Alle ingestelde drempels zijn in orde — niets heeft een lage voorraad.';

  @override
  String get currentStockLabel => 'Op voorraad';

  @override
  String get minimumStockLabel => 'Minimumdrempel';

  @override
  String get setThresholdTitle => 'Minimumvoorraaddrempel instellen';

  @override
  String get searchDecorHint => 'Decor zoeken (code of naam)';

  @override
  String get minimumStockQuantityLabel => 'Minimumvoorraad (stuks)';

  @override
  String get clearThresholdButton => 'Drempel verwijderen';

  @override
  String get invalidQuantityMessage => 'Voer een geheel getal in, 0 of hoger.';

  @override
  String get aiQueryTitle => 'AI vragen';

  @override
  String get aiQueryInputHint =>
      'Stel een vraag over het magazijn, bijv. \"Hoeveel H3303 heb ik?\"';

  @override
  String get aiQuerySendTooltip => 'Verzenden';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Ik begrijp de vraag niet: „$query”. Probeer bijv. „Hoeveel H3303 heb ik?”';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity stuks op voorraad';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Locaties — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Geen platen van dit decor momenteel op voorraad.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Afmetingen — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Geen materiaal van dit decor momenteel op voorraad.';

  @override
  String get aiQueryStaleHeader => 'Liggend materiaal';

  @override
  String get aiQueryStaleEmpty => 'Geen liggend materiaal.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Passende reststukken — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty => 'Geen passend reststuk van dit decor.';

  @override
  String get aiQueryBoardTypeLabel => 'Plaat';

  @override
  String get aiQueryOffcutTypeLabel => 'Reststuk';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Overschot: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Magazijn „$name” verwijderen?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Deze actie kan niet ongedaan worden gemaakt. Alle rekken en vakken in dit magazijn worden verwijderd. Platen en reststukken erin worden gearchiveerd (niet verwijderd) — hun geschiedenis blijft zichtbaar.';

  @override
  String deleteRackQuestion(String name) {
    return 'Rek „$name” verwijderen?';
  }

  @override
  String get deleteRackWarning =>
      'Deze actie kan niet ongedaan worden gemaakt. Alle vakken in dit rek worden verwijderd. Platen en reststukken erin worden gearchiveerd (niet verwijderd) — hun geschiedenis blijft zichtbaar.';
}
