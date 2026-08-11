// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class AppLocalizationsLt extends AppLocalizations {
  AppLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get warehousesTitle => 'Sandėliai';

  @override
  String get boardTitle => 'Plokštė';

  @override
  String get offcutTitle => 'Atraiža';

  @override
  String get historyLabel => 'Istorija';

  @override
  String get noEntries => 'Nėra įrašų.';

  @override
  String get cancel => 'Atšaukti';

  @override
  String get save => 'Išsaugoti';

  @override
  String get archive => 'Archyvuoti';

  @override
  String get move => 'Perkelti';

  @override
  String get moveToLabel => 'Perkelti į:';

  @override
  String get cut => 'Pjauti';

  @override
  String get cutOffcut => 'Atpjauti atraižą';

  @override
  String get retry => 'Bandyti dar kartą';

  @override
  String get searchManually => 'Ieškoti rankiniu būdu';

  @override
  String get scanAgain => 'Skenuoti iš naujo';

  @override
  String get scanQrCode => 'Skenuoti QR kodą';

  @override
  String get viewSourceBoard => 'Žiūrėti šaltinio plokštę';

  @override
  String get addBoard => 'Pridėti plokštę';

  @override
  String get addRack => 'Pridėti stelažą';

  @override
  String get addSlot => 'Pridėti ląstelę';

  @override
  String get newBoardTitle => 'Nauja plokštė';

  @override
  String get newRackTitle => 'Naujas stelažas';

  @override
  String get newSlotTitle => 'Nauja ląstelė';

  @override
  String get deleteSlotQuestion => 'Ištrinti šią ląstelę?';

  @override
  String get archiveBoardQuestion => 'Archyvuoti šią plokštę?';

  @override
  String get archiveOffcutQuestion => 'Archyvuoti šią atraižą?';

  @override
  String get historyStaysVisible => 'Istorija (Ledger) išliks matoma.';

  @override
  String get deleteSlotWarning =>
      'Šio veiksmo negalima anuliuoti. Šioje ląstelėje esančios plokštės ir atraižos bus archyvuotos (neištrintos) — jų istorija liks matoma.';

  @override
  String get fillDimensionsCorrectly => 'Užpildykite matmenis teisingai.';

  @override
  String get noDecorsInCatalog =>
      'Kataloge nėra dekorų — pridėkite bent vieną.';

  @override
  String get noOtherSlotInRack => 'Šiame stelaže nėra kitos ląstelės.';

  @override
  String get noWarehousesYet =>
      'Kol kas nėra sandėlių. Pridėkite pirmąjį mygtuku +.';

  @override
  String get nameLabel => 'Pavadinimas';

  @override
  String get nameHintSlot => 'Pavadinimas (pvz. A1)';

  @override
  String get nameHintRack => 'Stelažo pavadinimas (pvz. A, SANDĖLIS-1)';

  @override
  String get addressOptional => 'Adresas (nebūtinas)';

  @override
  String get decorLabel => 'Dekoras';

  @override
  String get lengthMm => 'Ilgis (mm)';

  @override
  String get widthMm => 'Plotis (mm)';

  @override
  String get thicknessMm => 'Storis (mm)';

  @override
  String get capacityLabel => 'Talpa';

  @override
  String get capacityPcsLabel => 'Talpa (vnt.)';

  @override
  String errorPrefix(String message) {
    return 'Klaida: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Stelažas $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Stelažai — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity vnt.';
  }

  @override
  String get statusInStock => 'sandėlyje';

  @override
  String get statusAvailable => 'pasiekiama';

  @override
  String get statusArchived => 'archyvuota';

  @override
  String get newWarehouseTitle => 'Naujas sandėlis';

  @override
  String get noItemsInSlot => 'Šioje ląstelėje nėra plokščių ar atraižų.';

  @override
  String get noRacksYet =>
      'Šiame sandėlyje nėra stelažų.\nPridėkite pirmąjį, kad pradėtumėte organizuoti vietas.';

  @override
  String get noSlotsYet =>
      'Šiame stelaže nėra ląstelių.\nPridėkite pirmąją, kad galėtumėte priskirti plokštes ir atraižas.';

  @override
  String get boardsSectionLabel => 'PLOKŠTĖS';

  @override
  String get offcutsSectionLabel => 'ATRAIŽOS';

  @override
  String get qrCodeNotFound => 'Šio kodo nėra arba jis buvo pašalintas.';

  @override
  String get delete => 'Ištrinti';

  @override
  String get deleteSlotButton => 'Ištrinti ląstelę';

  @override
  String cutFromBoardNote(String decor) {
    return 'Iš plokštės ($decor) — lieka toje pačioje ląstelėje.';
  }

  @override
  String statusLabel(String value) {
    return 'Būsena: $value';
  }

  @override
  String get printLabelsForSlot => 'Spausdinti etiketes';

  @override
  String get eventCreated => 'Sukurta';

  @override
  String get eventMoved => 'Perkelta';

  @override
  String get eventArchived => 'Archyvuota';

  @override
  String get eventCut => 'Supjaustyta';

  @override
  String get eventQrRegenerated => 'QR sugeneruotas iš naujo';

  @override
  String get ownerDashboardTitle => 'Savininko skydelis';

  @override
  String get totalBoardsLabel => 'Plokštės';

  @override
  String get totalOffcutsLabel => 'Atraižos';

  @override
  String get overallFillRateLabel => 'Užpildymas';

  @override
  String get totalRacksSlotsLabel => 'Stelažai / Ląstelės';

  @override
  String get staleItemsSectionTitle => 'Ilgai gulinčios medžiagos';

  @override
  String get staleItemsSectionSubtitle => 'Nenaudota daugiau nei metus';

  @override
  String get noStaleItems => 'Nėra ilgai gulinčių medžiagų.';

  @override
  String get locationUnknown => 'Vieta nežinoma';

  @override
  String daysAgo(int days) {
    return 'prieš $days d.';
  }

  @override
  String get exportTitle => 'Eksportuoti';

  @override
  String get exportWarehouseLabel => 'Sandėlis';

  @override
  String get exportButton => 'Eksportuoti';

  @override
  String get exportEmptyWarehouse =>
      'Šiame sandėlyje nėra plokščių ar atraižų eksportavimui.';

  @override
  String get exportColumnType => 'Tipas';

  @override
  String get exportColumnQrCode => 'QR kodas';

  @override
  String get exportColumnDecorCode => 'Dekoro kodas';

  @override
  String get exportColumnDecorName => 'Dekoro pavadinimas';

  @override
  String get exportColumnLocation => 'Vieta';

  @override
  String get exportColumnStatus => 'Būsena';

  @override
  String get exportColumnCreatedAt => 'Sukurta';

  @override
  String exportFailedMessage(String message) {
    return 'Eksportavimas nepavyko: $message';
  }

  @override
  String get calculatorsTitle => 'Skaičiuoklės';

  @override
  String get calculatorAreaVolumeTab => 'Plotas / tūris';

  @override
  String get calculatorEdgeBandingTab => 'Briaunų juostelė';

  @override
  String get areaM2Label => 'Plotas (m²)';

  @override
  String get volumeM3Label => 'Tūris (m³)';

  @override
  String get outerDiameterMmLabel => 'Išorinis skersmuo (mm)';

  @override
  String get coreDiameterMmLabel => 'Šerdies skersmuo (mm)';

  @override
  String get tapeThicknessMmLabel => 'Juostelės storis (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Juostelės ilgis (m)';

  @override
  String get calculateButton => 'Apskaičiuoti';

  @override
  String get shoppingListTitle => 'Pirkinių sąrašas';

  @override
  String get shoppingListNoThresholds =>
      'Kol kas nenustatyta jokių minimalaus atsargų kiekio ribų. Palieskite +, kad nustatytumėte pirmąją.';

  @override
  String get shoppingListAllSufficient =>
      'Visos nustatytos ribos yra išlaikytos — nėra žemų atsargų.';

  @override
  String get currentStockLabel => 'Sandėlyje';

  @override
  String get minimumStockLabel => 'Minimali riba';

  @override
  String get setThresholdTitle => 'Nustatyti minimalaus atsargų kiekio ribą';

  @override
  String get searchDecorHint => 'Ieškoti dekoro (kodas arba pavadinimas)';

  @override
  String get minimumStockQuantityLabel => 'Minimalus kiekis (vnt.)';

  @override
  String get clearThresholdButton => 'Pašalinti ribą';

  @override
  String get invalidQuantityMessage =>
      'Įveskite sveiką skaičių, 0 arba daugiau.';

  @override
  String get aiQueryTitle => 'Klausti AI';

  @override
  String get aiQueryInputHint =>
      'Užduokite klausimą apie sandėlį, pvz., \"Kiek turiu H3303?\"';

  @override
  String get aiQuerySendTooltip => 'Siųsti';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Nesuprantu klausimo: „$query“. Pabandykite, pvz., „Kiek turiu H3303?“';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity vnt. sandėlyje';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Vietos — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Šiuo metu sandėlyje nėra šio dekoro plokščių.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Matmenys — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Šiuo metu sandėlyje nėra šio dekoro medžiagos.';

  @override
  String get aiQueryStaleHeader => 'Gulinti medžiaga';

  @override
  String get aiQueryStaleEmpty => 'Gulinčios medžiagos nėra.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Tinkamos atraižos — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty => 'Nėra tinkamos šio dekoro atraižos.';

  @override
  String get aiQueryBoardTypeLabel => 'Plokštė';

  @override
  String get aiQueryOffcutTypeLabel => 'Atraiža';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Perteklius: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Ištrinti sandėlį „$name“?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Šio veiksmo nebus galima anuliuoti. Visi šio sandėlio stelažai ir vietos bus ištrinti. Juose esančios plokštės ir atraižos bus archyvuotos (neištrintos) — jų istorija liks matoma.';

  @override
  String deleteRackQuestion(String name) {
    return 'Ištrinti stelažą „$name“?';
  }

  @override
  String get deleteRackWarning =>
      'Šio veiksmo nebus galima anuliuoti. Visos šio stelažo ląstelės bus ištrintos. Jose esančios plokštės ir atraižos bus archyvuotos (neištrintos) — jų istorija liks matoma.';
}
