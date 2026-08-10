// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

  @override
  String get warehousesTitle => 'Lagre';

  @override
  String get boardTitle => 'Plate';

  @override
  String get offcutTitle => 'Kappstykke';

  @override
  String get historyLabel => 'Historikk';

  @override
  String get noEntries => 'Ingen oppføringer.';

  @override
  String get cancel => 'Avbryt';

  @override
  String get save => 'Lagre';

  @override
  String get archive => 'Arkiver';

  @override
  String get move => 'Flytt';

  @override
  String get moveToLabel => 'Flytt til:';

  @override
  String get cut => 'Kapp';

  @override
  String get cutOffcut => 'Kapp et stykke';

  @override
  String get retry => 'Prøv igjen';

  @override
  String get searchManually => 'Søk manuelt';

  @override
  String get scanAgain => 'Skann igjen';

  @override
  String get scanQrCode => 'Skann QR-kode';

  @override
  String get viewSourceBoard => 'Vis opprinnelig plate';

  @override
  String get addBoard => 'Legg til plate';

  @override
  String get addRack => 'Legg til reol';

  @override
  String get addSlot => 'Legg til hylle';

  @override
  String get newBoardTitle => 'Ny plate';

  @override
  String get newRackTitle => 'Ny reol';

  @override
  String get newSlotTitle => 'Ny hylle';

  @override
  String get deleteSlotQuestion => 'Slette denne hyllen?';

  @override
  String get archiveBoardQuestion => 'Arkivere denne platen?';

  @override
  String get archiveOffcutQuestion => 'Arkivere dette kappstykket?';

  @override
  String get historyStaysVisible => 'Historikken (Ledger) forblir synlig.';

  @override
  String get deleteSlotWarning =>
      'Denne handlingen kan ikke angres. Plater og kappstykker tilknyttet denne hyllen blir ikke slettet — de mister bare sin tilknyttede plassering (slot_id vil peke på en post som ikke finnes — et fremtidig ryddesteg om nødvendig).';

  @override
  String get fillDimensionsCorrectly => 'Fyll inn målene riktig.';

  @override
  String get noDecorsInCatalog =>
      'Ingen dekorer i katalogen — legg til minst én.';

  @override
  String get noOtherSlotInRack => 'Ingen annen hylle i denne reolen.';

  @override
  String get noWarehousesYet =>
      'Ingen lagre ennå. Legg til det første med +-knappen.';

  @override
  String get nameLabel => 'Navn';

  @override
  String get nameHintSlot => 'Navn (f.eks. A1)';

  @override
  String get nameHintRack => 'Reolnavn (f.eks. A, LAGER-1)';

  @override
  String get addressOptional => 'Adresse (valgfritt)';

  @override
  String get decorLabel => 'Dekor';

  @override
  String get lengthMm => 'Lengde (mm)';

  @override
  String get widthMm => 'Bredde (mm)';

  @override
  String get thicknessMm => 'Tykkelse (mm)';

  @override
  String get capacityLabel => 'Kapasitet';

  @override
  String get capacityPcsLabel => 'Kapasitet (stk.)';

  @override
  String errorPrefix(String message) {
    return 'Feil: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Reol $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Reoler — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity stk.';
  }

  @override
  String get statusInStock => 'på lager';

  @override
  String get statusAvailable => 'tilgjengelig';

  @override
  String get statusArchived => 'arkivert';

  @override
  String get newWarehouseTitle => 'Nytt lager';

  @override
  String get noItemsInSlot => 'Ingen plater eller kappstykker i denne hyllen.';

  @override
  String get noRacksYet =>
      'Ingen reoler i dette lageret.\nLegg til den første for å begynne å organisere plasseringer.';

  @override
  String get noSlotsYet =>
      'Ingen hyller i denne reolen.\nLegg til den første for å kunne tilordne plater og kappstykker.';

  @override
  String get boardsSectionLabel => 'PLATER';

  @override
  String get offcutsSectionLabel => 'KAPPSTYKKER';

  @override
  String get qrCodeNotFound => 'Denne koden finnes ikke eller er fjernet.';

  @override
  String get delete => 'Slett';

  @override
  String get deleteSlotButton => 'Slett hylle';

  @override
  String cutFromBoardNote(String decor) {
    return 'Fra plate ($decor) — blir i samme hylle.';
  }

  @override
  String statusLabel(String value) {
    return 'Status: $value';
  }

  @override
  String get printLabelsForSlot => 'Skriv ut etiketter';

  @override
  String get eventCreated => 'Opprettet';

  @override
  String get eventMoved => 'Flyttet';

  @override
  String get eventArchived => 'Arkivert';

  @override
  String get eventCut => 'Kappet';

  @override
  String get eventQrRegenerated => 'QR regenerert';

  @override
  String get ownerDashboardTitle => 'Eierpanel';

  @override
  String get totalBoardsLabel => 'Plater';

  @override
  String get totalOffcutsLabel => 'Kappstykker';

  @override
  String get overallFillRateLabel => 'Fyllingsgrad';

  @override
  String get totalRacksSlotsLabel => 'Reoler / Hyller';

  @override
  String get staleItemsSectionTitle => 'Liggende materialer';

  @override
  String get staleItemsSectionSubtitle => 'Ubrukt i over ett år';

  @override
  String get noStaleItems => 'Ingen liggende materialer.';

  @override
  String get locationUnknown => 'Ukjent plassering';

  @override
  String daysAgo(int days) {
    return '$days dager siden';
  }

  @override
  String get exportTitle => 'Eksporter';

  @override
  String get exportWarehouseLabel => 'Lager';

  @override
  String get exportButton => 'Eksporter';

  @override
  String get exportEmptyWarehouse =>
      'Dette lageret har ingen plater eller kappstykker å eksportere.';

  @override
  String get exportColumnType => 'Type';

  @override
  String get exportColumnQrCode => 'QR-kode';

  @override
  String get exportColumnDecorCode => 'Dekorkode';

  @override
  String get exportColumnDecorName => 'Dekornavn';

  @override
  String get exportColumnLocation => 'Plassering';

  @override
  String get exportColumnStatus => 'Status';

  @override
  String get exportColumnCreatedAt => 'Opprettet';

  @override
  String exportFailedMessage(String message) {
    return 'Eksport mislyktes: $message';
  }

  @override
  String get calculatorsTitle => 'Kalkulatorer';

  @override
  String get calculatorAreaVolumeTab => 'Areal / volum';

  @override
  String get calculatorEdgeBandingTab => 'Kantbånd';

  @override
  String get areaM2Label => 'Areal (m²)';

  @override
  String get volumeM3Label => 'Volum (m³)';

  @override
  String get outerDiameterMmLabel => 'Ytre diameter (mm)';

  @override
  String get coreDiameterMmLabel => 'Kjernediameter (mm)';

  @override
  String get tapeThicknessMmLabel => 'Tykkelse kantbånd (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Lengde kantbånd (m)';

  @override
  String get calculateButton => 'Beregn';
}
