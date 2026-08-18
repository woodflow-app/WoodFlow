// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Latvian (`lv`).
class AppLocalizationsLv extends AppLocalizations {
  AppLocalizationsLv([String locale = 'lv']) : super(locale);

  @override
  String get warehousesTitle => 'Noliktavas';

  @override
  String get boardTitle => 'Plāksne';

  @override
  String get offcutTitle => 'Atgriezums';

  @override
  String get historyLabel => 'Vēsture';

  @override
  String get noEntries => 'Nav ierakstu.';

  @override
  String get cancel => 'Atcelt';

  @override
  String get save => 'Saglabāt';

  @override
  String get archive => 'Arhivēt';

  @override
  String get move => 'Pārvietot';

  @override
  String get moveToLabel => 'Pārvietot uz:';

  @override
  String get cut => 'Zāģēt';

  @override
  String get cutOffcut => 'Nozāģēt atgriezumu';

  @override
  String get retry => 'Atkārtot';

  @override
  String get searchManually => 'Meklēt manuāli';

  @override
  String get scanAgain => 'Skenēt atkārtoti';

  @override
  String get scanQrCode => 'Skenēt QR kodu';

  @override
  String get viewSourceBoard => 'Skatīt sākotnējo plāksni';

  @override
  String get addBoard => 'Pievienot plāksni';

  @override
  String get addRack => 'Pievienot plauktu';

  @override
  String get addSlot => 'Pievienot nišu';

  @override
  String get newBoardTitle => 'Jauna plāksne';

  @override
  String get newRackTitle => 'Jauns plaukts';

  @override
  String get newSlotTitle => 'Jauna niša';

  @override
  String get deleteSlotQuestion => 'Dzēst šo nišu?';

  @override
  String get archiveBoardQuestion => 'Arhivēt šo plāksni?';

  @override
  String get archiveOffcutQuestion => 'Arhivēt šo atgriezumu?';

  @override
  String get historyStaysVisible => 'Vēsture (Ledger) paliks redzama.';

  @override
  String get deleteSlotWarning =>
      'Šo darbību nevar atsaukt. Šajā nišā esošās plāksnes un atgriezumi tiks arhivēti (nevis dzēsti) — to vēsture paliks redzama.';

  @override
  String get fillDimensionsCorrectly => 'Aizpildiet izmērus pareizi.';

  @override
  String get noDecorsInCatalog =>
      'Katalogā nav dekoru — pievienojiet vismaz vienu.';

  @override
  String get noOtherSlotInRack => 'Šajā plauktā nav citas nišas.';

  @override
  String get noWarehousesYet =>
      'Vēl nav noliktavu. Pievienojiet pirmo, izmantojot pogu +.';

  @override
  String get nameLabel => 'Nosaukums';

  @override
  String get nameHintSlot => 'Nosaukums (piem. A1)';

  @override
  String get nameHintRack => 'Plaukta nosaukums (piem. A, NOLIKTAVA-1)';

  @override
  String get addressOptional => 'Adrese (nav obligāta)';

  @override
  String get decorLabel => 'Dekors';

  @override
  String get lengthMm => 'Garums (mm)';

  @override
  String get widthMm => 'Platums (mm)';

  @override
  String get thicknessMm => 'Biezums (mm)';

  @override
  String get capacityLabel => 'Ietilpība';

  @override
  String get capacityPcsLabel => 'Ietilpība (gab.)';

  @override
  String errorPrefix(String message) {
    return 'Kļūda: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Plaukts $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Plaukti — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity gab.';
  }

  @override
  String get statusInStock => 'noliktavā';

  @override
  String get statusAvailable => 'pieejams';

  @override
  String get statusArchived => 'arhivēts';

  @override
  String get newWarehouseTitle => 'Jauna noliktava';

  @override
  String get noItemsInSlot => 'Šajā nišā nav plāksņu vai atgriezumu.';

  @override
  String get noRacksYet =>
      'Šajā noliktavā nav plauktu.\nPievienojiet pirmo, lai sāktu organizēt atrašanās vietas.';

