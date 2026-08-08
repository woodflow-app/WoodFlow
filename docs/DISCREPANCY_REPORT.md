# WoodFlow — Raport rozbieżności: Slice 1–4 vs zamrożone dokumenty

**Cel:** porównanie tego, co zbudowaliśmy w tej rozmowie (Backend
Foundation, Warehouse, Board, Offcut, Cut Operation, Rack/Slot) z
siedmioma zamrożonymi dokumentami referencyjnymi, które przesłałeś.
Nic tu nie jest jeszcze zmienione w kodzie — to tylko mapa różnic do
Twojej decyzji.

---

## A. Rozbieżności terminologiczne (szybkie do poprawienia)

### A1. "Slot" vs "Półka" w UI
**Zamrożone (Dictionary, ADR-006):** jeden byt, w kodzie `Slot`, **w
interfejsie użytkownika "Półka"** — bardziej naturalne dla stolarza
niż żargon magazynowy.
**U nas:** wszystkie ekrany (mockup HTML, nazwy klas Dart) używają
"Slot" zarówno w kodzie, jak i w UI.
**Poprawka:** kosmetyczna — zmiana etykiet w UI, `Slot` w kodzie
zostaje bez zmian.

### A2. Numeracja ADR nie zgadza się z prawdziwym ADR Logiem
**Zamrożone (`WoodFlow_ADR_Log.md`):** 6 wpisów, ADR-001 do ADR-006.
**U nas:** zacząłem numerację od ADR-019 (przyjmując, że coś już tam
było, bez sprawdzenia) i doszedłem do ADR-024. **Te numery nie
odpowiadają żadnym prawdziwym wpisom w Twoim realnym ADR Logu** —
istnieją tylko w plikach, które stworzyłem w tej rozmowie
(`docs/adr/019-...md` do `024-...md`).
**Poprawka:** przenumerować nasze ADR-019→024 na ADR-007→012 (kolejne
wolne numery w prawdziwym logu) i dopisać je do właściwego
`WoodFlow_ADR_Log.md`, żeby był jeden, spójny rejestr — nie dwa
równoległe.

---

## B. Brakujące byty domenowe (Domain Model Audit)

### B1. Project / Zlecenie — całkowicie nieobecne
**Zamrożone:** pełnoprawny byt od v1.0: `id`, `uuid`, `name`,
`status`, `customer`, `createdAt`. Rezerwacje (PRO) i Furniture
(START) już zakładają powiązanie ze zleceniem — brak tego bytu teraz
oznacza bolesną migrację później (dokładnie ten sam wzorzec problemu
co `operator_name → user_id`).
**U nas:** nie istnieje żaden `Project`. `BoardTransaction`/
`OffcutTransaction` mają pole `note` (wolny tekst), nie referencję do
zlecenia.
**Skala poprawki:** średnia — nowa encja + tabela + FK z Transaction.

### B2. Supplier / Dostawca — całkowicie nieobecny
**Zamrożone:** pełnoprawny byt od v1.0 (nazwa, kontakt, historia
dostaw), nie pole tekstowe.
**U nas:** nie istnieje. Board nie ma żadnego powiązania z
dostawcą/dostawą.
**Skala poprawki:** średnia — nowa encja + tabela.

### B3. Decor — jest polem tekstowym, nie katalogiem globalnym
**Zamrożone:** byt globalny (`decors`), 421 kodów EGGER + Kronospan +
Pfleiderer, współdzielony między organizacjami, z autouzupełnianiem
nazwy po wpisaniu kodu.
**U nas:** `Board.decorCode`/`Offcut.decorCode` to zwykły `String`,
wpisywany ręcznie, bez żadnej tabeli referencyjnej ani walidacji.
**Skala poprawki:** duża — wymaga seeda 421 kodów (masz go już z
poprzedniej wersji aplikacji, `egger_decors_seed.dart`), tabeli
`decors`, i przepięcia `decorCode` z wolnego tekstu na FK.

### B4. Organization / Subscription / Station — brak jakiejkolwiek warstwy
**Zamrożone (ADR-003, Backend Foundation):** Organization jest
korzeniem całej hierarchii (`Organization → Warehouses → ...`), z
Subscription (plan cenowy) i Station (jednostka licencjonowania)
jako częścią szkieletu budowanego od v1.0, w większości wyłączoną.
**U nas:** nie istnieje pojęcie Organization w ogóle — Warehouse jest
dziś najwyższym poziomem hierarchii, bez żadnego "właściciela"
nad nim.
**Skala poprawki:** duża, ale zgodnie z ADR-003 **większość ma być
wyłączona/nieaktywna teraz** — realnie potrzebna jest tylko tabela
`organizations` z jednym domyślnym rekordem i FK z Warehouse, nie
pełny system multi-tenant.

---

## C. Backend Foundation — częściowa zgodność z ADR-003

**Zamrożone (ADR-003):** Authentication, Organizations, Licensing,
API Gateway, UUID, Cloud Storage Interface, Sync abstraction, Feature
flags, Telemetry.

**U nas zbudowane:** UUID (✅, `uuid` package), warstwa błędów/logów/
DI (nie było jawnie wymagane, ale nie koliduje z niczym zamrożonym).

