# WoodFlow Visual Identity — Proposal (v2, expanded — for review)

**Status:** PROPOSAL ONLY. No code, no assets, no animations have been
implemented against this document. §§1–11 are the original proposal,
approved on direction; §12 is the expansion you asked for (technical/
blueprint illustration style, motion design, navigation redesign,
brand identity) — still waiting for approval before anything gets
built.

## 0. Method

Reviewed as: `design-system-expert` (does this extend
`WoodFlowDesignSystem.md` or fight it), `mobile-ux-expert` (does it
help or hurt "large touch targets, minimal typing, fast scanning, few
taps" for a warehouse-floor operator), `ui-ux-reviewer`,
`wood-industry-expert`/`warehouse-expert` (does the visual language
actually read as "this industry," not generic corporate),
`performance-reviewer` (cost of decorative rendering on real, possibly
low-end warehouse devices), `woodflow-architect` (does this reopen a
decision already made and shipped this session).

## 1. Read this section first — what's actually buildable

Before any concepts: one constraint shapes everything below, and
hiding it would set up a proposal you approve and then a delivery that
disappoints.

**I have no illustration/asset-generation tool.** I can't produce
hand-drawn or vector-illustrated scenes — a forklift, an operator
scanning a board, a "panoramic warehouse" perspective. What I *can*
build, well, is **procedural line-art drawn directly in Flutter code**
(`CustomPainter`: straight lines, rectangles, grids, simple paths) —
geometric, abstract, structural marks, not pictorial scenes.

This isn't just a limitation to work around — it's the right call for
this brief on its own terms. Look at the actual reference points named
in the mission (Stripe, Linear, Notion, Figma): **none of them use
pictorial illustrations of their subject matter as chrome.** Stripe's
background marks are abstract line/dot grids. Linear's are geometric
gradients and thin strokes. What reads as "premium enterprise" in
2026 is restraint and geometry, not clip-art of a forklift at 3%
opacity (which, at that opacity, would be an unrecognizable smear
anyway — pictorial detail is the first thing to disappear at low
alpha; geometric structure is the last).

**Recommendation: abstract geometric motifs, not literal scene
illustrations**, for every module below. Flagging this as the single
highest-leverage decision in this whole proposal — if you want literal
illustrated scenes specifically, that requires a real illustrator or
an asset-generation pipeline neither of which exist in this project
today, and this proposal should be rejected/revised rather than
approved on the assumption I can deliver that.

## 2. What this does NOT reopen

`WoodFlowDesignSystem.md` and its `WF*` component library (built and
shipped this session) already established: Material 3 `colorScheme`
semantic roles for every functional color (buttons, status chips,
errors), `textTheme` roles for every piece of text, one spacing scale,
one radius scale, one icon language. **None of that is up for revision
here.** Module accent colors (§4) are a new, narrow, additive layer —
decoration only, never a second source of truth for what a button or
a status means. If a module accent color and a semantic color (e.g.
`colorScheme.error`) ever visually clash on the same screen, the
semantic color wins, always — a color that means "something is wrong"
must never be mistaken for a module's brand tint.

## 3. Current state (grounding facts)

- One `ThemeData(useMaterial3: true, colorSchemeSeed: 0xFF1F4D3D)`
  ("Forest Green") in `main.dart` — **no `darkTheme` is defined at
  all today.** The app doesn't adapt to system dark mode currently,
  despite `WoodFlowDesignSystem.md` naming dark-mode compatibility as
  a principle. This matters directly for §4 — module accents and
  low-opacity line-art both need retuning for a dark background, and
  there is no dark theme yet to retune. Flagged as an open question
  in §9, not assumed.
- 21-language i18n, every screen already migrated to `WF*` components
  (this session).
- Icon set already passed one consistency audit (`Icon Audit Report`,
  earlier this session) — this proposal extends that language, it
  doesn't replace it.

## 4. Color identity — one new layer, not a second system

Proposed: a small `WFModuleAccent` token set (one `Color` per module),
used **only** for:
- the tint of that module's decorative line-art (§5),
- a thin accent (e.g. a 2–3px top border or icon tint) on that
  module's `WFTopBar`/section headers — subtle wayfinding, not a
  repaint of the screen.

**Never** used for: buttons (`WFButton` keeps its 4-role
primary/secondary/tertiary/destructive system), status chips
(`WFStatusChip` keeps `success`/`warning`/`error`/`neutral`), body
text, or anything a colorblind user needs to distinguish
unambiguously — those stay exactly as `WoodFlowDesignSystem.md`
already specifies. This is the reconciliation that lets "every module
has its own atmosphere" coexist with "one consistent semantic color
system" instead of the two fighting each other.

Proposed palette (desaturated/muted versions of each name, not the
literal named color — "Wood Brown" as a saturated brown would clash
with the Forest Green seed; muted, low-chroma tones sit alongside it):

| Module | Accent (muted) | Hex (indicative) |
|---|---|---|
| Warehouse | Deep green (matches the app seed — Warehouse is "home") | `#1F4D3D` |
| Rack | Steel blue-gray | `#5B7A8C` |
| Slot | Slate gray | `#6B7280` |
| Board | Warm taupe (wood-adjacent, not literal brown) | `#8A7561` |
| Offcut | Muted amber-orange | `#C08552` |
| Dashboard | Navy | `#2C3E5C` |
| Shopping List | Muted amber | `#B8923A` |
| QR Scanner | Cyan-blue | `#3D7EA6` |
| Calculators | Muted violet | `#6B5B8C` |
| Export | Neutral gray | `#78716C` |

## 5. Per-module motif concepts (abstract line-art, per §1)

Every motif below is a small set of straight lines/rectangles/simple
curves — genuinely paintable with `CustomPainter`, genuinely legible
at 2–5% opacity because it's structural, not detailed.

| Module | Motif (abstract) | Placement |
|---|---|---|
| **Warehouse** | A repeating vertical-line "aisle" rhythm — evenly spaced thin verticals of varying height, like a floor plan silhouette | Behind `WFTopBar`/hero area on `WarehouseListScreen` only, never behind the list itself |
| **Rack** | A grid of horizontal shelf-lines with a few short vertical uprights — literally the shape of a rack elevation | Behind `WFTopBar` on `RackListScreen`/`SlotGridScreen` |
| **Slot** | One isolated rectangle-with-tick-marks (a single shelf cell) — the "zoomed in one level further" version of Rack's motif | `SlotDetailScreen` header area |
| **Board** | Stacked thin horizontal rectangles, slightly offset — a sheet stack silhouette | `BoardDetailScreen` header, behind the QR card |
| **Offcut** | The same rectangles as Board, but with one corner cut at an angle — visually says "board, but cut" without needing a caption | `OffcutDetailScreen` header |
| **Dashboard** | A simple bar-chart silhouette (ascending thin rectangles) — echoes the stat cards already on that screen | Behind the stat-card row |
| **Shopping List** | A checklist motif — a few horizontal lines with short leading tick marks | Empty state / header |
| **QR Scanner** | A viewfinder-corner-bracket motif (the four L-shaped corners of a camera scan frame) — already a near-universal, instantly legible mark | Behind the camera preview edges |
| **Calculators (Area)** | A rectangle with dimension arrows on two sides — literally a technical drawing convention | `CalculatorsScreen`, area tab |
| **Calculators (Edge banding)** | A thin rolled-ribbon spiral (a few concentric arcs) | Edge-banding tab |
| **Export** | A simple stacked-document corner-fold silhouette | `ExportScreen` header |
| **Cut Optimizer (future — Krok 15)** | Explicitly out of scope here — the entity doesn't have a screen yet; propose its motif when that screen is actually built, not speculatively now |

## 6. Iconography

No new icon *set* — extends the existing Material Symbols outlined
language from the earlier icon audit. Proposed additions: one small
"module marker" glyph per module (already-common Material icons:
`warehouse_outlined`, `view_column_outlined`, `inbox_outlined`,
`crop_landscape_outlined`, `content_cut`, `dashboard_outlined`,
`shopping_cart_outlined`, `qr_code_scanner`, `calculate_outlined`,
`ios_share_outlined` — all already in use today per the icon audit).
This section is mostly "confirm the existing language is the final
one," not a new proposal.

## 7. Animation — a bounded catalog, not "animate everything"

Flagging the same risk `docs/expert-system/ExpertConsensus.md`
already raised for the earlier premium-rebuild discussion: a worker
scanning and shelving material all shift benefits from **speed and
predictability** more than from delight motion. An animation on every
interaction adds latency to routine, repeated actions. Proposed
approach — curated, not universal:

| Interaction | Proposal | Why |
|---|---|---|
| Page transitions | Material's own default (already present) | Already correct, already fast, no change needed |
| Card/list appearance | **No stagger-in animation on data lists.** A shopping list or slot grid loading with a per-item fade-in delay makes scanning *slower* on a long list — directly against the stated workflow goal | Reject |
| Dialogs / bottom sheets | Material's own default (already present via `showWFConfirmationDialog`/`showWFBottomSheet`) | Already correct |
| FAB expansion | Material's own default | Already correct |
| QR scan | A subtle scan-line sweep over the camera preview while waiting for a detection | Real, useful feedback — "it's actively looking" — not decoration |
| Search | A brief (~150ms) crossfade when result count changes | Small, cheap, doesn't block typing |

**Hard budget:** every animation duration ≤250ms, and every one
respects `MediaQuery.of(context).disableAnimations` (system
"reduce motion" setting) by skipping straight to the end state. No
animation should ever be the reason a repeated daily action feels
slower after this work than before it.

## 8. Premium details

- **Empty states**: `WFEmptyState` already exists; extend it to
  optionally render its module's line-art motif faintly behind the
  icon/title instead of a plain background — small, contained change,
  reuses the existing widget.
- **Onboarding**: flagged as a **new feature**, not a visual-identity
  task — no onboarding flow exists in the app today. Out of scope for
  this proposal; a candidate for `docs/BACKLOG.md` if wanted.
- **Typography / cards / dialogs / spacing**: already standardized by
  `WoodFlowDesignSystem.md`; this proposal doesn't touch that layer,
  only adds the module-accent/motif skin on top of it.

## 9. Performance guardrails

- Every motif is one static `CustomPainter` per module (drawn once,
  `shouldRepaint => false` — the shapes never change), wrapped in
  `RepaintBoundary` so it never triggers a repaint of the real content
  above it.
- No motif renders behind scrolling list content — only behind fixed
  header/empty-state areas — so scroll performance is unaffected.
- Zero network assets, zero image decoding — pure vector paths, so
  APK size impact is negligible and there's nothing to cache.

## 10. Open questions — decisions needed before implementation

1. **Illustration style (§1)** — confirm abstract geometric motifs
   (recommended, buildable now) rather than literal pictorial scenes
   (would need an illustrator/asset pipeline this project doesn't
   have).
2. **Dark mode (§3)** — the app has no dark theme today. Should this
   effort include adding one (module accents + motifs need separate
   tuning for a dark background), or does light-only stay the
   explicit scope for now, with dark mode as its own later decision?
3. **Onboarding (§8)** — confirmed out of scope (new feature, not
   visual identity), or do you want it folded in here?
4. **Animation catalog (§7)** — confirm the curated/bounded list
   above, specifically confirm rejecting stagger-in list animations,
   before any animation code is written.

## 11. Estimated cost (per this project's Small/Medium/Large/Major convention)

- Module accent tokens + wiring into `WFTopBar`/section headers:
  **Small** (hours).
- 11 `CustomPainter` motifs (§5) + `WFEmptyState` extension:
  **Medium** (a day or so) — mechanical once the style is approved.
- Animation catalog (§7), scoped as written: **Small–Medium.**
- Dark theme (if in scope per open question 2): **Medium** on its own
  — a second full palette pass, not free.
- **Total, as scoped: Medium–Large**, not Major — specifically
  *because* §1 rules out hand-illustrated scenes, which is the part
  of the original brief that would have made this Major/weeks.

---

## 12. Addendum (v2) — technical/blueprint style, motion, navigation, brand

Direction approved; expanding per your follow-up. Same rule as
before: recommend/reject explicitly, reasoning first, nothing
implemented yet.

### 12.1 Illustration style — revised, and it's good news

Blueprint/CAD/engineering-sketch style is a **better fit for what I
can actually build** than the "elegant illustration" framing in v1 —
this isn't a downgrade, it's a more precise brief. Blueprints are
*already* schematic simplifications (thin uniform strokes, no
shading, no perspective realism, construction/dimension lines as a
first-class element) — that's exactly the vocabulary a `CustomPainter`
built from lines/rects/arcs speaks natively. Revising §1's guidance:
**recommend blueprint/technical-sketch line art**, superseding v1's
plainer "abstract geometric" framing (not contradicting it — a
blueprint motif *is* an abstract geometric motif, just with the added
convention of dimension lines, hatching, and construction marks that
read as unmistakably "technical drawing," which is the recognizability
your brief is actually asking for).

Per-motif feasibility, honestly graded — this is the part that
matters, not the previous framing:

| Motif from your list | Feasibility | Recommendation |
|---|---|---|
| Warehouse **floor plan** (top-down aisles, bay outlines) | High — literally a grid + rectangles, this is what a real architectural floor plan *is* | Build as specified |
| **Shelving layout** (Racks module) | High — rack elevation = repeated horizontal lines + vertical uprights, already in v1 §5 | Build as specified |
| **Storage cells** (Slots) | High — single bounded rectangle with corner tick marks, already in v1 §5 | Build as specified |
| **Board dimensions / technical panel drawing** | High — this is literally a dimension-arrow diagram, the single easiest "CAD" motif to do well | Build as specified, priority motif |
| **Nesting/offcut fragments** | High — angled-cut rectangle, already in v1 §5 | Build as specified |
| **Edge banding roll / spool cross-section** | High — concentric arcs + one straight tangent line, a standard CAD cross-section convention | Build as specified |
| **Blueprint-style export/document sheets** | High — rectangle with a folded corner + a few horizontal "text" lines, standard technical-doc iconography | Build as specified |
| **Forklift** | Medium — a *side-elevation schematic* (a box body, two thin vertical mast lines, two wheel circles) reads as "forklift" the same reduced way a parking-sign pictogram reads as "car." A photorealistic forklift is out of reach; a 6-line technical elevation is not | Build, but as a flat schematic elevation, not a 3D render — set that expectation now so the result isn't a surprise |
| **Warehouse "perspective"** | Medium — true 3D perspective drawing is a genuinely hard rendering problem by hand-coded paths. An **isometric** line grid (30°/150° axes, the classic CAD-isometric convention) gets 90% of the "dimensional" feel at a fraction of the complexity, and isometric IS a standard blueprint convention, not a compromise dressed up as one | Recommend isometric grid instead of literal perspective — same "technical drawing" read, achievable quality |
| **Operator silhouette** (Scanner module) | Medium-low as literally described (a human figure rendered well in line art is genuinely hard — bad human figures read as amateurish faster than almost anything else, directly risking the "premium" goal) | Recommend an **ISO/pictogram-style figure** instead — the simplified circle-head + trapezoid-body convention from safety/wayfinding signage. That register is *already* "technical drawing" (ISO 7010 pictograms are literally engineering-standard symbols), it's easy to draw cleanly, and it won't read as a cartoon |
| **QR label + scan frame** | High — corner brackets + a small square grid pattern for the "label," already in v1 §5 | Build as specified, this one's a gift — it's the easiest AND most recognizable motif on the list |
| **Material trolley** (Shopping List) | Medium — a simple flat-cart schematic (rectangle deck + two wheel circles + a vertical handle line) is easy; skip trying to depict "stacked panels ON the trolley" in the same motif — one clear shape reads better at 3% opacity than a busy compound scene | Build the cart alone; drop the stacked-panels-on-cart detail |
| **Production overview** (Dashboard) | High — already in v1 §5 as a bar-chart silhouette; this doubles as "production overview" without inventing a second motif for the same screen | Keep v1's motif, no change |

Net effect: **11 of 13 requested motifs are straightforwardly
buildable as literally described or near enough that no one will
notice the simplification; 2 (forklift, operator) get a specific,
named simplification (schematic elevation / ISO pictogram) so the
result stays in "premium technical drawing" territory instead of
sliding into "amateur clip-art," which is the actual risk being
managed here.**

### 12.2 Motion design — expanding the v1 catalog, same budget

v1 §7 already set a hard rule (≤250ms, respects reduce-motion, reject
stagger-in on data lists) — that rule stays. Expanding *which*
transitions get built, not loosening the budget:

- **Shared-element transitions, recommended and concrete**: Flutter's
  built-in `Hero` widget is the direct tool for this — no custom
  animation engine needed. Proposed: the entity's leading icon (the
  same `Icon` already shown in every `WFListTile`) becomes a `Hero`
  between list and detail screens — `WarehouseListScreen` →
  `RackListScreen` → `SlotGridScreen` → `SlotDetailScreen` →
  `BoardDetailScreen`/`OffcutDetailScreen`. This is exactly the
  "premium navigation" feel named in your brief (Linear/Notion-style
  continuity), it's cheap (one widget wrapper, no new painter), and
  it visually reinforces the hierarchy drill-down that's already
  WoodFlow's actual navigation model — so it's illustrating real
  structure, not decoration for its own sake.
