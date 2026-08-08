# ADR-022: Offcut nigdy nie jest "małym Board"

## Status
Zaakceptowane (przed rozpoczęciem implementacji Slice 2)

## Kontekst
Klasyczny błąd w systemach magazynowych/rozkroju: modelowanie Offcut
jako Board z mniejszymi wymiarami lub jako wariant tego samego typu.
Prowadzi to do mieszania logiki pełnych płyt z logiką ścinków —
dokładnie tego, czego WoodFlow Dictionary od początku unikał,
rozróżniając Board (pełna, niepocięta płyta) od Offcut (pozostałość
po rozkroju, spełniająca minimalne wymiary do dalszego wykorzystania).

Offcut ma odmienną semantykę na poziomie domeny:
- zawsze ma rodzica — konkretny Board, z którego powstał (Board nie
  ma rodzica; istnieje samodzielnie od dostawy)
- powstaje wyłącznie jako rezultat operacji cięcia — nigdy nie jest
  tworzony "od zera" tak jak Board przy dostawie
- może mieć własny cykl życia (dalsze pocięcie, zużycie, utylizacja)
  odrębny od cyklu życia Board

## Decyzja
Offcut jest osobną encją domenową od pierwszego dnia Slice 2, nie
podtypem ani wariantem Board:
- własny plik encji (`offcut.dart`), własna tabela (`offcuts`)
- obowiązkowa referencja do rodzica: `parentBoardId` (nigdy nullable
  — Offcut bez Board, z którego powstał, nie ma sensu domenowego)
- własny `OffcutRepository`, nieoparty na wspólnym kodzie z
  `BoardRepository` poza tym, co faktycznie jest identyczne (wzorzec
  Result<T>, atomowy zapis Transaction+Ledger)
- operacja "pocięcia" Board na Offcut(y) jest własną transakcją
  domenową (np. `BoardCut`), nie reużyciem `moveBoard`/`create`

## Konsekwencje
- Więcej kodu na start (dwie encje zamiast jednej z flagą
  `isOffcut`), ale żadna przyszła funkcja (Cut Optimizer, raporty,
  AI) nie musi rozgałęziać logiki warunkiem "czy to Board czy
  Offcut" — typ już to wyraża.
- Zgodnie z ADR-020: pola Offcut pojawiają się wyłącznie z potrzeby
  konkretnego kroku Slice'a 2, nie przez kopiowanie pól z Board.

## Zasada na start Slice 2
> Offcut nigdy nie jest "małym Board".

To jest równie wiążąca decyzja architektoniczna jak ADR-019 dla
Board — obowiązuje od pierwszej linijki kodu Slice 2.
