# Backlog — WoodFlow (post-Stage-1 candidates)

Planning artifacts only. **None of these are part of the current Stage 1 /
FREE roadmap** (`docs/CHANGELOG.md`, `README.md`) and none carry a Krok
number. They are not scheduled and must not be implemented without a
separate, explicit decision to pull one into a roadmap step. Two related
architectural decisions live as ADRs instead of here, because they impose
binding constraints on future implementers rather than describing a single
feature: `docs/adr/printer-integration.md`,
`docs/adr/smart-offcut-scoring-engine.md`.

---

## Demo Mode

**Priority:** High

**Problem it solves:** A fresh install is an empty database. A prospective
user (or anyone evaluating the app before committing real inventory data)
has nothing to explore — every screen (Dashboard, AI query, Shopping List)
is blank and unconvincing until they've manually built out a warehouse.

**Expected user value:** "Start Empty" vs. "Open Demo Warehouse" choice after
install. The demo path pre-populates a full realistic dataset (warehouse,
racks, slots, boards, offcuts with QR codes) so every existing screen —
Dashboard, AI query (Krok 14), Shopping List, Export — has something
meaningful to show immediately, letting a new user judge the product in
minutes instead of after manual setup.

**Dependencies:** None on unbuilt features — can be built entirely on top of
Stage 1's existing entities/repositories once Stage 1 is complete. Benefits
from Krok 14 (AI v1) and Krok 9 (Dashboard) already existing, since those are
the screens a demo dataset makes most convincing.

**Acceptance criteria (future):**
- First-launch flow offers both options before any warehouse exists.
- Demo dataset covers every entity type (Warehouse → Offcut) with enough
  variety to exercise Dashboard stale-items, Shopping List low-stock, and
  AI query answers non-trivially.
- Demo data is clearly distinguishable from real data (e.g. a marker field
  or naming convention) and removable in one action without residue.
- Choosing "Start Empty" produces byte-identical behavior to today's
  first-launch state (no regression).

---

## WoodFlow Academy

**Priority:** High

**Problem it solves:** A warehouse-management app with 14+ feature areas
(Krok 1–14) has no in-app guidance. New users either read no documentation
and under-use the app, or need external support to discover features like
QR scanning, the shopping list threshold editor, or AI query.

**Expected user value:** Interactive, lesson-based onboarding shown after
first launch — a natural pairing with Demo Mode (lessons performed against
the demo dataset, not the user's real inventory, so mistakes during learning
are free).

**Dependencies:** Demo Mode (lessons need a populated dataset to act on
without touching real inventory). Best sequenced after Stage 1 is feature-
complete, since it needs to reference every screen it teaches.

**Acceptance criteria (future):**
- A discrete lesson exists per major feature area (Warehouse/Rack/Slot setup,
  Board/Offcut lifecycle, QR scan, Dashboard, Export, Calculators, Shopping
  List, AI query).
- Lessons are skippable and re-enterable later from a help/settings entry
  point, not just forced once at first launch.
- Progress is tracked so a partially-completed run can resume.
- No lesson requires real inventory data to complete.

---

## Installation Wizard

**Priority:** High

**Problem it solves:** Today's "first launch" is just an empty app — no
language confirmation, no units choice (mm vs inches), no decision about
QR labels or printer setup, no path into Demo Mode. Every one of those is
either hidden in settings (found late) or hardcoded (not configurable at
all yet).

**Expected user value:** A short first-run flow (language, company name,
units, QR labels on/off, printer setup now-or-later, demo warehouse
yes/no) that leaves the app fully configured in about two minutes, instead
of a new user hunting through menus.

**Dependencies:** Demo Mode (the wizard's last step offers it). Printer
Integration ADR (the wizard's printer step is "configure now or later," not
a full printer setup flow itself — it just needs the ADR's `PrinterService`
abstraction to exist so "later" is a real, working deferral rather than a
dead-end).

**Acceptance criteria (future):**
- Every choice made in the wizard is changeable later from Settings — the
  wizard is a convenience default-setter, not the only way to configure
  these values.
- Skipping the entire wizard produces the same state as today's app (no
  forced choices with no escape).
- Wizard completion is one-time per install, not shown again on normal
  launches.
- "Printer setup later" leaves the app fully usable with zero printer
  configured, per the Printer Integration ADR's core constraint.

---

## Health Check

**Priority:** Medium

**Problem it solves:** Data quality issues (materials without QR codes,
missing decor assignment, duplicate QR codes, items unscanned for months)
accumulate silently. Nothing in the app today surfaces them — an owner only
discovers a duplicate QR code when a scan resolves to the wrong item.

