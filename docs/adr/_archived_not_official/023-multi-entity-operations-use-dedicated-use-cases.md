# ADR-023: Operacje wieloencyjne dostają własny Use Case, nie kompozycję repozytoriów

## Status
Zaakceptowane

## Kontekst
Slice 3 (Cut Operation) wymaga zmiany Board (nowe wymiary pozostałej
części) i utworzenia 1..N Offcut **w jednej, atomowej transakcji
SQLite**. Dotąd każde repozytorium (`BoardRepositoryImpl`,
`OffcutRepositoryImpl`) samo wywołuje `DatabaseService.transaction()`
dla swoich własnych zapisów. sqflite nie obsługuje zagnieżdżonych
transakcji na tym samym połączeniu — wywołanie
`boardRepository.someMethod()` (które samo otwiera transakcję) z
wnętrza `offcutRepository.someMethod()` (też otwierającego własną
transakcję) nie da atomowości między nimi. Repozytoria nie mogą się
więc po prostu "wołać nawzajem" dla operacji, które muszą być
atomowe razem.

## Decyzja
Operacja obejmująca więcej niż jedną encję atomowo dostaje własną
klasę **Use Case**, która:
- operuje bezpośrednio na `DatabaseService` (jedna transakcja SQLite
  na całą operację), nie przez wywołania metod repozytoriów
- ma interfejs w `domain/usecases/`, implementację w `data/usecases/`
  (ten sam podział co Repository)
- publikuje wszystkie odpowiednie eventy PO udanym committcie całej
  transakcji, nie osobno dla każdej encji

Pierwszy przykład: `CutBoardUseCase` — aktualizuje `boards`, tworzy
N wierszy w `offcuts`, zapisuje transakcje i wpisy ledgera dla obu
encji, wszystko w jednym `db.transaction()`.

## Konsekwencje
- Repozytoria (`BoardRepositoryImpl`, `OffcutRepositoryImpl`)
  pozostają odpowiedzialne wyłącznie za operacje na swojej własnej
  encji — pojedyncza odpowiedzialność zachowana.
- Use Case celowo duplikuje niewielki fragment mapowania wiersz↔
  encja zamiast reużywać prywatnych metod repozytoriów — akceptowalny
  koszt, żeby uniknąć sprzęgania Use Case z wewnętrzną implementacją
  dwóch repozytoriów.
- Wzorzec jest gotowy pod przyszłe operacje wieloencyjne (np. import
  CSV tworzący wiele Board+Delivery naraz) bez nowej decyzji
  architektonicznej — tylko nowy Use Case w tym samym miejscu.
- Warstwa Use Case NIE zastępuje repozytoriów dla operacji
  jednoencyjnych — `BoardRepository.moveBoard()` zostaje w
  repozytorium, bo dotyczy tylko Board.

## Zgodność z ADR-020
Ta decyzja nie zmienia zasady "nowe pole/typ tylko z konkretną
funkcją" — `BoardTransactionType.cut` i schemat tabel pozostają bez
zmian (żadnej nowej migracji), bo `board_transactions.type` i
`offcuts`/`offcut_transactions` już istnieją z Slice 1/2. To czysty
dowód na payoff wcześniejszych decyzji: nowa operacja wieloencyjna
nie wymagała żadnej zmiany schematu bazy.
