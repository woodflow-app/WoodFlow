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

  @override
  String get exportTitle => 'Izvoz';

  @override
  String get exportWarehouseLabel => 'Skladišče';

  @override
  String get exportButton => 'Izvozi';

  @override
  String get exportEmptyWarehouse =>
      'To skladišče nima plošč ali odrezkov za izvoz.';

  @override
  String get exportColumnType => 'Vrsta';

  @override
  String get exportColumnQrCode => 'QR koda';

  @override
  String get exportColumnDecorCode => 'Koda dekorja';

  @override
  String get exportColumnDecorName => 'Ime dekorja';

  @override
  String get exportColumnLocation => 'Lokacija';

  @override
  String get exportColumnStatus => 'Stanje';

  @override
  String get exportColumnCreatedAt => 'Ustvarjeno';

  @override
  String exportFailedMessage(String message) {
    return 'Izvoz ni uspel: $message';
  }

  @override
  String get calculatorsTitle => 'Kalkulatorji';

  @override
  String get calculatorAreaVolumeTab => 'Površina / volumen';

  @override
  String get calculatorEdgeBandingTab => 'Robni trak';

  @override
  String get areaM2Label => 'Površina (m²)';

  @override
  String get volumeM3Label => 'Volumen (m³)';

  @override
  String get outerDiameterMmLabel => 'Zunanji premer (mm)';

  @override
  String get coreDiameterMmLabel => 'Premer jedra (mm)';

  @override
  String get tapeThicknessMmLabel => 'Debelina traku (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Dolžina traku (m)';

  @override
  String get calculateButton => 'Izračunaj';

  @override
  String get shoppingListTitle => 'Nakupovalni seznam';

  @override
  String get shoppingListNoThresholds =>
      'Še ni nastavljenih pragov minimalne zaloge. Dotaknite se +, da nastavite prvega.';

  @override
  String get shoppingListAllSufficient =>
      'Vsi nastavljeni pragovi so izpolnjeni — nobena zaloga ni nizka.';

  @override
  String get currentStockLabel => 'Na zalogi';

  @override
  String get minimumStockLabel => 'Minimalni prag';

  @override
  String get setThresholdTitle => 'Nastavi prag minimalne zaloge';

  @override
  String get searchDecorHint => 'Iskanje dekorja (koda ali ime)';

  @override
  String get minimumStockQuantityLabel => 'Minimalna zaloga (kos)';

  @override
  String get clearThresholdButton => 'Odstrani prag';

  @override
  String get invalidQuantityMessage => 'Vnesite celo število, 0 ali več.';

  @override
  String get aiQueryTitle => 'Vprašaj AI';

  @override
  String get aiQueryInputHint =>
      'Postavite vprašanje o skladišču, npr. \"Koliko imam H3303?\"';

  @override
  String get aiQuerySendTooltip => 'Pošlji';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Ne razumem vprašanja: „$query”. Poskusite npr. „Koliko imam H3303?”';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity kos na zalogi';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Lokacije — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Trenutno ni plošč tega dekorja na zalogi.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Dimenzije — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Trenutno ni materiala tega dekorja na zalogi.';

  @override
  String get aiQueryStaleHeader => 'Zaostali material';

  @override
  String get aiQueryStaleEmpty => 'Ni zaostalega materiala.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Ustrezni odrezki — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty => 'Ni ustreznega odrezka tega dekorja.';

  @override
  String get aiQueryBoardTypeLabel => 'Plošča';

  @override
  String get aiQueryOffcutTypeLabel => 'Odrezek';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Presežek: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Izbrisati skladišče „$name”?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Tega dejanja ni mogoče razveljaviti. Vse police in mesta v tem skladišču bodo izbrisani. Plošče in odrezki na njih bodo arhivirani (ne izbrisani) — njihova zgodovina ostane vidna.';
}
