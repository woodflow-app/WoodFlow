# WoodFlow — Audyt przed budową (v1.0 → v3.5)

Cel: znaleźć WSZYSTKO, co mogłoby dać niespodziankę w trakcie
budowy, zanim napiszemy kolejną linijkę kodu. Poniżej — dokładnie w
kolejności ważności, nie chronologicznej.

---

## 🔴 Ryzyko #1 — Sprzeczność wewnątrz Waszej własnej dokumentacji

**ADR-001** (Project jako pełnoprawny byt) mówi w kontekście:
*"transakcje magazynowe potrzebowały odniesienia do zlecenia... przy
wprowadzeniu **Rezerwacji (PRO)**"* — czyli ADR-001 został napisany,
gdy Rezerwacja była jeszcze planowana jako funkcja PRO/v2.0.

Ale w finalnym, zamrożonym `WoodFlow_Katalog_Funkcji.md`, Rezerwacja
("Widok regał/slot z rezerwacją") jest w **FREE/v1.0** (pozycja 8 z
mojego wcześniejszego audytu).

**To nie jest błąd krytyczny** — decyzja ADR-001 (Project jako pełny
byt) jest nadal słuszna, nawet BARDZIEJ, bo teraz potrzebna jest już
w v1.0, nie dopiero w v2.0. Ale to pokazuje, że ADR-001 nie został
zaktualizowany po tym, jak Rezerwacja przesunęła się do FREE — kontekst
w dokumencie jest nieaktualny względem decyzji, którą uzasadnia.

**Rekomendacja:** poprawić kontekst ADR-001 w prawdziwym logu, żeby
nie mylić przyszłych czytelników.

---

## 🔴 Ryzyko #2 — Organization nie istnieje, a powinna od pierwszej tabeli

**Domain Model Audit** ustala hierarchię: `Organization → Warehouses
→ Racks → Slots → Boards/Offcuts`. **ADR-003** mówi wprost: szkielet
(w tym Organizations) budowany **od v1.0**, w większości wyłączony,
żeby moduły włączać "**bez przebudowy architektury**".

**U nas:** `Warehouse` nie ma `organization_id`. Jest dziś najwyższym
poziomem hierarchii.

**Dlaczego to problem:** v2.5 (Synchronizacja wielu magazynów) i
cała koncepcja licencji per organizacja (limity stanowisk: FREE=1,
START=3...) zakładają, że Warehouse należy do jakiejś Organization.
Dodanie tego teraz to jedna kolumna (`organization_id`, z jednym
domyślnym rekordem Organization). Dodanie tego PO zbudowaniu Board,
Offcut, Rezerwacji, Projektów itd. to migracja przez wszystkie tabele
naraz — dokładnie ten scenariusz, przed którym ADR-003 miał chronić.

**Rekomendacja:** dodać minimalną tabelę `organizations` (jeden
domyślny rekord) + `organization_id` na `warehouses` **teraz**, zanim
pójdziemy dalej. Koszt: 1 migracja, 15 minut pracy. Koszt odłożenia:
nieznany, ale prawdopodobnie znacznie większy.

---

## 🔴 Ryzyko #3 — Decor jako wolny tekst, a powinien być katalogiem

**ADR-002:** Decor to jedna globalna tabela `decors`, nie tekst.

**U nas:** `Board.decorCode` to zwykły `String`. Dokładnie ten sam typ
problemu, co Project (ADR-001) — pole tekstowe zamiast odniesienia do
bytu.

**Dlaczego to boli konkretnie teraz:** samo v1.0 ma funkcję "Baza
dekorów z autouzupełnianiem" (wpisanie "H3303" ma automatycznie
podpowiedzieć "Natural Hamilton Oak"). Nie da się tego zrobić bez
tabeli `decors`. Będziemy to i tak budować w Etapie 1 (krok 12 z
Twojej listy) — pytanie, czy zrobić to PRZED Offcut (żeby Offcut od
razu referencjonował `decor_id`, nie kopiował string), czy PO.

**Rekomendacja:** zbudować `Decor` jako encję teraz, PRZED Offcut.
Zmienić `Board.decorCode` z `String` na `Board.decorId` (FK). To
mała, kontrolowana zmiana teraz; duża, niekontrolowana później (Board
i Offcut oba referencjonowałyby zduplikowany, niespójny tekst).

