# WoodFlow — Jakość tłumaczeń (21 języków)

## Warstwa "silna" — wysoka pewność jakości fachowego słownictwa

| Kod | Język |
|---|---|
| `en` | Angielski |
| `pl` | Polski |
| `de` | Niemiecki |
| `fr` | Francuski |
| `it` | Włoski |
| `es` | Hiszpański |
| `ru` | Rosyjski |

## Warstwa "do przeglądu" — solidny pierwszy szkic, rekomendowany przegląd native speakera przed wypuszczeniem produkcyjnym

| Kod | Język |
|---|---|
| `nl` | Niderlandzki |
| `sv` | Szwedzki |
| `da` | Duński |
| `cs` | Czeski |
| `sk` | Słowacki |
| `hu` | Węgierski |
| `hr` | Chorwacki |
| `sl` | Słoweński |
| `lv` | Łotewski |
| `lt` | Litewski |
| `no` | Norweski |

## Warstwa "wymaga przeglądu przed jakimkolwiek użyciem produkcyjnym"

| Kod | Język | Uwaga |
|---|---|---|
| `ga` | Irlandzki | Niższa pewność fachowego słownictwa stolarskiego |
| `cy` | Walijski | Niższa pewność fachowego słownictwa stolarskiego |
| `gd` | Szkocki gaelicki | **Najniższa pewność ze wszystkich 21** — jawnie zaznaczone przy tworzeniu pliku ARB |

## Co to oznacza praktycznie

- Wszystkie 21 plików ARB mają **identyczny zestaw 60 kluczy** (zweryfikowane programowo) — żaden ekran nie pokaże pustego/domyślnego tekstu w żadnym z języków.
- Gramatyczna poprawność i naturalność sformułowań w warstwie "silnej" — wysoka pewność.
- W warstwie "do przeglądu" i "wymaga przeglądu" — tłumaczenia są kompletne i gramatycznie sensowne, ale **nie były weryfikowane przez native speakera** ani przez nikogo z doświadczeniem w branży stolarskiej w tym języku. Przed pokazaniem realnym klientom w tych językach: przegląd przez kogoś, kto zna zarówno język, jak i słownictwo branżowe (ścinek, okleina, rozkrój, dekor).

## Zabezpieczenie na przyszłość

`test/arb_consistency_test.dart` — automatyczny test uruchamiany przy
każdym `flutter test`, pilnujący spójności wszystkich 21 plików ARB
w miarę jak lista kluczy rośnie (dziś ~60, docelowo prawdopodobnie
300-500):

- każdy plik ma dokładnie ten sam zestaw kluczy co szablon (`app_pl.arb`)
- żaden plik nie ma dodatkowego klucza, którego nie ma w pozostałych
- `@@locale` zgadza się z nazwą pliku
- każdy placeholder (np. `{message}` w `errorPrefix`) istnieje w
  metadanych I faktycznie występuje w treści tłumaczenia w każdym
  języku — łapie sytuację, gdy tłumacz przypadkiem usunie
  placeholder z tekstu, zostawiając metadane nietknięte

Logika zweryfikowana symulacją w Pythonie na prawdziwych plikach
przed napisaniem testu Dart — zero błędów na wszystkich 21 plikach.

## Zasada od teraz (ustalona)

Commit → potem README → potem dokumentacja. Nigdy odwrotnie —
dokumentacja nie wyprzedza kodu.

## Decyzja: język źródłowy projektu (`app_pl.arb` jako szablon)

**Świadomie, nie przez przypadek:** `app_pl.arb` jest `template-arb-file`
w `l10n.yaml`, nie `app_en.arb`.

**Uzasadnienie:** cały proces tworzenia tego projektu — decyzje
architektoniczne, komunikacja, code review, ta rozmowa — toczy się po
polsku. Nowy string w UI powstaje najpierw po polsku (bo tak myśli i
pisze Piotr), więc polski jako źródło jest zgodny z tym, jak realnie
powstaje kod, nie odwrotnie do niego.

**Kiedy to rozważyć ponownie:** jeśli proces developmentu zmieni się
na anglojęzyczny (np. zespół międzynarodowy, dokumentacja API po
angielsku dla zewnętrznych integratorów) — wtedy `app_en.arb` jako
źródło miałoby więcej sensu, bo odpowiadałoby nowemu realnemu
procesowi. Nie zmieniać samego faktu, że WoodFlow ma być produktem
międzynarodowym — to osobna sprawa od tego, w jakim języku *powstają*
nowe stringi.

## Definition of Done — dodanie nowego języka

- [ ] Dodany plik `app_xx.arb` w `lib/l10n/`
- [ ] Wszystkie klucze przetłumaczone (żaden nie skopiowany 1:1 z
      angielskiego/polskiego jako "tymczasowy" placeholder)
- [ ] `@@locale` ustawione na poprawny kod języka
- [ ] `flutter test` przechodzi (`arb_consistency_test.dart` —
      zgodność kluczy, placeholderów, `@@locale`)
- [ ] Język dodany do `LocaleProvider.supportedLocales`
- [ ] Aplikacja uruchamia się i przełącza na ten język bez crasha
- [ ] Najważniejsze ekrany (Warehouse, Rack, Slot, Board, Offcut,
      Scan) sprawdzone ręcznie — teksty się mieszczą, nic nie jest
      ucięte, nie ma odwróconego kierunku tekstu tam gdzie nie trzeba
- [ ] Warstwa jakości ("silna" / "do przeglądu" / "wymaga przeglądu")
      przypisana i zapisana w tabeli wyżej w tym dokumencie
- [ ] *(jeśli warstwa "do przeglądu" lub niżej)* przegląd native
      speakera przed pokazaniem realnym klientom w tym języku

## Skąd te 21 języków

Wybrane przez Piotra z pełnej listy języków europejskich (24 urzędowe UE + inne + regionalne), po dyskusji o realnym zakresie rynkowym vs. ambicji "wszystkie języki Europy". Zob. `woodflow_language_picker.html` — interaktywne narzędzie użyte do wyboru.

## Źródło kluczy

`lib/l10n/app_pl.arb` jest szablonem (`template-arb-file` w `l10n.yaml`) — każdy nowy string w kodzie najpierw trafia tam, potem do pozostałych 20 plików. Wyciągnięte z kodu przez systematyczny audyt (`grep`/Python), z dwiema turami poprawek po znalezieniu stringów pominiętych przez pierwszy, zbyt wąski wzorzec wyszukiwania (`Text('...', style: ...)` z dodatkowymi parametrami).
