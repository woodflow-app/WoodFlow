// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Welsh (`cy`).
class AppLocalizationsCy extends AppLocalizations {
  AppLocalizationsCy([String locale = 'cy']) : super(locale);

  @override
  String get warehousesTitle => 'Warysau';

  @override
  String get boardTitle => 'Panel';

  @override
  String get offcutTitle => 'Toriad';

  @override
  String get historyLabel => 'Hanes';

  @override
  String get noEntries => 'Dim cofnodion.';

  @override
  String get cancel => 'Diddymu';

  @override
  String get save => 'Cadw';

  @override
  String get archive => 'Archifo';

  @override
  String get move => 'Symud';

  @override
  String get moveToLabel => 'Symud i:';

  @override
  String get cut => 'Torri';

  @override
  String get cutOffcut => 'Torri toriad';

  @override
  String get retry => 'Ceisio eto';

  @override
  String get searchManually => 'Chwilio â llaw';

  @override
  String get scanAgain => 'Sganio eto';

  @override
  String get scanQrCode => 'Sganio cod QR';

  @override
  String get viewSourceBoard => 'Gweld y panel gwreiddiol';

  @override
  String get addBoard => 'Ychwanegu panel';

  @override
  String get addRack => 'Ychwanegu rac';

  @override
  String get addSlot => 'Ychwanegu slot';

  @override
  String get newBoardTitle => 'Panel newydd';

  @override
  String get newRackTitle => 'Rac newydd';

  @override
  String get newSlotTitle => 'Slot newydd';

  @override
  String get deleteSlotQuestion => 'Dileu\'r slot yma?';

  @override
  String get archiveBoardQuestion => 'Archifo\'r panel yma?';

  @override
  String get archiveOffcutQuestion => 'Archifo\'r toriad yma?';

  @override
  String get historyStaysVisible =>
      'Bydd yr hanes (Ledger) yn parhau i fod yn weladwy.';

  @override
  String get deleteSlotWarning =>
      'Ni ellir dad-wneud y weithred hon. Ni fydd paneli a thoriadau sydd wedi\'u neilltuo i\'r slot hwn yn cael eu dileu — dim ond yn colli eu lleoliad neilltuedig (bydd slot_id yn pwyntio at gofnod nad yw\'n bodoli — cam glanhau yn y dyfodol os bydd angen).';

  @override
  String get fillDimensionsCorrectly => 'Llenwch y dimensiynau yn gywir.';

  @override
  String get noDecorsInCatalog =>
      'Dim addurniadau yn y catalog — ychwanegwch o leiaf un.';

  @override
  String get noOtherSlotInRack => 'Dim slot arall yn y rac hwn.';

  @override
  String get noWarehousesYet =>
      'Dim warysau eto. Ychwanegwch y cyntaf gyda\'r botwm +.';

  @override
  String get nameLabel => 'Enw';

  @override
  String get nameHintSlot => 'Enw (e.e. A1)';

  @override
  String get nameHintRack => 'Enw\'r rac (e.e. A, WARWS-1)';

  @override
  String get addressOptional => 'Cyfeiriad (dewisol)';

  @override
  String get decorLabel => 'Addurn';

  @override
  String get lengthMm => 'Hyd (mm)';

  @override
  String get widthMm => 'Lled (mm)';

  @override
  String get thicknessMm => 'Trwch (mm)';

  @override
  String get capacityLabel => 'Capasiti';

  @override
  String get capacityPcsLabel => 'Capasiti (darnau)';

  @override
  String errorPrefix(String message) {
    return 'Gwall: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Rac $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Raciau — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity darn';
  }

  @override
  String get statusInStock => 'mewn stoc';

  @override
  String get statusAvailable => 'ar gael';

  @override
  String get statusArchived => 'wedi\'i archifo';

  @override
  String get newWarehouseTitle => 'Warws newydd';

  @override
  String get noItemsInSlot => 'Dim paneli na thoriadau yn y slot yma.';

  @override
  String get noRacksYet =>
      'Dim raciau yn y warws yma.\nYchwanegwch yr un cyntaf i ddechrau trefnu lleoliadau.';

  @override
  String get noSlotsYet =>
      'Dim slotiau yn y rac yma.\nYchwanegwch yr un cyntaf er mwyn gallu neilltuo paneli a thoriadau iddo.';

  @override
  String get boardsSectionLabel => 'PANELI';

  @override
  String get offcutsSectionLabel => 'TORIADAU';

  @override
  String get qrCodeNotFound =>
      'Nid yw\'r cod yma\'n bodoli neu mae wedi\'i dynnu.';

  @override
  String get delete => 'Dileu';

  @override
  String get deleteSlotButton => 'Dileu slot';

  @override
  String cutFromBoardNote(String decor) {
    return 'O\'r panel ($decor) — yn aros yn yr un slot.';
  }

  @override
  String statusLabel(String value) {
    return 'Statws: $value';
  }

  @override
  String get printLabelsForSlot => 'Argraffu labeli';