---

## 🟡 Ryzyko #4 — Brak warstwy abstrakcji synchronizacji

**ADR-003** wymienia "Sync abstraction" jako część szkieletu od v1.0.

**U nas:** `DatabaseService` jest ciasno powiązany z lokalnym
`sqflite` — zero abstrakcji pod przyszłą synchronizację.

**Dlaczego to ważne:** v1.5/START już obiecuje "do 3 aktywnych
stanowisk" ze wspólną bazą danych ("magazynier na tablecie w
magazynie, operator na tablecie przy CNC widzi zmianę po ~30
sekundach"). To wymaga architektury synchronizacji (backend + API +
rozwiązywanie konfliktów, albo coś jak Firebase/Supabase) — nie da
się tego zrobić na czystym lokalnym SQLite bez żadnej warstwy
pośredniej.

**To NIE jest coś do zbudowania teraz** — ale warto **świadomie
zaplanować punkt rozszerzenia** (interfejs `SyncableRepository` czy
podobny), żeby v1.5 nie wymagało przepisania całej warstwy danych.
To jest dokładnie ten sam wzorzec co `EventPublisher` — pusty
interfejs dziś, realna implementacja gdy przyjdzie pora.

**Rekomendacja:** zanotować to jawnie jako przyszły krok (nie budować
teraz), ale mieć świadomość, że to największe ryzyko techniczne w
całej roadmapie — większe niż jakikolwiek pojedynczy ekran.

---

## 🟡 Ryzyko #5 — Pallet (v1.5) a model "slot_id jako jedyny klucz"

Twoja korekta ("Board należy do Slot, nie Warehouse") jest w kodzie.
Ale v1.5 wprowadza "Paletę jako obiekt magazynowy" z własną
lokalizacją, zawierającą wiele płyt.

**Pytanie, które trzeba będzie rozstrzygnąć w v1.5 (nie teraz):**
czy Board na palecie ma `slotId` palety bezpośrednio (paleta i board
w tym samym slocie), czy Board odnosi się do `palletId`, a paleta ma
`slotId` (lokalizacja pośrednia)? To nie jest sprzeczność z tym, co
zbudowaliśmy — ale warto to rozstrzygnąć świadomie, gdy dojdziemy do
Etapu 2, żeby nie złamać zasady "jedno źródło prawdy o lokalizacji".

**Rekomendacja:** nic teraz. Zanotowane na przyszłość.

---

## 🟢 Rzeczy, które SPRAWDZIŁEM i są w porządku

- **`ledger_entries`** (generyczne, `entity_type`/`entity_id`) już
  dziś pełni rolę, jaką w dokumentacji nazwano `inventory_transactions`
  (potrzebne AI v2 w v3.0 do analizy tempa zużycia). Brak konfliktu.
- **Rack/Slot/Board hierarchia** zgadza się w 100% z Domain Model Audit.
- **Terminologia Slot/Półka** (ADR-006) poprawiona w prototypie.
- **Cut Optimizer, Decision Engine, role per-stanowisko vs per-osoba**
  — wszystkie poprawione we wcześniejszym audycie prototypu.

---

## Rekomendowana kolejność przed dalszą budową

1. **Organization** (minimalna: 1 tabela, 1 domyślny rekord, FK z Warehouse) — 15 min
2. **Decor** (encja + tabela, `Board.decorId` zamiast `decorCode`) — realna praca, ale mała
3. Dopiero potem: **Offcut**, zgodnie z pierwotnym planem
4. **Project** i **Supplier** — mogą poczekać do momentu budowania Rezerwacji, pod warunkiem, że nie zbudujemy nigdzie po drodze pola tekstowego "numer zlecenia" czy "dostawca" na żadnej tabeli (żeby nie powtórzyć błędu, który Project/Supplier miały rozwiązać)

To jedyne dwie rzeczy (#1, #2), które rekomenduję zrobić PRZED
kontynuacją — obie małe, obie zapobiegają dokładnie temu typowi
migracji, przed którym ostrzegają Wasze własne ADR.