**Expected user value:** A dedicated panel showing warehouse data-quality
metrics (% of materials with QR, materials missing photo/decor, duplicate
QR codes, materials unscanned for X months) so an owner can proactively fix
data issues instead of discovering them as user-facing bugs.

**Dependencies:** None blocking — reads existing Board/Offcut/QR data. Real
value increases once AI v1 (Krok 14) exists, since a "duplicate QR code"
or "missing decor" finding could become an AI-answerable query later.

**Acceptance criteria (future):**
- Each metric has a clear, non-technical definition and links directly to
  the offending items (not just a raw count).
- Panel is read-only in v1 — it surfaces problems, it does not
  auto-fix them.
- Computation reuses existing repositories only, same architecture-boundary
  rule already applied to Dashboard/Shopping List/AI query — no parallel
  data access path.

---

## Diagnostics

**Priority:** Medium

**Problem it solves:** When something goes wrong (sync issue, slow queries,
unclear DB/migration state, backup status), there's no way for the user or
support to see what's actually happening without developer access to the
device.

**Expected user value:** A hidden service screen (DB state, migration
version, sync status, app version, backup status, printer status, response
times) that support staff can walk a user to, without needing remote/dev
access, cutting support resolution time.

**Dependencies:** Printer Integration ADR (printer status row needs
`PrinterService` to exist). Otherwise independent.

