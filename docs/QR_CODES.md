# WoodFlow — Kody QR (Krok 7.1 — Generowanie)

## Format

`WF-{TYP}-{numer}`, np. `WF-B-000128`, `WF-O-004521`.

| Typ | Litera |
|---|---|
| Warehouse | `W` |
| Rack | `R` |
| Slot | `S` |
| Board | `B` |
| Offcut | `O` |

**QR zawiera WYŁĄCZNIE identyfikator — nigdy dane.** Aplikacja po
zeskanowaniu zawsze wyszukuje rekord lokalnie (Krok 7.2). Zmiana
dekoru, lokalizacji czy nazwy nigdy nie wymaga przedrukowania
etykiety — kod dalej wskazuje ten sam rekord. Potwierdzone testem:
`moveBoard()` nie zmienia `qrCode`.

## Generowanie — wyprowadzone z `id`, jedno źródło prawdy

Pierwszy kod QR (przy tworzeniu) to **czysta funkcja `id`** encji —
pierwsze 8 znaków hex z `id` (bez myślników), wielkimi literami
(`lib/data/database/qr_code_generator.dart`, `qrCodeFromEntityId()`).
Żadnego zapytania do bazy, żadnej dodatkowej, niezależnej losowości —
`id` i pierwszy `qrCode` są deterministycznie powiązane. To
poprawka po review: wcześniejsza wersja losowała `qrCode` osobnym,
niezależnym UUID-em, co tworzyło dwa niepowiązane źródła losowości
tam, gdzie wystarczy jedno.

**Jedyny świadomy wyjątek: `regenerateQrCode()`.** Regeneracja z
definicji musi dać *inny* kod niż oryginał — nie da się go wyprowadzić
z niezmiennego `id`. Ta ścieżka używa osobnej funkcji
`randomQrCode()` (świeży, niezależny UUID), udokumentowanej wprost
jako wyjątek od reguły "jedno źródło prawdy".

## Dlaczego nie `COUNT(*)+1`

Pierwsza wersja tego generatora liczyła kolejny numer jako
`COUNT(*)+1` na docelowej tabeli. Odrzucone po review: dwa offline
urządzenia (v1.5) mogłyby wygenerować ten sam numer dla tego samego
typu bytu, a scalanie baz przy imporcie mogłoby się zderzyć.
Obecny schemat (wyprowadzony z globalnie unikalnego `id`) jest
odporny na oba te przyszłe scenariusze bez żadnej zmiany kodu, gdy
do nich dojdziemy.

## Regeneracja — "tylko dla administratora"

Każdy z pięciu bytów ma metodę `regenerateQrCode(id)`. **Nie ma dziś
żadnego wymuszenia uprawnień** — w systemie nie istnieje jeszcze
pojęcie roli/administratora (to Auth, v2.5/BUSINESS). Metody
istnieją (Krok 7.1 tego wymaga), ale:

- żaden ekran UI ich dziś nie wywołuje,
- nie ma przycisku "Regeneruj QR" w żadnym widoku,
- jeśli budujesz taki przycisk, zanim Auth/Role istnieją — to
  świadoma decyzja do podjęcia wprost, nie domyślne zachowanie.

Board i Offcut zapisują regenerację do Ledgera (`qrRegenerated`) —
ślad audytowy istnieje niezależnie od tego, czy dostęp jest
kontrolowany. Warehouse/Rack/Slot (bez własnego Ledgera) po prostu
nadpisują pole.

## Wielkość liter — decyzja (Krok 7.2, obowiązkowa przed zamknięciem Kroku 7)

**Dopasowanie jest niewrażliwe na wielkość liter.** Kanoniczny,
zapisany w bazie format jest zawsze wielkimi literami — ale
`QrResolver.resolve()` normalizuje każde wejście do uppercase przed
dopasowaniem i wyszukaniem. `wf-b-8f4c29a1`, `WF-b-8F4C29A1` i
`WF-B-8F4C29A1` rozwiązują się identycznie.

**Dlaczego:** skan kamerą zawsze odczytuje dokładnie to, co
zakodowano — więc dziś to nie jest realny problem. Staje się ważne w
momencie, gdy powstanie jakakolwiek ścieżka ręcznego wpisania kodu
(przyszły fallback w Smart Material Finder, v1.5, albo osoba wsparcia
przepisująca kod ze zdjęcia). Normalizacja w jednym miejscu
(`QrResolver`) oznacza, że żadna przyszła ścieżka nie musi powtarzać
tej decyzji.

Przetestowane: `test/qr_resolver_test.dart` — kod w pełni lowercase i
mixed-case rozwiązują się identycznie jak kanoniczny uppercase.

## Co świadomie NIE jest częścią Kroku 7.1

- Skanowanie (Krok 7.2 — kamera, nawigacja do właściwego ekranu)
- Etykiety PDF / druk (Krok 7.3)
- Integracja z konkretnymi drukarkami (Zebra/Brother) — poza
  zakresem v1.0 w ogóle, zgodnie z ustaleniem
