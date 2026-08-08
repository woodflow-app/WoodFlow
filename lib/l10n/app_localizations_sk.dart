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
      'Túto akciu nie je možné vrátiť späť. Dosky a odrezky priradené k tejto priehradke sa nezmažú — iba stratia priradené umiestnenie (slot_id bude odkazovať na neexistujúci záznam — budúci krok upratovania, ak bude potrebný).';

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
}
