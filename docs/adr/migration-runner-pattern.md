# ADR: MigrationRunner — migracje jako osobne, wersjonowane pliki

## Status
Zaakceptowane

## Kontekst
WoodFlow będzie miał wiele tabel dochodzących w czasie (warehouses,
boards, racks, slots, transactions, ledger, suppliers, projects...).
Jeśli cały SQL tworzenia/zmiany schematu żyje w jednej metodzie
`DatabaseService._runMigration()`, ta metoda urośnie do setek linii
w ciągu roku, mieszając SQL dla wszystkich wersji w jednym miejscu —
trudne do przeglądania w code review, trudne do namierzenia "co się
zmieniło w v4".

## Decyzja
- Każda wersja schematu to osobny plik implementujący interfejs
  `Migration` (`version`, `up(Database db)`), np. `v1_initial.dart`,
  `v2_add_boards.dart`.
- `MigrationRunner` trzyma uporządkowaną listę wszystkich migracji,
  jakie kiedykolwiek istniały, i wykonuje te z zakresu
  `(fromVersion, toVersion]`.
- `DatabaseService` nie zawiera ani jednej linijki SQL — deleguje
  całość do `MigrationRunner.run(db, from, to)`.
- Migracje są **append-only**: raz wydany plik migracji nigdy nie
  jest edytowany (bo urządzenia w terenie już go wykonały);
  poprawki idą jako nowa migracja.

## Konsekwencje
**Plusy:**
- Historia zmian schematu jest czytelna jako historia plików/commitów
  w `migrations/`, nie jako diff jednej rozrastającej się metody.
- `dbVersion` w `AppConstants` + kolejna klasa `Migration` to cały
  rytuał dodania nowej tabeli — niski próg wejścia dla przyszłego
  "ja za rok", które nie pamięta szczegółów.
- Testowalne osobno: test migracji sprawdza `PRAGMA table_info`
  po `MigrationRunner.run()`, bez uruchamiania całej aplikacji.

**Minusy / kompromisy:**
- Przy wielu wersjach lista w `MigrationRunner._migrations` rośnie —
  akceptowalne, bo to tylko rejestr, nie logika.
- Brak automatycznego rollbacku (`down()`) — świadomie pominięte na
  tym etapie, bo WoodFlow nie ma jeszcze produkcyjnych danych
  użytkowników do migrowania wstecz. Jeśli po wydaniu synchronizacji
  rollback stanie się potrzebny, to osobna, przyszła decyzja.

## Alternatywy rozważane
- **Jedna metoda ze switchem po wersji** — odrzucone z powodów
  opisanych w Kontekście.
- **Zewnętrzne narzędzie migracyjne (np. `moor`/`drift` migration
  builder)** — rozważane przy ewentualnym przejściu z surowego
  `sqflite` na ORM w przyszłości; nie teraz, żeby nie zwiększać
  zależności na tym etapie.
