// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Irish (`ga`).
class AppLocalizationsGa extends AppLocalizations {
  AppLocalizationsGa([String locale = 'ga']) : super(locale);

  @override
  String get warehousesTitle => 'Stórais';

  @override
  String get boardTitle => 'Painéal';

  @override
  String get offcutTitle => 'Fuílleach';

  @override
  String get historyLabel => 'Stair';

  @override
  String get noEntries => 'Gan iontrálacha.';

  @override
  String get cancel => 'Cealaigh';

  @override
  String get save => 'Sábháil';

  @override
  String get archive => 'Cartlannaigh';

  @override
  String get move => 'Bog';

  @override
  String get moveToLabel => 'Bog chuig:';

  @override
  String get cut => 'Gearr';

  @override
  String get cutOffcut => 'Gearr fuílleach';

  @override
  String get retry => 'Bain triail eile as';

  @override
  String get searchManually => 'Cuardaigh de láimh';

  @override
  String get scanAgain => 'Scan arís';

  @override
  String get scanQrCode => 'Scan cód QR';

  @override
  String get viewSourceBoard => 'Féach ar an bpainéal foinseach';

  @override
  String get addBoard => 'Cuir painéal leis';

  @override
  String get addRack => 'Cuir raca leis';

  @override
  String get addSlot => 'Cuir sliotán leis';

  @override
  String get newBoardTitle => 'Painéal nua';

  @override
  String get newRackTitle => 'Raca nua';

  @override
  String get newSlotTitle => 'Sliotán nua';

  @override
  String get deleteSlotQuestion => 'Scrios an sliotán seo?';

  @override
  String get archiveBoardQuestion => 'Cartlannaigh an painéal seo?';

  @override
  String get archiveOffcutQuestion => 'Cartlannaigh an fuílleach seo?';

  @override
  String get historyStaysVisible => 'Fanfaidh an stair (Ledger) le feiceáil.';

  @override
  String get deleteSlotWarning =>
      'Ní féidir an gníomh seo a chealú. Ní scriosfar na painéil agus na fuíollaigh atá sannta don sliotán seo — ach caillfidh siad a suíomh sannta (léireoidh slot_id taifead nach ann dó — céim ghlanta amach anseo más gá).';

  @override
  String get fillDimensionsCorrectly => 'Líon isteach na toisí i gceart.';

  @override
  String get noDecorsInCatalog =>
      'Níl aon mhaisiú sa chatalóg — cuir ceann amháin ar a laghad leis.';

  @override
  String get noOtherSlotInRack => 'Níl aon sliotán eile sa raca seo.';

  @override
  String get noWarehousesYet =>
      'Níl aon stóras ann fós. Cuir an ceann is túisce leis leis an gcnaipe +.';

  @override
  String get nameLabel => 'Ainm';

  @override
  String get nameHintSlot => 'Ainm (m.sh. A1)';

  @override
  String get nameHintRack => 'Ainm an raca (m.sh. A, STÓRAS-1)';

  @override
  String get addressOptional => 'Seoladh (roghnach)';

  @override
  String get decorLabel => 'Maisiú';

  @override
  String get lengthMm => 'Fad (mm)';

  @override
  String get widthMm => 'Leithead (mm)';

  @override
  String get thicknessMm => 'Tiús (mm)';

  @override
  String get capacityLabel => 'Toilleadh';

  @override
  String get capacityPcsLabel => 'Toilleadh (píosaí)';

  @override
  String errorPrefix(String message) {
    return 'Earráid: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Raca $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Racaí — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity píosaí';
  }

  @override
  String get statusInStock => 'ar stoc';

  @override
  String get statusAvailable => 'ar fáil';

  @override
  String get statusArchived => 'cartlannaithe';

  @override
  String get newWarehouseTitle => 'Stóras nua';

  @override
  String get noItemsInSlot => 'Níl aon phainéal ná fuílleach sa sliotán seo.';

  @override
  String get noRacksYet =>
      'Níl aon raca sa stóras seo.\nCuir an chéad cheann leis chun suíomhanna a eagrú.';

  @override
  String get noSlotsYet =>
      'Níl aon sliotán sa raca seo.\nCuir an chéad cheann leis chun painéil agus fuíollaigh a shannadh dó.';

  @override
  String get boardsSectionLabel => 'PAINÉIL';

  @override
  String get offcutsSectionLabel => 'FUÍOLLAIGH';

  @override
  String get qrCodeNotFound => 'Níl an cód seo ann nó baineadh é.';

  @override
  String get delete => 'Scrios';

  @override
  String get deleteSlotButton => 'Scrios sliotán';

  @override
  String cutFromBoardNote(String decor) {
    return 'Ón bpainéal ($decor) — fanann sa sliotán céanna.';
  }

  @override
  String statusLabel(String value) {
    return 'Stádas: $value';
  }

  @override
  String get printLabelsForSlot => 'Priontáil lipéid';

  @override
  String get eventCreated => 'Cruthaithe';

  @override
  String get eventMoved => 'Bogtha';

  @override
  String get eventArchived => 'Cartlannaithe';

  @override
  String get eventCut => 'Gearrtha';

  @override
  String get eventQrRegenerated => 'QR athghinte';

  @override
  String get ownerDashboardTitle => 'Painéal an úinéara';

  @override
  String get totalBoardsLabel => 'Painéil';

  @override
  String get totalOffcutsLabel => 'Fuíollaigh';

  @override
  String get overallFillRateLabel => 'Ráta líonta';

  @override
  String get totalRacksSlotsLabel => 'Racaí / Sliotáin';

  @override
  String get staleItemsSectionTitle => 'Ábhair mharbhánta';

  @override
  String get staleItemsSectionSubtitle => 'Gan úsáid le breis is bliain';

  @override
  String get noStaleItems => 'Níl aon ábhar marbhánta ann.';

  @override
  String get locationUnknown => 'Suíomh anaithnid';

  @override
  String daysAgo(int days) {
    return '$days lá ó shin';
  }
}