- **Premium dialog/bottom-sheet entrance**: propose a slightly more
  deliberate curve (`Curves.easeOutCubic` over ~200ms scale+fade)
  replacing Material's default sheet slide, applied once inside
  `showWFBottomSheet`/`showWFConfirmationDialog`/`showWFDialog` —
  three call sites, every dialog in the app upgrades at once. Still
  inside budget.
- **Still rejected, unchanged from v1**: per-item stagger-in on
  scrolling lists (Warehouse/Rack/Slot/Shopping list) — this is the
  one place "premium" and "fast warehouse-floor workflow" genuinely
  pull in opposite directions, and per `mobile-ux-expert`'s
  standing brief, the workflow wins.
- **New rejection**: full custom page-route transform animations
  (parallax, 3D flips, morph transitions between totally different
  layouts). These are exactly the "flashy" category your own brief
  says to avoid, and they're also the highest-risk category for
  jank on a real, possibly mid-range warehouse-floor Android device —
  `performance-reviewer`'s objection, not just a style preference.

### 12.3 Navigation — reviewed, and yes, there's a real improvement here

Current state, confirmed by re-reading the code: `WarehouseListScreen`
has **seven** `AppBar` actions today (QA debug icon [dev-only,
excluded from release builds], Shopping List, Calculators, Export,
Dashboard, Scan, AI Query) — this was flagged as an explicit open IA
question back in `WoodFlowDesignSystem.md` and never resolved. Your
brief is the right moment to close it.

