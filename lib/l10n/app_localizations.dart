import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_cy.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ga.dart';
import 'app_localizations_gd.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_it.dart';
import 'app_localizations_lt.dart';
import 'app_localizations_lv.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_no.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('cy'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ga'),
    Locale('gd'),
    Locale('hr'),
    Locale('hu'),
    Locale('it'),
    Locale('lt'),
    Locale('lv'),
    Locale('nl'),
    Locale('no'),
    Locale('pl'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sv')
  ];

  /// No description provided for @warehousesTitle.
  ///
  /// In pl, this message translates to:
  /// **'Magazyny'**
  String get warehousesTitle;

  /// No description provided for @boardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Płyta'**
  String get boardTitle;

  /// No description provided for @offcutTitle.
  ///
  /// In pl, this message translates to:
  /// **'Ścinek'**
  String get offcutTitle;

  /// No description provided for @historyLabel.
  ///
  /// In pl, this message translates to:
  /// **'Historia'**
  String get historyLabel;

  /// No description provided for @noEntries.
  ///
  /// In pl, this message translates to:
  /// **'Brak wpisów.'**
  String get noEntries;

  /// No description provided for @cancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get save;

  /// No description provided for @archive.
  ///
  /// In pl, this message translates to:
  /// **'Archiwizuj'**
  String get archive;

  /// No description provided for @move.
  ///
  /// In pl, this message translates to:
  /// **'Przenieś'**
  String get move;

  /// No description provided for @moveToLabel.
  ///
  /// In pl, this message translates to:
  /// **'Przenieś do:'**
  String get moveToLabel;

  /// No description provided for @cut.
  ///
  /// In pl, this message translates to:
  /// **'Wytnij'**
  String get cut;

  /// No description provided for @cutOffcut.
  ///
  /// In pl, this message translates to:
  /// **'Wytnij ścinek'**
  String get cutOffcut;

  /// No description provided for @retry.
  ///
  /// In pl, this message translates to:
  /// **'Ponów'**
  String get retry;

  /// No description provided for @searchManually.
  ///
  /// In pl, this message translates to:
  /// **'Wyszukaj ręcznie'**
  String get searchManually;

  /// No description provided for @scanAgain.
  ///
  /// In pl, this message translates to:
  /// **'Skanuj ponownie'**
  String get scanAgain;

  /// No description provided for @scanQrCode.
  ///
  /// In pl, this message translates to:
  /// **'Skanuj kod QR'**
  String get scanQrCode;

  /// No description provided for @viewSourceBoard.
  ///
  /// In pl, this message translates to:
  /// **'Zobacz płytę źródłową'**
  String get viewSourceBoard;

  /// No description provided for @addBoard.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj płytę'**
  String get addBoard;

  /// No description provided for @addRack.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj regał'**
  String get addRack;

  /// No description provided for @addSlot.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj półkę'**
  String get addSlot;

  /// No description provided for @newBoardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowa płyta'**
  String get newBoardTitle;

  /// No description provided for @newRackTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowy regał'**
  String get newRackTitle;

  /// No description provided for @newSlotTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowa półka'**
  String get newSlotTitle;

  /// No description provided for @deleteSlotQuestion.
  ///
  /// In pl, this message translates to:
  /// **'Usunąć półkę?'**
  String get deleteSlotQuestion;

  /// No description provided for @archiveBoardQuestion.
  ///
  /// In pl, this message translates to:
  /// **'Zarchiwizować płytę?'**
  String get archiveBoardQuestion;

  /// No description provided for @archiveOffcutQuestion.
  ///
  /// In pl, this message translates to:
  /// **'Zarchiwizować ścinek?'**
  String get archiveOffcutQuestion;

  /// No description provided for @historyStaysVisible.
  ///
  /// In pl, this message translates to:
  /// **'Historia (Ledger) pozostanie widoczna.'**
  String get historyStaysVisible;

  /// No description provided for @deleteSlotWarning.
  ///
  /// In pl, this message translates to:
  /// **'Ta operacja jest nieodwracalna. Płyty i ścinki w tej półce zostaną zarchiwizowane (nie usunięte) — historia pozostanie widoczna.'**
  String get deleteSlotWarning;

  /// No description provided for @fillDimensionsCorrectly.
  ///
  /// In pl, this message translates to:
  /// **'Uzupełnij wymiary poprawnie.'**
  String get fillDimensionsCorrectly;

  /// No description provided for @noDecorsInCatalog.
  ///
  /// In pl, this message translates to:
  /// **'Brak dekorów w katalogu — dodaj przynajmniej jeden.'**
  String get noDecorsInCatalog;

  /// No description provided for @noOtherSlotInRack.
  ///
  /// In pl, this message translates to:
  /// **'Brak innej półki w tym regale.'**
  String get noOtherSlotInRack;

  /// No description provided for @noWarehousesYet.
  ///
  /// In pl, this message translates to:
  /// **'Brak magazynów. Dodaj pierwszy przyciskiem +.'**
  String get noWarehousesYet;

  /// No description provided for @nameLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa'**
  String get nameLabel;

  /// No description provided for @nameHintSlot.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa (np. A1)'**
  String get nameHintSlot;

  /// No description provided for @nameHintRack.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa regału (np. A, MAGAZYN-1)'**
  String get nameHintRack;

  /// No description provided for @addressOptional.
  ///
  /// In pl, this message translates to:
  /// **'Adres (opcjonalnie)'**
  String get addressOptional;

  /// No description provided for @decorLabel.
  ///
  /// In pl, this message translates to:
  /// **'Dekor'**
  String get decorLabel;

  /// No description provided for @lengthMm.
  ///
  /// In pl, this message translates to:
  /// **'Dł. (mm)'**
  String get lengthMm;

  /// No description provided for @widthMm.
  ///
  /// In pl, this message translates to:
  /// **'Szer. (mm)'**
  String get widthMm;

  /// No description provided for @thicknessMm.
  ///
  /// In pl, this message translates to:
  /// **'Grub. (mm)'**
  String get thicknessMm;

  /// No description provided for @capacityLabel.
  ///
  /// In pl, this message translates to:
  /// **'Pojemność'**
  String get capacityLabel;

  /// No description provided for @capacityPcsLabel.
  ///
  /// In pl, this message translates to:
  /// **'Pojemność (szt.)'**
  String get capacityPcsLabel;

  /// No description provided for @errorPrefix.
  ///
  /// In pl, this message translates to:
  /// **'Błąd: {message}'**
  String errorPrefix(String message);

  /// No description provided for @rackNameTitle.
  ///
  /// In pl, this message translates to:
  /// **'Regał {name}'**
  String rackNameTitle(String name);

  /// No description provided for @racksForWarehouseTitle.
  ///
  /// In pl, this message translates to:
  /// **'Regały — {warehouseName}'**
  String racksForWarehouseTitle(String warehouseName);

  /// No description provided for @slotFillCount.
  ///
  /// In pl, this message translates to:
  /// **'{used} / {capacity} szt.'**
  String slotFillCount(int used, int capacity);

  /// No description provided for @statusInStock.
  ///
  /// In pl, this message translates to:
  /// **'w magazynie'**
  String get statusInStock;

  /// No description provided for @statusAvailable.
  ///
  /// In pl, this message translates to:
  /// **'dostępny'**
  String get statusAvailable;

  /// No description provided for @statusArchived.
  ///
  /// In pl, this message translates to:
  /// **'zarchiwizowany'**
  String get statusArchived;

  /// No description provided for @newWarehouseTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowy magazyn'**
  String get newWarehouseTitle;

  /// No description provided for @noItemsInSlot.
  ///
  /// In pl, this message translates to:
  /// **'Brak płyt ani ścinków w tej półce.'**
  String get noItemsInSlot;

  /// No description provided for @noRacksYet.
  ///
  /// In pl, this message translates to:
  /// **'Brak regałów w tym magazynie.\nDodaj pierwszy, żeby zacząć organizować lokalizacje.'**
  String get noRacksYet;

  /// No description provided for @noSlotsYet.
  ///
  /// In pl, this message translates to:
  /// **'Brak półek w tym regale.\nDodaj pierwszą, żeby móc przypisywać do niej płyty i ścinki.'**
  String get noSlotsYet;

  /// No description provided for @boardsSectionLabel.
  ///
  /// In pl, this message translates to:
  /// **'PŁYTY'**
  String get boardsSectionLabel;

  /// No description provided for @offcutsSectionLabel.
  ///
  /// In pl, this message translates to:
  /// **'ŚCINKI'**
  String get offcutsSectionLabel;

  /// No description provided for @qrCodeNotFound.
  ///
  /// In pl, this message translates to:
  /// **'Ten kod nie istnieje lub został usunięty.'**
  String get qrCodeNotFound;

  /// No description provided for @delete.
  ///
  /// In pl, this message translates to:
  /// **'Usuń'**
  String get delete;

  /// No description provided for @deleteSlotButton.
  ///
  /// In pl, this message translates to:
  /// **'Usuń półkę'**
  String get deleteSlotButton;

  /// No description provided for @cutFromBoardNote.
  ///
  /// In pl, this message translates to:
  /// **'Ze płyty ({decor}) — zostaje w tej samej półce.'**
  String cutFromBoardNote(String decor);

  /// No description provided for @statusLabel.
  ///
  /// In pl, this message translates to:
  /// **'Status: {value}'**
  String statusLabel(String value);

  /// No description provided for @printLabelsForSlot.
  ///
  /// In pl, this message translates to:
  /// **'Drukuj etykiety'**
  String get printLabelsForSlot;

  /// No description provided for @eventCreated.
  ///
  /// In pl, this message translates to:
  /// **'Utworzono'**
  String get eventCreated;

  /// No description provided for @eventMoved.
  ///
  /// In pl, this message translates to:
  /// **'Przeniesiono'**
  String get eventMoved;

  /// No description provided for @eventArchived.
  ///
  /// In pl, this message translates to:
  /// **'Zarchiwizowano'**
  String get eventArchived;

  /// No description provided for @eventCut.
  ///
  /// In pl, this message translates to:
  /// **'Wycięto'**
  String get eventCut;

  /// No description provided for @eventQrRegenerated.
  ///
  /// In pl, this message translates to:
  /// **'Zregenerowano QR'**
  String get eventQrRegenerated;

  /// No description provided for @ownerDashboardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Panel właściciela'**
  String get ownerDashboardTitle;

  /// No description provided for @totalBoardsLabel.
  ///
  /// In pl, this message translates to:
  /// **'Płyty'**
  String get totalBoardsLabel;

  /// No description provided for @totalOffcutsLabel.
  ///
  /// In pl, this message translates to:
  /// **'Ścinki'**
  String get totalOffcutsLabel;

  /// No description provided for @overallFillRateLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zapełnienie'**
  String get overallFillRateLabel;

  /// No description provided for @totalRacksSlotsLabel.
  ///
  /// In pl, this message translates to:
  /// **'Regały / Sloty'**
  String get totalRacksSlotsLabel;

  /// No description provided for @staleItemsSectionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Materiały zalegające'**
  String get staleItemsSectionTitle;

  /// No description provided for @staleItemsSectionSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Nieużywane dłużej niż rok'**
  String get staleItemsSectionSubtitle;

  /// No description provided for @noStaleItems.
  ///
  /// In pl, this message translates to:
  /// **'Brak materiałów zalegających.'**
  String get noStaleItems;

  /// No description provided for @locationUnknown.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja nieznana'**
  String get locationUnknown;

  /// No description provided for @daysAgo.
  ///
  /// In pl, this message translates to:
  /// **'{days} dni temu'**
  String daysAgo(int days);

  /// No description provided for @exportTitle.
  ///
  /// In pl, this message translates to:
  /// **'Eksport'**
  String get exportTitle;

  /// No description provided for @exportWarehouseLabel.
  ///
  /// In pl, this message translates to:
  /// **'Magazyn'**
  String get exportWarehouseLabel;

  /// No description provided for @exportButton.
  ///
  /// In pl, this message translates to:
  /// **'Eksportuj'**
  String get exportButton;

  /// No description provided for @exportEmptyWarehouse.
  ///
  /// In pl, this message translates to:
  /// **'Ten magazyn nie ma płyt ani ścinków do eksportu.'**
  String get exportEmptyWarehouse;

  /// No description provided for @exportColumnType.
  ///
  /// In pl, this message translates to:
  /// **'Typ'**
  String get exportColumnType;

  /// No description provided for @exportColumnQrCode.
  ///
  /// In pl, this message translates to:
  /// **'Kod QR'**
  String get exportColumnQrCode;

  /// No description provided for @exportColumnDecorCode.
  ///
  /// In pl, this message translates to:
  /// **'Kod dekoru'**
  String get exportColumnDecorCode;

  /// No description provided for @exportColumnDecorName.
  ///
  /// In pl, this message translates to:
  /// **'Nazwa dekoru'**
  String get exportColumnDecorName;

  /// No description provided for @exportColumnLocation.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacja'**
  String get exportColumnLocation;

  /// No description provided for @exportColumnStatus.
  ///
  /// In pl, this message translates to:
  /// **'Status'**
  String get exportColumnStatus;

  /// No description provided for @exportColumnCreatedAt.
  ///
  /// In pl, this message translates to:
  /// **'Utworzono'**
  String get exportColumnCreatedAt;

  /// No description provided for @exportFailedMessage.
  ///
  /// In pl, this message translates to:
  /// **'Eksport nie powiódł się: {message}'**
  String exportFailedMessage(String message);

  /// No description provided for @calculatorsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Kalkulatory'**
  String get calculatorsTitle;

  /// No description provided for @calculatorAreaVolumeTab.
  ///
  /// In pl, this message translates to:
  /// **'Powierzchnia / objętość'**
  String get calculatorAreaVolumeTab;

  /// No description provided for @calculatorEdgeBandingTab.
  ///
  /// In pl, this message translates to:
  /// **'Okleina'**
  String get calculatorEdgeBandingTab;

  /// No description provided for @areaM2Label.
  ///
  /// In pl, this message translates to:
  /// **'Powierzchnia (m²)'**
  String get areaM2Label;

  /// No description provided for @volumeM3Label.
  ///
  /// In pl, this message translates to:
  /// **'Objętość (m³)'**
  String get volumeM3Label;

  /// No description provided for @outerDiameterMmLabel.
  ///
  /// In pl, this message translates to:
  /// **'Średnica zewnętrzna (mm)'**
  String get outerDiameterMmLabel;

  /// No description provided for @coreDiameterMmLabel.
  ///
  /// In pl, this message translates to:
  /// **'Średnica rdzenia (mm)'**
  String get coreDiameterMmLabel;

  /// No description provided for @tapeThicknessMmLabel.
  ///
  /// In pl, this message translates to:
  /// **'Grubość tasiemki (mm)'**
  String get tapeThicknessMmLabel;

  /// No description provided for @edgeBandingLengthResultLabel.
  ///
  /// In pl, this message translates to:
  /// **'Długość okleiny (m)'**
  String get edgeBandingLengthResultLabel;

  /// No description provided for @calculateButton.
  ///
  /// In pl, this message translates to:
  /// **'Przelicz'**
  String get calculateButton;

  /// No description provided for @shoppingListTitle.
  ///
  /// In pl, this message translates to:
  /// **'Lista zakupów'**
  String get shoppingListTitle;

  /// No description provided for @shoppingListNoThresholds.
  ///
  /// In pl, this message translates to:
  /// **'Nie ustawiono jeszcze żadnych progów minimalnego stanu. Dotknij +, aby ustawić pierwszy.'**
  String get shoppingListNoThresholds;

  /// No description provided for @shoppingListAllSufficient.
  ///
  /// In pl, this message translates to:
  /// **'Wszystkie ustawione progi są zachowane — brak niskich stanów.'**
  String get shoppingListAllSufficient;

  /// No description provided for @currentStockLabel.
  ///
  /// In pl, this message translates to:
  /// **'W magazynie'**
  String get currentStockLabel;

  /// No description provided for @minimumStockLabel.
  ///
  /// In pl, this message translates to:
  /// **'Próg minimalny'**
  String get minimumStockLabel;

  /// No description provided for @setThresholdTitle.
  ///
  /// In pl, this message translates to:
  /// **'Ustaw próg minimalnego stanu'**
  String get setThresholdTitle;

  /// No description provided for @searchDecorHint.
  ///
  /// In pl, this message translates to:
  /// **'Szukaj dekoru (kod lub nazwa)'**
  String get searchDecorHint;

  /// No description provided for @minimumStockQuantityLabel.
  ///
  /// In pl, this message translates to:
  /// **'Minimalny stan (szt.)'**
  String get minimumStockQuantityLabel;

  /// No description provided for @clearThresholdButton.
  ///
  /// In pl, this message translates to:
  /// **'Usuń próg'**
  String get clearThresholdButton;

  /// No description provided for @invalidQuantityMessage.
  ///
  /// In pl, this message translates to:
  /// **'Podaj liczbę całkowitą, 0 lub więcej.'**
  String get invalidQuantityMessage;

  /// No description provided for @aiQueryTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zapytaj AI'**
  String get aiQueryTitle;

  /// No description provided for @aiQueryInputHint.
  ///
  /// In pl, this message translates to:
  /// **'Zapytaj o magazyn, np. \"Ile mam H3303?\"'**
  String get aiQueryInputHint;

  /// No description provided for @aiQuerySendTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Wyślij'**
  String get aiQuerySendTooltip;

  /// No description provided for @aiQueryUnrecognized.
  ///
  /// In pl, this message translates to:
  /// **'Nie rozumiem pytania: „{query}”. Spróbuj np. „Ile mam H3303?”'**
  String aiQueryUnrecognized(String query);

  /// No description provided for @aiQueryStockAnswer.
  ///
  /// In pl, this message translates to:
  /// **'{code} — {name}: {quantity} szt. w magazynie'**
  String aiQueryStockAnswer(String code, String name, int quantity);

  /// No description provided for @aiQueryLocationHeader.
  ///
  /// In pl, this message translates to:
  /// **'Lokalizacje — {code} — {name}'**
  String aiQueryLocationHeader(String code, String name);

  /// No description provided for @aiQueryLocationEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak płyt tego dekoru obecnie w magazynie.'**
  String get aiQueryLocationEmpty;

  /// No description provided for @aiQueryDimensionsHeader.
  ///
  /// In pl, this message translates to:
  /// **'Wymiary — {code} — {name}'**
  String aiQueryDimensionsHeader(String code, String name);

  /// No description provided for @aiQueryDimensionsEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak materiału tego dekoru obecnie w magazynie.'**
  String get aiQueryDimensionsEmpty;

  /// No description provided for @aiQueryStaleHeader.
  ///
  /// In pl, this message translates to:
  /// **'Materiały zalegające'**
  String get aiQueryStaleHeader;

  /// No description provided for @aiQueryStaleEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak zalegających materiałów.'**
  String get aiQueryStaleEmpty;

  /// No description provided for @aiQueryOffcutMatchHeader.
  ///
  /// In pl, this message translates to:
  /// **'Pasujące ścinki — {code} — {name}'**
  String aiQueryOffcutMatchHeader(String code, String name);

  /// No description provided for @aiQueryOffcutMatchEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak pasującego ścinka tego dekoru.'**
  String get aiQueryOffcutMatchEmpty;

  /// No description provided for @aiQueryBoardTypeLabel.
  ///
  /// In pl, this message translates to:
  /// **'Płyta'**
  String get aiQueryBoardTypeLabel;

  /// No description provided for @aiQueryOffcutTypeLabel.
  ///
  /// In pl, this message translates to:
  /// **'Ścinek'**
  String get aiQueryOffcutTypeLabel;

  /// No description provided for @aiQueryWasteAreaLabel.
  ///
  /// In pl, this message translates to:
  /// **'Nadmiar: {value} mm²'**
  String aiQueryWasteAreaLabel(String value);

  /// No description provided for @deleteWarehouseQuestion.
  ///
  /// In pl, this message translates to:
  /// **'Usunąć magazyn „{name}”?'**
  String deleteWarehouseQuestion(String name);

  /// No description provided for @deleteWarehouseWarning.
  ///
  /// In pl, this message translates to:
  /// **'Ta operacja jest nieodwracalna. Wszystkie regały i półki w tym magazynie zostaną usunięte. Płyty i ścinki w nich zostaną zarchiwizowane (nie usunięte) — historia pozostanie widoczna.'**
  String get deleteWarehouseWarning;

  /// No description provided for @deleteRackQuestion.
  ///
  /// In pl, this message translates to:
  /// **'Usunąć regał „{name}”?'**
  String deleteRackQuestion(String name);

  /// No description provided for @deleteRackWarning.
  ///
  /// In pl, this message translates to:
  /// **'Ta operacja jest nieodwracalna. Wszystkie półki w tym regale zostaną usunięte. Płyty i ścinki w nich zostaną zarchiwizowane (nie usunięte) — historia pozostanie widoczna.'**
  String get deleteRackWarning;

  /// No description provided for @decorCatalogBreadcrumb.
  ///
  /// In pl, this message translates to:
  /// **'Magazyn'**
  String get decorCatalogBreadcrumb;

  /// No description provided for @decorCatalogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Katalog dekorów'**
  String get decorCatalogTitle;

  /// No description provided for @decorCatalogSearchHint.
  ///
  /// In pl, this message translates to:
  /// **'Szukaj kodu lub nazwy…'**
  String get decorCatalogSearchHint;

  /// No description provided for @decorFilterAll.
  ///
  /// In pl, this message translates to:
  /// **'Wszystkie'**
  String get decorFilterAll;

  /// No description provided for @decorFilterBoard.
  ///
  /// In pl, this message translates to:
  /// **'Płyty'**
  String get decorFilterBoard;

  /// No description provided for @decorFilterWorktop.
  ///
  /// In pl, this message translates to:
  /// **'Blaty'**
  String get decorFilterWorktop;

  /// No description provided for @decorFilterEdging.
  ///
  /// In pl, this message translates to:
  /// **'Obrzeża'**
  String get decorFilterEdging;

  /// No description provided for @decorTypeBoard.
  ///
  /// In pl, this message translates to:
  /// **'Płyta'**
  String get decorTypeBoard;

  /// No description provided for @decorTypeWorktop.
  ///
  /// In pl, this message translates to:
  /// **'Blat'**
  String get decorTypeWorktop;

  /// No description provided for @decorTypeEdging.
  ///
  /// In pl, this message translates to:
  /// **'Obrzeże'**
  String get decorTypeEdging;

  /// No description provided for @decorEmptyNoData.
  ///
  /// In pl, this message translates to:
  /// **'Brak dekorów w bazie danych'**
  String get decorEmptyNoData;

  /// No description provided for @decorEmptyNoResults.
  ///
  /// In pl, this message translates to:
  /// **'Brak dekorów pasujących do „{query}”'**
  String decorEmptyNoResults(String query);

  /// No description provided for @decorRetry.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj ponownie'**
  String get decorRetry;

  /// No description provided for @decorApproxColorLabel.
  ///
  /// In pl, this message translates to:
  /// **'kolor przybliżony'**
  String get decorApproxColorLabel;

  /// No description provided for @decorSeeRealPhoto.
  ///
  /// In pl, this message translates to:
  /// **'Zobacz zdjęcie dekoru'**
  String get decorSeeRealPhoto;

  /// No description provided for @decorImageSourceNote.
  ///
  /// In pl, this message translates to:
  /// **'otwiera oficjalną stronę {domain}'**
  String decorImageSourceNote(String domain);

  /// No description provided for @decorNoImageLinkSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Brak linku do zdjęcia tego dekoru'**
  String get decorNoImageLinkSnackbar;

  /// No description provided for @decorFailedToOpenLinkSnackbar.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się otworzyć linku'**
  String get decorFailedToOpenLinkSnackbar;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'cs',
        'cy',
        'da',
        'de',
        'en',
        'es',
        'fr',
        'ga',
        'gd',
        'hr',
        'hu',
        'it',
        'lt',
        'lv',
        'nl',
        'no',
        'pl',
        'ru',
        'sk',
        'sl',
        'sv'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'cy':
      return AppLocalizationsCy();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ga':
      return AppLocalizationsGa();
    case 'gd':
      return AppLocalizationsGd();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'it':
      return AppLocalizationsIt();
    case 'lt':
      return AppLocalizationsLt();
    case 'lv':
      return AppLocalizationsLv();
    case 'nl':
      return AppLocalizationsNl();
    case 'no':
      return AppLocalizationsNo();
    case 'pl':
      return AppLocalizationsPl();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
