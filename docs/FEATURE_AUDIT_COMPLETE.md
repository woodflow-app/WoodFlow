# WoodFlow — Audyt kompletności: Katalog Funkcji vs Prototyp vs Kod

Źródło: `WoodFlow_Katalog_Funkcji.md` (zamrożony, jedyne źródło prawdy).
Cel: znaleźć KAŻDĄ funkcję pominiętą w prototypie, zanim zaczniemy
budować dalej, żeby uniknąć pomyłek.

**Legenda:** ✅ jest w prototypie | ⬜ BRAK w prototypie | 🔴 błędnie
umieszczone w złej wersji w prototypie | 💻 istnieje w prawdziwym kodzie

---

## v1.0 / FREE — Fundament (19 grup funkcji w dokumencie, prototyp miał ~6)

| # | Funkcja (dokładna nazwa z katalogu) | Status |
|---|---|---|
| 1 | Lista ścinków z pełnym CRUD | ⬜ (tylko lista Offcut bez edycji/usuwania pokazana) |
| 2 | **Zdjęcia materiału** | ⬜ **całkowicie brak** |
| 3 | Skanowanie QR **+ etykiety QR (eksport PDF do druku)** | ✅ skan, ⬜ druk etykiet |
| 4 | Historia zmian z przypisaniem operatora (i18n neutralnie) | ✅ (Ledger) |
| 5 | **Backup i przywracanie (JSON + zdjęcia base64)** | ⬜ **całkowicie brak** |
| 6 | Wielozakładkowy kalkulator | ✅ |
| 7 | Ewidencja rolek okleiny (wzór przekroju pierścieniowego) | ⬜ brak (kalkulator miał tylko przeliczenie mb, nie śledzenie stanu rolki) |
| 8 | Widok regał/slot **z rezerwacją pod zlecenie** | ✅ siatka, ⬜ **rezerwacja całkowicie brak** |
| 9 | Panel właściciela: wycena magazynu i oszczędności | ✅ częściowo (Dashboard) |
| 10 | **Magazyn materiałów (nie tylko ścinki — pełne płyty, okucia, akcesoria, min/optimum)** | ⬜ **brak — pokazałem tylko Board/Offcut, nie okucia/akcesoria** |
| 11 | **Tryb Operator vs Command Center (dwa widoki interfejsu)** | ⬜ **całkowicie brak, nigdzie nie pokazane** |
| 12 | Baza dekorów 421 kodów z **autouzupełnianiem** | ⬜ brak (dekor jako wolny tekst, nie katalog z autocomplete) |
| 13 | **Przeglądarka producentów (WebView)** | ⬜ **całkowicie brak** |
| 14 | **Prosty asystent zapytań (Logic Engine, PL NL)** | ⬜ **całkowicie brak** |
| 15 | **Data Quality Score (podstawowa, jawna formuła 20%×5)** | ⬜ **całkowicie brak** |
| 16 | Eksport PDF/CSV/RTF | ⬜ brak (nie pokazany żaden ekran eksportu) |
| 17 | Stan wg kolorów, lista zakupów, alerty niskiego stanu | ⬜ brak (tylko jedna linijka w Dashboard) |
| 18 | Przypomnienie o synchronizacji z Cabinet Vision | ⬜ brak |
| 19 | Ustawienia: 9 języków, tryb ciemny | ✅ (pokazane 2 z 9 języków, ale infrastruktura jasna) |

**Realnie w kodzie dziś (💻):** tylko Warehouse, Rack, Slot, Board —
czyli fundament pod #1, #8, #10 (częściowo), nic więcej z tej listy.

---

## v1.5 / START — Kreator mebli, dostawy, Smart Finder

| # | Funkcja | Status |
|---|---|---|
| 1 | **Skan dokumentu dostawy (OCR) + import PDF** | ⬜ **całkowicie brak** |
| 2 | **Paleta jako obiekt magazynowy** | ⬜ **całkowicie brak** |
| 3 | **Rekomendacja lokalizacji przy odkładaniu (z uzasadnieniem)** | ⬜ **całkowicie brak** |
| 4 | **Smart Material Finder (jedna wyszukiwarka płyty+ścinki)** | ⬜ **całkowicie brak** |
| 5 | Silnik parametryczny mebli (Szafka/Wnęka/Komoda presety) | ✅ |
| 6 | Automatyczna lista elementów + podgląd 2D + PDF | ✅ |
| 7 | Historia projektów + biblioteka szablonów | ✅ |
| 8 | **Tryb stanowiska (Piła/CNC/Magazyn/Biuro) — do 3 urządzeń** | 🔴 **umieściłem to błędnie w v2.5, a to jest v1.5** |