**Rejected options, with reasons:**
- **Radial/pie menu** — not a pattern used by any of your own named
  references (Linear, Notion, Figma, Stripe all use linear
  lists/bars, never radial), worse one-handed reachability on a
  phone than a vertical list, and no established accessibility
  convention for it. Rejected outright.
- **Bottom dock nav (persistent tab bar)** — WoodFlow's structure is
  a *drill-down hierarchy* (Warehouse → Rack → Slot → Board/Offcut),
  not a set of 5–7 equal-weight peer destinations the way a dock
  implies. Forcing the tool screens (Export, Calculators, Dashboard,
  Shopping List, AI Query) into dock-tab peers of "Warehouses"
  misrepresents the app's actual shape. Rejected.
- **"Hide everything behind one expandable FAB/command hub,"
  applied uniformly** — rejected specifically for **Scan**. Scanning
  a QR code is very plausibly the single most frequent action in the
  entire app on an actual warehouse floor (per `warehouse-expert`) —
  burying the highest-frequency action one extra tap deep, purely for
  visual tidiness, directly fights the "few taps" principle this
  project has held all session. The other five tools genuinely are
  lower-frequency (checked a handful of times per day/week, not
  dozens of times per shift) and are good candidates for
  consolidation — Scan is not.

**Recommended: split by actual frequency, not by aesthetics.**
1. **Scan stays a single, always-visible, top-priority action** —
   proposed as the app's *second* `WFFloatingActionButton` (leading
   position, before "New Warehouse"), or the single leftmost `AppBar`
   icon if a second FAB reads as too busy next to the existing one —
   either way, zero extra taps versus today.
