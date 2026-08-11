// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get warehousesTitle => 'Lagre';

  @override
  String get boardTitle => 'Plade';

  @override
  String get offcutTitle => 'Afskær';

  @override
  String get historyLabel => 'Historik';

  @override
  String get noEntries => 'Ingen poster.';

  @override
  String get cancel => 'Annuller';

  @override
  String get save => 'Gem';

  @override
  String get archive => 'Arkiver';

  @override
  String get move => 'Flyt';

  @override
  String get moveToLabel => 'Flyt til:';

  @override
  String get cut => 'Skær';

  @override
  String get cutOffcut => 'Skær et afskær';

  @override
  String get retry => 'Forsøg igen';

  @override
  String get searchManually => 'Søg manuelt';

  @override
  String get scanAgain => 'Scan igen';

  @override
  String get scanQrCode => 'Scan QR-kode';

  @override
  String get viewSourceBoard => 'Vis oprindelig plade';

  @override
  String get addBoard => 'Tilføj plade';

  @override
  String get addRack => 'Tilføj reol';

  @override
  String get addSlot => 'Tilføj hylde';

  @override
  String get newBoardTitle => 'Ny plade';

  @override
  String get newRackTitle => 'Ny reol';

  @override
  String get newSlotTitle => 'Ny hylde';

  @override
  String get deleteSlotQuestion => 'Slet denne hylde?';

  @override
  String get archiveBoardQuestion => 'Arkiver denne plade?';

  @override
  String get archiveOffcutQuestion => 'Arkiver dette afskær?';

  @override
  String get historyStaysVisible => 'Historikken (Ledger) forbliver synlig.';

  @override
  String get deleteSlotWarning =>
      'Denne handling kan ikke fortrydes. Plader og afskær på denne hylde arkiveres (slettes ikke) — deres historik forbliver synlig.';

  @override
  String get fillDimensionsCorrectly => 'Udfyld målene korrekt.';

  @override
  String get noDecorsInCatalog =>
      'Ingen dekorer i kataloget — tilføj mindst én.';

  @override
  String get noOtherSlotInRack => 'Ingen anden hylde i denne reol.';

  @override
  String get noWarehousesYet =>
      'Endnu ingen lagre. Tilføj det første med +-knappen.';

  @override
  String get nameLabel => 'Navn';

  @override
  String get nameHintSlot => 'Navn (f.eks. A1)';

  @override
  String get nameHintRack => 'Reolnavn (f.eks. A, LAGER-1)';

  @override
  String get addressOptional => 'Adresse (valgfrit)';

  @override
  String get decorLabel => 'Dekor';

  @override
  String get lengthMm => 'Længde (mm)';

  @override
  String get widthMm => 'Bredde (mm)';

  @override
  String get thicknessMm => 'Tykkelse (mm)';

  @override
  String get capacityLabel => 'Kapacitet';

  @override
  String get capacityPcsLabel => 'Kapacitet (stk.)';

  @override
  String errorPrefix(String message) {
    return 'Fejl: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Reol $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Reoler — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity stk.';
  }

  @override
  String get statusInStock => 'på lager';

  @override
  String get statusAvailable => 'tilgængelig';

  @override
  String get statusArchived => 'arkiveret';

  @override
  String get newWarehouseTitle => 'Nyt lager';

  @override
  String get noItemsInSlot => 'Ingen plader eller afskær i denne hylde.';

  @override
  String get noRacksYet =>
      'Ingen reoler i dette lager.\nTilføj den første for at begynde at organisere placeringer.';

  @override
  String get noSlotsYet =>
      'Ingen hylder i denne reol.\nTilføj den første for at kunne tildele plader og afskær.';

  @override
  String get boardsSectionLabel => 'PLADER';

  @override
  String get offcutsSectionLabel => 'AFSKÆR';

  @override
  String get qrCodeNotFound =>
      'Denne kode findes ikke eller er blevet fjernet.';

  @override
  String get delete => 'Slet';

  @override
  String get deleteSlotButton => 'Slet hylde';

  @override
  String cutFromBoardNote(String decor) {
    return 'Fra plade ($decor) — forbliver i samme hylde.';
  }

  @override
  String statusLabel(String value) {
    return 'Status: $value';
  }

  @override
  String get printLabelsForSlot => 'Udskriv etiketter';

  @override
  String get eventCreated => 'Oprettet';

  @override
  String get eventMoved => 'Flyttet';

  @override
  String get eventArchived => 'Arkiveret';

  @override
  String get eventCut => 'Skåret';

  @override
  String get eventQrRegenerated => 'QR gendannet';

  @override
  String get ownerDashboardTitle => 'Ejerpanel';

  @override
  String get totalBoardsLabel => 'Plader';

  @override
  String get totalOffcutsLabel => 'Afskær';

  @override
  String get overallFillRateLabel => 'Fyldningsgrad';

  @override
  String get totalRacksSlotsLabel => 'Reoler / Hylder';

  @override
  String get staleItemsSectionTitle => 'Hvilende materialer';

  @override
  String get staleItemsSectionSubtitle => 'Ubrugt i over et år';

  @override
  String get noStaleItems => 'Ingen hvilende materialer.';

  @override
  String get locationUnknown => 'Placering ukendt';

  @override
  String daysAgo(int days) {
    return '$days dage siden';
  }

  @override
  String get exportTitle => 'Eksport';

  @override
  String get exportWarehouseLabel => 'Lager';

  @override
  String get exportButton => 'Eksporter';

  @override
  String get exportEmptyWarehouse =>
      'Dette lager har ingen plader eller afskær at eksportere.';

  @override
  String get exportColumnType => 'Type';

  @override
  String get exportColumnQrCode => 'QR-kode';

  @override
  String get exportColumnDecorCode => 'Dekorkode';

  @override
  String get exportColumnDecorName => 'Dekornavn';

  @override
  String get exportColumnLocation => 'Placering';

  @override
  String get exportColumnStatus => 'Status';

  @override
  String get exportColumnCreatedAt => 'Oprettet';

  @override
  String exportFailedMessage(String message) {
    return 'Eksport mislykkedes: $message';
  }

  @override
  String get calculatorsTitle => 'Lommeregnere';

  @override
  String get calculatorAreaVolumeTab => 'Areal / volumen';

  @override
  String get calculatorEdgeBandingTab => 'Kantbånd';

  @override
  String get areaM2Label => 'Areal (m²)';

  @override
  String get volumeM3Label => 'Volumen (m³)';

  @override
  String get outerDiameterMmLabel => 'Yderdiameter (mm)';

  @override
  String get coreDiameterMmLabel => 'Kernediameter (mm)';

  @override
  String get tapeThicknessMmLabel => 'Tykkelse kantbånd (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Længde kantbånd (m)';

  @override
  String get calculateButton => 'Beregn';

  @override
  String get shoppingListTitle => 'Indkøbsliste';

  @override
  String get shoppingListNoThresholds =>
      'Ingen minimumslagerniveauer angivet endnu. Tryk på + for at angive det første.';

  @override
  String get shoppingListAllSufficient =>
      'Alle angivne niveauer er opfyldt — intet lager er lavt.';

  @override
  String get currentStockLabel => 'På lager';

  @override
  String get minimumStockLabel => 'Minimumsgrænse';

  @override
  String get setThresholdTitle => 'Angiv minimumslagerniveau';

  @override
  String get searchDecorHint => 'Søg dekor (kode eller navn)';

  @override
  String get minimumStockQuantityLabel => 'Minimumslager (stk.)';

  @override
  String get clearThresholdButton => 'Fjern grænse';

  @override
  String get invalidQuantityMessage => 'Angiv et helt tal, 0 eller mere.';

  @override
  String get aiQueryTitle => 'Spørg AI';

  @override
  String get aiQueryInputHint =>
      'Stil et spørgsmål om lageret, f.eks. \"Hvor meget H3303 har jeg?\"';

  @override
  String get aiQuerySendTooltip => 'Send';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Jeg forstår ikke spørgsmålet: „$query”. Prøv f.eks. „Hvor meget H3303 har jeg?”';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity stk. på lager';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Placeringer — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Ingen plader af denne dekor på lager lige nu.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Mål — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Intet materiale af denne dekor på lager lige nu.';

  @override
  String get aiQueryStaleHeader => 'Liggende materiale';

  @override
  String get aiQueryStaleEmpty => 'Intet liggende materiale.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Passende afskær — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty => 'Intet passende afskær af denne dekor.';

  @override
  String get aiQueryBoardTypeLabel => 'Plade';

  @override
  String get aiQueryOffcutTypeLabel => 'Afskær';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Overskud: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Slet lager „$name”?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Denne handling kan ikke fortrydes. Alle reoler og pladser i dette lager slettes. Plader og afskær i dem arkiveres (slettes ikke) — deres historik forbliver synlig.';

  @override
  String deleteRackQuestion(String name) {
    return 'Slet reol „$name”?';
  }

  @override
  String get deleteRackWarning =>
      'Denne handling kan ikke fortrydes. Alle pladser på denne reol slettes. Plader og afskær i dem arkiveres (slettes ikke) — deres historik forbliver synlig.';
}
