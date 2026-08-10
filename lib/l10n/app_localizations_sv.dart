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
      'Denna åtgärd kan inte ångras. Skivor och kapbitar i detta fack tas inte bort — de förlorar bara sin tilldelade plats (slot_id kommer att peka på en post som inte finns — ett framtida rensningssteg om det behövs).';

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
}
