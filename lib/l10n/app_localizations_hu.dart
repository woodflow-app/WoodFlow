// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get warehousesTitle => 'Raktárak';

  @override
  String get boardTitle => 'Lap';

  @override
  String get offcutTitle => 'Hulladékdarab';

  @override
  String get historyLabel => 'Előzmények';

  @override
  String get noEntries => 'Nincs bejegyzés.';

  @override
  String get cancel => 'Mégse';

  @override
  String get save => 'Mentés';

  @override
  String get archive => 'Archiválás';

  @override
  String get move => 'Áthelyezés';

  @override
  String get moveToLabel => 'Áthelyezés ide:';

  @override
  String get cut => 'Vágás';

  @override
  String get cutOffcut => 'Hulladékdarab levágása';

  @override
  String get retry => 'Újra próbálom';

  @override
  String get searchManually => 'Kézi keresés';

  @override
  String get scanAgain => 'Újra szkennelés';

  @override
  String get scanQrCode => 'QR-kód szkennelése';

  @override
  String get viewSourceBoard => 'Forráslap megtekintése';

  @override
  String get addBoard => 'Lap hozzáadása';

  @override
  String get addRack => 'Állvány hozzáadása';

  @override
  String get addSlot => 'Rekesz hozzáadása';

  @override
  String get newBoardTitle => 'Új lap';

  @override
  String get newRackTitle => 'Új állvány';

  @override
  String get newSlotTitle => 'Új rekesz';

  @override
  String get deleteSlotQuestion => 'Törli ezt a rekeszt?';

  @override
  String get archiveBoardQuestion => 'Archiválja ezt a lapot?';

  @override
  String get archiveOffcutQuestion => 'Archiválja ezt a hulladékdarabot?';

  @override
  String get historyStaysVisible => 'Az előzmények (Ledger) láthatók maradnak.';

  @override
  String get deleteSlotWarning =>
      'Ez a művelet nem vonható vissza. Az ehhez a rekeszhez rendelt lapok és hulladékdarabok nem törlődnek — csak elvesztik a hozzárendelt helyüket (a slot_id egy nem létező rekordra fog mutatni — jövőbeli takarítási lépés, ha szükséges).';

  @override
  String get fillDimensionsCorrectly => 'Töltse ki helyesen a méreteket.';

  @override
  String get noDecorsInCatalog =>
      'Nincs dekor a katalógusban — adjon hozzá legalább egyet.';

  @override
  String get noOtherSlotInRack => 'Nincs másik rekesz ezen az állványon.';

  @override
  String get noWarehousesYet =>
      'Még nincs raktár. Adja hozzá az elsőt a + gombbal.';

  @override
  String get nameLabel => 'Név';

  @override
  String get nameHintSlot => 'Név (pl. A1)';

  @override
  String get nameHintRack => 'Állvány neve (pl. A, RAKTÁR-1)';

  @override
  String get addressOptional => 'Cím (opcionális)';

  @override
  String get decorLabel => 'Dekor';

  @override
  String get lengthMm => 'Hossz (mm)';

  @override
  String get widthMm => 'Szélesség (mm)';

  @override
  String get thicknessMm => 'Vastagság (mm)';

  @override
  String get capacityLabel => 'Kapacitás';

  @override
  String get capacityPcsLabel => 'Kapacitás (db)';

  @override
  String errorPrefix(String message) {
    return 'Hiba: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Állvány $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Állványok — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity db';
  }

  @override
  String get statusInStock => 'készleten';

  @override
  String get statusAvailable => 'elérhető';

  @override
  String get statusArchived => 'archiválva';

  @override
  String get newWarehouseTitle => 'Új raktár';

  @override
  String get noItemsInSlot => 'Ebben a rekeszben nincs lap vagy hulladékdarab.';

  @override
  String get noRacksYet =>
      'Ebben a raktárban nincs állvány.\nAdja hozzá az elsőt a helyek rendszerezéséhez.';

  @override
  String get noSlotsYet =>
      'Ebben az állványban nincs rekesz.\nAdja hozzá az elsőt, hogy hozzárendelhessen lapokat és hulladékdarabokat.';

  @override
  String get boardsSectionLabel => 'LAPOK';

  @override
  String get offcutsSectionLabel => 'HULLADÉKDARABOK';

  @override
  String get qrCodeNotFound => 'Ez a kód nem létezik, vagy eltávolították.';

  @override
  String get delete => 'Törlés';

  @override
  String get deleteSlotButton => 'Rekesz törlése';

  @override
  String cutFromBoardNote(String decor) {
    return 'Lapból ($decor) — ugyanabban a rekeszben marad.';
  }

  @override
  String statusLabel(String value) {
    return 'Állapot: $value';
  }

  @override
  String get printLabelsForSlot => 'Címkék nyomtatása';

  @override
  String get eventCreated => 'Létrehozva';

  @override
  String get eventMoved => 'Áthelyezve';

  @override
  String get eventArchived => 'Archiválva';

  @override
  String get eventCut => 'Levágva';

  @override
  String get eventQrRegenerated => 'QR újragenerálva';

  @override
  String get ownerDashboardTitle => 'Tulajdonosi irányítópult';

  @override
  String get totalBoardsLabel => 'Lapok';

  @override
  String get totalOffcutsLabel => 'Hulladékdarabok';

  @override
  String get overallFillRateLabel => 'Telítettség';

  @override
  String get totalRacksSlotsLabel => 'Állványok / Rekeszek';

  @override
  String get staleItemsSectionTitle => 'Heverő anyagok';

  @override
  String get staleItemsSectionSubtitle => 'Egy éve felhasználatlan';

  @override
  String get noStaleItems => 'Nincs heverő anyag.';

  @override
  String get locationUnknown => 'Ismeretlen hely';

  @override
  String daysAgo(int days) {
    return '$days napja';
  }

  @override
  String get exportTitle => 'Exportálás';

  @override
  String get exportWarehouseLabel => 'Raktár';

  @override
  String get exportButton => 'Exportálás';

  @override
  String get exportEmptyWarehouse =>
      'Ebben a raktárban nincs exportálható lap vagy hulladékdarab.';

  @override
  String get exportColumnType => 'Típus';

  @override
  String get exportColumnQrCode => 'QR-kód';

  @override
  String get exportColumnDecorCode => 'Dekor kódja';

  @override
  String get exportColumnDecorName => 'Dekor neve';

  @override
  String get exportColumnLocation => 'Hely';

  @override
  String get exportColumnStatus => 'Állapot';

  @override
  String get exportColumnCreatedAt => 'Létrehozva';

  @override
  String exportFailedMessage(String message) {
    return 'Az exportálás nem sikerült: $message';
  }

  @override
  String get calculatorsTitle => 'Kalkulátorok';

  @override
  String get calculatorAreaVolumeTab => 'Terület / térfogat';

  @override
  String get calculatorEdgeBandingTab => 'Élzáró szalag';

  @override
  String get areaM2Label => 'Terület (m²)';

  @override
  String get volumeM3Label => 'Térfogat (m³)';

  @override
  String get outerDiameterMmLabel => 'Külső átmérő (mm)';

  @override
  String get coreDiameterMmLabel => 'Mag átmérője (mm)';

  @override
  String get tapeThicknessMmLabel => 'Szalag vastagsága (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Szalag hossza (m)';

  @override
  String get calculateButton => 'Számítás';
}
