# Changelog — Offcut Manager

Wszystkie istotne zmiany w projekcie są odnotowywane w tym pliku.
Format wersji: `MAJOR.MINOR.PATCH` (np. v0.1.0).

## [0.3.0] — 2026-07-12

### Dodano
- Pełna, samodzielna kontrola nad strukturą magazynu: użytkownik sam tworzy
  regały (dowolna nazwa) i sloty (dowolna nazwa, np. A1, A2 — bez wymuszonego
  zera wiodącego) wraz z dowolną pojemnością, wprost w ekranie **Lokalizacje**.
- Usunięto automatyczne seedowanie regałów A/B/C × 01–10 — nowa instalacja
  aplikacji startuje z pustym magazynem.
- Nowe akcje w ekranie Lokalizacje: dodawanie regału, dodawanie slotu do
  regału, usuwanie pojedynczego slotu, usuwanie całego regału (z potwierdzeniem).
- Pusty stan z podpowiedzią, gdy nie ma jeszcze żadnej lokalizacji.
- Ekran "Dodaj ścinkę" pobiera listę regałów/slotów dynamicznie z bazy zamiast
  sztywnej listy — pokazuje ostrzeżenie, jeśli nie dodano jeszcze żadnej lokalizacji.
- Nawigacja między zakładkami odświeża dane z bazy przy każdym wejściu (żeby
  nowo dodane lokalizacje były od razu widoczne w formularzu dodawania ścinki).

### Zmiany w bazie danych
- `DatabaseHelper`: dodano `insertLocation`, `deleteLocation`, `deleteRack`,
  `getDistinctRacks`; `updateLocationStatus` zmieniono na ogólniejsze `updateLocation`.

## [0.2.0] — 2026-07-12

### Dodano
- Pełna baza kolorów EGGER (`egger_colours.dart`) wyciągnięta z oficjalnego katalogu
  producenta — ok. 250 dekorów (kod, tekstura, nazwa): Whites & Unis, Wood & Material
  Reproductions, PerfectSense Premium.
- Autouzupełnianie kodu dekoru w ekranie **Dodaj ścinkę** — podpowiedzi z bazy EGGER,
  automatyczne wypełnienie nazwy koloru po wybraniu.
- Link "Zobacz oficjalne zdjęcie na egger.com" przy wybranym dekorze (otwiera stronę
  producenta z podglądem dekoru w przeglądarce).
- Zależność `url_launcher` do otwierania linków zewnętrznych.

### Ograniczenia / decyzja projektowa
- Nie pobrano lokalnych miniatur zdjęć dla wszystkich ~250 dekorów — EGGER przechowuje
  je pod niepowtarzalnymi, losowymi identyfikatorami CDN, których nie da się wyliczyć
  z kodu dekoru. Pobranie realnych zdjęć wymagałoby osobnego zapytania do strony
  każdego dekoru z osobna.
- **Rozwiązanie tymczasowe**: link do oficjalnej strony/zdjęcia zamiast wbudowanej
  miniatury.
- **Następny krok (opcjonalnie)**: jeśli firma używa stałej, ograniczonej listy
  dekorów (np. 15–20 kodów), można dla nich pobrać realne zdjęcia i wbudować
  jako miniatury offline w kolejnej wersji.

## [0.1.0] — 2026-07-12

### Dodano
- Struktura projektu Flutter (`pubspec.yaml`, katalogi `lib/models`, `lib/database`, `lib/screens`, `lib/data`).
- Model danych `Offcut` (ścinka): kod dekoru, nazwa koloru, grubość, długość, szerokość, ilość, regał, slot, status, data dodania, notatki.
- Model danych `StorageLocation` (lokalizacja): regał, slot, pojemność, status.
- Baza SQLite (`sqflite`) z tabelami `offcuts` i `locations`.
- Automatyczne tworzenie domyślnych lokalizacji: regały A/B/C, sloty 01–10, pojemność 20 szt./slot.
- Ekran **Dashboard**: liczba ścinek w magazynie, łączna powierzchnia (m²), podział na regały, top 5 najczęstszych dekorów.
- Ekran **Dodaj ścinkę**: formularz z walidacją, automatycznym ID (autoincrement SQLite), podglądem powierzchni na żywo, wyborem regału/slotu.
- Ekran **Baza ścinek**: lista wszystkich ścinek, wyszukiwanie po kodzie dekoru, nazwie koloru, minimalnej długości/szerokości, usuwanie pozycji.
- Ekran **Lokalizacje**: widok siatki slotów per regał, wskaźnik wypełnienia (zielony/pomarańczowy/czerwony) na podstawie pojemności.
- Startowa baza kolorów EGGER (`egger_colours.dart`) — do rozbudowy w kolejnych wersjach (autouzupełnianie w formularzu).

### Znane ograniczenia
- Brak zdjęć dekorów (planowane w v2.0).
- Brak kodów QR (planowane w v2.0).
- Brak historii zmian per ścinka (planowane w v2.0).
- Baza kolorów EGGER zawiera tylko przykładowe wpisy — pełny katalog do uzupełnienia.

### Następne kroki (v0.2.0 — planowane)
- Edycja istniejącej ścinki (obecnie tylko dodawanie/usuwanie).
- Zmiana statusu ścinki (Dostępna / Zarezerwowana / Zużyta) z poziomu listy.
- Eksport listy ścinek do CSV.
- Rozbudowa bazy kolorów EGGER.

---

## [Unreleased] — Plan v1.0 (pozostałe elementy)
- [x] Dashboard
- [x] Baza ścinek
- [x] Lokalizacje A/B/C
- [x] Automatyczne ID
- [x] Wyszukiwanie po kodzie dekoru
- [x] Wyszukiwanie po nazwie
- [x] Wyszukiwanie po wymiarach
- [x] Automatyczne liczenie powierzchni
- [x] Zarządzanie pojemnością lokalizacji
- [x] Baza kolorów EGGER (szkielet, do rozbudowy)
