import 'package:flutter/material.dart';

import '../../core/services/locale_provider.dart';
import '../../core/services/service_locator.dart';

/// ============================================================
/// QA-ONLY TOOL — NOT A PRODUCT FEATURE.
///
/// Added to make manual verification of Krok 14 (AI v1) across all
/// 21 app languages practical — the app has no real in-app language
/// switcher yet (`LocaleProvider.setLocale()` exists but nothing in
/// `presentation/` calls it outside this file). This is a stopgap for
/// that gap, not a preview of a future settings screen.
///
/// - Gated to debug builds only by its ONE call site in
///   `WarehouseListScreen` (`if (kDebugMode) ...`) — never appears in
///   a release/profile build, so it ships nowhere real.
/// - Deliberately NOT part of `docs/BACKLOG.md` or any roadmap step —
///   a real language switcher is a separate future product decision,
///   not this.
/// - MUST BE DELETED before the v1.0 release: this file, plus its one
///   `if (kDebugMode)` call site in `warehouse_list_screen.dart`.
///   Nothing else in the codebase references this file.
/// ============================================================
class QaLanguageSwitcherButton extends StatelessWidget {
  const QaLanguageSwitcherButton({super.key});

  static const _languageNames = {
    'pl': 'Polski',
    'en': 'English',
    'de': 'Deutsch',
    'fr': 'Français',
    'it': 'Italiano',
    'es': 'Español',
    'ru': 'Русский',
    'nl': 'Nederlands',
    'sv': 'Svenska',
    'da': 'Dansk',
    'cs': 'Čeština',
    'sk': 'Slovenčina',
    'hu': 'Magyar',
    'hr': 'Hrvatski',
    'sl': 'Slovenščina',
    'lv': 'Latviešu',
    'lt': 'Lietuvių',
    'ga': 'Gaeilge',
    'no': 'Norsk',
    'cy': 'Cymraeg',
    'gd': 'Gàidhlig',
  };

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.bug_report_outlined, color: Colors.orange),
      tooltip: 'QA ONLY: switch language (debug builds only)',
      onPressed: () => _openPicker(context),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final localeProvider = sl<LocaleProvider>();

    final selected = await showModalBottomSheet<Locale>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'QA ONLY — language switcher (debug builds only, removed before v1.0)',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final locale in LocaleProvider.supportedLocales)
                    ListTile(
                      title: Text(_languageNames[locale.languageCode] ?? locale.languageCode),
                      trailing: locale == localeProvider.locale ? const Icon(Icons.check) : null,
                      onTap: () => Navigator.of(context).pop(locale),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      await localeProvider.setLocale(selected);
    }
  }
}
