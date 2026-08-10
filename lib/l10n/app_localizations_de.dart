// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get warehousesTitle => 'Lager';

  @override
  String get boardTitle => 'Platte';

  @override
  String get offcutTitle => 'Verschnitt';

  @override
  String get historyLabel => 'Verlauf';

  @override
  String get noEntries => 'Keine Einträge.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get archive => 'Archivieren';

  @override
  String get move => 'Verschieben';

  @override
  String get moveToLabel => 'Verschieben nach:';

  @override
  String get cut => 'Zuschneiden';

  @override
  String get cutOffcut => 'Verschnitt zuschneiden';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get searchManually => 'Manuell suchen';

  @override
  String get scanAgain => 'Erneut scannen';

  @override
  String get scanQrCode => 'QR-Code scannen';

  @override
  String get viewSourceBoard => 'Ausgangsplatte ansehen';

  @override
  String get addBoard => 'Platte hinzufügen';

  @override
  String get addRack => 'Regal hinzufügen';

  @override
  String get addSlot => 'Fach hinzufügen';

  @override
  String get newBoardTitle => 'Neue Platte';

  @override
  String get newRackTitle => 'Neues Regal';

  @override
  String get newSlotTitle => 'Neues Fach';

  @override
  String get deleteSlotQuestion => 'Fach löschen?';

  @override
  String get archiveBoardQuestion => 'Platte archivieren?';

  @override
  String get archiveOffcutQuestion => 'Verschnitt archivieren?';

  @override
  String get historyStaysVisible => 'Der Verlauf (Ledger) bleibt sichtbar.';

  @override
  String get deleteSlotWarning =>
      'Dieser Vorgang kann nicht widerrufen werden. Platten und Verschnittstücke in diesem Fach werden nicht gelöscht — sie verlieren nur ihren zugewiesenen Standort (slot_id verweist dann auf keinen bestehenden Datensatz — ein späterer Aufräumschritt, falls nötig).';

  @override
  String get fillDimensionsCorrectly => 'Bitte die Maße korrekt ausfüllen.';

  @override
  String get noDecorsInCatalog =>
      'Keine Dekore im Katalog — mindestens eines hinzufügen.';

  @override
  String get noOtherSlotInRack => 'Kein weiteres Fach in diesem Regal.';

  @override
  String get noWarehousesYet =>
      'Noch keine Lager. Fügen Sie das erste mit der +-Taste hinzu.';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHintSlot => 'Name (z. B. A1)';

  @override
  String get nameHintRack => 'Regalname (z. B. A, LAGER-1)';

  @override
  String get addressOptional => 'Adresse (optional)';

  @override
  String get decorLabel => 'Dekor';

  @override
  String get lengthMm => 'Länge (mm)';

  @override
  String get widthMm => 'Breite (mm)';

  @override
  String get thicknessMm => 'Dicke (mm)';

  @override
  String get capacityLabel => 'Kapazität';

  @override
  String get capacityPcsLabel => 'Kapazität (Stk.)';

  @override
  String errorPrefix(String message) {
    return 'Fehler: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Regal $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Regale — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity Stk.';
  }

  @override
  String get statusInStock => 'vorhanden';

  @override
  String get statusAvailable => 'verfügbar';

  @override
  String get statusArchived => 'archiviert';

  @override
  String get newWarehouseTitle => 'Neues Lager';

  @override
  String get noItemsInSlot =>
      'Keine Platten oder Verschnittstücke in diesem Fach.';

  @override
  String get noRacksYet =>
      'Keine Regale in diesem Lager.\nFügen Sie das erste hinzu, um mit der Organisation zu beginnen.';

  @override
  String get noSlotsYet =>
      'Keine Fächer in diesem Regal.\nFügen Sie das erste hinzu, um Platten und Verschnitt zuzuweisen.';

  @override
  String get boardsSectionLabel => 'PLATTEN';

  @override
  String get offcutsSectionLabel => 'VERSCHNITT';

  @override
  String get qrCodeNotFound =>
      'Dieser Code existiert nicht oder wurde entfernt.';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteSlotButton => 'Fach löschen';

  @override
  String cutFromBoardNote(String decor) {
    return 'Von Platte ($decor) — bleibt im selben Fach.';
  }

  @override
  String statusLabel(String value) {
    return 'Status: $value';
  }

  @override
  String get printLabelsForSlot => 'Etiketten drucken';

  @override
  String get eventCreated => 'Erstellt';

  @override
  String get eventMoved => 'Verschoben';

  @override
  String get eventArchived => 'Archiviert';

  @override
  String get eventCut => 'Zugeschnitten';

  @override
  String get eventQrRegenerated => 'QR neu generiert';

  @override
  String get ownerDashboardTitle => 'Eigentümer-Dashboard';

  @override
  String get totalBoardsLabel => 'Platten';

  @override
  String get totalOffcutsLabel => 'Verschnitt';

  @override
  String get overallFillRateLabel => 'Auslastung';

  @override
  String get totalRacksSlotsLabel => 'Regale / Fächer';

  @override
  String get staleItemsSectionTitle => 'Liegengebliebenes Material';

  @override
  String get staleItemsSectionSubtitle => 'Über ein Jahr ungenutzt';

  @override
  String get noStaleItems => 'Kein liegengebliebenes Material.';

  @override
  String get locationUnknown => 'Standort unbekannt';

  @override
  String daysAgo(int days) {
    return 'vor $days Tagen';
  }

  @override
  String get exportTitle => 'Export';

  @override
  String get exportWarehouseLabel => 'Lager';

  @override
  String get exportButton => 'Exportieren';

  @override
  String get exportEmptyWarehouse =>
      'Dieses Lager hat keine Platten oder Verschnittstücke zum Exportieren.';

  @override
  String get exportColumnType => 'Typ';

  @override
  String get exportColumnQrCode => 'QR-Code';

  @override
  String get exportColumnDecorCode => 'Dekorcode';

  @override
  String get exportColumnDecorName => 'Dekorname';

  @override
  String get exportColumnLocation => 'Standort';

  @override
  String get exportColumnStatus => 'Status';

  @override
  String get exportColumnCreatedAt => 'Erstellt';

  @override
  String exportFailedMessage(String message) {
    return 'Export fehlgeschlagen: $message';
  }

  @override
  String get calculatorsTitle => 'Kalkulatoren';

  @override
  String get calculatorAreaVolumeTab => 'Fläche / Volumen';

  @override
  String get calculatorEdgeBandingTab => 'Kantenband';

  @override
  String get areaM2Label => 'Fläche (m²)';

  @override
  String get volumeM3Label => 'Volumen (m³)';

  @override
  String get outerDiameterMmLabel => 'Außendurchmesser (mm)';

  @override
  String get coreDiameterMmLabel => 'Kerndurchmesser (mm)';

  @override
  String get tapeThicknessMmLabel => 'Banddicke (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Kantenbandlänge (m)';

  @override
  String get calculateButton => 'Berechnen';

  @override
  String get shoppingListTitle => 'Einkaufsliste';

  @override
  String get shoppingListNoThresholds =>
      'Noch keine Mindestbestandsgrenzen festgelegt. Tippen Sie auf +, um die erste festzulegen.';

  @override
  String get shoppingListAllSufficient =>
      'Alle festgelegten Grenzen sind eingehalten — kein Bestand ist knapp.';

  @override
  String get currentStockLabel => 'Vorhanden';

  @override
  String get minimumStockLabel => 'Mindestbestand';

  @override
  String get setThresholdTitle => 'Mindestbestandsgrenze festlegen';

  @override
  String get searchDecorHint => 'Dekor suchen (Code oder Name)';

  @override
  String get minimumStockQuantityLabel => 'Mindestbestand (Stk.)';

  @override
  String get clearThresholdButton => 'Grenze entfernen';

  @override
  String get invalidQuantityMessage =>
      'Geben Sie eine ganze Zahl, 0 oder größer, ein.';

  @override
  String get aiQueryTitle => 'KI fragen';

  @override
  String get aiQueryInputHint =>
      'Frage zum Lager, z. B. \"Wie viel H3303 habe ich?\"';

  @override
  String get aiQuerySendTooltip => 'Senden';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Ich verstehe die Frage nicht: „$query“. Versuchen Sie z. B. „Wie viel H3303 habe ich?“';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity Stk. auf Lager';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Standorte — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'Keine Platten dieses Dekors derzeit auf Lager.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Abmessungen — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Kein Material dieses Dekors derzeit auf Lager.';

  @override
  String get aiQueryStaleHeader => 'Liegen gebliebenes Material';

  @override
  String get aiQueryStaleEmpty => 'Kein liegen gebliebenes Material.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Passender Verschnitt — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty =>
      'Kein passender Verschnitt dieses Dekors.';

  @override
  String get aiQueryBoardTypeLabel => 'Platte';

  @override
  String get aiQueryOffcutTypeLabel => 'Verschnitt';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Überschuss: $value mm²';
  }
}
