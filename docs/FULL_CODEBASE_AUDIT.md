# WoodFlow — Pełny audyt całości (przed naprawami)

Sprawdzone: migracje, encje, repozytoria, service locator, nawigacja
UI, testy, dokumentacja. Poniżej WSZYSTKO znalezione, w kolejności
ważności — nic jeszcze nie naprawione.

---

## 🔴 KRYTYCZNE

### 1. Nie istnieje `pubspec.yaml`
Cały projekt używa pakietów (`sqflite`, `uuid`, `get_it`,
`mobile_scanner`, `sqflite_common_ffi`, `path`) — ale nigdzie nie ma
pliku deklarującego te zależności. **Kod się nie skompiluje.** To nie
jest nowy błąd — nigdy tego pliku nie stworzyliśmy, mimo wielu
godzin pisania kodu Dart.

### 2. Nie istnieje `main.dart` — aplikacja nie ma punktu wejścia
Usunięty przy resecie do zamkniętej roadmapy, nigdy nie odtworzony.
Potwierdzone: `grep "void main()\|runApp("` w całym `lib/` — zero
wyników. Wszystko, co zbudowaliśmy (Warehouse→Offcut→QR), nie da się
uruchomić, bo nic nie wywołuje `WarehouseListScreen` jako pierwszego
ekranu.

### 3. Brak nawigacji z listy Board/Offcut w `SlotDetailScreen` do ich ekranów szczegółów
`ListTile` dla płyty i ścinka w `SlotDetailScreen` **nie mają
`onTap`**. Można dotrzeć do `BoardDetailScreen`/`OffcutDetailScreen`
WYŁĄCZNIE przez skan QR — normalną nawigacją dotknięciem elementu
listy nie da się tam dojść wcale. To odwraca sytuację z poprzedniego
audytu (Warehouse→Rack) — tam brakowało nawigacji zwykłej, tu
brakuje jej gdzie indziej.

---

## 🟡 ŚREDNIE

### 4. `README.md` opisuje architekturę usuniętą przy resecie
Cały plik to opis "Slice 3: Cut Operation" i "ADR-023" —
`CutBoardUseCase`, który **nie istnieje w kodzie od dawna**.
Ktokolwiek otworzy README, dostanie fałszywy obraz projektu.

### 5. Osierocony plik `lib/core/services/support_contact.dart`
Zależy od `device_info_plus`, `package_info_plus`, `url_launcher` —
ale nic go nie importuje (ekran `SettingsScreen`, który go używał,
usunięty przy resecie). Martwy kod + trzy niepotrzebne zależności.

### 6. `organization_id` na `warehouses` bez `REFERENCES`
Wszystkie inne FK w projekcie mają jawne `REFERENCES tabela (id)`.
`organization_id` (dodane przez `ALTER TABLE` w v3) tego nie ma —
niekonsekwencja dokumentacyjna. Potwierdzone przy tej okazji:
`PRAGMA foreign_keys` nigdy nie jest włączone w całym projekcie, więc
żaden FK nie jest faktycznie wymuszany przez SQLite — to świadome
(walidacja po stronie repozytoriów), ale warto to nazwać wprost, nie
zostawiać domyślnym zachowaniem.

---

## 🟢 SPRAWDZONE I W PORZĄDKU

- **Migracje v1-v6**: kompletne, bez dziur, `dbVersion=6` zgodne z
  ostatnią migracją, wszystkie FK odwołują się do tabel istniejących
  wcześniej lub w tej samej migracji.
- **Interfejsy repozytoriów vs implementacje**: liczba metod się
  zgadza (różnice to tylko metody dziedziczone z `BaseRepository`).
- **Service locator**: wszystkie 7 repozytoriów + `QrResolver`
  zarejestrowane, zależności między nimi poprawne.
- **Łańcuch nawigacji Warehouse→Rack→Slot**: w pełni podłączony
  (`RackListScreen→SlotGridScreen→SlotDetailScreen`).
- **3 pozostałe ADR** (`get_it`, `MigrationRunner`, `Result<T>`) —
  wciąż aktualne, opisują niezmienione decyzje Backend Foundation.
- **QR (7.1+7.2)**: sprawdzony w poprzedniej rundzie code review,
  bez zmian od tamtej pory.

---

## Plan naprawy (w tej kolejności)

1. `pubspec.yaml` — bez tego nic innego nie ma znaczenia
2. `main.dart` — punkt wejścia + minimalna nawigacja startowa
3. `onTap` na Board/Offcut w `SlotDetailScreen`
4. Usunięcie `support_contact.dart`
5. `REFERENCES organizations (id)` w migracji v3
6. Przepisanie `README.md`