2. **The other five (Shopping List, Calculators, Export, Dashboard,
   AI Query) collapse into one "Tools" entry point** — a single
   `AppBar` icon opening a `showWFBottomSheet` grid of five labeled
   tiles (reusing `WFListTile` or a small icon-grid variant of it —
   no new dialog component needed, same `WF*` library). Net result:
   `AppBar` goes from 7 icons to 2 (Scan + Tools), each tool is still
   exactly one tap further than today (icon → sheet → tile, versus
   icon → screen), and the visual clutter your brief is reacting to
   is genuinely gone — not just relocated.

This closes `WoodFlowDesignSystem.md`'s long-open AppBar question
with an actual usability argument, not a coat of paint.

### 12.4 Brand identity — what's already covered, and the one real gap

Most of "every screen should say 'this is WoodFlow'" is already the
*sum* of what's proposed: consistent module motifs (§5/12.1) +
module accents (§4) + the navigation consolidation (12.3) + the
existing `WF*` component shapes/radii, applied everywhere. Proposing
a *sixth*, separate "brand system" on top of that would be exactly
the kind of unnecessary layered abstraction this project has
consistently avoided — so the honest answer is: **there is no
additional brand system to design; the identity IS the consistent
application of everything above.**

One genuine gap, one concrete recommendation: the app title
("WoodFlow") renders today as plain default `AppBar` title text —
identical to what any generic Flutter/Material app would show. Small,
low-risk addition: a deliberate typographic treatment for that one
string specifically on the home (`WarehouseListScreen`) — tighter
letter-spacing, the module-accent green, possibly a thin rule beneath
it — a wordmark *treatment*, not a designed logo. Flagging honestly:
**an actual logo/icon-asset mark is real graphic design work outside
what procedural code can produce well** (same limitation as
photorealistic illustration in §1) — if you want a proper app icon/
logomark, that's a separate, human-designer deliverable, not
something to fold into this proposal.

