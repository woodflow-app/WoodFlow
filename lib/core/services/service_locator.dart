import 'package:get_it/get_it.dart';

import '../logging/app_logger.dart';
import '../events/event_publisher.dart';
import '../../data/database/database_service.dart';
import '../../data/repositories/warehouse_repository_impl.dart';
import '../../data/repositories/rack_repository_impl.dart';
import '../../data/repositories/slot_repository_impl.dart';
import '../../data/repositories/board_repository_impl.dart';
import '../../data/repositories/decor_repository_impl.dart';
import '../../data/repositories/offcut_repository_impl.dart';
import '../../domain/repositories/warehouse_repository.dart';
import '../../domain/repositories/rack_repository.dart';
import '../../domain/repositories/slot_repository.dart';
import '../../domain/repositories/board_repository.dart';
import '../../domain/repositories/decor_repository.dart';
import '../../domain/repositories/offcut_repository.dart';
import '../../domain/services/qr_resolver.dart';
import '../../domain/services/label_generator.dart';
import '../../domain/services/dashboard_service.dart';
import '../../domain/services/export_generator.dart';
import '../../data/labels/pdf_label_generator.dart';
import '../../data/export/pdf_export_generator.dart';
import '../../data/export/csv_export_generator.dart';
import '../../data/export/rtf_export_generator.dart';
import 'locale_provider.dart';

/// Global service locator. Deliberately NOT a custom-built container —
/// get_it is a single, well-tested dependency doing exactly one job.
///
/// DI is the ONLY mechanism managing instance lifecycles in this app.
/// Nothing has its own internal `.instance` singleton — that was the
/// mistake in the first draft (DatabaseService had one AND get_it had
/// one, two systems solving the same problem). Every class below just
/// takes a plain constructor; get_it decides how many of them exist.
final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // --- Core (singletons, no dependencies) ---
  sl.registerLazySingleton<AppLogger>(() => const AppLogger());
  sl.registerLazySingleton<DatabaseService>(
    () => DatabaseService(sl<AppLogger>()),
  );

  // Extension point for future domain events — not consumed by any
  // repository yet. See core/events/domain_event.dart.
  sl.registerLazySingleton<EventPublisher>(() => InMemoryEventPublisher());

  // Eagerly open the DB connection once at startup rather than lazily
  // on first query, so migration errors surface immediately at boot.
  await sl<DatabaseService>().open();

  // --- Repositories ---
  // Each new module adds exactly one line here once its datasource
  // and repository implementation exist.
  //
  // Build order: Warehouse → Rack → Slot → Board → Offcut.
  sl.registerLazySingleton<WarehouseRepository>(
    () => WarehouseRepositoryImpl(sl<DatabaseService>(), sl<AppLogger>()),
  );
  sl.registerLazySingleton<RackRepository>(
    () => RackRepositoryImpl(sl<DatabaseService>(), sl<AppLogger>()),
  );
  sl.registerLazySingleton<SlotRepository>(
    () => SlotRepositoryImpl(sl<DatabaseService>(), sl<AppLogger>()),
  );
  sl.registerLazySingleton<DecorRepository>(
    () => DecorRepositoryImpl(sl<DatabaseService>(), sl<AppLogger>()),
  );
  sl.registerLazySingleton<BoardRepository>(
    () => BoardRepositoryImpl(
      sl<DatabaseService>(),
      sl<AppLogger>(),
      sl<EventPublisher>(),
      sl<SlotRepository>(),
      sl<DecorRepository>(),
    ),
  );
  sl.registerLazySingleton<OffcutRepository>(
    () => OffcutRepositoryImpl(
      sl<DatabaseService>(),
      sl<AppLogger>(),
      sl<EventPublisher>(),
      sl<BoardRepository>(),
      sl<SlotRepository>(),
    ),
  );

  // Anything after Offcut registers here next, in that order.

  // --- Services (Krok 7.2) ---
  sl.registerLazySingleton<QrResolver>(
    () => QrResolver(
      sl<WarehouseRepository>(),
      sl<RackRepository>(),
      sl<SlotRepository>(),
      sl<BoardRepository>(),
      sl<OffcutRepository>(),
    ),
  );

  // --- Services (Krok 7.3) ---
  // Bound to the interface, not the concrete class — swapping in a
  // ZebraLabelGenerator later is a one-line change here, nothing
  // else in the app references PdfLabelGenerator by name.
  sl.registerLazySingleton<LabelGenerator>(() => PdfLabelGenerator());

  // --- Services (Krok 9) ---
  sl.registerLazySingleton<DashboardService>(
    () => DashboardService(
      sl<WarehouseRepository>(),
      sl<RackRepository>(),
      sl<SlotRepository>(),
      sl<BoardRepository>(),
      sl<OffcutRepository>(),
      sl<DecorRepository>(),
    ),
  );

  // --- Services (Krok 10) ---
  // Unlike LabelGenerator (one interface, one implementation), all
  // three ExportGenerator formats have to be resolvable at once — the
  // user picks PDF/CSV/RTF at runtime in ExportScreen. get_it's named
  // instances give ExportScreen a way to ask for "the generator for
  // this format" without ever importing a concrete data/export/ class
  // itself — instanceName matches ExportFormat.name exactly ('pdf'/
  // 'csv'/'rtf'), so resolving is `sl<ExportGenerator>(instanceName:
  // 'export_${format.name}')`, never a switch statement duplicated
  // between here and the screen.
  sl.registerLazySingleton<ExportGenerator>(
    () => PdfExportGenerator(),
    instanceName: 'export_pdf',
  );
  sl.registerLazySingleton<ExportGenerator>(
    () => CsvExportGenerator(),
    instanceName: 'export_csv',
  );
  sl.registerLazySingleton<ExportGenerator>(
    () => RtfExportGenerator(),
    instanceName: 'export_rtf',
  );

  // --- App-wide reactive state (ChangeNotifier, listened to via
  // ListenableBuilder in main.dart — not the `provider` package, to
  // avoid mixing two DI/state mechanisms alongside get_it) ---
  sl.registerLazySingleton<LocaleProvider>(() => LocaleProvider());
  await sl<LocaleProvider>().load();

  // --- ViewModels / Providers ---
  // Registered as factories so each screen gets a fresh instance:
  //
  // sl.registerFactory<WarehouseViewModel>(
  //   () => WarehouseViewModel(sl<WarehouseRepository>()),
  // );
}
