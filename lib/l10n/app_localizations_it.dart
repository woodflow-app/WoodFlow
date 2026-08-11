// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get warehousesTitle => 'Magazzini';

  @override
  String get boardTitle => 'Pannello';

  @override
  String get offcutTitle => 'Ritaglio';

  @override
  String get historyLabel => 'Cronologia';

  @override
  String get noEntries => 'Nessuna voce.';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get archive => 'Archivia';

  @override
  String get move => 'Sposta';

  @override
  String get moveToLabel => 'Sposta in:';

  @override
  String get cut => 'Taglia';

  @override
  String get cutOffcut => 'Taglia ritaglio';

  @override
  String get retry => 'Riprova';

  @override
  String get searchManually => 'Cerca manualmente';

  @override
  String get scanAgain => 'Scansiona di nuovo';

  @override
  String get scanQrCode => 'Scansiona codice QR';

  @override
  String get viewSourceBoard => 'Vedi pannello di origine';

  @override
  String get addBoard => 'Aggiungi pannello';

  @override
  String get addRack => 'Aggiungi scaffale';

  @override
  String get addSlot => 'Aggiungi vano';

  @override
  String get newBoardTitle => 'Nuovo pannello';

  @override
  String get newRackTitle => 'Nuovo scaffale';

  @override
  String get newSlotTitle => 'Nuovo vano';

  @override
  String get deleteSlotQuestion => 'Eliminare questo vano?';

  @override
  String get archiveBoardQuestion => 'Archiviare questo pannello?';

  @override
  String get archiveOffcutQuestion => 'Archiviare questo ritaglio?';

  @override
  String get historyStaysVisible => 'La cronologia (Ledger) resterà visibile.';

  @override
  String get deleteSlotWarning =>
      'Questa operazione è irreversibile. I pannelli e i ritagli in questo vano verranno archiviati (non eliminati) — la cronologia rimane visibile.';

  @override
  String get fillDimensionsCorrectly =>
      'Inserisci correttamente le dimensioni.';

  @override
  String get noDecorsInCatalog =>
      'Nessun decoro nel catalogo — aggiungine almeno uno.';

  @override
  String get noOtherSlotInRack => 'Nessun altro vano in questo scaffale.';

  @override
  String get noWarehousesYet =>
      'Nessun magazzino ancora. Aggiungi il primo con il pulsante +.';

  @override
  String get nameLabel => 'Nome';

  @override
  String get nameHintSlot => 'Nome (es. A1)';

  @override
  String get nameHintRack => 'Nome scaffale (es. A, MAGAZZINO-1)';

  @override
  String get addressOptional => 'Indirizzo (opzionale)';

  @override
  String get decorLabel => 'Decoro';

  @override
  String get lengthMm => 'Lunghezza (mm)';

  @override
  String get widthMm => 'Larghezza (mm)';

  @override
  String get thicknessMm => 'Spessore (mm)';

  @override
  String get capacityLabel => 'Capacità';

  @override
  String get capacityPcsLabel => 'Capacità (pz)';

  @override
  String errorPrefix(String message) {
    return 'Errore: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Scaffale $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Scaffali — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity pz';
  }

  @override
  String get statusInStock => 'in magazzino';

  @override
  String get statusAvailable => 'disponibile';

  @override
  String get statusArchived => 'archiviato';

  @override
  String get newWarehouseTitle => 'Nuovo magazzino';

  @override
  String get noItemsInSlot => 'Nessun pannello o ritaglio in questo vano.';

  @override
  String get noRacksYet =>
      'Nessuno scaffale in questo magazzino.\nAggiungine uno per iniziare a organizzare le posizioni.';

  @override
  String get noSlotsYet =>
      'Nessun vano in questo scaffale.\nAggiungine uno per poter assegnare pannelli e ritagli.';

  @override
  String get boardsSectionLabel => 'PANNELLI';

  @override
  String get offcutsSectionLabel => 'RITAGLI';

  @override
  String get qrCodeNotFound => 'Questo codice non esiste o è stato rimosso.';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteSlotButton => 'Elimina vano';

  @override
  String cutFromBoardNote(String decor) {
    return 'Dal pannello ($decor) — rimane nello stesso vano.';
  }

  @override
  String statusLabel(String value) {
    return 'Stato: $value';
  }

  @override
  String get printLabelsForSlot => 'Stampa etichette';

  @override
  String get eventCreated => 'Creato';

  @override
  String get eventMoved => 'Spostato';

  @override
  String get eventArchived => 'Archiviato';

  @override
  String get eventCut => 'Tagliato';

  @override
  String get eventQrRegenerated => 'QR rigenerato';

  @override
  String get ownerDashboardTitle => 'Dashboard proprietario';

  @override
  String get totalBoardsLabel => 'Pannelli';

  @override
  String get totalOffcutsLabel => 'Ritagli';

  @override
  String get overallFillRateLabel => 'Riempimento';

  @override
  String get totalRacksSlotsLabel => 'Scaffali / Vani';

  @override
  String get staleItemsSectionTitle => 'Materiali inutilizzati';

  @override
  String get staleItemsSectionSubtitle => 'Fermi da oltre un anno';

  @override
  String get noStaleItems => 'Nessun materiale inutilizzato.';

  @override
  String get locationUnknown => 'Posizione sconosciuta';

  @override
  String daysAgo(int days) {
    return '$days giorni fa';
  }

  @override
  String get exportTitle => 'Esportazione';

  @override
  String get exportWarehouseLabel => 'Magazzino';

  @override
  String get exportButton => 'Esporta';

  @override
  String get exportEmptyWarehouse =>
      'Questo magazzino non ha pannelli né ritagli da esportare.';

  @override
  String get exportColumnType => 'Tipo';

  @override
  String get exportColumnQrCode => 'Codice QR';

  @override
  String get exportColumnDecorCode => 'Codice decoro';

  @override
  String get exportColumnDecorName => 'Nome decoro';

  @override
  String get exportColumnLocation => 'Posizione';

  @override
  String get exportColumnStatus => 'Stato';

  @override
  String get exportColumnCreatedAt => 'Creato';

  @override
  String exportFailedMessage(String message) {
    return 'Esportazione non riuscita: $message';
  }

  @override
  String get calculatorsTitle => 'Calcolatrici';

  @override
  String get calculatorAreaVolumeTab => 'Superficie / volume';

  @override
  String get calculatorEdgeBandingTab => 'Bordo';

  @override
  String get areaM2Label => 'Superficie (m²)';

  @override
  String get volumeM3Label => 'Volume (m³)';

  @override
  String get outerDiameterMmLabel => 'Diametro esterno (mm)';

  @override
  String get coreDiameterMmLabel => 'Diametro anima (mm)';

  @override
  String get tapeThicknessMmLabel => 'Spessore bordo (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Lunghezza bordo (m)';

  @override
  String get calculateButton => 'Calcola';

  @override
  String get shoppingListTitle => 'Lista della spesa';

  @override
  String get shoppingListNoThresholds =>
      'Nessuna soglia di scorta minima impostata. Tocca + per impostarne una.';

  @override
  String get shoppingListAllSufficient =>
      'Tutte le soglie impostate sono rispettate — nessuna scorta è bassa.';

  @override
  String get currentStockLabel => 'In magazzino';

  @override
  String get minimumStockLabel => 'Soglia minima';

  @override
  String get setThresholdTitle => 'Imposta soglia di scorta minima';

  @override
  String get searchDecorHint => 'Cerca decoro (codice o nome)';

  @override
  String get minimumStockQuantityLabel => 'Scorta minima (pz)';

  @override
  String get clearThresholdButton => 'Rimuovi soglia';

  @override
  String get invalidQuantityMessage =>
      'Inserisci un numero intero, 0 o superiore.';

  @override
  String get aiQueryTitle => 'Chiedi all\'IA';

  @override
  String get aiQueryInputHint =>
      'Fai una domanda sul magazzino, es. \"Quanto H3303 ho?\"';

  @override
  String get aiQuerySendTooltip => 'Invia';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Non capisco la domanda: «$query». Prova ad es. «Quanto H3303 ho?»';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity pz in magazzino';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Posizioni — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Nessun pannello di questo decoro attualmente in magazzino.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Dimensioni — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Nessun materiale di questo decoro attualmente in magazzino.';

  @override
  String get aiQueryStaleHeader => 'Materiali fermi';

  @override
  String get aiQueryStaleEmpty => 'Nessun materiale fermo.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Ritagli corrispondenti — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty =>
      'Nessun ritaglio corrispondente per questo decoro.';

  @override
  String get aiQueryBoardTypeLabel => 'Pannello';

  @override
  String get aiQueryOffcutTypeLabel => 'Ritaglio';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Eccedenza: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Eliminare il magazzino «$name»?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Questa operazione è irreversibile. Tutti gli scaffali e i ripiani di questo magazzino verranno eliminati. I pannelli e i ritagli al loro interno verranno archiviati (non eliminati) — la cronologia rimane visibile.';

  @override
  String deleteRackQuestion(String name) {
    return 'Eliminare lo scaffale «$name»?';
  }

  @override
  String get deleteRackWarning =>
      'Questa operazione è irreversibile. Tutti i vani di questo scaffale verranno eliminati. I pannelli e i ritagli al loro interno verranno archiviati (non eliminati) — la cronologia rimane visibile.';
}