### 12.5 What changes in the cost estimate

- 12.1's illustration revisions: no change to §11's Medium estimate —
  same painter count, same complexity class, just better-specified
  content.
- 12.2 Hero transitions + dialog curve upgrade: **Small** (a handful
  of widget wraps, no new animation infrastructure).
- 12.3 Navigation consolidation: **Small–Medium** (one new bottom
  sheet, five icon moves, `AppBar` cleanup across every screen that
  currently has the 7-icon row — today that's just
  `WarehouseListScreen`).
- 12.4 Wordmark treatment: **Small** (one `Text` widget's styling).
- **Revised total: still Medium–Large, not Major** — the scope grew
  in specificity, not in size, because §1/12.1's constraint (no
  hand-illustration pipeline) keeps holding the ceiling down.

### 12.6 Updated open questions

Original §10 questions 2–4 (dark mode scope, onboarding in/out,
animation catalog) still stand, unanswered. Adding:

5. **Forklift/operator simplification (12.1)** — confirm schematic
   elevation / ISO pictogram treatment, rather than treating this as
   a blocker on literal depiction.
6. **Isometric vs literal perspective (12.1)** — confirm isometric
   grid for the Warehouse/Dashboard "perspective" motifs.
7. **Navigation redesign (12.3)** — confirm the Scan-promoted +
   Tools-consolidated split, and which placement you prefer for Scan
   (second FAB vs. single leading `AppBar` icon).
