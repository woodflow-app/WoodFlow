// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Scottish Gaelic Gaelic (`gd`).
class AppLocalizationsGd extends AppLocalizations {
  AppLocalizationsGd([String locale = 'gd']) : super(locale);

  @override
  String get warehousesTitle => 'Taighean-stòir';

  @override
  String get boardTitle => 'Bòrd';

  @override
  String get offcutTitle => 'Criomag';

  @override
  String get historyLabel => 'Eachdraidh';

  @override
  String get noEntries => 'Chan eil clàran ann.';

  @override
  String get cancel => 'Sguir dheth';

  @override
  String get save => 'Sàbhail';

  @override
  String get archive => 'Tasglannaich';

  @override
  String get move => 'Gluais';

  @override
  String get moveToLabel => 'Gluais gu:';

  @override
  String get cut => 'Gearr';

  @override
  String get cutOffcut => 'Gearr criomag';

  @override
  String get retry => 'Feuch a-rithist';

  @override
  String get searchManually => 'Lorg le làimh';

  @override
  String get scanAgain => 'Sganaich a-rithist';

  @override
  String get scanQrCode => 'Sganaich còd QR';

  @override
  String get viewSourceBoard => 'Seall am bòrd tùsail';

  @override
  String get addBoard => 'Cuir bòrd ris';

  @override
  String get addRack => 'Cuir rac ris';

  @override
  String get addSlot => 'Cuir slot ris';

  @override
  String get newBoardTitle => 'Bòrd ùr';

  @override
  String get newRackTitle => 'Rac ùr';

  @override
  String get newSlotTitle => 'Slot ùr';

  @override
  String get deleteSlotQuestion =>
      'A bheil thu airson an slot seo a sguabadh às?';

  @override
  String get archiveBoardQuestion =>
      'A bheil thu airson am bòrd seo a thasglannachadh?';

  @override
  String get archiveOffcutQuestion =>
      'A bheil thu airson a\' chriomag seo a thasglannachadh?';

  @override
  String get historyStaysVisible =>
      'Bidh an eachdraidh (Ledger) fhathast ri fhaicinn.';

  @override
  String get deleteSlotWarning =>
      'Cha ghabh an gnìomh seo a neo-dhèanamh. Cha tèid bùird is criomagan a chaidh a shònrachadh dhan slot seo a sguabadh às — chan ann ach gun caill iad an t-àite a chaidh a shònrachadh (bidh slot_id a\' comharrachadh clàr nach eil ann — ceum glanaidh san àm ri teachd ma tha feum air).';

  @override
  String get fillDimensionsCorrectly =>
      'Lìon a-steach na tomhasan mar bu chòir.';

  @override
  String get noDecorsInCatalog =>
      'Chan eil sgeadachadh sam bith sa chatalog — cuir fear a-steach co-dhiù.';

  @override
  String get noOtherSlotInRack => 'Chan eil slot eile san rac seo.';

  @override
  String get noWarehousesYet =>
      'Chan eil taigh-stòir ann fhathast. Cuir a\' chiad fhear ris leis a\' phutan +.';

  @override
  String get nameLabel => 'Ainm';

  @override
  String get nameHintSlot => 'Ainm (m.e. A1)';

  @override
  String get nameHintRack => 'Ainm an rac (m.e. A, TAIGH-STÒIR-1)';

  @override
  String get addressOptional => 'Seòladh (roghainneil)';

  @override
  String get decorLabel => 'Sgeadachadh';

  @override
  String get lengthMm => 'Faid (mm)';

  @override
  String get widthMm => 'Leud (mm)';

  @override
  String get thicknessMm => 'Tighead (mm)';

  @override
  String get capacityLabel => 'Tomhas-lìonaidh';

  @override
  String get capacityPcsLabel => 'Tomhas-lìonaidh (pìosan)';

  @override
  String errorPrefix(String message) {
    return 'Mearachd: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Rac $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Racaichean — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity pìos';
  }

  @override
  String get statusInStock => 'san stòr';

  @override
  String get statusAvailable => 'ri fhaighinn';

  @override
  String get statusArchived => 'air a thasglannachadh';

  @override
  String get newWarehouseTitle => 'Taigh-stòir ùr';

  @override
  String get noItemsInSlot => 'Chan eil bòrd no criomag anns an t-slot seo.';

  @override
  String get noRacksYet =>
      'Chan eil rac anns an taigh-stòir seo.\nCuir an rac an toiseach ris gus àiteachan a chur air dòigh.';

  @override
  String get noSlotsYet =>
      'Chan eil slot anns an rac seo.\nCuir a\' chiad fhear ris gus a bhith comasach air bùird is criomagan a shònrachadh dha.';

  @override
  String get boardsSectionLabel => 'BÙIRD';

  @override
  String get offcutsSectionLabel => 'CRIOMAGAN';

  @override
  String get qrCodeNotFound =>
      'Chan eil an còd seo ann no chaidh a thoirt air falbh.';

  @override
  String get delete => 'Sguab às';

  @override
  String get deleteSlotButton => 'Sguab às an slot';

  @override
  String cutFromBoardNote(String decor) {
    return 'Bhon bhòrd ($decor) — a\' fuireach san aon slot.';
  }

  @override
  String statusLabel(String value) {
    return 'Staid: $value';
  }

  @override
  String get printLabelsForSlot => 'Clò-bhuail bileagan';

  @override
  String get eventCreated => 'Air a chruthachadh';

