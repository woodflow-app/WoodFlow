# WoodFlow — Product Vision & UI/UX Master Specification

**Status: Historyczny / Nieaktualny — patrz `docs/WoodFlow_Handbook.md`.**
This document was at one point treated as the governing document for
UI decisions, before `docs/WoodFlow_Handbook.md` existed. The Handbook
is now the single source of truth for WoodFlow and wins in case of any
disagreement (`docs/WoodFlow_Handbook.md`, front matter). This file is
preserved solely for its original reasoning and historical context,
not as an alternate source of truth.

This document doesn't duplicate the detailed work already done — it
governs, consolidates, resolves open questions with your new input,
and adds what's genuinely new in your latest message. Full detail
lives in the referenced documents; read this alongside them, not
instead of them.

## 1. Document map

| Document | Scope | Status |
|---|---|---|
| `WoodFlowDesignSystem.md` | Tokens (spacing/type/color roles), `WF*` component library | **Approved, implemented** — every screen uses it |
| `WoodFlowVisualIdentity.md` | Blueprint/CAD illustration motifs, module accent colors, motion catalogue, Command Hub interaction/animation spec, responsive breakpoints | **Direction approved (v1–v3), implementation not yet approved** |
| `EntityEditingSpecification.md` | Strict **current-state audit** — what's editable today, per entity, at repository vs. UI layer. Explicitly excludes proposing new fields | **Audit only, not an approval to build editing UI** — see §6 for how this relates to your new editing requirements |
| This document | Brand/logo, theme (light+dark), full responsive matrix, module-list reconciliation, entity-editing relationship, accessibility, performance, phasing | **New material below is proposal only** |

## 2. Product goal — read as intent, not a new instruction

Agreed and unchanged from `WoodFlowVisualIdentity.md`'s framing: this
project is optimizing for "premium, industrial, calm, precise" over
"generic Flutter/Material," benchmarked against restraint-first
references (Linear, Notion, Stripe, Apple) rather than decoration-
first ones. Tesla and Autodesk are new reference points here — read
as reinforcing the same direction (precision instruments, not
consumer-app playfulness), not adding a fourth, different aesthetic
to reconcile.

## 3. Module identities — reconciled list

Your list this round: Warehouse, Boards, Rack/Slot, Shopping List,
Calculators, Dashboard, Export, Settings (new). Two notes, not
objections:

- **Offcuts** isn't in this round's list but was in the previous one,
  with a motif already designed (`WoodFlowVisualIdentity.md` §5/12.1
  — the cut-corner board-stack). Carrying it forward rather than
  dropping it; flag if that's wrong.
- **Settings** is genuinely new — no `SettingsScreen` exists in the
  app today (confirmed: no matching file under `lib/presentation/`).
  Its motif ("blueprint grid, gears, technical maintenance") is
  reasonable and buildable the same way as every other module
  (`WoodFlowVisualIdentity.md` §12.1's feasibility method applies
  directly — a grid + a simple gear outline, both easy line-art), but
  building its *screen* is new scope this document surfaces, not
  something to assume already covered.
- **QR Scanner** correctly stays out of the module-identity list — it
  already has its own motif (`WoodFlowVisualIdentity.md` §5, the
  scan-frame corners) and its navigation placement is settled
  (§13.5 of that document): always-visible, not a Hub module.

## 4. Brand & logo — scoped honestly

Requirement: a WoodFlow mark, permanently top-left, logo-only on
phone, logo+wordmark on tablet/desktop, tapping it always returns to
Dashboard.

**What I can build, and what I can't, stated plainly (same honesty
as `WoodFlowVisualIdentity.md` §1/§12.4):**
- A **wordmark treatment** — the text "WoodFlow" with deliberate
  typography (weight, tracking, the module-accent green) — is
  straightforward, already scoped in §12.4 of the Visual Identity
  doc.
- A **simple geometric monogram** (e.g. a stylized "W" or an
  abstracted stacked-board glyph, built from clean straight/arc
  paths in a `CustomPainter`, in the same blueprint-line register as
  every module motif) is achievable and would read as "a mark," not
  generic text.
- A **designed illustrative logo** (something a brand designer would
  produce — custom letterforms, a crafted icomark meant to also work
  as an app icon/favicon/letterhead) is real graphic-design work
  outside what procedural code can produce well. If that's what
  "logo" means here, it needs a human designer or a design tool
  outside this session — flagging now, not after building something
  that falls short of that bar.

**Recommendation:** build the geometric monogram + wordmark pairing
now (in scope, achievable, on-brand); treat a fully designed
brand-mark as a separate, later, possibly non-Claude-Code deliverable
if you want one beyond the monogram.

