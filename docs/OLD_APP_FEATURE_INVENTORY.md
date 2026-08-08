# Offcut Manager / WoodFlow — funkcje sprzed rebuildu

Zebrane z historii wszystkich sesji sprzed obecnego "Backend
Foundation" (Warehouse → Board → Offcut → Ledger). To jest inwentarz
tego, co REALNIE istniało i działało w starej aplikacji — nie plan,
nie koncepcja.

## Fundament (v0.8.0 i wcześniej)

- Wielokategoryjny system katalogów
- 9 języków interfejsu (pliki ARB, `LocaleProvider` + `SharedPreferences`)
- Pełna warstwa SQLite z wersjonowanymi migracjami
- Baza dekorów EGGER (421 zweryfikowanych kodów) + Kronospan + Pfleiderer
- Motyw Material 3: forest green (#1F4B3F) / amber (#C98A3B)
- Wielozakładkowy kalkulator warsztatowy: powierzchnia, metry okleiny,
  przeliczanie jednostek, wycena z VAT
- Śledzenie rolek okleiny (wzór na przekrój pierścieniowy rolki)
- Alerty o niskim stanie + lista zakupowa
- Eksport raportów: CSV, PDF, RTF
- Drukowanie etykiet QR

## v0.9.0 — QR, zdjęcia, backup, historia

- Skanowanie QR/kodów kreskowych (`mobile_scanner`, `qr_flutter`)
- Zdjęcia ścinków z aparatu (`image_picker`)
- Pełny backup/restore do JSON z zdjęciami zakodowanymi w base64 (`file_picker`)
- Historia zmian z przypisaniem operatora (kto, kiedy, co)

## v0.9.1 — Dashboard właściciela

- Wycena magazynu: cena/m² per kolor, całkowita wartość zapasu
- Miesięczne oszczędności z użytych ścinków
- Wykrywanie zalegających ścinków (>1 rok bez ruchu)
- Konfigurowalny symbol waluty

## v0.9.2 — AI Cut Optimizer

- Algorytm best-fit + shelf-packing (jawnie opisany jako heurystyka,
  NIE prawdziwe AI/ML)
- Konfigurowalne wymiary płyty
- **Rozszerzenia później:** szerokość rzazu/kerf (domyślnie 3.2mm),
  ograniczenia kierunku słojów, grupowanie po grubości, automatyczne
  tworzenie nowych ścinków z reszty po rozkroju
- **Planowane, może nie zaimplementowane:** tryb "Zero Waste"
  (sugestia "nie otwieraj nowej płyty")

## v0.9.3 — Magazyn cyfrowy (Rack/Slot) ⭐ TO JEST TO, CZEGO SZUKAMY

- Siatka regał/slot z paskami zapełnienia (fill-ratio bars)
- Kliknięcie w slot pokazuje jego zawartość (`SlotContentsScreen`)
- `LocationsScreen` — zarządzanie regałami i slotami:
  - `_addRackDialog` — dodawanie nowego regału
  - dodawanie slotu w regale z polem pojemności (`capacity`)
  - usuwanie slotu z potwierdzeniem (przypisane ścinki NIE są usuwane)
  - usuwanie całego regału z potwierdzeniem (usuwa wszystkie sloty)
- **Wymóg biznesowy ze starej appki:** nie dało się dodać ścinka bez
  wcześniejszego zdefiniowania przynajmniej jednego regału i slotu —
  komunikat blokujący: *"Brak zdefiniowanych lokalizacji. Przejdź do
  zakładki Lokalizacje i dodaj przynajmniej jeden regał i slot,
  zanim dodasz ścinkę."*
- System rezerwacji: pole `reservedFor`, numer zlecenia, dialog
  potwierdzenia chroniący zarezerwowane ścinki przed przypadkowym
  użyciem

## v0.9.4 — Asystent AI (rules-based, PL)

Parser zapytań w naturalnym języku polskim, oparty o reguły (nie ML):
- "Czy mam ścinkę na element 820×460 H3303?"
- "Ile mam U702 ST9?"
- "Gdzie jest H3303?"

## v0.9.5 — Naprawa i18n w historii

Wpisy historii przechowywane neutralnie (bez języka), tłumaczone
dopiero przy wyświetlaniu:
`ADD|ilość|długość|szerokość`, `QTY|poprzednia|nowa`,
`STATUS|poprzedni|nowy|zarezerwowanyDla`, `EDITED`, `DEL|ilość`

## v0.9.6 — Naprawy zależności + rozszerzenie Cut Optimizer

- Naprawa konfliktu wersji `intl` (^0.19.0 → ^0.20.2)
- Rozszerzenie Cut Optimizera jak wyżej (kerf, słoje, reszty)

## UI — karty listy ścinków (redesign)

- Zaokrąglone rogi, kolorowe odznaki statusu (zielony/pomarańczowy/
  szary = dostępny/zarezerwowany/użyty)
- Wyświetlanie kodu koloru, lokalizacji z ikoną pinezki, miniatury zdjęć
- Automatyczne wyświetlenie etykiety QR zaraz po dodaniu nowego ścinka

## Ustawienia

- 9 języków interfejsu
- Tryb ciemny

## Planowane dalej (Fazy 5-11 z planu, status: częściowo/w całości niezrealizowane)

- Faza 5: numer zlecenia w atrybucji historii
- Faza 6: najczęściej używane dekory, oszczędności w tym miesiącu
- Faza 10: integracja z drukarkami etykiet (QR + wymiary/dekor/data/
  lokalizacja na naklejce)
- Faza 11: finalne ustawienia i polerowanie

### Poza zasięgiem samej apki mobilnej (osobny, przyszły projekt)
- Wtyczka do Cabinet Vision / AlphaCAM / WoodWOP / Cut Rite / IntelliDivide
- Bezpośrednia integracja z CNC Anderson GS-710 (auto-zapis ścinków
  po zakończeniu programu)

---

## Co z tego przenosimy do nowej architektury (Warehouse/Board/Offcut/Ledger)

| Stara funkcja | Status w nowej architekturze |
|---|---|
| Rack/Slot (Magazyn cyfrowy) | ⬜ **Budujemy teraz — Slice 4** |
| QR skanowanie/generowanie | ✅ Gotowe (Board + Offcut) |
| Historia zmian z atrybucją | ✅ Gotowe jako Ledger (append-only), bez `userId` na razie |
| Backup/restore JSON | ⬜ Nie zaczęte |
| Zdjęcia ścinków | ⬜ Nie zaczęte |
| Dashboard właściciela / wycena | ⬜ Nie zaczęte |
| AI Cut Optimizer | ⬜ Nie zaczęte (Slice 3 to ręczna operacja cięcia, nie optymalizacja) |
| Asystent AI | ⬜ Nie zaczęte |
| System rezerwacji | ⬜ Nie zaczęte — naturalnie pasowałby do Rack/Slot (Slice 4) |
| Multi-tab kalkulator warsztatowy | ⬜ Nie zaczęte |
| Raporty CSV/PDF/RTF | ⬜ Nie zaczęte |
| 9 języków / dark mode | ⬜ Nie zaczęte |
