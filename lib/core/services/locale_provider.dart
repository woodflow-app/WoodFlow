import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's chosen app language. Registered as a
/// ChangeNotifier singleton in get_it — MaterialApp listens via
/// ListenableBuilder, not the `provider` package, same pattern used
/// once before this project's reset (kept identical intentionally,
/// it worked).
class LocaleProvider extends ChangeNotifier {
  static const _prefsKey = 'woodflow_locale';

  /// 21 languages selected by Piotr (7 "strong" tier: en, pl, de,
  /// fr, es, it, ru — high translation confidence; 14 "review" tier
  /// — solid first drafts, recommended for native-speaker review
  /// before shipping. See docs/LANGUAGE_QUALITY.md.
  static const supportedLocales = [
    Locale('pl'), Locale('en'), Locale('de'), Locale('fr'),
    Locale('it'), Locale('es'), Locale('ru'),
    Locale('nl'), Locale('sv'), Locale('da'), Locale('cs'),
    Locale('sk'), Locale('hu'), Locale('hr'), Locale('sl'),
    Locale('lv'), Locale('lt'), Locale('ga'), Locale('no'),
    Locale('cy'), Locale('gd'),
  ];

  Locale _locale = const Locale('pl');
  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && supportedLocales.any((l) => l.languageCode == saved)) {
      _locale = Locale(saved);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }
}
