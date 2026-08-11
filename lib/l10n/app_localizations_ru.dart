// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get warehousesTitle => 'Склады';

  @override
  String get boardTitle => 'Плита';

  @override
  String get offcutTitle => 'Обрезок';

  @override
  String get historyLabel => 'История';

  @override
  String get noEntries => 'Нет записей.';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get archive => 'Архивировать';

  @override
  String get move => 'Переместить';

  @override
  String get moveToLabel => 'Переместить в:';

  @override
  String get cut => 'Отрезать';

  @override
  String get cutOffcut => 'Отрезать обрезок';

  @override
  String get retry => 'Повторить';

  @override
  String get searchManually => 'Искать вручную';

  @override
  String get scanAgain => 'Сканировать снова';

  @override
  String get scanQrCode => 'Сканировать QR-код';

  @override
  String get viewSourceBoard => 'Посмотреть исходную плиту';

  @override
  String get addBoard => 'Добавить плиту';

  @override
  String get addRack => 'Добавить стеллаж';

  @override
  String get addSlot => 'Добавить ячейку';

  @override
  String get newBoardTitle => 'Новая плита';

  @override
  String get newRackTitle => 'Новый стеллаж';

  @override
  String get newSlotTitle => 'Новая ячейка';

  @override
  String get deleteSlotQuestion => 'Удалить эту ячейку?';

  @override
  String get archiveBoardQuestion => 'Архивировать эту плиту?';

  @override
  String get archiveOffcutQuestion => 'Архивировать этот обрезок?';

  @override
  String get historyStaysVisible => 'История (Ledger) останется видимой.';

  @override
  String get deleteSlotWarning =>
      'Это действие необратимо. Плиты и обрезки в этой ячейке будут заархивированы (не удалены) — их история останется видимой.';

  @override
  String get fillDimensionsCorrectly => 'Заполните размеры правильно.';

  @override
  String get noDecorsInCatalog =>
      'В каталоге нет декоров — добавьте хотя бы один.';

  @override
  String get noOtherSlotInRack => 'В этом стеллаже нет другой ячейки.';

  @override
  String get noWarehousesYet => 'Складов пока нет. Добавьте первый кнопкой +.';

  @override
  String get nameLabel => 'Название';

  @override
  String get nameHintSlot => 'Название (напр. A1)';

  @override
  String get nameHintRack => 'Название стеллажа (напр. A, СКЛАД-1)';

  @override
  String get addressOptional => 'Адрес (необязательно)';

  @override
  String get decorLabel => 'Декор';

  @override
  String get lengthMm => 'Длина (мм)';

  @override
  String get widthMm => 'Ширина (мм)';

  @override
  String get thicknessMm => 'Толщина (мм)';

  @override
  String get capacityLabel => 'Вместимость';

  @override
  String get capacityPcsLabel => 'Вместимость (шт.)';

  @override
  String errorPrefix(String message) {
    return 'Ошибка: $message';
  }

  @override
  String rackNameTitle(String name) {
    return 'Стеллаж $name';
  }

  @override
  String racksForWarehouseTitle(String warehouseName) {
    return 'Стеллажи — $warehouseName';
  }

  @override
  String slotFillCount(int used, int capacity) {
    return '$used / $capacity шт.';
  }

  @override
  String get statusInStock => 'на складе';

  @override
  String get statusAvailable => 'доступен';

  @override
  String get statusArchived => 'архивирован';

  @override
  String get newWarehouseTitle => 'Новый склад';

  @override
  String get noItemsInSlot => 'В этой ячейке нет плит или обрезков.';

  @override
  String get noRacksYet =>
      'В этом складе нет стеллажей.\nДобавьте первый, чтобы начать организацию мест хранения.';

  @override
  String get noSlotsYet =>
      'В этом стеллаже нет ячеек.\nДобавьте первую, чтобы можно было привязывать плиты и обрезки.';

  @override
  String get boardsSectionLabel => 'ПЛИТЫ';

  @override
  String get offcutsSectionLabel => 'ОБРЕЗКИ';

  @override
  String get qrCodeNotFound => 'Этот код не существует или был удалён.';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteSlotButton => 'Удалить ячейку';

  @override
  String cutFromBoardNote(String decor) {
    return 'Из плиты ($decor) — остаётся в той же ячейке.';
  }

  @override
  String statusLabel(String value) {
    return 'Статус: $value';
  }

  @override
  String get printLabelsForSlot => 'Печать этикеток';

  @override
  String get eventCreated => 'Создано';

  @override
  String get eventMoved => 'Перемещено';

  @override
  String get eventArchived => 'Архивировано';

  @override
  String get eventCut => 'Отрезано';

  @override
  String get eventQrRegenerated => 'QR перегенерирован';

  @override
  String get ownerDashboardTitle => 'Панель владельца';

  @override
  String get totalBoardsLabel => 'Плиты';

  @override
  String get totalOffcutsLabel => 'Обрезки';

  @override
  String get overallFillRateLabel => 'Заполненность';

  @override
  String get totalRacksSlotsLabel => 'Стеллажи / Ячейки';

  @override
  String get staleItemsSectionTitle => 'Залежавшиеся материалы';

  @override
  String get staleItemsSectionSubtitle => 'Не используются более года';

  @override
  String get noStaleItems => 'Нет залежавшихся материалов.';

  @override
  String get locationUnknown => 'Местоположение неизвестно';

  @override
  String daysAgo(int days) {
    return '$days дн. назад';
  }

  @override
  String get exportTitle => 'Экспорт';

  @override
  String get exportWarehouseLabel => 'Склад';

  @override
  String get exportButton => 'Экспортировать';

  @override
  String get exportEmptyWarehouse =>
      'В этом складе нет плит или обрезков для экспорта.';

  @override
  String get exportColumnType => 'Тип';

  @override
  String get exportColumnQrCode => 'QR-код';

  @override
  String get exportColumnDecorCode => 'Код декора';

  @override
  String get exportColumnDecorName => 'Название декора';

  @override
  String get exportColumnLocation => 'Местоположение';

  @override
  String get exportColumnStatus => 'Статус';

  @override
  String get exportColumnCreatedAt => 'Создано';

  @override
  String exportFailedMessage(String message) {
    return 'Ошибка экспорта: $message';
  }

  @override
  String get calculatorsTitle => 'Калькуляторы';

  @override
  String get calculatorAreaVolumeTab => 'Площадь / объём';

  @override
  String get calculatorEdgeBandingTab => 'Кромка';

  @override
  String get areaM2Label => 'Площадь (м²)';

  @override
  String get volumeM3Label => 'Объём (м³)';

  @override
  String get outerDiameterMmLabel => 'Внешний диаметр (мм)';

  @override
  String get coreDiameterMmLabel => 'Диаметр втулки (мм)';

  @override
  String get tapeThicknessMmLabel => 'Толщина кромки (мм)';

  @override
  String get edgeBandingLengthResultLabel => 'Длина кромки (м)';

  @override
  String get calculateButton => 'Рассчитать';

  @override
  String get shoppingListTitle => 'Список покупок';

  @override
  String get shoppingListNoThresholds =>
      'Пороги минимального запаса ещё не заданы. Нажмите +, чтобы задать первый.';

  @override
  String get shoppingListAllSufficient =>
      'Все заданные пороги соблюдены — низких запасов нет.';

  @override
  String get currentStockLabel => 'На складе';

  @override
  String get minimumStockLabel => 'Минимальный порог';

  @override
  String get setThresholdTitle => 'Задать порог минимального запаса';

  @override
  String get searchDecorHint => 'Поиск декора (код или название)';

  @override
  String get minimumStockQuantityLabel => 'Минимальный запас (шт.)';

  @override
  String get clearThresholdButton => 'Удалить порог';

  @override
  String get invalidQuantityMessage => 'Введите целое число, 0 или больше.';

  @override
  String get aiQueryTitle => 'Спросить ИИ';

  @override
  String get aiQueryInputHint =>
      'Задайте вопрос о складе, напр. «Сколько у меня H3303?»';

  @override
  String get aiQuerySendTooltip => 'Отправить';

  @override
  String aiQueryUnrecognized(String query) {
    return 'Не понимаю вопрос: «$query». Попробуйте, например, «Сколько у меня H3303?»';
  }

  @override
  String aiQueryStockAnswer(String code, String name, int quantity) {
    return '$code — $name: $quantity шт. на складе';
  }

  @override
  String aiQueryLocationHeader(String code, String name) {
    return 'Расположение — $code — $name';
  }

  @override
  String get aiQueryLocationEmpty => 'Плит этого декора сейчас нет на складе.';

  @override
  String aiQueryDimensionsHeader(String code, String name) {
    return 'Размеры — $code — $name';
  }

  @override
  String get aiQueryDimensionsEmpty =>
      'Материала этого декора сейчас нет на складе.';

  @override
  String get aiQueryStaleHeader => 'Залежавшиеся материалы';

  @override
  String get aiQueryStaleEmpty => 'Нет залежавшихся материалов.';

  @override
  String aiQueryOffcutMatchHeader(String code, String name) {
    return 'Подходящие обрезки — $code — $name';
  }

  @override
  String get aiQueryOffcutMatchEmpty => 'Нет подходящих обрезков этого декора.';

  @override
  String get aiQueryBoardTypeLabel => 'Плита';

  @override
  String get aiQueryOffcutTypeLabel => 'Обрезок';

  @override
  String aiQueryWasteAreaLabel(String value) {
    return 'Излишек: $value мм²';
  }

  @override
  String deleteWarehouseQuestion(String name) {
    return 'Удалить склад «$name»?';
  }

  @override
  String get deleteWarehouseWarning =>
      'Это действие необратимо. Все стеллажи и полки этого склада будут удалены. Плиты и обрезки на них будут заархивированы (не удалены) — их история останется видимой.';

  @override
  String deleteRackQuestion(String name) {
    return 'Удалить стеллаж «$name»?';
  }

  @override
  String get deleteRackWarning =>
      'Это действие необратимо. Все ячейки этого стеллажа будут удалены. Плиты и обрезки на них будут заархивированы (не удалены) — их история останется видимой.';
}
