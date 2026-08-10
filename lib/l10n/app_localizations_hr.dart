// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get warehousesTitle => 'Skladišta';

  @override
  String get boardTitle => 'Ploča';

  @override
  String get offcutTitle => 'Otpadak';

  @override
  String get historyLabel => 'Povijest';

  @override
  String get noEntries => 'Nema unosa.';

  @override
  String get cancel => 'Odustani';

  @override
  String get save => 'Spremi';

  @override
  String get archive => 'Arhiviraj';

  @override
  String get move => 'Premjesti';

  @override
  String get moveToLabel => 'Premjesti u:';

  @override
  String get cut => 'Izreži';

  @override
  String get cutOffcut => 'Izreži otpadak';

  @override
  String get retry => 'Pokušaj ponovno';

  @override
  String get searchManually => 'Pretraži ručno';

  @override
  String get scanAgain => 'Skeniraj ponovno';

  @override
  String get scanQrCode => 'Skeniraj QR kod';

  @override
  String get viewSourceBoard => 'Pogledaj izvornu ploču';

  @override
  String get addBoard => 'Dodaj ploču';

  @override
  String get addRack => 'Dodaj regal';

  @override
  String get addSlot => 'Dodaj pretinac';

  @override
  String get newBoardTitle => 'Nova ploča';

  @override
  String get newRackTitle => 'Novi regal';

  @override
  String get newSlotTitle => 'Novi pretinac';

  @override
  String get deleteSlotQuestion => 'Izbrisati ovaj pretinac?';

  @override
  String get archiveBoardQuestion => 'Arhivirati ovu ploču?';

  @override
  String get archiveOffcutQuestion => 'Arhivirati ovaj otpadak?';

  @override
  String get historyStaysVisible => 'Povijest (Ledger) ostaje vidljiva.';

  @override
  String get deleteSlotWarning =>
      'Ova radnja se ne može poništiti. Ploče i otpaci dodijeljeni ovom pretincu neće biti izbrisani — samo će izgubiti dodijeljenu lokaciju (slot_id će upućivati na nepostojeći zapis — budući korak čišćenja ako bude potrebno).';

  @override
  String get fillDimensionsCorrectly => 'Ispravno popunite dimenzije.';

  @override
  String get noDecorsInCatalog =>
      'Nema dekora u katalogu — dodajte barem jedan.';

  @override
  String get noOtherSlotInRack => 'Nema drugog pretinca u ovom regalu.';

  @override
  String get noWarehousesYet =>
      'Još nema skladišta. Dodajte prvo pomoću gumba +.';

  @override
  String get nameLabel => 'Naziv';

  @override
  String get nameHintSlot => 'Naziv (npr. A1)';

  @override
  String get nameHintRack => 'Naziv regala (npr. A, SKLADIŠTE-1)';

  @override
  String get addressOptional => 'Adresa (neobavezno)';

  @override
  String get decorLabel => 'Dekor';

  @override
  String get lengthMm => 'Dužina (mm)';

  @override
  String get widthMm => 'Širina (mm)';

  @override
  String get thicknessMm => 'Debljina (mm)';

  @override
  String get capacityLabel => 'Kapacitet';

  @override
  String get capacityPcsLabel => 'Kapacitet (kom.)';

  @override
  String errorPrefix(String message) {
    return 'Greška: $message';
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
    return '$used / $capacity kom.';
  }

  @override
  String get statusInStock => 'na skladištu';

  @override
  String get statusAvailable => 'dostupan';

  @override
  String get statusArchived => 'arhivirano';

  @override
  String get newWarehouseTitle => 'Novo skladište';

  @override
  String get noItemsInSlot => 'Nema ploča ni otpadaka u ovom pretincu.';

  @override
  String get noRacksYet =>
      'Nema regala u ovom skladištu.\nDodajte prvi da biste počeli organizirati lokacije.';

  @override
  String get noSlotsYet =>
      'Nema pretinaca u ovom regalu.\nDodajte prvi kako biste mogli dodijeliti ploče i otpatke.';

  @override
  String get boardsSectionLabel => 'PLOČE';

  @override
  String get offcutsSectionLabel => 'OTPACI';

  @override
  String get qrCodeNotFound => 'Ovaj kod ne postoji ili je uklonjen.';

  @override
  String get delete => 'Izbriši';

  @override
  String get deleteSlotButton => 'Izbriši pretinac';

  @override
  String cutFromBoardNote(String decor) {
    return 'S ploče ($decor) — ostaje u istom pretincu.';
  }

  @override
  String statusLabel(String value) {
    return 'Status: $value';
  }

  @override
  String get printLabelsForSlot => 'Ispis naljepnica';

  @override
  String get eventCreated => 'Stvoreno';

  @override
  String get eventMoved => 'Premješteno';

  @override
  String get eventArchived => 'Arhivirano';

  @override
  String get eventCut => 'Izrezano';

  @override
  String get eventQrRegenerated => 'QR ponovno generiran';

  @override
  String get ownerDashboardTitle => 'Vlasnička nadzorna ploča';

  @override
  String get totalBoardsLabel => 'Ploče';

  @override
  String get totalOffcutsLabel => 'Otpaci';

  @override
  String get overallFillRateLabel => 'Popunjenost';

  @override
  String get totalRacksSlotsLabel => 'Regali / Pretinci';

  @override
  String get staleItemsSectionTitle => 'Zaostali materijali';

  @override
  String get staleItemsSectionSubtitle => 'Nekorišteno više od godinu dana';

  @override
  String get noStaleItems => 'Nema zaostalih materijala.';

  @override
  String get locationUnknown => 'Lokacija nepoznata';

  @override
  String daysAgo(int days) {
    return 'prije $days dana';
  }

  @override
  String get exportTitle => 'Izvoz';

  @override
  String get exportWarehouseLabel => 'Skladište';

  @override
  String get exportButton => 'Izvezi';

  @override
  String get exportEmptyWarehouse =>
      'Ovo skladište nema ploča ni otpadaka za izvoz.';

  @override
  String get exportColumnType => 'Vrsta';

  @override
  String get exportColumnQrCode => 'QR kod';

  @override
  String get exportColumnDecorCode => 'Kod dekora';

  @override
  String get exportColumnDecorName => 'Naziv dekora';

  @override
  String get exportColumnLocation => 'Lokacija';

  @override
  String get exportColumnStatus => 'Status';

  @override
  String get exportColumnCreatedAt => 'Stvoreno';

  @override
  String exportFailedMessage(String message) {
    return 'Izvoz nije uspio: $message';
  }

  @override
  String get calculatorsTitle => 'Kalkulatori';

  @override
  String get calculatorAreaVolumeTab => 'Površina / volumen';

  @override
  String get calculatorEdgeBandingTab => 'Rubna traka';

  @override
  String get areaM2Label => 'Površina (m²)';

  @override
  String get volumeM3Label => 'Volumen (m³)';

  @override
  String get outerDiameterMmLabel => 'Vanjski promjer (mm)';

  @override
  String get coreDiameterMmLabel => 'Promjer jezgre (mm)';

  @override
  String get tapeThicknessMmLabel => 'Debljina trake (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Duljina trake (m)';

  @override
  String get calculateButton => 'Izračunaj';
}