---

## v2.0 / PRO — Integracja z ekosystemem

| # | Funkcja | Status |
|---|---|---|
| 1 | **Cut Optimizer (best-fit+shelf-packing, kerf, słoje, resztki)** | 🔴 **umieściłem to błędnie w v3.5 — Cut Optimizer zaczyna się w v2.0, w v3.5 tylko rozszerza się na CAŁY magazyn zamiast jednego zlecenia** |
| 2 | **Decision Engine — rekomendacje kontekstowe (reguły, nie AI)** | ⬜ **brak — pomyliłem to z AI v2 z v3.0** |
| 3 | WoodFlow Integration Hub (CV, TopSolid, SketchUp, AlphaCAM) | ✅ częściowo (tylko CV pokazane) |
| 4 | **Public API dla ERP** | ⬜ **całkowicie brak** |
| 5 | **Role i uprawnienia PER STANOWISKO (nie per osoba — to dopiero BUSINESS)** | ⬜ brak, i pomieszane z v2.5 w prototypie |

---

## v2.5 / BUSINESS — Praca zespołowa

| # | Funkcja | Status |
|---|---|---|
| 1 | Pełne konta użytkowników + audit log per osoba (do 30 stanowisk) | ✅ częściowo, ale **pomieszane z rolami per-stanowisko z PRO** |
| 2 | Synchronizacja wielu telefonów **i lokalizacji (multi-warehouse)** | ✅ częściowo (tylko sync urządzeń, nie multi-magazyn) |
| 3 | Licencjonowanie po aktywnych stanowiskach, nie sprzęcie | ⬜ nie wytłumaczone w prototypie |

---

## v3.0 / AI — Inteligentne rekomendacje

| # | Funkcja | Status |
|---|---|---|
| 1 | AI v2 — rekomendacje z historii zużycia (`inventory_transactions`) | ✅ (2 karty) |
| 2 | Wyjaśnialność — **w tym uczciwe "za mało danych"** | ⬜ pokazałem tylko "dlaczego", nie pokazałem przypadku "za mało danych, wróć za 2 tygodnie" |
| 3 | **Productivity Suite: AI Work Assistant "Znajdź zadanie" (Quick Wins)** | ⬜ **całkowicie brak** |
| 4 | **Productivity Dashboard + Time Utilization** | ⬜ **całkowicie brak** |
| 5 | **Data Quality Score — warstwa przyczynowa** | ⬜ **całkowicie brak** |
| 6 | **Panel kierownika — fakty per pracownik, bez rankingu** | ⬜ **całkowicie brak** |

---

## v3.5 / ENTERPRISE

| # | Funkcja | Status |
|---|---|---|
| 1 | Cut Optimizer rozszerzony na CAŁY magazyn (nie jedno zlecenie) | ✅ (ale patrz uwaga wyżej — to nie jest wprowadzenie Cut Optimizera, tylko jego rozszerzenie) |
| 2 | Terminale przemysłowe, stanowiska bez limitu | ⬜ brak (mniej krytyczne — to bardziej kwestia licencji niż ekranu) |

---

## Najważniejsze poprawki do zapamiętania na przyszłość

1. **Cut Optimizer to v2.0/PRO, nie v3.5** — w v3.5 tylko się rozszerza na cały magazyn.
2. **Tryb stanowiska (Piła/CNC/Magazyn/Biuro) to v1.5/START**, nie v2.5.
3. **Role per-stanowisko (v2.0/PRO) ≠ pełne konta per-osoba (v2.5/BUSINESS)** — to dwa różne poziomy, pomieszałem je.
4. **v1.0 ma dużo więcej niż pokazałem** — zwłaszcza: zdjęcia, backup, tryb Operator/Command Center, asystent NL, Data Quality Score, przeglądarka producentów, magazyn materiałów ogólnych (nie tylko płyty/ścinki).

## Rekomendacja

Ten dokument to teraz najbardziej wiarygodna checklista do budowy —
dokładniejsza niż sam prototyp. Zanim rozbuduję prototyp o te
wszystkie brakujące ekrany (to dużo pracy), pytanie do Ciebie: czy
wolisz, żebym (a) rozbudował prototyp o wszystkie brakujące funkcje,
żeby zobaczyć całość wizualnie, czy (b) używał tej checklisty
bezpośrednio jako listy kontrolnej przy budowie prawdziwego kodu,
funkcja po funkcji, bez dodatkowego mockupowania każdej z nich.
