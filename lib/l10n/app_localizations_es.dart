// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get warehousesTitle => 'Almacenes';

  @override
  String get boardTitle => 'Tablero';

  @override
  String get offcutTitle => 'Recorte';

  @override
  String get historyLabel => 'Historial';

  @override
  String get noEntries => 'Sin registros.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get archive => 'Archivar';

  @override
  String get move => 'Mover';

  @override
  String get moveToLabel => 'Mover a:';

  @override
  String get cut => 'Cortar';

  @override
  String get cutOffcut => 'Cortar recorte';

  @override
  String get retry => 'Reintentar';

  @override
  String get searchManually => 'Buscar manualmente';

  @override
  String get scanAgain => 'Escanear de nuevo';

  @override
  String get scanQrCode => 'Escanear código QR';

  @override
  String get viewSourceBoard => 'Ver tablero de origen';

  @override
  String get addBoard => 'Añadir tablero';

  @override
  String get addRack => 'Añadir estantería';

  @override
  String get addSlot => 'Añadir hueco';

  @override
  String get newBoardTitle => 'Nuevo tablero';

  @override
  String get newRackTitle => 'Nueva estantería';

  @override
  String get newSlotTitle => 'Nuevo hueco';

  @override
  String get deleteSlotQuestion => '¿Eliminar este hueco?';

  @override
  String get archiveBoardQuestion => '¿Archivar este tablero?';

  @override
  String get archiveOffcutQuestion => '¿Archivar este recorte?';

  @override
  String get historyStaysVisible => 'El historial (Ledger) seguirá visible.';

  @override
  String get deleteSlotWarning =>
      'Esta acción no se puede deshacer. Los tableros y recortes asignados a este hueco no se eliminarán — solo perderán su ubicación asignada (slot_id apuntará a un registro inexistente — un futuro paso de limpieza, si es necesario).';

  @override
  String get fillDimensionsCorrectly =>
      'Completa las dimensiones correctamente.';

  @override
  String get noDecorsInCatalog =>
      'No hay decorados en el catálogo — añade al menos uno.';

  @override
  String get noOtherSlotInRack => 'No hay otro hueco en esta estantería.';

  @override
  String get noWarehousesYet =>
      'Aún no hay almacenes. Añade el primero con el botón +.';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get nameHintSlot => 'Nombre (p. ej. A1)';

  @override
  String get nameHintRack => 'Nombre de la estantería (p. ej. A, ALMACÉN-1)';

  @override
  String get addressOptional => 'Dirección (opcional)';

  @override
  String get decorLabel => 'Decorado';

  @override
  String get lengthMm => 'Largo (mm)';

  @override
  String get widthMm => 'Ancho (mm)';

  @override
  String get thicknessMm => 'Espesor (mm)';

  @override
  String get capacityLabel => 'Capacidad';

  @override
  String get capacityPcsLabel => 'Capacidad (uds.)';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Estantería $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Estanterías — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity uds.';
  }

  @override
  String get statusInStock => 'en stock';

  @override
  String get statusAvailable => 'disponible';

  @override
  String get statusArchived => 'archivado';

  @override
  String get newWarehouseTitle => 'Nuevo almacén';

  @override
  String get noItemsInSlot => 'No hay tableros ni recortes en este hueco.';

  @override
  String get noRacksYet =>
      'No hay estanterías en este almacén.\nAñade la primera para empezar a organizar ubicaciones.';

  @override
  String get noSlotsYet =>
      'No hay huecos en esta estantería.\nAñade el primero para poder asignarle tableros y recortes.';

  @override
  String get boardsSectionLabel => 'TABLEROS';

  @override
  String get offcutsSectionLabel => 'RECORTES';

  @override
  String get qrCodeNotFound => 'Este código no existe o ha sido eliminado.';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteSlotButton => 'Eliminar hueco';

  @override
  String cutFromBoardNote(String decor) {
    return 'Del tablero ($decor) — permanece en el mismo hueco.';
  }

  @override
  String statusLabel(String value) {
    return 'Estado: $value';
  }

  @override
  String get printLabelsForSlot => 'Imprimir etiquetas';

  @override
  String get eventCreated => 'Creado';

  @override
  String get eventMoved => 'Movido';

  @override
  String get eventArchived => 'Archivado';

  @override
  String get eventCut => 'Cortado';

  @override
  String get eventQrRegenerated => 'QR regenerado';

  @override
  String get ownerDashboardTitle => 'Panel del propietario';

  @override
  String get totalBoardsLabel => 'Tableros';

  @override
  String get totalOffcutsLabel => 'Recortes';

  @override
  String get overallFillRateLabel => 'Ocupación';

  @override
  String get totalRacksSlotsLabel => 'Estanterías / Huecos';

  @override
  String get staleItemsSectionTitle => 'Materiales estancados';

  @override
  String get staleItemsSectionSubtitle => 'Sin usar hace más de un año';

  @override
  String get noStaleItems => 'No hay materiales estancados.';

  @override
  String get locationUnknown => 'Ubicación desconocida';

  @override
  String daysAgo(int days) {
    return 'hace $days días';
  }

  @override
  String get exportTitle => 'Exportar';

  @override
  String get exportWarehouseLabel => 'Almacén';

  @override
  String get exportButton => 'Exportar';

  @override
  String get exportEmptyWarehouse =>
      'Este almacén no tiene tableros ni recortes para exportar.';

  @override
  String get exportColumnType => 'Tipo';

  @override
  String get exportColumnQrCode => 'Código QR';

  @override
  String get exportColumnDecorCode => 'Código de decorado';

  @override
  String get exportColumnDecorName => 'Nombre del decorado';

  @override
  String get exportColumnLocation => 'Ubicación';

  @override
  String get exportColumnStatus => 'Estado';

  @override
  String get exportColumnCreatedAt => 'Creado';

  @override
  String exportFailedMessage(String message) {
    return 'Error al exportar: $message';
  }
}
