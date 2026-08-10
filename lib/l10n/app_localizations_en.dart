// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get warehousesTitle => 'Warehouses';

  @override
  String get boardTitle => 'Board';

  @override
  String get offcutTitle => 'Offcut';

  @override
  String get historyLabel => 'History';

  @override
  String get noEntries => 'No entries.';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get archive => 'Archive';

  @override
  String get move => 'Move';

  @override
  String get moveToLabel => 'Move to:';

  @override
  String get cut => 'Cut';

  @override
  String get cutOffcut => 'Cut offcut';

  @override
  String get retry => 'Retry';

  @override
  String get searchManually => 'Search manually';

  @override
  String get scanAgain => 'Scan again';

  @override
  String get scanQrCode => 'Scan QR code';

  @override
  String get viewSourceBoard => 'View source board';

  @override
  String get addBoard => 'Add board';

  @override
  String get addRack => 'Add rack';

  @override
  String get addSlot => 'Add slot';

  @override
  String get newBoardTitle => 'New board';

  @override
  String get newRackTitle => 'New rack';

  @override
  String get newSlotTitle => 'New slot';

  @override
  String get deleteSlotQuestion => 'Delete this slot?';

  @override
  String get archiveBoardQuestion => 'Archive this board?';

  @override
  String get archiveOffcutQuestion => 'Archive this offcut?';

  @override
  String get historyStaysVisible => 'History (Ledger) will remain visible.';

  @override
  String get deleteSlotWarning =>
      'This action cannot be undone. Boards and offcuts assigned to this slot will not be deleted — they will just lose their assigned location (slot_id will point to a non-existent record — a future cleanup step, if ever needed).';

  @override
  String get fillDimensionsCorrectly =>
      'Please fill in the dimensions correctly.';

  @override
  String get noDecorsInCatalog =>
      'No decors in the catalog — add at least one.';

  @override
  String get noOtherSlotInRack => 'No other slot in this rack.';

  @override
  String get noWarehousesYet =>
      'No warehouses yet. Add the first one with the + button.';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHintSlot => 'Name (e.g. A1)';

  @override
  String get nameHintRack => 'Rack name (e.g. A, WAREHOUSE-1)';

  @override
  String get addressOptional => 'Address (optional)';

  @override
  String get decorLabel => 'Decor';

  @override
  String get lengthMm => 'Length (mm)';

  @override
  String get widthMm => 'Width (mm)';

  @override
  String get thicknessMm => 'Thickness (mm)';

  @override
  String get capacityLabel => 'Capacity';

  @override
  String get capacityPcsLabel => 'Capacity (pcs)';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Rack $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Racks — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity pcs';
  }

  @override
  String get statusInStock => 'in stock';

  @override
  String get statusAvailable => 'available';

  @override
  String get statusArchived => 'archived';

  @override
  String get newWarehouseTitle => 'New warehouse';

  @override
  String get noItemsInSlot => 'No boards or offcuts in this slot.';

  @override
  String get noRacksYet =>
      'No racks in this warehouse.\nAdd the first one to start organizing locations.';

  @override
  String get noSlotsYet =>
      'No slots in this rack.\nAdd the first one to assign boards and offcuts to it.';

  @override
  String get boardsSectionLabel => 'BOARDS';

  @override
  String get offcutsSectionLabel => 'OFFCUTS';

  @override
  String get qrCodeNotFound => 'This code doesn\'t exist or has been removed.';

  @override
  String get delete => 'Delete';

  @override
  String get deleteSlotButton => 'Delete slot';

  @override
  String cutFromBoardNote(String decor) {
    return 'From board ($decor) — stays in the same slot.';
  }

  @override
  String statusLabel(String value) {
    return 'Status: $value';
  }

  @override
  String get printLabelsForSlot => 'Print labels';

  @override
  String get eventCreated => 'Created';

  @override
  String get eventMoved => 'Moved';

  @override
  String get eventArchived => 'Archived';

  @override
  String get eventCut => 'Cut';

  @override
  String get eventQrRegenerated => 'QR regenerated';

  @override
  String get ownerDashboardTitle => 'Owner dashboard';

  @override
  String get totalBoardsLabel => 'Boards';

  @override
  String get totalOffcutsLabel => 'Offcuts';

  @override
  String get overallFillRateLabel => 'Fill rate';

  @override
  String get totalRacksSlotsLabel => 'Racks / Slots';

  @override
  String get staleItemsSectionTitle => 'Stale materials';

  @override
  String get staleItemsSectionSubtitle => 'Unused for over a year';

  @override
  String get noStaleItems => 'No stale materials.';

  @override
  String get locationUnknown => 'Location unknown';

  @override
  String daysAgo(int days) {
    return '$days days ago';
  }

  @override
  String get exportTitle => 'Export';

  @override
  String get exportWarehouseLabel => 'Warehouse';

  @override
  String get exportButton => 'Export';

  @override
  String get exportEmptyWarehouse =>
      'This warehouse has no boards or offcuts to export.';

  @override
  String get exportColumnType => 'Type';

  @override
  String get exportColumnQrCode => 'QR code';

  @override
  String get exportColumnDecorCode => 'Decor code';

  @override
  String get exportColumnDecorName => 'Decor name';

  @override
  String get exportColumnLocation => 'Location';

  @override
  String get exportColumnStatus => 'Status';

  @override
  String get exportColumnCreatedAt => 'Created';

  @override
  String exportFailedMessage(String message) {
    return 'Export failed: $message';
  }

  @override
  String get calculatorsTitle => 'Calculators';

  @override
  String get calculatorAreaVolumeTab => 'Area / volume';

  @override
  String get calculatorEdgeBandingTab => 'Edge banding';

  @override
  String get areaM2Label => 'Area (m²)';

  @override
  String get volumeM3Label => 'Volume (m³)';

  @override
  String get outerDiameterMmLabel => 'Outer diameter (mm)';

  @override
  String get coreDiameterMmLabel => 'Core diameter (mm)';

  @override
  String get tapeThicknessMmLabel => 'Tape thickness (mm)';

  @override
  String get edgeBandingLengthResultLabel => 'Edge banding length (m)';

  @override
  String get calculateButton => 'Calculate';

  @override
  String get shoppingListTitle => 'Shopping list';

  @override
  String get shoppingListNoThresholds =>
      'No minimum stock thresholds set yet. Tap + to set the first one.';

  @override
  String get shoppingListAllSufficient =>
      'Every set threshold is satisfied — nothing is low on stock.';

  @override
  String get currentStockLabel => 'In stock';

  @override
  String get minimumStockLabel => 'Minimum threshold';

  @override
  String get setThresholdTitle => 'Set minimum stock threshold';

  @override
  String get searchDecorHint => 'Search decor (code or name)';

  @override
  String get minimumStockQuantityLabel => 'Minimum stock (pcs)';

  @override
  String get clearThresholdButton => 'Clear threshold';

  @override
  String get invalidQuantityMessage => 'Enter a whole number, 0 or greater.';

  @override
  String get aiQueryTitle => 'Ask AI';

  @override
  String get aiQueryInputHint =>
      'Ask about the warehouse, e.g. \"How much H3303 do I have?\"';

  @override
  String get aiQuerySendTooltip => 'Send';

  @override
  String aiQueryUnrecognized(String query) {
    return 'I don\'t understand: \"$query\". Try e.g. \"How much H3303 do I have?\"';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity pcs in stock';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Locations — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty =>
      'No boards of this decor currently in stock.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Dimensions — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'No material of this decor currently in stock.';

  @override
  String get aiQueryStaleHeader => 'Stale materials';

  @override
  String get aiQueryStaleEmpty => 'No stale materials.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Matching offcuts — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty => 'No matching offcut of this decor.';

  @override
  String get aiQueryBoardTypeLabel => 'Board';

  @override
  String get aiQueryOffcutTypeLabel => 'Offcut';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Waste: $value mm²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Delete warehouse \"$name\"?';
  }

  @override
  String get deleteWarehouseWarning =>
      'This action cannot be undone. All racks and slots in this warehouse will be deleted. Boards and offcuts inside them will be archived (not deleted) — their history remains visible.';
}
