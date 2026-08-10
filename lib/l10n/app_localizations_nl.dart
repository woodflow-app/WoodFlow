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
      'Deze actie kan niet ongedaan worden gemaakt. Platen en restplaten in dit vak worden niet verwijderd — ze verliezen alleen hun toegewezen locatie (slot_id verwijst dan naar een niet-bestaand record — een toekomstige opruimstap indien nodig).';

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
}