8. **Wordmark-only brand treatment (12.4)** — confirm no separate
   logo/icon-asset work is expected as part of this effort.

Still not implementing anything until these, plus §10, are answered.

---

## 13. Addendum (v3) — WoodFlow Command Hub (final navigation decision)

You've made the call on navigation and responsive layout directly —
this section documents the decision, supersedes §12.3's simpler
"Tools bottom sheet" recommendation, and adds the implementation
shape. A companion interactive mockup is published separately (see
message) covering portrait/landscape/tablet visually — this section
is the written spec behind it.

### 13.1 Supersession note

§12.3 recommended a lighter-weight "Scan stays put, five tools
collapse into one bottom sheet" fix, scoped to close the 7-icon
`AppBar` question with minimal new surface area. You've since made a
larger, explicit product decision — a branded Command Hub as a
recognizable navigation *identity*, not just a decluttering fix. That
supersedes §12.3's specific mechanism; §12.3's underlying reasoning
(Scan is highest-frequency, stays exempt; the other five are lower-
frequency, consolidate together) still holds and is exactly why Scan
sits outside the Hub below.

### 13.2 Portrait — Command Hub

- Single floating "WoodFlow" button (bottom-center or bottom-trailing
  — shown both ways in the mockup for comparison), replacing the
  `WFFloatingActionButton` used for "New Warehouse" today on the
  entity-list screens specifically; other screens' existing FABs
  ("New Rack," "New Slot," etc.) are unaffected — the Hub is
  app-level chrome, not a per-screen action.
