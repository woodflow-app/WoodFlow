# WoodFlow — Rebranding techniczny (nazwa pakietu, nazwa aplikacji, ikona)

Decyzja z wcześniejszej sesji ("logo po v1.0") jest tym dokumentem
świadomie odwrócona — koszt zmiany jest teraz najniższy, korzyść
(spójność nazwy/pakietu/ikony od startu) długoterminowo większa.

## 1. pubspec.yaml — nazwa pakietu

Zmień pierwszą linijkę:

```yaml
name: woodflow
description: WoodFlow — system operacyjny dla nowoczesnej stolarni
publish_to: 'none'
version: 1.0.0+1
```

To WSZYSTKO, co dotyka kodu Dart — `lib/` używa wyłącznie importów
relatywnych (`../../domain/...`), więc zmiana `name:` nie wymaga
żadnej edycji w `lib/`. Dotyczy tylko plików testowych (już
zaktualizowane w tej rozmowie na `package:woodflow/...`).

## 2. Android — nazwa aplikacji i applicationId

**`android/app/src/main/AndroidManifest.xml`** — w tagu `<application>`:
```xml
<application
    android:label="WoodFlow"
    ...>
```

**`android/app/build.gradle`** (lub `build.gradle.kts`) — sekcja `defaultConfig`:
```gradle
defaultConfig {
    applicationId "uk.woodflow.app"  // <- dopasuj domenę do swojej firmy
    minSdkVersion flutter.minSdkVersion
    targetSdkVersion flutter.targetSdkVersion
    ...
}
```

⚠️ Zmiana `applicationId` jest bezpieczna TYLKO przed pierwszą
publikacją w Google Play — po publikacji zmiana ID = nowa aplikacja
w sklepie, utrata wszystkich opinii/instalacji. Teraz jest właściwy
moment.

## 3. iOS — nazwa aplikacji i bundle identifier

**`ios/Runner/Info.plist`**:
```xml
<key>CFBundleDisplayName</key>
<string>WoodFlow</string>
<key>CFBundleName</key>
<string>woodflow</string>
```

Bundle identifier zmienia się w Xcode: Runner target → General →
Bundle Identifier → np. `uk.woodflow.app` (dopasuj do tej samej
domeny co Android `applicationId`, dla spójności).

## 4. Ikona aplikacji — flutter_launcher_icons ✅ GOTOWE

Wybrany wariant: Wariant 1 (jednolite kolory), symbol WF + napis
"WoodFlow" — **bez tagline** "TRACK. CUT. FLOW." (usunięta po
porównaniu czytelności w realnej skali ikony na telefonie: 180px/
96px/48px). To kompromis między pełną nazwą a czytelnością przy
najmniejszych rozmiarach.

Plik źródłowy: `assets/branding/woodflow_icon_with_wordmark_no_tagline.png`
(1024×1024, czarne rogi oryginalnego renderu usunięte, zastąpione
białym tłem, z marginesem bezpieczeństwa pod adaptive icon).

Dodaj do `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/branding/woodflow_icon_with_wordmark_no_tagline.png"
  min_sdk_android: 21
  adaptive_icon_background: "#F7F4EE"  # Cream z palety WoodFlow
  adaptive_icon_foreground: "assets/branding/woodflow_icon_with_wordmark_no_tagline.png"
```

Skopiuj `assets/branding/woodflow_icon_with_wordmark_no_tagline.png`
do swojego projektu (`assets/branding/`), potem:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

Pozostałe warianty (`woodflow_icon_1024.png` — pełny lockup z tagline,
`woodflow_icon_monogram_only_1024.png` — sam symbol WF) zostają w
`assets/branding/` jako alternatywy na przyszłość — pełny lockup
dobrze nadaje się na ekran startowy/logowania czy "O aplikacji",
gdzie jest wystarczająco duży, żeby tagline była czytelna.

## 5. Splash screen — odłożone (zgodnie z ustaleniem)

`flutter_native_splash` zostaje na później — tuż przed pierwszą
publiczną wersją, zgodnie z tym, że to czysto wizualny element bez
obecnej wartości użytkowej.

## Status po tej iteracji

- ✅ Nazwa pakietu: `woodflow` (pubspec + testy)
- ✅ Nazwa aplikacji: gotowe snippety Android/iOS do wklejenia
- ✅ applicationId: gotowy snippet, bezpieczna zmiana (przed publikacją)
- ✅ Ikona: `assets/branding/woodflow_icon_1024.png` gotowy, konfiguracja gotowa
- ⬜ Splash: świadomie odłożone

Od tej iteracji: nazwa WoodFlow, pakiet `woodflow`, paleta Forest
Green (#1F4D3D) / Amber (#C8853D) / Green (#8FC454) / Cream (#F7F4EE)
— zamknięte decyzje projektowe, nie wracamy już do tożsamości
projektu.
