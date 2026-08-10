# ADR: Smart Offcut Scoring Engine — silnik oceny ścinków (v2.x → v3.0 AI)

## Status
Zaakceptowane jako długoterminowy kierunek produktowy — **nie
zaimplementowane**. Nie jest częścią żadnego Kroku obecnej roadmapy Etapu 1
ani zakresu Kroku 14 (AI v1, deterministyczny parser zapytań NL — patrz
`docs/CHANGELOG.md`). Do przeglądu dopiero po ukończeniu Etapu 1, razem z
resztą backlogu (`docs/BACKLOG.md`).

## Kontekst
Firmy stolarskie/meblarskie magazynują setki lub tysiące ścinków, ale nie
mają dziś obiektywnego sposobu oceny, które z nich warto zatrzymać, a które
tylko zajmują cenną przestrzeń magazynową. Decyzje "zatrzymać czy wyrzucić"
zapadają dziś na podstawie doświadczenia/intuicji operatora, nie danych —
mimo że dane te (Ledger, historia QR, historia inwentarza) już istnieją lub
będą istnieć w systemie.

## Decyzja
Trzyetapowa ścieżka, każdy etap świadomie odseparowany od poprzedniego:

- **v1.0 (FREE, dzisiejszy zakres)** — brak scoringu. Wyłącznie zbieranie
  danych historycznych przez istniejący Ledger, system QR i historię
  inwentarza; rejestrowanie akcji operatora, by mogły posłużyć później.
  Zero nowej logiki decyzyjnej w tym etapie.
- **v2.x** — deterministyczny Scoring Engine oparty o konfigurowalne reguły
  biznesowe, bez uczenia maszynowego. Silnik liczy wynik (np. 0–100) z
  ważonych reguł, klasyfikując ścinek jako Keep / Review / Scrap. **Wynik
  jest zawsze tylko rekomendacją — ostateczna decyzja zawsze należy do
  operatora**, silnik nigdy nie usuwa/blokuje ścinka samodzielnie.
- **v3.0 AI** — rozszerzenie deterministycznego silnika o uczenie się z
  historycznych decyzji operatorów, porównujące rekomendację silnika,
  faktyczną decyzję operatora i rzeczywisty wynik (np. "silnik rekomendował
  Scrap, operator zatrzymał, dwa tygodnie później ścinek został użyty" →
  silnik uczy się, że ta rekomendacja była błędna).

**Kluczowa decyzja architektoniczna, obowiązująca od v2.x:** reguły i wagi
scoringu nigdy nie mogą być zahardkodowane. Każda firma pracuje inaczej —
silnik musi być w pełni konfigurowalny (czynniki, wagi, progi, reguły
rekomendacji) bez zmiany kodu aplikacji.

Przykładowe (nie ostateczne, do przyszłej dyskusji) czynniki scoringu:
wymiary ścinka, typ materiału, dekor, grubość, koszt materiału, wiek, zajęta
przestrzeń magazynowa, częstotliwość ponownego użycia podobnych ścinków,
historyczny popyt, przyszły popyt produkcyjny, zajętość magazynu, reguły
specyficzne dla firmy.

**Przyszła pętla zwrotna (v3.0):** system docelowo przechowuje score,
rekomendację, decyzję operatora i faktyczny wynik — te dane stają się
danymi treningowymi dla przyszłych wersji AI.

**Przyszła integracja z Dashboardem:** silnik może docelowo zasilać insighty
magazynowe (wartościowe ścinki, ścinki do przeglądu, ścinki rekomendowane do
utylizacji, szacowana odzyskiwalna przestrzeń, szacowana zachowana wartość
inwentarza) — to rozszerzenie `DashboardService`, nie nowa równoległa ścieżka
dostępu do danych, zgodnie z tą samą granicą architektoniczną co Krok 14.

## Konsekwencje
**Plusy:**
- v1.0 zaczyna wyłącznie od zbierania danych, zero ryzyka architektonicznego
  dziś — nie blokuje ani nie komplikuje Kroku 14 czy żadnego kroku Etapu 1.
- Deterministyczny silnik v2.x jest w pełni wyjaśnialny i testowalny, zanim
  jakakolwiek logika ucząca się w ogóle wejdzie w grę — naturalny fundament
  pod przyszłe "Confidence Level"/"Explain AI" (`docs/BACKLOG.md`).
- Konfigurowalność reguł/wag od v2.x oznacza, że różne firmy o różnych
  priorytetach (np. koszt materiału vs. czas magazynowania) nie wymagają
  osobnych wersji aplikacji.

**Minusy / kompromisy:**
- Konfigurowalny silnik reguł (czynniki/wagi/progi bez zmiany kodu) to
  istotnie więcej pracy inżynieryjnej niż zahardkodowana heurystyka — świadomy
  koszt w zamian za realną użyteczność dla firm o różnych priorytetach.
- Pętla zwrotna v3.0 (rekomendacja → decyzja → wynik) wymaga długoterminowego
  gromadzenia danych zanim jakikolwiek model uczący się będzie miał czym się
  uczyć — wartość tego etapu materializuje się z opóźnieniem, nie od razu.

## Alternatywy rozważane
- **Od razu ML/AI zamiast etapu deterministycznego (v2.x pominięty)** —
  odrzucone: brak wyjaśnialności, brak danych treningowych na starcie
  (v1.0 dopiero je zbiera), i sprzeczne z zasadą projektu, by nie wprowadzać
  logiki predykcyjnej/uczącej się bez zweryfikowanych danych do nauki (ta
  sama zasada, która ograniczyła zakres Kroku 14 do czystego, deterministycznego
  parsera).
- **Zahardkodowane reguły/wagi zamiast konfigurowalnych** — odrzucone
  wprost jako "krytyczna decyzja architektoniczna": różne firmy stolarskie
  mają różne priorytety, jeden sztywny zestaw wag nie uogólnia się na cały
  rynek docelowy WoodFlow.