  @override
  String get eventMoved => 'Air a ghluasad';

  @override
  String get eventArchived => 'Air a thasglannachadh';

  @override
  String get eventCut => 'Air a ghearradh';

  @override
  String get eventQrRegenerated => 'QR ath-ghinte';

  @override
  String get ownerDashboardTitle => 'Panail an t-seilbheadair';

  @override
  String get totalBoardsLabel => 'Bùird';

  @override
  String get totalOffcutsLabel => 'Criomagan';

  @override
  String get overallFillRateLabel => 'Ìre lìonaidh';

  @override
  String get totalRacksSlotsLabel => 'Racaichean / Slotaichean';

  @override
  String get staleItemsSectionTitle => 'Stuthan gun chleachdadh';

  @override
  String get staleItemsSectionSubtitle =>
      'Gun chleachdadh airson còrr is bliadhna';

  @override
  String get noStaleItems => 'Chan eil stuthan gun chleachdadh ann.';

  @override
  String get locationUnknown => 'Àite neo-aithnichte';

  @override
  String daysAgo(int days) {
    return '$days latha air ais';
  }

  @override
  String get exportTitle => 'Às-phortadh';

  @override
  String get exportWarehouseLabel => 'Taigh-stòir';

  @override
  String get exportButton => 'Às-phortaich';

  @override
  String get exportEmptyWarehouse =>
      'Chan eil bòrd no criomag anns an taigh-stòir seo airson às-phortadh.';

  @override
  String get exportColumnType => 'Seòrsa';

  @override
  String get exportColumnQrCode => 'Còd QR';

  @override
  String get exportColumnDecorCode => 'Còd an sgeadachaidh';

  @override
  String get exportColumnDecorName => 'Ainm an sgeadachaidh';

  @override
  String get exportColumnLocation => 'Àite';

  @override
  String get exportColumnStatus => 'Staid';

  @override
  String get exportColumnCreatedAt => 'Air a chruthachadh';

  @override
  String exportFailedMessage(String message) {
    return 'Dh\'fhàillig an às-phortadh: $message';
  }

  @override
  String get calculatorsTitle => 'Àireamhairean';

  @override
  String get calculatorAreaVolumeTab => 'Farsaingeachd / tomhas-lìonaidh';

  @override
  String get calculatorEdgeBandingTab => 'Stiall oire';

  @override
  String get areaM2Label => 'Farsaingeachd (m²)';

  @override
  String get volumeM3Label => 'Tomhas-lìonaidh (m³)';

  @override
  String get outerDiameterMmLabel => 'Trast-thomhas a-muigh (mm)';

  @override
  String get coreDiameterMmLabel => 'Trast-thomhas a\' chridhe (mm)';

  @override
  String get tapeThicknessMmLabel => 'Tighead na stiall (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Faid na stiall (m)';

  @override
  String get calculateButton => 'Àireamhaich';

  @override
  String get shoppingListTitle => 'Liosta bhathaidh';

  @override
  String get shoppingListNoThresholds =>
      'Chan eil stairsneach stoca as ìsle air a shuidheachadh fhathast. Thoir gnogag air + gus a\' chiad tè a shuidheachadh.';

  @override
  String get shoppingListAllSufficient =>
      'Tha a h-uile stairsneach a chaidh a shuidheachadh air a choileanadh — chan eil stoc sam bith ìosal.';

  @override
  String get currentStockLabel => 'San stòr';

  @override
  String get minimumStockLabel => 'Stairsneach as ìsle';

  @override
  String get setThresholdTitle => 'Suidhich stairsneach stoca as ìsle';

  @override
  String get searchDecorHint => 'Lorg sgeadachadh (còd no ainm)';

  @override
  String get minimumStockQuantityLabel => 'Stoc as ìsle (pìosan)';

  @override
  String get clearThresholdButton => 'Thoir air falbh an stairsneach';

  @override
  String get invalidQuantityMessage =>
      'Cuir a-steach àireamh shlàn, 0 no barrachd.';

  @override
  String get aiQueryTitle => 'Faighnich den AI';

  @override
  String get aiQueryInputHint =>
      'Faighnich ceist mun stòr, m.e. \"Dè na tha agam de H3303?\"';

  @override
  String get aiQuerySendTooltip => 'Cuir';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Cha tuig mi a\' cheist: „$query”. Feuch m.e. „Dè na tha agam de H3303?”';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity pìos san stòr';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Ionadan — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Chan eil bùird den sgeadachadh seo san stòr an-dràsta.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Tomhasan — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Chan eil stuth den sgeadachadh seo san stòr an-dràsta.';

  @override
  String get aiQueryStaleHeader => 'Stuth na laighe';

  @override
  String get aiQueryStaleEmpty => 'Chan eil stuth na laighe ann.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Pìosan iomchaidh — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty =>
      'Chan eil pìos iomchaidh den sgeadachadh seo ann.';

  @override
  String get aiQueryBoardTypeLabel => 'Bòrd';

  @override
  String get aiQueryOffcutTypeLabel => 'Pìos';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Cus: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'A bheil thu airson an stòr „$name” a sguabadh às?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Cha ghabh an gnìomh seo a neo-dhèanamh. Thèid a h-uile seilf is àite san stòr seo a sguabadh às. Thèid tasgladh a dhèanamh air na bùird \'s na pìosan a th\' ann (chan ann gan sguabadh às) — fuirichidh an eachdraidh rim faicinn.';
}
