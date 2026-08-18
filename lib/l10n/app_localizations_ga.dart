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
      'Ní féidir an gníomh seo a chealú. Cuirfear cartlann ar na painéil agus na fuíollaigh sa sliotán seo (ní scriosfar iad) — fanfaidh a stair le feiceáil.';

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

  @override
  String get exportTitle => 'Easpórtáil';

  @override
  String get exportWarehouseLabel => 'Stóras';

  @override
  String get exportButton => 'Easpórtáil';

  @override
  String get exportEmptyWarehouse =>
      'Níl painéal ná fuílleach le easpórtáil sa stóras seo.';

  @override
  String get exportColumnType => 'Cineál';

  @override
  String get exportColumnQrCode => 'Cód QR';

  @override
  String get exportColumnDecorCode => 'Cód an mhaisithe';

  @override
  String get exportColumnDecorName => 'Ainm an mhaisithe';

  @override
  String get exportColumnLocation => 'Suíomh';

  @override
  String get exportColumnStatus => 'Stádas';

  @override
  String get exportColumnCreatedAt => 'Cruthaithe';

  @override
  String exportFailedMessage(String message) {
    return 'Theip ar an easpórtáil: $message';
  }

  @override
  String get calculatorsTitle => 'Áireamháin';

  @override
  String get calculatorAreaVolumeTab => 'Achar / toirt';

  @override
  String get calculatorEdgeBandingTab => 'Stiall imill';

  @override
  String get areaM2Label => 'Achar (m²)';

  @override
  String get volumeM3Label => 'Toirt (m³)';

  @override
  String get outerDiameterMmLabel => 'Trastomhas seachtrach (mm)';

  @override
  String get coreDiameterMmLabel => 'Trastomhas an lárnaigh (mm)';

  @override
  String get tapeThicknessMmLabel => 'Tiús na stialla (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Fad na stialla (m)';

  @override
  String get calculateButton => 'Ríomh';

  @override
  String get shoppingListTitle => 'Liosta siopadóireachta';

  @override
  String get shoppingListNoThresholds =>
      'Níl aon tairseach stoic íosta socraithe fós. Tapáil + chun an chéad cheann a shocrú.';

  @override
  String get shoppingListAllSufficient =>
      'Comhlíontar gach tairseach socraithe — níl aon stoc íseal.';

  @override
  String get currentStockLabel => 'Ar stoc';

  @override
  String get minimumStockLabel => 'Tairseach íosta';

  @override
  String get setThresholdTitle => 'Socraigh tairseach stoic íosta';

  @override
  String get searchDecorHint => 'Cuardaigh maisiú (cód nó ainm)';

  @override
  String get minimumStockQuantityLabel => 'Stoc íosta (píosaí)';

  @override
  String get clearThresholdButton => 'Bain an tairseach';

  @override
  String get invalidQuantityMessage => 'Cuir isteach slánuimhir, 0 nó níos mó.';

  @override
  String get aiQueryTitle => 'Fiafraigh den AI';

  @override
  String get aiQueryInputHint =>
      'Cuir ceist faoin stóras, m.sh. \"Cé mhéad H3303 atá agam?\"';

  @override
  String get aiQuerySendTooltip => 'Seol';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Ní thuigim an cheist: „$query“. Bain triail as m.sh. „Cé mhéad H3303 atá agam?“';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity píosa ar stoc';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Suíomhanna — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Níl aon phlanc den mhaisiú seo ar stoc faoi láthair.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Toisí — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Níl aon ábhar den mhaisiú seo ar stoc faoi láthair.';

  @override
  String get aiQueryStaleHeader => 'Ábhar ina luí';

  @override
  String get aiQueryStaleEmpty => 'Níl aon ábhar ina luí.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Fuíoll oiriúnach — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty =>
      'Níl aon fhuíoll oiriúnach den mhaisiú seo.';

  @override
  String get aiQueryBoardTypeLabel => 'Planc';

  @override
  String get aiQueryOffcutTypeLabel => 'Fuíoll';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Barrachas: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Scrios an stóras „$name”?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Ní féidir an gníomh seo a chur ar ceal. Scriosfar gach seilf agus áit sa stóras seo. Cuirfear cartlann ar na plancanna agus an fuíoll iontu (ní scriosfar iad) — fanfaidh a stair le feiceáil.';

  @override
  String deleteRackQuestion(String name) {
    return 'Scrios an raca „$name”?';
  }

  @override
  String get deleteRackWarning =>
      'Ní féidir an gníomh seo a chur ar ceal. Scriosfar gach sliotán sa raca seo. Cuirfear cartlann ar na plancanna agus an fuíoll iontu (ní scriosfar iad) — fanfaidh a stair le feiceáil.';

  @override
  String get decorCatalogBreadcrumb => 'Stóras';

  @override
  String get decorCatalogTitle => 'Catalóg maisiúcháin';

  @override
  String get decorCatalogSearchHint => 'Cuardaigh de réir cóid nó ainm…';

  @override
  String get decorFilterAll => 'Uile';

  @override
  String get decorFilterBoard => 'Cláir';

  @override
  String get decorFilterWorktop => 'Dromchlaí oibre';

  @override
  String get decorFilterEdging => 'Imill';

  @override
  String get decorTypeBoard => 'Clár';

  @override
  String get decorTypeWorktop => 'Dromchla oibre';

  @override
  String get decorTypeEdging => 'Imeall';

  @override
  String get decorEmptyNoData => 'Níl aon mhaisiúcháin sa bhunachar sonraí';

  @override
  String decorEmptyNoResults(String query) {
    return 'Níl aon mhaisiúchán a mheaitseálann le “$query”';
  }

  @override
  String get decorRetry => 'Bain triail eile as';

  @override
  String get decorApproxColorLabel => 'dath garbh';

  @override
  String get decorSeeRealPhoto => 'Féach ar ghrianghraf an mhaisiúcháin';

  @override
  String decorImageSourceNote(String domain) {
    return 'osclaíonn sé suíomh oifigiúil $domain';
  }

  @override
  String get decorNoImageLinkSnackbar =>
      'Níl aon nasc íomhá don mhaisiúchán seo';

  @override
  String get decorFailedToOpenLinkSnackbar =>
      'Níorbh fhéidir an nasc a oscailt';
}