**U nas brakujące:** Authentication, Organizations (patrz B4),
Licensing, API Gateway, Cloud Storage Interface, Sync abstraction,
Feature flags, Telemetry — żadne z tych siedmiu nie ma nawet
szkieletu.

**Ważne — to NIE jest błąd, tylko niedokończony zakres:** ADR-003 mówi
"w większości wyłączony" — więc brak *aktywnej* funkcjonalności jest
zgodny z planem. Brak jest **jakiegokolwiek szkieletu** (nawet pustych
klas/interfejsów oznaczających miejsce na te moduły), co utrudni
późniejsze włączenie bez przebudowy.

---

## D. Rzeczy, które NIE są rozbieżnościami (mylące na pierwszy rzut oka)

### D1. `get_it` zamiast `Provider`
`Technical_Architecture_v1.md` (punkt 4) jawnie oznacza DI jako
**OTWARTE** — "do decyzji przy pierwszym module, który tego wymaga".
Nasz wybór `get_it` (ADR lokalny w tej rozmowie) wypełnia otwartą
decyzję, nie łamie zamrożonej. Nie wymaga zmiany, ale warto dopisać
formalny ADR do prawdziwego logu, żeby ta otwarta pozycja się zamknęła.

### D2. Wzorzec Result<T> / Repository / EventPublisher / atomowe transakcje
`Technical_Architecture_v1.md` (punkt 3) oznacza "Warstwy aplikacji"
jako **OTWARTE**. Cały wzorzec, który zbudowaliśmy w tej rozmowie,
wypełnia tę otwartą decyzję i niczemu zamrożonemu nie przeczy — ale
tak samo jak D1, powinien dostać własny wpis w prawdziwym ADR Logu,
nie żyć tylko w osobnych plikach `docs/adr/`.

### D3. Package name `woodflow` zamiast `offcut_manager`
`Technical_Architecture_v1.md` (punkt 1) potwierdza `offcut_manager`
jako ówczesną nazwę pakietu — ale to było PRZED naszą decyzją o
rebrandzie w tej rozmowie (świadomie odwróconą, udokumentowaną w
`REBRANDING.md`). Nie jest to rozbieżność do naprawienia, tylko nowsza
decyzja nadpisująca starszą — pod warunkiem, że i to trafi jako ADR
do prawdziwego logu.

### D4. Rack/Slot
Brak rozbieżności — ADR-024 (nasza korekta) w pełni zgadza się z
zamrożoną hierarchią `Warehouse → Rack → Slot`.

---

## E. Ogromny brakujący zakres funkcji v1.0 FREE (Katalog Funkcji)

Te funkcje są w zamrożonym katalogu jako część v1.0, a nie dotknęliśmy
ich w ogóle w Slice 1–4:

| Funkcja | Status u nas |
|---|---|
| Zdjęcia materiału (`image_picker`) | ⬜ brak |
| Drukowanie etykiet QR (eksport PDF) | ⬜ brak (mamy tylko generowanie/skan QR) |
| Backup/restore JSON (base64 zdjęcia) | ⬜ brak |
| Wielozakładkowy kalkulator warsztatowy | ⬜ brak |
| Ewidencja rolek okleiny | ⬜ brak |
| Rezerwacje w Digital Warehouse | ⬜ brak |
| Dashboard właściciela + wycena magazynu | ⬜ brak |
| Baza dekorów z cenami (patrz B3) | ⬜ brak |
| Alerty niskiego stanu + lista zakupów | ⬜ brak |
| Eksport PDF/CSV/RTF | ⬜ brak |
| 9 języków + tryb ciemny | ⬜ brak |
| Przeglądarka producentów (WebView) | ⬜ brak |

Dodatkowo z `v1_5_Wycena_i_Magazyn.md` (dokument sam mówi, że to
realnie należy do zakresu v1.0/Etap 1, mimo tytułu "v1.5"):
częściowe wydanie/reszta ścinka, zgłaszanie uszkodzeń, limity
wymiarów lokalizacji, profile eksportu, `InsightsEngine` (6
konkretnych typów podpowiedzi) — żadne z tego nie istnieje u nas.

---

## F. Podsumowanie — trzy kategorie

1. **Do poprawienia od razu, tanio:** terminologia Slot→Półka w UI,
   przeniesienie naszych ADR do prawdziwego logu z właściwą numeracją.
2. **Do dobudowania, średni koszt:** Project, Supplier, Decor jako
   katalog, minimalna tabela Organization (jeden domyślny rekord, nie
   pełny multi-tenant).
3. **Ogromny, świadomie jeszcze nietknięty zakres:** cała reszta
   Katalogu Funkcji v1.0 — to nie jest "naprawa", tylko dalsza
   budowa zgodnie z tym, co i tak było zaplanowane.

**Nie rekomenduję** próby domknięcia wszystkiego naraz. To, co warto
rozstrzygnąć teraz, to kolejność: czy najpierw punkt 1 i 2 (żeby
fundament pod resztę był zgodny z zamrożonym modelem), zanim ruszymy
do punktu 3.