**Confirmed but worth naming explicitly:** "tapping the logo always
returns to Dashboard" makes **Dashboard the app's home**, not
Warehouse List (today's actual `main.dart` `home:`). That's a real,
concrete change to the app's entry point and primary navigation
model — noted here so it's a visible decision, not a side effect
discovered mid-implementation.

## 5. Themes — resolves an open question from `WoodFlowVisualIdentity.md`

§10/§12.6 of that document asked whether dark mode was in scope;
this message answers it: **yes, required.** Today `main.dart` defines
exactly one `ThemeData` (Material 3, Forest Green seed) — no dark
theme exists.

Proposed shape:
- `ThemeData` (light) stays the base; add a `darkTheme:` — same
  Material 3 `colorScheme` mechanism, different seed/brightness, not
  a second, parallel design system. Every `WF*` component already
  reads colors from `Theme.of(context).colorScheme`/`textTheme`
  (built that way from the start, per `WoodFlowDesignSystem.md`) —
  meaning dark mode is mostly "define the second `ColorScheme`,"
  not "touch every screen."
- Dark palette direction: your framing ("industrial graphite,
  professional machines, warehouse at night, high-end CAD software")
  maps to a low-chroma near-black graphite ground (not pure black —
  pure black plus thin white blueprint lines is harsh; a dark
  graphite ground is what "professional machine" surfaces actually
  look like) with the same Forest Green accent carried through at
  adjusted lightness for contrast.
- Module accent colors (`WoodFlowVisualIdentity.md` §4) and motif
  opacity (§1/§5) both need a second, separately-tuned value for
  dark — a color/opacity that reads as "2–5%, present but invisible"
  on white will either vanish or spike in contrast on graphite. Not
  a blocker, just real work each motif needs, not a global multiplier.
- Persistence: reuse the exact pattern already in the codebase —
  `LocaleProvider` (`lib/core/services/locale_provider.dart`) already
  persists the user's language choice via local storage and is
  registered in `service_locator.dart`. A `ThemeProvider` following
  the identical shape (same persistence mechanism, same
  `ChangeNotifier`/`ListenableBuilder` pattern already used for
  locale, not a new state-management approach) is the natural,
  already-precedented way to do this — not a new architectural
  pattern for the app to learn.

## 6. Entity editing — how this relates to `EntityEditingSpecification.md`

Important to keep these two documents' authority separate:

- `EntityEditingSpecification.md` is a **factual audit of today** —
  it doesn't propose that Warehouse/Rack/Slot/Board/Offcut/Decor
  *should* be editable, it documents what already is, at which layer,
  and flags gaps (see its §3).
- This message's "Entity Editing" section is a **forward-looking
  product requirement** — "editing is a core feature," covering the
  same five entities plus Shopping List entries and Minimum Stock
  entries (both of which resolve to `Decor`/`Decor.minimumStockQuantity`
  per that audit's §2.6 — not new entities) **plus "Export presets,"**
  which — like "Calculator presets" in the audit's §4 — **does not
  exist as a persisted entity today.** No `ExportPreset` table,
  entity, or repository exists anywhere in `lib/domain/`. Same
  treatment as Calculator presets: a future candidate, not something
  to design editing rules for yet.
- **This vision document does not, by itself, approve building
  editing UI.** Per §9's own process rule (which this document
  states as the standing rule for everything, including itself), an
  actual "what should be editable, and how" specification — informed
  by this vision's ambition but grounded the way
  `EntityEditingSpecification.md` was — would still need its own
  Phase 1 pass and your explicit approval before Phase 2 build. If
  you want that spec started now, say so as its own instruction; I'm
  not inferring it from "editing is a core feature" alone, since that
  sentence describes a destination, not a green light.

## 7. Responsive matrix

`WoodFlowVisualIdentity.md` §13 already specifies Portrait (Command
Hub overlay), Landscape (nav rail), and Tablet (permanent rail +
adaptive content) using Material 3's standard 600dp/840dp breakpoints
— that covers four of your five listed configurations directly
(phone portrait, phone landscape, tablet portrait, tablet landscape
all resolve to one of those three breakpoint bands, since the rail-
vs-overlay decision is about *width*, not phone-vs-tablet as a
device category).

**Desktop is the one genuinely new case**, and one fact worth
grounding before treating it as equivalent scope to the others: this
Flutter project already has `windows/`, `macos/`, `linux/`, and
`web/` platform folders (present from initial project scaffolding),
**but no desktop build has been exercised or tested at any point in
this project's history** — every verification this session has been
`flutter build apk`/on-device Android. Desktop isn't zero work
(platform folders exist), but it isn't "just another breakpoint"
either — a first desktop build would need its own verification pass
(does it even launch, does `sqflite` need `sqflite_common_ffi` there
the way tests already use, does the camera-based QR scanner degrade
sensibly with no camera). Recommend desktop as the **last** phase in
§9's timeline, after the mobile/tablet work is built and proven, not
in parallel with it.

## 8. Accessibility

Consolidating what's already been established piecemeal, as one
section per your ask, not new rules:
- Motif opacity (2–5%) must clear contrast against real body text —
  a `WFEmptyState` illustration behind its icon/title is the one
  place motif art sits near text; every other placement
  (`WoodFlowVisualIdentity.md` §5's "placement" column) is
  deliberately header/backdrop-only, never behind readable content.
- Every animation respects `MediaQuery.disableAnimations` (reduce
  motion) — stated in §7/12.2 of the Visual Identity doc, restated
  here as a hard requirement, not a nice-to-have.
- Status/semantic color (`WFStatusChip`'s success/warning/error/
  neutral) stays independent of module accent color (§4 of the
  Visual Identity doc already rules this) specifically so a
  color-blind user's reading of "something needs attention" is never
  entangled with which module they're in.
- Icon-only controls (the Hub's floating button, the logo mark on
  phone) need explicit `Semantics`/`tooltip` labels — Flutter's
  standard mechanism, no new pattern needed, just don't skip it
  because the icon "looks self-explanatory."
- Touch targets: `WF*` components already sit on Material's default
  48dp minimum; nothing in this proposal shrinks that.

## 9. Performance analysis

Also consolidating, not introducing new constraints:
- Motif rendering: one static `CustomPainter` per module,
  `shouldRepaint => false`, wrapped in `RepaintBoundary`, never
  behind scrolling content (`WoodFlowVisualIdentity.md` §9).
- Command Hub open/close: one coordinated `AnimationController`
  (§13.2 of that doc), ~300ms, GPU-friendly properties only (opacity,
  scale, position) — no per-frame layout recalculation.
- Micro-interaction budget: ≤250ms everywhere except the Hub's one
  deliberate brand moment (§12.2/§13.2).
- Explicitly rejected for cost reasons, unchanged: stagger-in list
  animations, custom parallax/3D route transforms (§12.2).
- 60 FPS target: nothing proposed here does per-frame Dart-side work
  during a gesture (no custom scroll physics, no live-recomputed
  paths) — the cost profile is "draw once, animate GPU-composited
  properties," which is the correct shape for the target you've set.
- No new desktop-specific performance work is proposed yet (§7) —
  that gets its own pass once desktop is actually a phase, not
  assumed now.

## 10. Implementation process (your §9, restated as the standing rule)

Saved to durable memory this turn — this now applies to all future
WoodFlow UI work, not just this document:

**Phase 1 (required, every time):** specification + reasoning + UX
explanation + performance impact + a concrete mockup for anything
visual. Wait for explicit approval.

**Phase 2:** implementation, testing, refinement — only after
approval.

## 11. Proposed phasing (Small/Medium/Large/Major, this project's own convention)

Ordered by dependency, not by request order — later phases build on
earlier ones:

1. **Theme foundation** (§5) — light+dark `ColorScheme`s, persisted
   `ThemeProvider` following `LocaleProvider`'s exact pattern.
   **Medium.**
2. **Command Hub navigation** (`WoodFlowVisualIdentity.md` §13) —
   overlay + rail + breakpoints, module-descriptor list (with the
   role-based-filter seam, §13.6). **Large** — the single biggest
   item, per that document's §13.8.
3. **Module motifs + accent colors**, light and dark variants
   (§5 above extends `WoodFlowVisualIdentity.md` §4/§5's original
   Medium estimate — building both themes' motif tuning roughly
   doubles that specific line item). **Medium–Large.**
4. **Motion polish** — Hero transitions, dialog/sheet entrance curve
   (`WoodFlowVisualIdentity.md` §12.2). **Small.**
5. **Brand mark** — monogram + wordmark, logo-tap-to-Dashboard
   wiring, phone-vs-tablet/desktop display rule (§4 above). **Small.**
6. **Settings screen** — doesn't exist yet; needs its own scope
   (what does it actually contain?) before it can be built, separate
   from its motif. **Not yet scoped — flagging, not estimating.**
7. **Desktop verification + adaptation** (§7) — last, after 1–5 are
   proven on mobile/tablet. **Unscoped until a first desktop build is
   attempted** — too early to size honestly.
8. **Entity editing** (§6) — its own, separate Phase 1 spec, not
   started by this document, sequenced independently of 1–7 above
   (touches domain/data layers, not the visual system).

**Not implementing anything from this list until you approve it —**
this phasing itself is part of the specification, open to
reordering or rejection before any Phase 2 work starts on any item.
