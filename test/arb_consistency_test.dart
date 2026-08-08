import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards against exactly the failure mode Piotr flagged: at ~60
/// keys today it's easy to eyeball consistency across 21 files: at
/// 300-500 keys it won't be. This runs on every `flutter test`, so a
/// missing key/placeholder is caught at commit time, not discovered
/// later when a screen silently shows blank text in one language.
///
/// `app_pl.arb` is the template (per l10n.yaml) — every other file
/// is checked against it, not against each other pairwise.
void main() {
  final l10nDir = Directory('lib/l10n');
  final templateFile = File('${l10nDir.path}/app_pl.arb');

  late Map<String, dynamic> template;
  late Map<String, String> templateKeys; // key -> value (for reference only)
  late Map<String, Map<String, dynamic>> templatePlaceholders; // @key -> placeholders

  setUpAll(() {
    template = json.decode(templateFile.readAsStringSync()) as Map<String, dynamic>;
    templateKeys = {
      for (final entry in template.entries)
        if (!entry.key.startsWith('@') && entry.key != '@@locale')
          entry.key: entry.value as String,
    };
    templatePlaceholders = {
      for (final entry in template.entries)
        if (entry.key.startsWith('@') && entry.key != '@@locale')
          entry.key: (entry.value as Map<String, dynamic>)['placeholders'] as Map<String, dynamic>? ?? {},
    };
  });

  test('app_pl.arb (template) is valid JSON with at least one key', () {
    expect(templateKeys, isNotEmpty);
  });

  test('every .arb file in lib/l10n has EXACTLY the template\'s key set'
      ' — no missing keys, no extra keys only in one language', () {
    final arbFiles = l10nDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb'))
        .toList();

    // Sanity check on the sweep itself — if this ever drops below 21,
    // someone deleted a language file without meaning to.
    expect(arbFiles.length, greaterThanOrEqualTo(21),
        reason: 'Expected at least 21 language files in lib/l10n/');

    final failures = <String>[];

    for (final file in arbFiles) {
      final data = json.decode(file.readAsStringSync()) as Map<String, dynamic>;
      final keys = <String>{
        for (final entry in data.entries)
          if (!entry.key.startsWith('@') && entry.key != '@@locale') entry.key,
      };

      final missing = templateKeys.keys.toSet().difference(keys);
      final extra = keys.difference(templateKeys.keys.toSet());

      if (missing.isNotEmpty) {
        failures.add('${file.path}: BRAKUJĄCE klucze: $missing');
      }
      if (extra.isNotEmpty) {
        failures.add('${file.path}: DODATKOWE klucze (tylko w tym pliku): $extra');
      }
    }

    expect(failures, isEmpty, reason: failures.join('\n'));
  });

  test('every .arb file has an @@locale matching its filename', () {
    final arbFiles = l10nDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb'));

    final failures = <String>[];
    for (final file in arbFiles) {
      final data = json.decode(file.readAsStringSync()) as Map<String, dynamic>;
      final expectedLocale = file.uri.pathSegments.last
          .replaceFirst('app_', '')
          .replaceFirst('.arb', '');
      final actualLocale = data['@@locale'];
      if (actualLocale != expectedLocale) {
        failures.add('${file.path}: @@locale="$actualLocale", oczekiwano "$expectedLocale"');
      }
    }
    expect(failures, isEmpty, reason: failures.join('\n'));
  });

  test('every placeholder-bearing key (e.g. errorPrefix, statusLabel,'
      ' cutFromBoardNote) has the SAME placeholder names in every'
      ' language — a dropped {value} would silently break interpolation'
      ' only in that language', () {
    final arbFiles = l10nDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb'));

    final failures = <String>[];

    for (final file in arbFiles) {
      final data = json.decode(file.readAsStringSync()) as Map<String, dynamic>;

      for (final metaKey in templatePlaceholders.keys) {
        final expectedPlaceholders = templatePlaceholders[metaKey]!.keys.toSet();
        final actualMeta = data[metaKey] as Map<String, dynamic>?;

        if (actualMeta == null) {
          failures.add('${file.path}: brak metadanych $metaKey (placeholdery zniknęły)');
          continue;
        }
        final actualPlaceholders =
            (actualMeta['placeholders'] as Map<String, dynamic>? ?? {}).keys.toSet();

        if (expectedPlaceholders.difference(actualPlaceholders).isNotEmpty ||
            actualPlaceholders.difference(expectedPlaceholders).isNotEmpty) {
          failures.add(
              '${file.path}: $metaKey ma placeholdery $actualPlaceholders, oczekiwano $expectedPlaceholders');
        }

        // The value itself must actually contain every {placeholder}
        // it declares — catches a translator deleting {value} from
        // the sentence while leaving the metadata untouched.
        final valueKey = metaKey.substring(1); // strip leading '@'
        final value = data[valueKey] as String? ?? '';
        for (final placeholder in expectedPlaceholders) {
          if (!value.contains('{$placeholder}')) {
            failures.add(
                '${file.path}: "$valueKey" nie zawiera {$placeholder} mimo że jest zadeklarowany');
          }
        }
      }
    }

    expect(failures, isEmpty, reason: failures.join('\n'));
  });
}
