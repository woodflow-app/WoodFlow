# ADR-021: BoardRepository nie implementuje generycznego BaseRepository — archive() zastępuje delete()

## Status
Zaakceptowane

## Kontekst
`BaseRepository<T, ID>` (Backend Foundation) zakładał, że każde
repozytorium ma wspólny kształt: `getById`, `getAll`, `create`,
`update`, `delete`. Jego własny doc comment przewidywał to ryzyko
wprost: *"Może się okazać, że za pół roku BaseRepository będzie miał
tylko jednego użytkownika... Nie usuwałbym go teraz, ale obserwował,
czy faktycznie wnosi wartość."*

Board był tym pierwszym testem. Jego rzeczywisty cykl życia okazał
się rozbieżny z generycznym CRUD w jednym konkretnym miejscu:
`delete()` pod append-only Ledgerem nigdy nie usuwa fizycznie —
archiwizuje. Metoda nazwana `delete()`, która nie usuwa, jest
myląca dla każdego, kto czyta kod bez kontekstu tej decyzji.

## Decyzja
`BoardRepository` przestaje deklarować `implements
BaseRepository<Board, String>`. Zamiast tego definiuje własny,
w pełni jawny kontrakt: `getById`, `getAll(includeArchived)`,
`create`, `update`, `getByQrCode`, `moveBoard`, `archive`,
`getLedgerForBoard`. Nazwa `archive()` opisuje dokładnie to, co
metoda robi — nie ma już rozjazdu między nazwą a zachowaniem.

`BaseRepository` pozostaje bez zmian dla repozytoriów, których
lifecycle faktycznie jest generycznym CRUD (na dziś: Warehouse).

## Konsekwencje
- Czytelność wygrywa z DRY w tym jednym miejscu — `BoardRepository`
  ma nieco więcej powtórzonych sygnatur niż gdyby dziedziczył z
  `BaseRepository`, ale żadna z nich nie kłamie o swoim zachowaniu.
- Każde kolejne repozytorium samo decyduje, czy jego lifecycle pasuje
  do `BaseRepository`, czy zasługuje na własny, jawny kontrakt —
  ocena per-encja, nie odgórna reguła "wszystko dziedziczy z bazy".
- `BaseRepository` zostaje — obserwacja z jego własnego doc commentu
  się potwierdziła częściowo (jeden użytkownik zboczył), ale
  Warehouse wciąż go używa, więc nie ma powodu go usuwać.

## Zanotowane na przyszłość (bez działania teraz)
`getAll({bool includeArchived})` już sygnalizuje kierunek: kolejne
Slice'y prawdopodobnie dołożą filtrowanie po magazynie, dekorze,
grubości, statusie. Gdy liczba opcjonalnych parametrów urośnie,
naturalnym krokiem będzie osobny obiekt kryteriów wyszukiwania
(`BoardQuery`) zamiast kolejnych parametrów w sygnaturze. Nie
wprowadzamy go teraz — nie ma jeszcze drugiego realnego przypadku
użycia poza `includeArchived`, więc byłaby to abstrakcja na zapas
(ta sama zasada co ADR-019/ADR-020).
