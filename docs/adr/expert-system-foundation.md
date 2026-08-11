# ADR: Expert System Foundation — proces deweloperski Claude Code, nie funkcja aplikacji

## Status
Zaakceptowane. Infrastruktura deweloperska — **nie jest częścią roadmapy Etapu 1**
i nie ma numeru Kroku (Cut Optimizer zostaje Krokiem 15 bez zmian).

## Kontekst
Pojawiła się potrzeba powtarzalnego, udokumentowanego procesu konsultowania
wielu specjalistów (`woodflow-architect`, `flutter-expert`,
`database-architect`, `warehouse-expert`, `wood-industry-expert`,
`security-reviewer`, `performance-reviewer`, `code-reviewer`,
`ui-ux-reviewer`, nowe `ai-architect`/`product-manager`) przed
implementacją nietrywialnych zmian — zamiast decydowania ad hoc za
każdym razem, którzy specjaliści są potrzebni.

**Kluczowa decyzja rozstrzygnięta w tej rozmowie:** pierwsza wersja tego
pomysłu została błędnie zaimplementowana jako prawdziwy kod Dart
(`Expert`/`ExpertRegistry`/`ExpertPipeline` w `lib/domain/`, wywoływane w
runtime przez `AiQueryEngine`) — czyli funkcja aplikacji WoodFlow. To była
pomyłka architektoniczna: ci "eksperci" to nazwy istniejących specjalistów
Claude Code (`.claude/skills/`), używanych przeze mnie podczas
implementacji i przeglądu kodu — nie mają żadnego sensu jako klasy Dart
uruchamiane na telefonie użytkownika. Plik został usunięty przed
commitem, nic z niego nie trafiło do aplikacji.

## Decyzja
Expert System Foundation to wyłącznie:
- `.claude/skills/expert-review/SKILL.md` — pipeline: czyta rejestr,
  uruchamia właściwych ekspertów w kolejności priorytetu, zbiera
  issues/recommendations/warnings/architectural-conflicts/long-term-risks,
  łączy w jeden raport.
- `.claude/skills/expert-review/registry.md` — rejestr ekspertów
  (priorytet, folder skilla, kryterium stosowalności, obszar). Dodanie
  nowego eksperta = nowy folder skilla + jeden wiersz w tabeli, bez zmian
  w `expert-review/SKILL.md` (Open/Closed).
- `.claude/skills/ai-architect/SKILL.md`, `.claude/skills/product-manager/SKILL.md`
  — dwaj nowi specjaliści, w tym samym formacie co istniejące skille.

**Nic z tego nie jest importowane, referencjonowane ani uruchamiane przez
kod w `lib/`.** Aplikacja WoodFlow pozostaje całkowicie nieświadoma
istnienia tego systemu — dokładnie ta sama zasada co przy QA-only
language switcherze (`lib/presentation/debug/qa_language_switcher_button.dart`):
narzędzie deweloperskie, wyraźnie oddzielone od produktu, nigdy nie
udające funkcji aplikacji.

## Konsekwencje
**Plusy:**
- Zero ryzyka dla aplikacji — nie ma nowego kodu Dart, nie ma nowej
  zależności, nie ma nic do przetestowania w APK.
- Rejestr jako zwykła tabela markdown jest równie łatwy do rozszerzenia
  jak proponowany kod (`ExpertRegistry.register()`), bez żadnego z ryzyk
  utrzymania kodu, który nigdy nie jest wywoływany przez prawdziwych
  użytkowników.
- Runner (`expert-review/SKILL.md`) faktycznie nie hardkoduje logiki
  żadnego eksperta — cała wiedza domenowa żyje w poszczególnych plikach
  `SKILL.md`, runner tylko orkiestruje kolejność i format raportu.

**Minusy / kompromisy:**
- "Uruchomienie" eksperta oznacza, że ja (Claude Code) czytam jego
  `SKILL.md` i stosuję tę perspektywę — nie ma programistycznej gwarancji
  wykonania w stylu prawdziwego runtime'u (żadnych testów jednostkowych
  na tym pipeline'ie, żadnej wymuszonej kolejności poza instrukcją w
  SKILL.md). Świadomy koszt: to narzędzie procesowe, nie system, który
  wymaga takich gwarancji.
- Wymaga dyscypliny, żeby faktycznie wywoływać ten pipeline przed
  nietrywialnymi zmianami, zamiast pomijać go pod presją czasu — nic w
  kodzie tego nie wymusza, bo nic w kodzie o tym nie wie.

## Alternatywy rozważane
- **Prawdziwy kod Dart (`lib/domain/experts/`)** — pierwotna, błędna
  implementacja tej sesji. Odrzucone wprost: eksperci reprezentują role
  deweloperskie Claude Code, nie domenę WoodFlow; zaszycie ich jako
  runtime'owych klas Dart oznaczałoby wysyłanie nieużywanego,
  niezrozumiałego kodu w prawdziwej aplikacji.
- **Pojedynczy wielki plik z całą logiką przeglądu** — odrzucone: łamie
  Open/Closed dokładnie tak samo jak hardkodowanie logiki eksperta w
  runnerze by łamało go w wersji kodowej; rejestr + osobne pliki skilli
  to bezpośredni odpowiednik "jeden plik per encja" już ugruntowanego w
  tym repo (katalogi dekorów per producent z Kroku 12, wzorce AI per
  język z Kroku 14).
