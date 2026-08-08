# ADR: get_it jako jedyny mechanizm zarządzania cyklem życia

## Status
Zaakceptowane (poprawka po code review — wcześniejsza wersja miała
równolegle `DatabaseService.instance` ORAZ rejestrację w get_it, co
było błędem: dwa mechanizmy rozwiązujące ten sam problem).

## Kontekst
WoodFlow ma rosnąć przez lata o kolejne moduły (Warehouse, Board,
Offcut, Ledger, Suppliers, AI, Sync). Każdy z nich potrzebuje
dostępu do współdzielonych serwisów (`DatabaseService`, `AppLogger`)
i będzie miał własne repozytorium. Potrzebny jest jeden, przewidywalny
sposób tworzenia i pobierania tych instancji — bez pisania własnego
kontenera DI od zera i bez ręcznego przekazywania zależności przez
konstruktory na wielu poziomach (constructor injection "na piechotę"
szybko robi się nieczytelne przy >5 zależnościach).

## Decyzja
- `get_it` jest jedynym miejscem, które tworzy i przechowuje
  instancje singletonowe (`AppLogger`, `DatabaseService`,
  repozytoria) oraz fabryki (przyszłe ViewModel/Provider).
- Żadna klasa nie ma własnego `static instance` / prywatnego
  konstruktora singletonowego. Wszystkie klasy przyjmują zależności
  przez zwykły konstruktor (`DatabaseService(this._logger)`) — to
  get_it decyduje, ile instancji istnieje i kiedy są tworzone.
- Rejestracja nowego repozytorium w `service_locator.dart` to jedna
  linijka (`sl.registerLazySingleton<XRepository>(...)`).

## Konsekwencje
**Plusy:**
- Jeden mechanizm cyklu życia w całej aplikacji — nie trzeba się
  zastanawiać "czy ta klasa ma singleton, czy dostaję nową instancję".
- Testy mogą łatwo podmienić rejestrację (`sl.registerSingleton` z
  mockiem) bez zmiany kodu produkcyjnego.
- Dodanie modułu nie wymaga przebudowy istniejących klas — tylko
  nowy wpis w `setupServiceLocator()`.

**Minusy / kompromisy:**
- `get_it` jest globalnym rejestrem (service locator), co część
  społeczności Fluttera krytykuje jako "ukrytą zależność" zamiast
  jawnego constructor injection. Świadomie akceptujemy ten kompromis
  ze względu na prostotę przy jednoosobowym rozwoju projektu.
- Błąd braku rejestracji (`sl<X>()` bez wcześniejszego
  `registerLazySingleton<X>`) ujawnia się dopiero w runtime, nie w
  czasie kompilacji.

## Alternatywy rozważane
- **Riverpod** — bardziej "flutterowy", kompilacyjnie bezpieczny,
  ale znacząco większa krzywa uczenia i przebudowa całego podejścia
  do stanu w UI. Odłożone jako możliwa migracja przy warstwie
  prezentacji, nie teraz.
- **Ręczny constructor injection bez kontenera** — odrzucone: przy
  planowanych 8+ modułach przekazywanie zależności przez wiele
  poziomów konstruktorów stałoby się nieczytelne.