  @override
  String get noSlotsYet =>
      'Šajā plauktā nav nišu.\nPievienojiet pirmo, lai varētu piešķirt plāksnes un atgriezumus.';

  @override
  String get boardsSectionLabel => 'PLĀKSNES';

  @override
  String get offcutsSectionLabel => 'ATGRIEZUMI';

  @override
  String get qrCodeNotFound => 'Šis kods neeksistē vai ir noņemts.';

  @override
  String get delete => 'Dzēst';

  @override
  String get deleteSlotButton => 'Dzēst nišu';

  @override
  String cutFromBoardNote(String decor) {
    return 'No plāksnes ($decor) — paliek tajā pašā nišā.';
  }

  @override
  String statusLabel(String value) {
    return 'Statuss: $value';
  }

  @override
  String get printLabelsForSlot => 'Drukāt etiķetes';

  @override
  String get eventCreated => 'Izveidots';

  @override
  String get eventMoved => 'Pārvietots';

  @override
  String get eventArchived => 'Arhivēts';

  @override
  String get eventCut => 'Sazāģēts';

  @override
  String get eventQrRegenerated => 'QR atjaunots';

  @override
  String get ownerDashboardTitle => 'Īpašnieka panelis';

  @override
  String get totalBoardsLabel => 'Plāksnes';

  @override
  String get totalOffcutsLabel => 'Atgriezumi';

  @override
  String get overallFillRateLabel => 'Piepildījums';

  @override
  String get totalRacksSlotsLabel => 'Plaukti / Nišas';

  @override
  String get staleItemsSectionTitle => 'Ilgstoši neizmantoti materiāli';

  @override
  String get staleItemsSectionSubtitle => 'Neizmantots ilgāk par gadu';

  @override
  String get noStaleItems => 'Nav ilgstoši neizmantotu materiālu.';

  @override
  String get locationUnknown => 'Atrašanās vieta nezināma';

  @override
  String daysAgo(int days) {
    return 'pirms $days dienām';
  }

  @override
  String get exportTitle => 'Eksportēt';

  @override
  String get exportWarehouseLabel => 'Noliktava';

  @override
  String get exportButton => 'Eksportēt';

  @override
  String get exportEmptyWarehouse =>
      'Šajā noliktavā nav plāksņu vai atgriezumu, ko eksportēt.';

  @override
  String get exportColumnType => 'Tips';

  @override
  String get exportColumnQrCode => 'QR kods';

  @override
  String get exportColumnDecorCode => 'Dekora kods';

  @override
  String get exportColumnDecorName => 'Dekora nosaukums';

  @override
  String get exportColumnLocation => 'Atrašanās vieta';

  @override
  String get exportColumnStatus => 'Statuss';

  @override
  String get exportColumnCreatedAt => 'Izveidots';

  @override
  String exportFailedMessage(String message) {
    return 'Eksportēšana neizdevās: $message';
  }

  @override
  String get calculatorsTitle => 'Kalkulatori';

  @override
  String get calculatorAreaVolumeTab => 'Laukums / tilpums';

  @override
  String get calculatorEdgeBandingTab => 'Apmales lente';

  @override
  String get areaM2Label => 'Laukums (m²)';

  @override
  String get volumeM3Label => 'Tilpums (m³)';

  @override
  String get outerDiameterMmLabel => 'Ārējais diametrs (mm)';

  @override
  String get coreDiameterMmLabel => 'Serdes diametrs (mm)';

  @override
  String get tapeThicknessMmLabel => 'Lentes biezums (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Lentes garums (m)';

  @override
  String get calculateButton => 'Aprēķināt';

  @override
  String get shoppingListTitle => 'Iepirkumu saraksts';

  @override
  String get shoppingListNoThresholds =>
      'Vēl nav iestatīts neviens minimālā krājuma slieksnis. Pieskarieties +, lai iestatītu pirmo.';

