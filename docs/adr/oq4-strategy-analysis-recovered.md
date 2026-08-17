# OQ4 — ANALIZA STRATEGII A–F (ODTWORZONA)

**Status:** ODTWORZONE Z POPRZEDNIEJ SESJI — nie było wcześniej zapisane w repozytorium  
**Źródło:** analiza Claude Code z sesji 2026-08-12/13, odtworzona z zapisu rozmowy  
**Dotyczy:** Open Question 4 — `exceedsUsefulThreshold`  
**Last Updated:** 2026-08-17

---

## ⚠️ OSTRZEŻENIE O POCHODZENIU

Ten dokument **nie jest** zapisem, który istniał wcześniej w repozytorium.

Analiza A–F została przeprowadzona przez Claude Code w poprzedniej sesji, ale jej **wynik nigdy nie trafił do repo** — zapisano wyłącznie decyzję końcową (Strategia D jako blokada Phase A), bez uzasadnienia i bez odrzuconych alternatyw.

Ten dokument odtwarza tamtą analizę z zapisu rozmowy, żeby uzasadnienie decyzji nie zależało od pamięci sesji AI.

**Etykiety „Strategia A–F" nie występują nigdzie w kanonicznej specyfikacji.** Były roboczym nazewnictwem tamtej analizy.

---

## 1. PYTANIE, NA KTÓRE ODPOWIADAŁA ANALIZA A–F

> Jak `exceedsUsefulThreshold` ma się zachowywać w Phase A, **zanim** OQ4 zostanie formalnie rozstrzygnięte?

To jest pytanie o **tymczasowe zachowanie w okresie przejściowym** — nie o docelową architekturę.

---

## 2. MACIERZ STRATEGII A–F

| # | Oryginalna nazwa | Znaczenie |
|---|---|---|
| **A** | *fixed interim default: always `false`* | Żaden leftover nigdy nie zostaje uznany za użyteczny → wszystko traktowane jako odpad |
| **B** | *fixed interim default: always `true`* | Każdy leftover, nawet drzazga, staje się trwałym Offcutem |
| **C** | *computed against a placeholder numeric threshold* | Tymczasowa, arbitralna stała liczbowa wybrana bez zgody Product Ownera |
| **D** | *block Phase A entirely until OQ4 is resolved* | Phase A nie startuje do czasu formalnego rozstrzygnięcia |
| **E** | *structural deferral (schema change)* | Zmiana schematu `CutPlacement` — pole nullable / przeniesienie decyzji |
| **F** | *move evaluation to execution time (Phase C)* | Próg oceniany dopiero przy wykonaniu, nie przy planowaniu |

---

## 3. DLACZEGO ODRZUCONO A, B, C

### Strategia A — zawsze `false`

