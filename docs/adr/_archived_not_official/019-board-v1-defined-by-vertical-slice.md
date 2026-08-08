# ADR-019: Board v1.0 defined by Vertical Slice

## Status
Zaakceptowane

## Kontekst
WoodFlow miał wcześniej rozpoczęty `Domain Model Audit` (Pass 1:
koncepcyjny, na podstawie dokumentacji). Pass 2 (na podstawie
rzeczywistych plików modeli) i Pass 3 (Reality Check — "które pole
odpowiada na pytanie: która funkcja z niego korzysta") nigdy nie
zostały domknięte — `WoodFlow_Implementation_Readiness_Checklist.md`
jawnie pokazuje je jako nieodhaczone, zablokowane na oczekiwaniu na
pliki Dart, które w międzyczasie przestały istnieć (rebuild na nowym
laptopie). Nie istnieje więc żaden "ukryty", zamrożony dokument z
ostateczną listą pól Board, do którego powinniśmy wracać jako
jedynego źródła prawdy.

Jednocześnie Board jest centralną encją WoodFlow — Inventory Engine,
Offcut, QR, Ledger, AI, raporty i synchronizacja wszystkie na nim
polegają. Czekanie w nieskończoność na dokończenie zawieszonego
audytu blokowało dostarczenie czegokolwiek działającego.

## Decyzja
Zamiast kontynuować hipotetyczny, zawieszony audyt, model Board
został zdefiniowany przez pierwszy kompletny scenariusz biznesowy
(Slice 1: Warehouse → Board → QR → Move → Ledger → Historia).
Pola Board na dzień dzisiejszy: `id`, `warehouseId`, `decorCode`,
`length`, `width`, `thickness`, `qrCode`, `status`, `createdAt`,
`updatedAt`. Ten zestaw jest traktowany jako **Board v1.0** —
świadomie zatwierdzony dla aktualnego zakresu funkcjonalnego, nie
jako "tymczasowy" czy "do potwierdzenia później".

Kod (repository + testy + migracja + ekrany UI) staje się źródłem
prawdy dla rozwijającego się modelu domenowego, zamiast odwrotnie.

## Konsekwencje
- Board v1.0 NIE jest kompletny na zawsze — kolejne pola (rack/slot,
  supplierId, projectId, grain direction, wartość jednostkowa) mogą
  zostać dodane, ale **wyłącznie gdy wynikają z kolejnego Slice'a i
  mają wskazanego, konkretnego użytkownika** (funkcję/ekran/proces).
- `WoodFlow_Domain_Model_Audit.md` Pass 2/Pass 3 dla Board uznaje się
  za zamknięte przez tę decyzję — nie wracamy do dokończenia tego
  konkretnego audytu jako osobnego dokumentu.
- Ta sama reguła obowiązuje teraz dla wszystkich przyszłych encji
  (Offcut, Project, Supplier...) — żadna nie czeka na "pełny audyt
  z góry", każda rośnie przez Slice.

## Zasada na przyszłość
> Nowe pole w encji pojawia się dopiero wtedy, gdy można wskazać
> konkretną funkcję, ekran lub proces, który go wymaga. Nie dodajemy
> pól "bo kiedyś mogą się przydać".

Ta zasada jest tożsama z Pass 3 Reality Check — różnica jest taka,
że stosujemy ją w czasie rzeczywistym, Slice po Slice, zamiast jako
jednorazowy audyt przed kodowaniem.
