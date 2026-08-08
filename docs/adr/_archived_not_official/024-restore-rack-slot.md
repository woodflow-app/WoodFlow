# ADR-024: Przywrócenie Rack/Slot — korekta błędnego odłożenia w Slice 1

## Status
Zaakceptowane

## Kontekst
Przy projektowaniu Slice 1 (Board) zasugerowałem odłożenie Rack/Slot
jako "niepotrzebne na razie", stosując zasadę ADR-020 ("nowe pole
tylko gdy jest do niego konkretna funkcja"). Piotr się zgodził w
tamtym momencie. To było błędne zastosowanie tej zasady.

Zasada ADR-020 dotyczy funkcji SPEKULATYWNYCH — rzeczy, które "mogą
się przydać kiedyś". Rack/Slot nie było spekulacją: w poprzedniej,
działającej wersji aplikacji (przed rebuildem na nową architekturę)
było to sprawdzone, obciążone realnym użyciem wymaganie —
`LocationsScreen`, siatka zapełnienia, i twardy warunek blokujący:
*"Brak zdefiniowanych lokalizacji. Przejdź do zakładki Lokalizacje i
dodaj przynajmniej jeden regał i slot, zanim dodasz ścinkę."*

Odłożenie sprawdzonej, już-udowodnionej-w-praktyce funkcji podczas
przepisywania architektury od zera to inne ryzyko niż unikanie
budowania czegoś spekulacyjnego — to utrata funkcjonalności w
trakcie rewrite'u. ADR-020 nie powinien był się tu zastosować.

## Decyzja
Przywracamy `Rack` i `Slot` jako pełnoprawne encje w Slice 4:
- `Warehouse → Rack → Slot → Board/Offcut`
- `Rack`/`Slot` implementują `BaseRepository` (ich lifecycle to
  zwykły CRUD, bez własnego Transaction/Ledger — brak potrzeby
  audytu zmian samej struktury regałów)
- `Board.slotId` i `Offcut.slotId` — nullable (miękka zachęta, nie
  twardy wymóg jak w starej appce — patrz Konsekwencje)
- `moveBoard()`/`moveOffcut()` rozszerzone o opcjonalny `toSlotId`
- `cutFromBoard()` i `OffcutSpec` przyjmują opcjonalny `slotId`
- Zapis do Ledgera przy przenoszeniu zawiera teraz `fromSlotId`/
  `toSlotId` obok `fromWarehouseId`/`toWarehouseId`

## Świadoma różnica od starej aplikacji: miękki wymóg, nie twardy
Stara appka BLOKOWAŁA dodanie ścinka bez wcześniej zdefiniowanego
regału/slotu. Tutaj `slotId` jest nullable — UI będzie zachęcać do
wyboru slotu (i ostrzegać, gdy magazyn nie ma żadnego zdefiniowanego
regału), ale nie blokuje na poziomie bazy danych. Powód: elastyczność
dla wczesnych użytkowników, którzy jeszcze nie skonfigurowali pełnej
struktury magazynu, nie powinna być karana twardym błędem. To można
zaostrzyć później, jeśli w praktyce okaże się, że miękka zachęta nie
wystarcza.

## Konsekwencje
- Board/Offcut mają teraz `slotId` — pole dodane z konkretnego,
  udowodnionego powodu (nie spekulacji), zgodnie z duchem, jeśli nie
  literą, ADR-020.
- Migracja v4 dodaje `slot_id` przez `ALTER TABLE ADD COLUMN` do już
  istniejących tabel `boards`/`offcuts` — nullable, więc nie wymaga
  backfillu istniejących wierszy.
- `Board.copyWith`/`Offcut.copyWith` używają sentinela (`_unset`),
  żeby jawnie rozróżnić "nie zmieniaj slotu" od "wyczyść slot" — ta
  sama klasa błędu, którą już raz złapano w starej aplikacji
  (`copyWith(id: null)` cicho nie czyściło ID).

## Wniosek na przyszłość
Przy odkładaniu jakiejkolwiek funkcji na "później", sprawdzić
najpierw: czy to jest spekulacja (ADR-020 ma zastosowanie), czy
sprawdzona funkcjonalność z poprzedniej wersji produktu (ADR-020 NIE
ma zastosowania — to nie jest "dodawanie na zapas", to "nie gubienie
tego, co już działało").
