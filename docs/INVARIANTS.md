# WoodFlow — Inwarianty domenowe

Ten dokument rozszerza **Invariants Audit** z `WoodFlow_ADR_Log.md`
(zamrożona lista założycielska) o reguły dopisane w trakcie budowy
kodu. Status `⬜ udokumentowane, niewyegzekwowane` oznacza: reguła
jest prawdziwa i ważna, ale kod jej dziś nie pilnuje — złamanie jej
nie zwróci błędu, tylko po cichu popsuje spójność danych.

## Z zamrożonego Invariants Audit (ADR Log)

- ✅ Płyta nie może znajdować się jednocześnie w dwóch lokalizacjach
  — wyegzekwowane strukturalnie: `slotId` to jedyne pole lokalizacji
  na Board/Offcut, nie da się mieć dwóch.
- ✅ Każda transakcja musi mieć znacznik czasu i źródło — wyegzekwowane:
  `occurred_at` i `entity_type`/`entity_id` są `NOT NULL` w `ledger_entries`.
- ✅ Historia (ledger) jest niezmienna — wyegzekwowane przez konwencję:
  żaden kod nigdy nie robi `UPDATE`/`DELETE` na `ledger_entries`,
  tylko `INSERT`.
- ✅ Ścinek nie może mieć większych wymiarów niż płyta, z której
  powstał — **⬜ udokumentowane, niewyegzekwowane**. `cutFromBoard()`
  dziś nie porównuje wymiarów Offcut z Board-rodzicem. Do rozważenia
  przy Cut Optimizerze (v2.0/PRO), gdzie wymiary będą liczone
  automatycznie, nie wpisywane ręcznie.
- ✅ UUID nigdy się nie zmienia — wyegzekwowane: `id` jest ustawiane
  raz przy tworzeniu, żaden `copyWith()` w projekcie nie pozwala go
  nadpisać (nie ma parametru `id` w żadnym `copyWith`).
- ✅ Soft delete nie usuwa historii — wyegzekwowane: `archive()` na
  Board/Offcut nigdy nie robi `DELETE`, ledger zostaje nienaruszony.

## Dopisane podczas budowy Offcut (ta rozmowa)

### Board nie może zostać zarchiwizowany, jeśli ma aktywne Offcut

**Status:** ⬜ udokumentowane, niewyegzekwowane (świadoma decyzja —
patrz niżej).

**Reguła:** dopóki istnieje choć jeden `Offcut` z `parentBoardId`
wskazującym na dany `Board` i statusem `available` (nie
`archived`), ten `Board` nie powinien móc zostać zarchiwizowany.
Zabezpiecza to pełną ścieżkę pochodzenia materiału — ważne przy
przyszłym Cut Optimizerze i historii materiału.

**Dlaczego niewyegzekwowane teraz:** `BoardRepositoryImpl.archive()`
dziś nie sprawdza `OffcutRepository.getByParentBoard()` przed
archiwizacją. To jest 1-2 linijki kodu do dodania, kiedy zdecydujemy
się to wyegzekwować — nie zrobione teraz na wyraźną prośbę: najpierw
dokumentacja, kod później, jeśli/gdy okaże się potrzebny.

**Ryzyko pozostawienia tylko w dokumentacji:** ktoś budujący inny
przepływ archiwizacji (np. masowa archiwizacja z Dashboardu, krok 9)
może o tej regule nie wiedzieć i ją złamać bez żadnego błędu w
aplikacji. Zanotowane wprost jako TODO w kodzie (patrz komentarz przy
`BoardRepositoryImpl.archive()`), żeby było widoczne dokładnie tam,
gdzie ktoś przyszłościowo mógłby to przeoczyć.