- Tap sequence: a semi-transparent scrim fades in over the current
  screen (dims, doesn't blur — cheaper, and keeps content legibly
  present underneath, which matters if someone taps by habit while
  mid-task) → the button scales/morphs into a panel anchored at its
  own origin point (not a generic centered dialog — the panel visibly
  *comes from* the button, which is what makes this read as one
  connected interaction rather than "a menu happened to open") →
  panel content (six module tiles) fades/slides in slightly after the
  panel shape settles, staggered by ~20–30ms per tile, not more —
  six items at a short stagger reads as "considered," unlike a
  10+ item list where the same technique reads as "slow."
- Implementation shape: an `OverlayEntry` (not a new route/page) — a
  Command Hub open/close is a chrome-level state change, not
  navigation, and shouldn't disturb the existing screen's own
  `Navigator` stack underneath it. Animation via a single
  `AnimationController` driving scrim opacity, panel scale/position,
  and content opacity as one coordinated timeline (~280–320ms total —
  intentionally a touch over the ≤250ms budget set for micro-
  interactions in §7/12.2, because this is the one deliberate "brand
  moment" in the whole app, not a routine action repeated dozens of
  times a shift; still respects `disableAnimations` by snapping
  straight to the open state).

### 13.3 Landscape — navigation rail

Confirmed: replace the Command Hub with Flutter's built-in
`NavigationRail` (icons + labels, per your spec) rather than keeping
the overlay pattern rotated — an overlay panel makes sense as a
*floating* interruption on a tall, narrow portrait screen; on a wide
landscape screen a persistent rail is strictly more efficient (zero
taps to switch modules instead of one) and is the standard, expected
pattern on every platform this could plausibly ship to next. Not
inventing a new widget — `NavigationRail` is the direct, un-fought
tool for this, matching `woodflow-architect`'s "reuse existing
components" rule at the Flutter-framework level, not just the `WF*`
level.

### 13.4 Tablet — permanent rail + adaptive content