  @override
  String get shoppingListAllSufficient =>
      'Visi iestatītie sliekšņi ir ievēroti — neviens krājums nav zems.';

  @override
  String get currentStockLabel => 'Noliktavā';

  @override
  String get minimumStockLabel => 'Minimālais slieksnis';

  @override
  String get setThresholdTitle => 'Iestatīt minimālā krājuma slieksni';

  @override
  String get searchDecorHint => 'Meklēt dekoru (kods vai nosaukums)';

  @override
  String get minimumStockQuantityLabel => 'Minimālais krājums (gab.)';

  @override
  String get clearThresholdButton => 'Noņemt slieksni';

  @override
  String get invalidQuantityMessage =>
      'Ievadiet veselu skaitli, 0 vai lielāku.';

  @override
  String get aiQueryTitle => 'Jautāt AI';

  @override
  String get aiQueryInputHint =>
      'Uzdodiet jautājumu par noliktavu, piem., \"Cik man ir H3303?\"';

  @override
  String get aiQuerySendTooltip => 'Sūtīt';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Nesaprotu jautājumu: „$query”. Mēģiniet, piem., „Cik man ir H3303?”';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity gab. noliktavā';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Atrašanās vietas — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty => 'Šī dekora plākšņu pašlaik noliktavā nav.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Izmēri — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Šī dekora materiāla pašlaik noliktavā nav.';

  @override
  String get aiQueryStaleHeader => 'Guļošs materiāls';

  @override
  String get aiQueryStaleEmpty => 'Nav guļoša materiāla.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Piemēroti atgriezumi — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty => 'Nav piemērota šī dekora atgriezuma.';

  @override
  String get aiQueryBoardTypeLabel => 'Plāksne';

  @override
  String get aiQueryOffcutTypeLabel => 'Atgriezums';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Pārpalikums: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Dzēst noliktavu „$name”?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Šo darbību nevar atsaukt. Visi plaukti un vietas šajā noliktavā tiks dzēsti. Tajos esošās plāksnes un atgriezumi tiks arhivēti (nevis dzēsti) — to vēsture paliks redzama.';

  @override
  String deleteRackQuestion(String name) {
    return 'Dzēst plauktu „$name”?';
  }

  @override
  String get deleteRackWarning =>
      'Šo darbību nevar atsaukt. Visas nišas šajā plauktā tiks dzēstas. Tajās esošās plāksnes un atgriezumi tiks arhivēti (nevis dzēsti) — to vēsture paliks redzama.';

  @override
  String get decorCatalogBreadcrumb => 'Noliktava';

  @override
  String get decorCatalogTitle => 'Dekoru katalogs';

  @override
  String get decorCatalogSearchHint => 'Meklēt pēc koda vai nosaukuma…';

  @override
  String get decorFilterAll => 'Visi';

  @override
  String get decorFilterBoard => 'Plāksnes';

  @override
  String get decorFilterWorktop => 'Darba virsmas';

  @override
  String get decorFilterEdging => 'Malu lentes';

  @override
  String get decorTypeBoard => 'Plāksne';

  @override
  String get decorTypeWorktop => 'Darba virsma';

  @override
  String get decorTypeEdging => 'Malu lente';

  @override
  String get decorEmptyNoData => 'Datu bāzē nav dekoru';

  @override
  String decorEmptyNoResults(String query) {
    return 'Nav dekoru, kas atbilst vaicājumam „$query“';
  }

  @override
  String get decorRetry => 'Mēģināt vēlreiz';

  @override
  String get decorApproxColorLabel => 'aptuvenā krāsa';

  @override
  String get decorSeeRealPhoto => 'Skatīt dekora fotoattēlu';

  @override
  String decorImageSourceNote(String domain) {
    return 'atver $domain oficiālo vietni';
  }

  @override
  String get decorNoImageLinkSnackbar => 'Šim dekoram nav attēla saites';

  @override
  String get decorFailedToOpenLinkSnackbar => 'Neizdevās atvērt saiti';
}