  @override
  String get eventCreated => 'Wedi\'i greu';

  @override
  String get eventMoved => 'Wedi symud';

  @override
  String get eventArchived => 'Wedi archifo';

  @override
  String get eventCut => 'Wedi torri';

  @override
  String get eventQrRegenerated => 'QR wedi\'i aildyfu';

  @override
  String get ownerDashboardTitle => 'Dangosfwrdd y perchennog';

  @override
  String get totalBoardsLabel => 'Paneli';

  @override
  String get totalOffcutsLabel => 'Toriadau';

  @override
  String get overallFillRateLabel => 'Cyfradd llenwi';

  @override
  String get totalRacksSlotsLabel => 'Raciau / Slotiau';

  @override
  String get staleItemsSectionTitle => 'Deunyddiau segur';

  @override
  String get staleItemsSectionSubtitle => 'Heb eu defnyddio ers dros flwyddyn';

  @override
  String get noStaleItems => 'Dim deunyddiau segur.';

  @override
  String get locationUnknown => 'Lleoliad anhysbys';

  @override
  String daysAgo(int days) {
    return '$days diwrnod yn ôl';
  }

  @override
  String get exportTitle => 'Allforio';

  @override
  String get exportWarehouseLabel => 'Warws';

  @override
  String get exportButton => 'Allforio';

  @override
  String get exportEmptyWarehouse =>
      'Nid oes panel na thoriad yn y warws hon i\'w allforio.';

  @override
  String get exportColumnType => 'Math';

  @override
  String get exportColumnQrCode => 'Cod QR';

  @override
  String get exportColumnDecorCode => 'Cod yr addurn';

  @override
  String get exportColumnDecorName => 'Enw\'r addurn';

  @override
  String get exportColumnLocation => 'Lleoliad';

  @override
  String get exportColumnStatus => 'Statws';

  @override
  String get exportColumnCreatedAt => 'Wedi\'i greu';

  @override
  String exportFailedMessage(String message) {
    return 'Methodd yr allforio: $message';
  }

  @override
  String get calculatorsTitle => 'Cyfrifianellau';

  @override
  String get calculatorAreaVolumeTab => 'Arwynebedd / cyfaint';

  @override
  String get calculatorEdgeBandingTab => 'Stribed ymyl';

  @override
  String get areaM2Label => 'Arwynebedd (m²)';

  @override
  String get volumeM3Label => 'Cyfaint (m³)';

  @override
  String get outerDiameterMmLabel => 'Diamedr allanol (mm)';

  @override
  String get coreDiameterMmLabel => 'Diamedr craidd (mm)';

  @override
  String get tapeThicknessMmLabel => 'Trwch y stribed (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Hyd y stribed (m)';

  @override
  String get calculateButton => 'Cyfrifo';

  @override
  String get shoppingListTitle => 'Rhestr siopa';

  @override
  String get shoppingListNoThresholds =>
      'Dim trothwyon stoc lleiaf wedi\'u gosod eto. Tapiwch + i osod y cyntaf.';

  @override
  String get shoppingListAllSufficient =>
      'Cyflawnir pob trothwy a osodwyd — nid oes unrhyw stoc yn isel.';

  @override
  String get currentStockLabel => 'Mewn stoc';

  @override
  String get minimumStockLabel => 'Trothwy lleiaf';

  @override
  String get setThresholdTitle => 'Gosod trothwy stoc lleiaf';

  @override
  String get searchDecorHint => 'Chwilio am addurn (cod neu enw)';

  @override
  String get minimumStockQuantityLabel => 'Stoc lleiaf (darnau)';

  @override
  String get clearThresholdButton => 'Clirio\'r trothwy';

  @override
  String get invalidQuantityMessage => 'Rhowch rif cyfan, 0 neu fwy.';

  @override
  String get aiQueryTitle => 'Gofyn i\'r AI';

  @override
  String get aiQueryInputHint =>
      'Gofynnwch gwestiwn am y warws, e.e. \"Faint o H3303 sydd gennyf?\"';

  @override
  String get aiQuerySendTooltip => 'Anfon';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Dydw i ddim yn deall y cwestiwn: „$query”. Ceisiwch e.e. „Faint o H3303 sydd gennyf?”';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity darn mewn stoc';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Lleoliadau — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Dim byrddau o\'r addurn hwn mewn stoc ar hyn o bryd.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Dimensiynau — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Dim deunydd o\'r addurn hwn mewn stoc ar hyn o bryd.';

  @override
  String get aiQueryStaleHeader => 'Deunydd yn gorwedd';

  @override
  String get aiQueryStaleEmpty => 'Dim deunydd yn gorwedd.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Darnau gwastraff addas — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty =>
      'Dim darn gwastraff addas o\'r addurn hwn.';

  @override
  String get aiQueryBoardTypeLabel => 'Bwrdd';

  @override
  String get aiQueryOffcutTypeLabel => 'Darn gwastraff';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Gormodedd: $value mm²';
  }
}
