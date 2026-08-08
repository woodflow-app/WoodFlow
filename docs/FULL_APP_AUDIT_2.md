# WoodFlow — Pełny audyt aplikacji (przed poprawkami)

## 🔴 KRYTYCZNE

### 1. `intl: ^0.20.2` w `pubspec.yaml` — odwrotne do rzeczywistości
Sprawdzone na żywo (wyszukiwanie, nie pamięć): `flutter_localizations`
z Flutter SDK wymaga **dokładnie `intl 0.19.0`**, nie `^0.20.2`.
Potwierdzone wielokrotnie w oficjalnych issue'ach Flutter/GitHub
(2023-2025), wszystkie z identycznym komunikatem błędu:
```
Because every version of flutter_localizations from sdk depends on
intl 0.19.0 and project depends on intl ^0.20.2, flutter_localizations
from sdk is forbidden. ... version solving failed.
```
**`flutter pub get` wysypałby się na starcie.** Mój wcześniejszy zapis
w pamięci ("^0.20.2, NIE ^0.19.0") był błędny — najprawdopodobniej
odnosił się do innej sytuacji lub innej wersji Fluttera. Naprawiam na
`^0.19.0`, zgodnie z aktualną, zweryfikowaną rzeczywistością.

## 🟡 ZNALEZIONE I NAPRAWIONE W TRAKCIE AUDYTU

### 2. Fragile string literal w `dashboard_service_test.dart`
Opis jednego testu używał sąsiadującej konkatenacji trzech literałów
stringów (`' getAll()'"'"'s default...'`), żeby wstawić apostrof bez
escapowania. Technicznie prawdopodobnie zadziałałoby (Dart pozwala na
konkatenację sąsiadujących literałów), ale to niepotrzebnie ryzykowne
i nieczytelne. **Już naprawione** — przepisane na prostszy,
jednoznaczny opis bez tej sztuczki.

## 🟢 SPRAWDZONE I POTWIERDZONE JAKO POPRAWNE

- **Zbalansowanie nawiasów** `{} () []` w całym `lib/` i `test/` (74
  plików) — zero problemów po odfiltrowaniu komentarzy/stringów.
- **Importy względne** — wszystkie prowadzą do istniejących plików,
  poza `l10n/app_localizations.dart`, który jest **generowany** przez
  `flutter gen-l10n` i nie istnieje w repo przed tym poleceniem (to
  oczekiwane, nie błąd).
- **Pakiety** — każdy `package:X/` użyty w kodzie ma odpowiadający
  wpis w `pubspec.yaml`, i odwrotnie.
- **`mobile_scanner ^5.2.3`, `pdf ^3.11.1`, `printing`** — zweryfikowane
  na żywo jako realne, istniejące wersje z API zgodnym z tym, co
  napisałem (`MobileScannerController`, `BarcodeWidget`/`Barcode.qrCode()`).
- **Wszystkie 76 kluczy `l10n.klucz` użytych w `lib/presentation/`**
  mają odpowiadający wpis w ARB — dokładnie 76 zdefiniowanych, 76
  użytych, zero brakujących, zero nieużywanych.
- **Liczba argumentów przy metodach z placeholderami**
  (`errorPrefix`, `rackNameTitle`, `slotFillCount` itd.) — zgodna z
  liczbą placeholderów zadeklarowanych w ARB, w każdym miejscu użycia.
- **Każda rejestracja w `service_locator.dart`** — zweryfikowana
  względem rzeczywistego konstruktora każdej klasy, **łącznie z
  kolejnością parametrów** (nie tylko liczbą) — wszystkie 11
  rejestracji poprawne.
- **`Result<T>`, `EventPublisher`, `DatabaseService`** — definicje
  zgodne z każdym miejscem użycia w repozytoriach i testach.
- **Nazwy kolumn SQL** — porównane migracja-po-migracji z
  `_toRow`/`_fromRow` w każdym z 6 repozytoriów. Zero rozbieżności
  (żadnej brakującej, żadnej dodatkowej kolumny).
- **Enumy statusów** (`BoardStatus`, `OffcutStatus`) — wartości
  `.dbValue`/`.name` zgodne z surowymi stringami SQL w migracjach,
  repozytoriach i testach.
- **Migracje v1-v6** — kolejność, wersje, `dbVersion=6` w
  `AppConstants` — wszystko zgodne.
- **Brak powrotu usuniętego wcześniej kodu** (`CutBoardUseCase`,
  `support_contact.dart`, `SettingsScreen`).
- **`main.dart`** — `Future<void> main() async` + `runApp()` obecne i
  poprawne (mój pierwszy grep dał fałszywy alarm, szukając dosłownie
  `void main`, nie `Future<void> main`).

## ⚪ DROBNE, NIE BŁĘDY (opcjonalne dla porządku, nie blokujące)

- `AppConstants.logTagRepository` zdefiniowane, ale każde
  repozytorium używa surowego stringa `'REPOSITORY'` zamiast tej
  stałej. Nie błąd kompilacji, tylko niewykorzystana szansa na DRY.
