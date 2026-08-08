import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/services/service_locator.dart';
import 'core/services/locale_provider.dart';
import 'l10n/app_localizations.dart';
import 'presentation/warehouse/warehouse_list_screen.dart';

/// Entry point. Rebuilt after the reset to the frozen roadmap.
///
/// i18n added on top afterwards (21 languages, Piotr's selection —
/// see docs/LANGUAGE_QUALITY.md) — this touches ONLY the
/// presentation layer's localizationsDelegates/supportedLocales
/// wiring here; zero changes to domain/data layers.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const WoodFlowApp());
}

class WoodFlowApp extends StatelessWidget {
  const WoodFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = sl<LocaleProvider>();

    // ListenableBuilder, not the `provider` package — get_it already
    // owns instance lifecycle (see service_locator.dart doc comment);
    // adding a second state-management mechanism alongside it would
    // solve the same problem twice.
    return ListenableBuilder(
      listenable: localeProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'WoodFlow',
          debugShowCheckedModeBanner: false,
          locale: localeProvider.locale,
          supportedLocales: LocaleProvider.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xFF1F4D3D), // Forest Green
          ),
          home: const WarehouseListScreen(),
        );
      },
    );
  }
}