Przez cały okres otwarcia OQ4 **żaden offcut nigdy nie zostałby zachowany**. To działa bezpośrednio przeciw celowi produktu zapisanemu w Section 1 („minimize wasted panel material").

Nowe założenie produktowe: *„Żaden leftover, niezależnie od wielkości, nie jest wart zachowania."* — to realny wybór biznesowy, nie neutralny domyślny.

### Strategia B — zawsze `true`

Każdy leftover, w tym drzazgi, staje się trwałym rekordem magazynowym. Zaśmieca listy Offcutów, silnik AI (Krok 14), Dashboard i Shopping List danymi bez wartości użytkowej.

Nowe założenie produktowe: *„Każdy leftover, niezależnie od wielkości, jest wart trzymania jako realny zapas."*

### Strategia C — tymczasowy próg liczbowy ⚠️

**To jest strategia, którą łatwo pomylić z obecną opcją „fixed constant" — a to nie to samo.**

Powód odrzucenia:

> Tworzy **realne, trudne do cofnięcia dane magazynowe** (rekordy Offcut, wpisy Ledger) na podstawie **niezatwierdzonej liczby**.

Mechanizm problemu: ledger jest append-only (Ch. 20.6 — archive-not-delete). Jeśli OQ4 zostanie później rozstrzygnięte na inną wartość, wszystkie już wykonane `CuttingJob` będą zawierać zapisane wartości `exceedsUsefulThreshold` obliczone wobec starej, tymczasowej liczby — a historii nie można po cichu przepisać. Powstaje potrzeba osobnego mechanizmu korekty, którego żadna sekcja nie przewiduje.

Analiza określiła C jako **najbardziej konsekwentną z trzech „stałych" strategii (A/B/C)**, właśnie dlatego, że tworzy nieodwracalne dane.

### Strategie E i F

- **E** — wymaga zmiany schematu `CutPlacement` (obecnie non-nullable `bool`) przed startem Phase A; nie rozwiązuje pytania, tylko przesuwa je do Phase C
- **F** — bezpośrednio sprzeczna z Section 6 linia 521 („`exceedsUsefulThreshold` is evaluated and recorded at planning time"); wymagałaby edycji już zatwierdzonej specyfikacji

---

## 4. DLACZEGO WYBRANO D

> **Jedyna strategia wymagająca zera niezatwierdzonych założeń produktowych/behawioralnych.**

Każda inna opcja albo (a) wprowadza nowe zachowanie widoczne dla użytkownika, którego nikt nie zatwierdził, albo (b) zmienia harmonogram, albo (c) wymaga edycji już zacommitowanych sekcji specyfikacji.

D po prostu **czeka**.

**Świadomie zaakceptowany koszt:** największy wpływ na harmonogram ze wszystkich sześciu opcji — tabela faz w Section 10 jest ściśle sekwencyjna (B zależy od A, C od A+B, D od A+B+C, E od D), więc zablokowanie Phase A blokuje całą implementację Kroku 15.

---

## 5. ⚠️ NAJWAŻNIEJSZE ROZRÓŻNIENIE

**Strategia C ≠ obecna opcja „fixed constant".**

| | Strategia C (odrzucona) | „Fixed constant" (opcja OQ4) |
|---|---|---|
| Czym jest | tymczasowa obejściówka | zatwierdzona wartość docelowa dla v1 |
| Kto wybiera wartość | nikt — arbitralna | Product Owner, jawnie |
| Cel | ruszyć dalej przed rozstrzygnięciem OQ4 | **rozstrzygnąć** OQ4 |
| Problem z ledgerem | tak — niezatwierdzona liczba w nieodwracalnych danych | nie — wartość jest zatwierdzona |

**Wniosek:** wybór „fixed constant" jako odpowiedzi na OQ4 **nie jest** powrotem do odrzuconej Strategii C i **nie narusza** Strategii D.

To są odpowiedzi na dwa różne pytania:
- **Strategia D** → *kiedy* Phase A może się zacząć (spec, linie 913-919) — **potwierdzona**
- **OQ4** → *gdzie żyje wartość progu* (spec, linie 906-908) — **nadal otwarte**

---

## 6. STAN OBECNY

| Element | Status |
|---|---|
| Strategia D | **POTWIERDZONA** — Phase A zablokowana do rozstrzygnięcia OQ4 |
| OQ4 | **OTWARTE** — trzy opcje: Settings value / per-decor value / fixed constant |
| Wartość progu | **NIEZATWIERDZONA** — żadna liczba nie została wybrana |
| Implementacja | **BRAK** — zero kodu Cut Optimizera w `lib/` |

---

## 7. CO POZOSTAJE DO ROZSTRZYGNIĘCIA

Product Owner musi wybrać, **gdzie żyje wartość progu**:

| Opcja | Blokuje Phase A? | Złożoność | Główna konsekwencja |
|---|---|---|---|
| Settings value | tak, tranzytywnie | najwyższa | ekran Settings nie ma zakresu — zależność od niezbudowanej funkcji |
| Per-decor value | tak, tranzytywnie | średnia | wymaga najpierw decyzji o schemacie Decor + migracji |
| Fixed constant | nie | najniższa | wymaga zatwierdzenia konkretnej liczby |

Wybór opcji **nie jest** tożsamy z wyborem wartości — przy „fixed constant" potrzebna jest osobno zatwierdzona liczba.

---

*Copyright © 2026 Piotr Dobrowolski. Wszystkie prawa zastrzeżone.*  
*WoodFlow™ i cała powiązana dokumentacja są chronione prawem autorskim.*

---

**Piotr Dobrowolski**  
Product Owner — WoodFlow
