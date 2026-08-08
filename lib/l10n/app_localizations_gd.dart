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
}