**Acceptance criteria (future):**
- Not reachable from normal navigation (explicit "hidden" entry, e.g. a
  gesture or version-tap sequence, consistent with the "hidden service
  screen" intent).
- Every value shown is read-only and sourced from existing services/
  repositories — no new write paths introduced for a diagnostics screen.
- Includes at minimum: DB version (`AppConstants.dbVersion`), pending
  migration state, app version, last backup timestamp (if backups exist by
  then), printer connection status.

---

## Works with WoodFlow

**Priority:** Medium

**Problem it solves:** Hardware vendors (printer, scanner, Pick-to-Light,
RFID, mobile terminal makers) have no defined path to build/certify
compatibility with WoodFlow, even though the Printer Integration ADR
already commits to a vendor-agnostic `PrinterService` abstraction — the
ecosystem direction exists but has no formal program around it.

**Expected user value:** A certification program ("Works with WoodFlow") for
hardware vendors, giving customers a trusted-compatibility signal when
choosing hardware, and giving WoodFlow a partner-ecosystem growth channel
instead of maintaining every integration alone.

**Dependencies:** Printer Integration ADR's `PrinterService` abstraction
(the first concrete interface a vendor would certify against). Realistically
also depends on WoodFlow having enough market presence to make certification
attractive to vendors — a business-readiness dependency, not just technical.

**Acceptance criteria (future):**
- A published, versioned compatibility interface (starting with
  `PrinterService`) vendors can implement against without WoodFlow source
  access.
- A defined (even if manual, v1) certification/testing process before a
  vendor can use the "Works with WoodFlow" mark.
- At least the four brands already named in the Printer Integration ADR
  (Zebra, Brother, Epson, PDF Export) have a clear certification path as
  the pilot cohort.

---

## Feature Preview

**Priority:** Medium

**Problem it solves:** When a FREE-tier user taps a feature gated to
START/PRO/AI, today that would presumably just block them with an empty/
disabled state — a dead end that doesn't communicate value or invite
upgrade.

**Expected user value:** Tapping a higher-tier feature shows a short preview
(animation/example/benefit summary) instead of a blank block, turning a
dead-end into a soft upsell moment — supports future START/PRO/AI plan
sales without being a hard paywall interruption.

**Dependencies:** Requires tiered plans (START/PRO/AI) and at least one
gated feature to exist first — currently everything shipped is Stage 1/
FREE, so this has no gated feature to preview against yet.

**Acceptance criteria (future):**
- Preview content is specific to the tapped feature, not a generic "upgrade
  now" screen.
- Never blocks or crashes the surrounding FREE-tier workflow — it's an
  overlay/dialog the user can dismiss and continue using the app normally.
- Same "must never be a dependency" principle as Printer Integration: a user
  who never upgrades still has a fully usable FREE app underneath every
  preview.

---

## Confidence Level *(future AI)*

**Priority:** Low

**Problem it solves:** Once AI logic goes beyond the current Krok 14
deterministic parser (i.e. once real decision/recommendation logic exists,
per the Smart Offcut Scoring Engine ADR's v2.x/v3.0 stages), a recommendation
without any indication of how reliable it is invites either blind trust or
blind distrust — neither is safe for warehouse decisions.

**Expected user value:** A visible confidence indicator on AI answers, with
the data sources behind it, so operators can calibrate how much to trust a
given recommendation instead of treating every AI output as equally
authoritative.

**Dependencies:** Real decision/weighting logic (Smart Offcut Scoring Engine
ADR, v2.x+) — Krok 14's parser is deterministic pattern-matching with no
uncertainty to express, so this has nothing to attach to until that logic
exists.

**Acceptance criteria (future):**
- Confidence is derived from real signal (data completeness, rule-weight
  agreement, historical accuracy) — never a decorative/fake number.
- Data sources behind a given answer are enumerable and shown, not just a
  single opaque score.
- Does not apply to, and is not shown on, Krok 14's deterministic query
  answers — those are exact lookups, not probabilistic recommendations.

---

## Explain AI *(future AI)*

**Priority:** Low

**Problem it solves:** Same dependency as Confidence Level: once the Smart
Offcut Scoring Engine (or similar) produces a recommendation, "the AI says
Scrap" with no reasoning is not actionable or trustworthy for a business
decision an operator is accountable for.

**Expected user value:** A "Why?" button next to AI recommendations that
shows the actual reasoning (which factors/weights drove this decision), so
operators can verify or challenge a recommendation instead of accepting or
rejecting it blind.

**Dependencies:** Real decision/weighting logic with inspectable
factors — same dependency as Confidence Level (Smart Offcut Scoring Engine
ADR, v2.x deterministic rule engine at minimum; more informative once v3.0's
learned adjustments exist too).

**Acceptance criteria (future):**
- Explanation reflects the actual rules/weights that fired for that specific
  decision — never a generic canned description of the feature.
- Available for every AI recommendation that has one, not a subset.
- Does not apply to Krok 14 — its answers are direct data lookups with no
  "decision" to explain (the answer *is* the explanation: "you asked for X,
  here is X").

---

## Smart Slot Recommendation

**Priority:** Medium

**Problem it solves:** When placing a new Board or Offcut into a Slot, the
operator has no assistance today deciding *where* — every Rack/Slot in a
Warehouse looks the same to the app, so the current picker offers no signal
about which location would actually make sense (grouping the same decor
together, favoring slots with available capacity, and similar). This is a
different problem from Krok 14's AI query engine, which only answers
"where is X *already*" — nothing today helps decide where something *new*
should go.

**Expected user value:** When adding a Board/Offcut to a Slot, the system
suggests one or more candidate Slots based on existing warehouse data — but
the suggestion is always advisory, never a decision made for the operator:
- The operator can accept, reject, or override the recommended slot at any
  time.
- If the recommended slot is no longer available by the time the operator
  acts on it, the system offers **"Find another location"** — it never
  silently substitutes a different slot or forces the original
  recommendation through.
- The recommendation never forces or automatically executes a warehouse
  operation on its own — it only ever proposes; the operator's own
  confirmation is what actually places material, the same as every other
  create/move flow already in the app.
- The recommendation is advisory only, end to end — the operator remains in
  control of the final placement at every step.

**Dependencies:** None on unbuilt features — could be built entirely on top
of Stage 1's existing Warehouse/Rack/Slot/Board/Offcut entities and
repositories. Would likely reuse the same "search existing data, propose,
let the operator decide" shape already established by Krok 14's
`OffcutMatchFinder` and the Cut Optimizer's own propose-never-auto-execute
pattern (`docs/specs/Krok15_CutOptimizer_Specification.md`), rather than
inventing a new interaction model.

**Acceptance criteria (future):**
- The operator can accept, reject, or override the recommended slot at any
  time before confirming placement.
- If the recommended slot becomes unavailable, the system offers "Find
  another location" — it never silently substitutes or forces a different
  slot.
- The recommendation never forces or automatically executes a warehouse
  operation — placement always requires explicit operator confirmation,
  matching every other create/move flow in the app.
- The recommendation is advisory only; declining it entirely (manual slot
  selection) remains fully supported and is never degraded.

---

## Physical Storage Safety

**Priority:** High

**Problem it solves:** Overcrowded or poorly organized offcut storage
creates a real physical risk — materials stacked beyond safe capacity or
haphazardly arranged can topple onto an operator. Today `Slot.capacity`
exists only as a number driving the fill-ratio display (Ch. 9 of the
Handbook) — it carries no safety semantics and triggers no warning of any
kind when exceeded or approached.

**Expected user value:** A future warning mechanism that helps operators
and owners recognize when a Slot's physical storage is approaching an
unsafe state, rather than relying entirely on visual judgment on the
floor.

**Dependencies:** None on unbuilt features — `Slot.capacity` already
exists as a starting data point, though it is not assumed here to already
solve the problem.

**Acceptance criteria (future):**
- To be defined by a future Phase 1 — this entry intentionally does not
  specify capacity limits, overcrowding-detection logic, warning
  thresholds, or how risk is presented to the operator.
- Must not assume `Slot.capacity`'s existing fill-ratio number is
  sufficient on its own without that future Phase 1 explicitly deciding so.
