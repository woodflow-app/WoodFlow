# ADR-020: Domain Model Evolves Through Vertical Slices

## Status
Zaakceptowane

## Kontekst
ADR-019 rozstrzygnął konkretny przypadek (Board v1.0), ale zasada,
która za nim stoi, dotyczy całego modelu domenowego WoodFlow, nie
tylko jednej encji. `WoodFlow_Domain_Model_Audit.md` pozostaje
wartościowym dokumentem historycznym (hierarchia Warehouse→Rack→
Slot→Board/Offcut, rozróżnienie Board/Offcut, 5 wstępnych znalezisk),
ale jego Pass 2 (weryfikacja na prawdziwych modelach) i Pass 3
(Reality Check — "które pole odpowiada na pytanie: która funkcja z
niego korzysta") nie zostaną już dokończone jako osobny dokument
przygotowawczy przed kodowaniem.

Precyzyjne sformułowanie (za Piotrem): Pass 2 i Pass 3 **zostały
wykonane poprzez implementację** — nie zostały porzucone. Board v1.0
przeszedł Reality Check w praktyce: `decorCode`, `warehouseId`,
`qrCode`, `length/width/thickness` mają wskazanego użytkownika
(identyfikacja materiału, `moveBoard()`, skaner QR, przyszły rozkrój).
`supplierId`, `projectId`, `purchasePrice`, `photo`, `manufacturer`
nie przeszły Reality Check dla Slice 1 i świadomie ich nie dodano —
to jest dokładnie rezultat Pass 3, tylko osiągnięty przez pisanie
kodu zamiast pisanie audytu.

## Decyzja
1. `WoodFlow_Domain_Model_Audit.md` pozostaje dokumentem
   historycznym — nie jest już aktywnym źródłem prawdy do
   dokończenia.
2. **Kod jest źródłem prawdy dla aktualnej implementacji modelu
   domenowego — ADR opisuje, dlaczego model wygląda właśnie tak.**
   To rozróżnienie jest celowe: kod odpowiada na pytanie *co
   istnieje*, ADR na pytanie *dlaczego*. Za dwa lata ktoś zobaczy
   pole (np. `supplierId`) i z samego kodu nie dowie się, dlaczego
   się pojawiło, dlaczego nie jest nullable, dlaczego nie żyje w
   osobnej encji — to jest rola ADR, nie kodu. "Kod jako źródło
   prawdy" dotyczy struktury (jakie pola, jakie typy, jakie
   zależności), nie uzasadnienia. Dokumentacja (ADR) nie jest przez
   to wtórna — jest komplementarna, opisuje inny wymiar pytania.
3. Nowe pole w dowolnej encji pojawia się wyłącznie wtedy, gdy
   istnieje konkretna funkcja biznesowa, ekran lub proces, który go
   wymaga. Nigdy "bo kiedyś się przyda".
4. Każda taka zmiana modelu domenowego wymaga krótkiego wpisu ADR —
   nie osobnego audytu, tylko zwięzłego zapisu: jakie pole, jaka
   funkcja je wymaga, jaki Slice to wprowadził.

## Konsekwencje
- Koniec ryzyka "nieskończonego audytu przed kodowaniem" — to był
  realny problem (Pass 2/3 utknęły na miesiące, czekając na pliki,
  które przestały istnieć).
- Model domenowy rośnie inkrementalnie i jest zawsze zweryfikowany
  na żywym kodzie, nigdy czysto teoretyczny.
- Koszt: każda istotna decyzja architektoniczna wymaga krótkiego
  ADR. Drobne decyzje implementacyjne pozostają w historii zmian i
  commitach, aby ADR Log zachował wartość jako rejestr decyzji
  strategicznych, a nie dziennik każdej zmiany w kodzie.

## Relacja do ADR-019
ADR-019 jest pierwszym zastosowaniem tej zasady (dla Board).
ADR-020 formalizuje ją jako regułę obowiązującą projekt WoodFlow
jako całość, na przyszłość.

## Uogólnienie — jedno pytanie dla wszystkiego, nie tylko dla pól

Test z Decyzji #3 ("czy istnieje konkretna funkcja biznesowa, która
tego wymaga") nie jest ograniczony do pól encji. Obowiązuje jako
jedno pytanie zadawane przed dodaniem **czegokolwiek** do projektu:

> Która funkcja użytkownika wymaga jego istnienia?

Dotyczy to równo: nowego serwisu, nowego repozytorium, nowego
domain eventu, nowej tabeli, nowej zależności w `pubspec.yaml`,
nowego pakietu. To ten sam mechanizm, który już zadziałał przy
`EventPublisher` (zarejestrowany, ale nieużywany, dopóki Board
faktycznie nie potrzebował publikować zdarzenia) i przy
`BaseRepository` (obserwowany, aż Board pokazał, że mu nie pasuje —
patrz ADR-021). To uniwersalne narzędzie przeciw
over-engineeringowi, nie osobna zasada dla modelu domenowego.
