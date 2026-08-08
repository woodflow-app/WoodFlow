# WoodFlow — Krok 7.2: Skanowanie (QR działa od początku do końca)

## Zasada "Launch Gate" (przyjęta)

Nowa funkcja nie zaczyna się, dopóki poprzednia nie działa od
początku do końca. QR (Krok 7) = 7.1 (generowanie) + 7.2 (skanowanie)
+ 7.3 (etykiety PDF). Dopiero po 7.3 przechodzimy do Kroku 8
(Historia).

## Architektura (dokładnie jak ustalono)

```
ScanScreen → MobileScanner → QrResolver.resolve(code) → Repository → ekran
```

Zero `if (code.startsWith('WF-B'))` rozsianego po UI — cały
przełącznik typu żyje w jednym miejscu (`QrResolver`), a wynik to
`sealed class QrResolution` (5 wariantów Found + `QrNotFound`), więc
kompilator pilnuje wyczerpującego `switch` w UI.

## Nowe pliki

```
domain/services/qr_resolution.dart  → sealed QrResolution (Warehouse/Rack/
                                        Slot/Board/OffcutFound, QrNotFound)
domain/services/qr_resolver.dart    → jedyny punkt dyspozycji, dispatch
                                        po literze typu z "WF-{L}-..."
presentation/scan/scan_screen.dart  → kamera (mobile_scanner) + switch
                                        po QrResolution + nawigacja
presentation/board/board_detail_screen.dart   → NOWY (nie istniał od
                                        resetu) — QR, dekor, lokalizacja
                                        (getFullLocation), historia,
                                        przenieś/archiwizuj
presentation/offcut/offcut_detail_screen.dart → NOWY, analogicznie
                                        (lokalizacja liczona ręcznie
                                        Slot→Rack→Warehouse — Offcut
                                        nie ma jeszcze własnego
                                        getFullLocation)
test/qr_resolver_test.dart          → 9 testów: wszystkie 5 typów,
                                        kod nieznany, format zły,
                                        litera nieznana, whitespace
```

## UX "nie znaleziono" — zgodnie z Twoją specyfikacją

Nigdy suchy komunikat. Zamiast tego: *"Ten kod nie istnieje lub
został usunięty"* + dwa przyciski: **Skanuj ponownie** / **Wyszukaj
ręcznie**. Uczciwie: "Wyszukaj ręcznie" dziś tylko wraca do
poprzedniego ekranu — prawdziwa wyszukiwarka (Smart Material Finder)
to dopiero v1.5/START, nie ma jej jeszcze.

## Znaleziony i naprawiony błąd sprzed tej wiadomości

`WarehouseListScreen` **w ogóle nie miała podłączonej nawigacji** z
karty magazynu do listy regałów (`onTap` nie istniał). To nie był
błąd wprowadzony teraz — istniał od czasu resetu. Naprawiony przy
okazji, bo bez tego "QR działa od początku do końca" byłoby
nieprawdą — QR prowadziłby do ekranu, do którego zwykłą nawigacją
nie dało się dojść wcale.

## Błąd, który sam popełniłem i złapałem przed wysłaniem

Pierwsza wersja `ScanScreen` odwoływała się do nieistniejącego typu
(`RackListScreenRackLookup`) przy rozwiązywaniu nazwy regału dla
Slotu. Poprawione na zwykłe `sl<RackRepository>()` — sprawdzone
grepem przed prezentacją.

## Definition of Done — Krok 7.2

- ✅ Skan → Board/Offcut/Slot/Rack/Warehouse — wszystkie 5 typów
- ✅ Jeden punkt dyspozycji (`QrResolver`), zero rozsianej logiki
- ✅ Przyjazny "not found" z dwiema opcjami
- ✅ Przycisk skanera osiągalny z ekranu startowego (`WarehouseListScreen`)
- ✅ Przy okazji naprawiona brakująca nawigacja Warehouse→Rack
- ✅ 9 testów `QrResolver`, w tym przypadki brzegowe (zły format,
  nieznana litera, whitespace)

## Następny krok

Krok 7.3 — etykiety PDF (wybór elementów → arkusz PDF → wydruk na
zwykłej drukarce, bez integracji z konkretnym sprzętem). Dopiero po
7.3 — Krok 8 (Historia), zgodnie z Launch Gate.
