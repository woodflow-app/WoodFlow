# ADR: Integracja drukarek jako opcjonalna, wymienna warstwa

## Status
Zaakceptowane jako decyzja architektoniczna na przyszłość — **nie
zaimplementowane**. Nie jest częścią żadnego Kroku obecnej roadmapy Etapu 1.
Patrz `docs/BACKLOG.md` dla powiązanych, zależnych od tej decyzji pozycji
(Installation Wizard, Diagnostics, Works with WoodFlow).

## Kontekst
WoodFlow generuje już etykiety QR (Krok 7.3, `PdfLabelGenerator`), ale
wyłącznie jako PDF do wyświetlenia/wyeksportowania — nie ma dziś żadnej
integracji z fizyczną drukarką. Przyszła integracja z realnymi drukarkami
(Zebra, Brother, Epson i inne) musi zostać zaprojektowana tak, by **nigdy**
nie stać się zależnością krytyczną: część firm korzystających z WoodFlow
może nie drukować etykiet w ogóle, a te które drukują, mogą używać różnego
sprzętu, na różnych interfejsach (Bluetooth, Wi-Fi, USB).

## Decyzja
- Drukowanie jest zawsze **opcjonalną możliwością**, nigdy zależnością.
  WoodFlow musi pozostać w pełni użyteczny bez żadnej skonfigurowanej
  drukarki — firmy niedrukujące etykiet mają pełny dostęp do systemu
  inwentaryzacji bez ograniczeń.
- Aplikacja nigdy nie może się zawiesić ani zablokować przepływu pracy z
  powodu niedostępnej drukarki.
- Użytkownik konfiguruje preferowaną drukarkę (Bluetooth/Wi-Fi/USB) raz;
  po konfiguracji WoodFlow pamięta wybór i wysyła zadania druku
  bezpośrednio, bez ponownego wyboru za każdym razem.
- Przed drukiem zawsze weryfikowana jest dostępność drukarki. Gdy drukarka
  jest niedostępna, pokazywany jest przyjazny dialog z opcjami: Ponów,
  Wybierz inną drukarkę, Zapisz jako PDF, Kontynuuj bez drukowania — nigdy
  twardy błąd blokujący dalszą pracę.
- Etykiety QR muszą zawsze pozostać dostępne do podglądu na ekranie i
  eksportu jako PDF — to ścieżka istniejąca już dziś
  (`PdfLabelGenerator`/`ExportGenerator`) i pozostaje niezależna od tego,
  czy jakakolwiek drukarka jest skonfigurowana.
- Podsystem drukowania projektowany wokół abstrakcji `PrinterService` z
  wymiennymi implementacjami per marka/typ — dokładnie ten sam wzorzec co
  istniejący `LabelGenerator`/`ExportGenerator` (interfejs + get_it,
  `presentation/` nigdy nie importuje konkretnej implementacji
  bezpośrednio).
- Początkowa lista oficjalnie wspieranych marek drukarek (na przyszłość, nie
  do dzisiejszej implementacji): **Zebra, Brother, Epson, PDF Export
  (drukarka wirtualna)**. Kolejne marki dodawane później jako nowa
  implementacja `PrinterService`, bez zmiany logiki biznesowej — ten sam
  wzorzec rozszerzalności co katalogi dekorów per producent (Krok 12) i
  formaty eksportu (Krok 10).
- Podsystem drukowania pozostaje całkowicie odseparowany od głównego
  przepływu inwentaryzacji (Warehouse → Rack → Slot → Board/Offcut) —
  Board/Offcut/Slot nigdy nie importują `PrinterService` ani nie wiedzą o
  jego istnieniu; jedynym miejscem stykowym jest ekran etykiet, tak jak
  dziś stykowym miejscem dla `LabelGenerator` jest wyłącznie ekran etykiet.

## Konsekwencje
**Plusy:**
- Firmy bez drukarek etykiet mają zerowe tarcie — funkcja jest niewidoczna,
  dopóki jej nie skonfigurują.
- Dodanie nowej marki drukarki to nowa implementacja `PrinterService`, nie
  zmiana istniejącego kodu — ten sam, już sprawdzony wzorzec rozszerzalności
  co `ExportGenerator`/katalogi dekorów.
- Awaria/niedostępność drukarki nigdy nie blokuje realnej pracy magazynowej
  (dodania płyty, przesunięcia ścinka) — z definicji, bo `PrinterService`
  nie jest zależnością tych operacji.

**Minusy / kompromisy:**
- Wymaga zaprojektowania obsługi wielu protokołów sprzętowych (Bluetooth/
  Wi-Fi/USB) za jednym interfejsem — nietrywialne w warstwie `data/`, gdy
  przyjdzie do realnej implementacji.
- Dialog "drukarka niedostępna" z czterema opcjami (Ponów/Wybierz
  inną/PDF/Kontynuuj) to więcej stanów UI do przetestowania niż prosty
  komunikat błędu — świadomy koszt w zamian za brak zablokowanego
  workflow.

## Alternatywy rozważane
- **Drukowanie jako wymagany krok w cyklu życia etykiety** — odrzucone
  wprost: naruszałoby zasadę "WoodFlow musi pozostać w pełni użyteczny bez
  drukarki", zamieniając opcjonalną wygodę w twardą zależność.
- **Integracja z jedną marką na start (np. tylko Zebra), reszta później bez
  interfejsu** — odrzucone: bez `PrinterService` od początku, dodanie
  drugiej marki wymagałoby przepisania miejsca wywołania zamiast dodania
  nowej implementacji — ten sam błąd architektoniczny, którego świadomie
  uniknięto przy `ExportGenerator` w Kroku 10.
