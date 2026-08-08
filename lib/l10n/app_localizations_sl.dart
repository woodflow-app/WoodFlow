// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get warehousesTitle => 'Skladišča';

  @override
  String get boardTitle => 'Plošča';

  @override
  String get offcutTitle => 'Odrezek';

  @override
  String get historyLabel => 'Zgodovina';

  @override
  String get noEntries => 'Ni vnosov.';

  @override
  String get cancel => 'Prekliči';

  @override
  String get save => 'Shrani';

  @override
  String get archive => 'Arhiviraj';

  @override
  String get move => 'Premakni';

  @override
  String get moveToLabel => 'Premakni v:';

  @override
  String get cut => 'Odreži';

  @override
  String get cutOffcut => 'Odreži odrezek';

  @override
  String get retry => 'Poskusi znova';

  @override
  String get searchManually => 'Iskanje ročno';

  @override
  String get scanAgain => 'Ponovno skeniraj';

  @override
  String get scanQrCode => 'Skeniraj QR kodo';

  @override
  String get viewSourceBoard => 'Ogled izvorne plošče';

  @override
  String get addBoard => 'Dodaj ploščo';

  @override
  String get addRack => 'Dodaj regal';

  @override
  String get addSlot => 'Dodaj predal';

  @override
  String get newBoardTitle => 'Nova plošča';

  @override
  String get newRackTitle => 'Nov regal';

  @override
  String get newSlotTitle => 'Nov predal';

  @override
  String get deleteSlotQuestion => 'Izbrisati ta predal?';

  @override
  String get archiveBoardQuestion => 'Arhivirati to ploščo?';

  @override
  String get archiveOffcutQuestion => 'Arhivirati ta odrezek?';

  @override
  String get historyStaysVisible => 'Zgodovina (Ledger) bo ostala vidna.';

  @override
  String get deleteSlotWarning =>
      'Tega dejanja ni mogoče razveljaviti. Plošče in odrezki, dodeljeni temu predalu, ne bodo izbrisani — samo izgubili bodo dodeljeno lokacijo (slot_id bo kazal na neobstoječ zapis — prihodnji korak čiščenja, če bo potreben).';

  @override
  String get fillDimensionsCorrectly => 'Pravilno izpolnite dimenzije.';

  @override
  String get noDecorsInCatalog =>
      'V katalogu ni dekorjev — dodajte vsaj enega.';

  @override
  String get noOtherSlotInRack => 'V tem regalu ni drugega predala.';

  @override
  String get noWarehousesYet => 'Še ni skladišč. Dodajte prvo z gumbom +.';

  @override
  String get nameLabel => 'Ime';

  @override
  String get nameHintSlot => 'Ime (npr. A1)';

  @override
  String get nameHintRack => 'Ime regala (npr. A, SKLADIŠČE-1)';

  @override
  String get addressOptional => 'Naslov (neobvezno)';

  @override
  String get decorLabel => 'Dekor';

  @override
  String get lengthMm => 'Dolžina (mm)';

  @override
  String get widthMm => 'Širina (mm)';

  @override
  String get thicknessMm => 'Debelina (mm)';

  @override
  String get capacityLabel => 'Kapaciteta';

  @override
  String get capacityPcsLabel => 'Kapaciteta (kos)';

  @override
  String errorPrefix(String message) {
    return 'Napaka: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Regal $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Regali — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity kos';
  }

  @override
  String get statusInStock => 'na zalogi';

  @override
  String get statusAvailable => 'na voljo';

  @override
  String get statusArchived => 'arhivirano';

  @override
  String get newWarehouseTitle => 'Novo skladišče';

  @override
  String get noItemsInSlot => 'V tem predalu ni plošč ali odrezkov.';

  @override
  String get noRacksYet =>
      'V tem skladišču ni regalov.\nDodajte prvega, da začnete organizirati lokacije.';

  @override
  String get noSlotsYet =>
      'V tem regalu ni predalov.\nDodajte prvega, da boste lahko dodeljevali plošče in odrezke.';

  @override
  String get boardsSectionLabel => 'PLOŠČE';

  @override
  String get offcutsSectionLabel => 'ODREZKI';

  @override
  String get qrCodeNotFound => 'Ta koda ne obstaja ali je bila odstranjena.';

  @override
  String get delete => 'Izbriši';

  @override
  String get deleteSlotButton => 'Izbriši predal';

  @override
  String cutFromBoardNote(String decor) {
    return 'S plošče ($decor) — ostane v istem predalu.';
  }

  @override
  String statusLabel(String value) {
    return 'Stanje: $value';
  }

  @override
  String get printLabelsForSlot => 'Natisni nalepke';

  @override
  String get eventCreated => 'Ustvarjeno';

  @override
  String get eventMoved => 'Premaknjeno';

  @override
  String get eventArchived => 'Arhivirano';

  @override
  String get eventCut => 'Odrezano';

  @override
  String get eventQrRegenerated => 'QR obnovljen';

  @override
  String get ownerDashboardTitle => 'Nadzorna plošča lastnika';

  @override
  String get totalBoardsLabel => 'Plošče';

  @override
  String get totalOffcutsLabel => 'Odrezki';

  @override
  String get overallFillRateLabel => 'Zasedenost';

  @override
  String get totalRacksSlotsLabel => 'Regali / Predali';

  @override
  String get staleItemsSectionTitle => 'Zaležani materiali';

  @override
  String get staleItemsSectionSubtitle => 'Neuporabljeno več kot leto dni';

  @override
  String get noStaleItems => 'Ni zaležanih materialov.';

  @override
  String get locationUnknown => 'Lokacija neznana';

  @override
  String daysAgo(int days) {
    return 'pred $days dnevi';
  }
}