Same `NavigationRail`, permanently visible (not collapsible), plus:
- **Dashboard**: `OwnerDashboardScreen`'s stat-card `Row`s already
  wrap two cards per row on phone; on tablet width this becomes a
  `GridView`/`Wrap` at 3–4 cards per row, and the stale-items list
  gains a second column instead of running the full width — this is
  a `LayoutBuilder` breakpoint change to an existing screen, not a
  new one.
- **Forms** (the various `showWFBottomSheet` create/edit forms):
  above the tablet breakpoint, render as a centered fixed-width
  panel (e.g. 480px) rather than a full-width sheet — full-width
  text fields on a 1024px-wide tablet screen is exactly the "large
  empty areas" your brief calls out.
- Breakpoints: **not inventing new numbers** — using Material 3's own
  standard window-size classes (600dp compact/medium boundary,
  840dp medium/expanded boundary), so this rides on a convention
  Flutter's own `MediaQuery`-based tooling already understands,
  instead of a bespoke breakpoint set only this app knows about.

### 13.5 QR Scanner — confirmed exempt, placement

Stays outside the Hub entirely, per your explicit reasoning (primary
daily workflow) and matching §12.3's frequency argument. Placement:
its own persistent, always-visible action — proposed as a second,
smaller FAB (or the single leading `AppBar` icon on screens where a
second FAB would visually compete with the Hub button) present on
every screen, not just the Warehouse list. Zero taps added versus
today's behavior; the only change is *where* it sits once the other
six icons move into the Hub.

### 13.6 Role-based navigation (future) — not built now, seam kept open

No Auth/Role system exists yet (v2.5, per `EntityEditingSpecification.md`
§0.1's confirmed fact — still true here). Building permission logic
now would be speculative. What *is* worth doing now, cheaply: define
the Hub's six modules as a plain list of descriptors (id, icon,
label, route) rather than hard-coding six `WFListTile`-equivalent
widgets inline — a filter step (`modules.where((m) => role.canSee(m))`)
slots in later without restructuring the Hub itself. This is the same
"one seam, not a built permission system" approach already used for
QR regeneration's "admin-only" comment (§0.2) — except this time the
seam is real code shape, not just a comment.

### 13.7 Brand language beyond the app

Scoping honestly: this proposal, and this Flutter codebase, can only
speak to the app itself. Two pieces already exist *inside* this
codebase and are legitimate near-term extensions of the same
blueprint language: `PdfLabelGenerator` (QR labels) and the
PDF/CSV/RTF `ExportGenerator`s — both could pick up the same
accent-color-per-context and thin technical-line treatment as a
follow-up, small task once the in-app version is approved and built,
since the visual vocabulary would already exist to reuse. Website,
desktop application, and marketing materials are different
codebases, teams, and tools entirely — genuinely out of reach of this
session, and flagging that now rather than implying otherwise.

### 13.8 Cost estimate — revised again

The Command Hub (custom overlay, coordinated multi-property
animation, three responsive layout modes via breakpoints, module
descriptor list, rail integration on every screen) is real,
non-mechanical work — more than §12.5's "Small–Medium" navigation
estimate. **Revised: Large** on its own (the single biggest line item
in this whole proposal), separate from and in addition to §11's
Medium estimate for the motif/accent/motion work. Flagging plainly
since "final product decision" language suggests this is heading
toward approval — the size should be visible before that happens, not
discovered mid-build.

### 13.9 Updated open questions

§10 (dark mode, onboarding) and §12.6 questions 5–6 (forklift/operator
simplification, isometric vs. perspective) and 8 (wordmark-only, no
separate logo) still stand. §12.6 question 7 (navigation pattern) is
now answered by this section. Adding:

9. **FAB placement** (13.2) — bottom-center vs. bottom-trailing for
   the Hub button; the companion mockup shows both.
10. **Animation duration** (13.2) — confirm the ~300ms "brand moment"
    exception to the ≤250ms micro-interaction budget, scoped to Hub
    open/close only.

Still waiting for approval before implementing anything.
