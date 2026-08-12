# Krok 15 — Cut Optimizer: Phase 1 Specification

**Status:** 📝 Phase 1 — Specification only, per `docs/WoodFlow_Handbook.md`
Chapter 23.2. **Nothing in this document has been implemented.** No
widgets, screens, routes, assets, or database migrations exist for
this feature. Wait for explicit Product Owner approval before any
Phase 2 work begins.

**Revision note:** the Product Owner has resolved Open Questions 1
(guillotine cutting only) and 2 (`CuttingJob` persisted) — see Section
11. Every section below has been reconciled against those two
decisions. **This is still not approval to begin implementation** —
Open Questions 3–7 remain open, and no Phase 2 work has started.

**Location note:** this is the first Phase 1 spec filed under
`docs/specs/` — no existing Handbook chapter or archived document
already owns "Cut Optimizer" (Handbook Ch. 1/26 only mark Krok 15 as
"not started"), so per Chapter 2's single-source-of-truth check, a
new document is the correct home, not an extension of something that
doesn't exist yet. Once approved, this becomes a new Handbook chapter
rather than staying a standalone file — same lifecycle as every prior
Phase 1 document this project has produced.

**Grounding:** every architectural claim below cites the existing
codebase or Handbook chapter it extends, not a fresh invention. Where
no such precedent exists (the optimization algorithm itself), that's
stated plainly, not implied to be more settled than it is.

---

## 1. Purpose

**Business objective:** minimize wasted panel material when an
operator cuts a Board into the pieces a job actually needs. Panel
material (MDF/HPL/laminate board) is a direct, significant cost line
for a wood/furniture manufacturer — every cm² of avoidable waste is
margin lost on every job, not a cosmetic inefficiency.

**User problems solved:**
1. Today, cutting a Board into multiple required pieces is entirely
   manual guesswork — an operator has no tool-assisted way to know
   whether four required pieces fit efficiently on one Board or need
   two, or which orientation minimizes offcut waste.
2. Krok 14's AI query engine can answer *"is there already an offcut
   big enough for this one piece?"* (`OffcutMatchFinder`,
   `docs/WoodFlow_Handbook.md` Ch. 10/16), but has no concept of a
   *cutting list* (multiple pieces, possibly needing a fresh cut from
   a Board when no existing offcut fits) — it finds a match, it
   doesn't plan a cut.
3. There is no way today to see, before committing a saw cut, what a
   proposed layout looks like or how much material it will waste.

**Why this belongs in Stage 1:** it is not a new scope decision — it
is Krok 15, the final, already-confirmed step of the Stage 1/FREE
roadmap (Handbook Ch. 1, Ch. 26). Krok 14's own scope was explicitly
bounded specifically so this would remain Cut Optimizer's job, not
duplicated early: `OffcutMatchFinder`'s existing doc comment states
its geometric matching is *"prep for [Cut Optimizer], not a
substitute."* This spec is that commitment being cashed in, not a new
one being made.

---

## 2. Functional Specification

### Workflow

1. **Build a cutting list** — the operator specifies one or more
   required pieces: dimensions, decor, quantity, and whether rotation
   is allowed (see grain-direction note under Validation). **Now
   persisted as soon as created** (a `CuttingJob` in `draft` status,
   Section 5) — it survives leaving the screen, per the Product
   Owner's decision on Open Question 2.
2. **Search existing stock first** — for each required piece, the
   system checks for an already-available Offcut that satisfies it,
   reusing `OffcutMatchFinder` (Krok 14) unchanged rather than
   re-implementing that check.
3. **Plan new cuts for the remainder** — pieces with no matching
   Offcut are grouped and run through the **guillotine-only**
   optimization algorithm (Section 6) against available Boards,
   producing a proposed cutting layout: which Board(s), where each
   piece is positioned, and what's left over. **The computed layout is
   persisted** as part of the `CuttingJob` (status → `planned`) — the
   proposed plan itself is now durable, not just the input list.
4. **Review** — the operator sees the full proposed plan (which
   existing Offcuts get consumed, which Boards get cut and how,
   projected waste) before anything happens to real inventory. Because
   the plan is persisted, review can now happen in a later session, not
   only immediately after optimizing.
5. **Confirm & execute** — on confirmation, the system **re-validates
   that every referenced Offcut/Board is still available** (a new
   requirement introduced by persistence — a planned job can go stale
   between planning and execution, see Section 8), then executes as
   one atomic operation (Section 4): matched Offcuts are archived,
   selected Boards are cut per the computed layout, new Offcuts are
   created for any leftover piece large enough to be worth keeping,
   the full Ledger trail is written, and the `CuttingJob` transitions
   to `executed` — the exact same archive-not-delete, append-only
   rules already governing every other Board/Offcut mutation (Handbook
   Ch. 20.6).

### Inputs

- Cutting list: `{ lengthMm, widthMm, thicknessMm, decorId, quantity, allowRotation }` per row.
- Search scope: which Warehouse(s) to draw stock from (open question, Section 11).
- Kerf width (saw blade material loss per cut) — a numeric setting; source and default value are open (Section 11).

### Outputs

- A proposed plan: per involved Board, the placement of every piece
  (position, rotation) and the resulting waste region(s); per
  consumed Offcut, which piece it satisfies.
- A summary: total pieces satisfied from existing stock vs. newly
  cut, boards consumed, total waste area/percentage.

### User interactions

Add/edit/remove cutting-list rows; run optimization; review the
proposed plan (Section 3); accept or discard; confirm execution.

### Validation

- Every piece's `decorId` must match its source material's `decorId`
  exactly — never mixed, same rule already enforced by `cutFromBoard`
  today.
- Thickness must match exactly — no cutting a piece from
  wrong-thickness stock.
- A piece must fit within its assigned source's *remaining* usable
  area after accounting for kerf on every cut, independently
  re-verified before execution (Section 8) rather than trusted from
  the algorithm alone.
- **Guillotine validity (new, per Open Question 1's resolution):**
  every proposed placement must be expressible as a sequence of
  straight, full-length, edge-to-edge cuts (Section 6's formal
  definition). A layout that would require a partial/interior cut is
  invalid and must never be proposed, not just discouraged.
- **Grain/pattern direction:** many wood/laminate decors have a
  directional grain or pattern — rotating such a piece 90° during
  layout would produce a visibly wrong result even though it "fits."
  **No field capturing this exists on `Decor` today.** Treated here
  as a required, unresolved input to this spec, not assumed away —
  see Section 11.

### Error handling

- No source material (existing Offcut or Board) can satisfy a
  required piece at all (piece larger than any stock, or wrong
  thickness/decor never in inventory) → reported as **unmatched**,
  clearly separated from "matched but requires a new cut," not a
  silent failure.
- Insufficient total stock to satisfy the full cutting list → same
  "unmatched remainder" reporting, at cutting-list granularity — a
  natural extension of Shopping List's (Ch. 12) existing
  shortage-reporting philosophy, not a new failure paradigm.
- **Stale persisted plan (new, direct consequence of Open Question 2's
  resolution):** a `planned` `CuttingJob`'s referenced Offcut or Board
  is consumed by something else (another cutting job, a manual
  archive, a move) before execution → execution must fail cleanly with
  a "this plan is no longer valid, re-plan" message, never proceed
  against a stale assumption. This risk did not exist under the
  ephemeral option and is a direct, new obligation created by choosing
  persistence — see Section 8.

### Edge cases

- Requested piece dimensions exceed the largest available/producible
  Board in scope → rejected outright with a clear reason, not
  silently dropped.
- Quantity ≤ 0 → validation error at entry, not at optimization time.
- Kerf ≥ the smallest requested dimension (degenerate input) →
  validation error.
- Two cutting plans executed concurrently against overlapping source
  material → must not both succeed and double-consume the same Board
  or Offcut; addressed structurally in Section 4/8, not left to
  chance.
- A `planned` `CuttingJob` is reopened for editing after its
  underlying stock has changed → must re-run validation (and likely
  re-optimization) before it can return to `planned`, not silently
  keep a now-inaccurate layout.

---

## 3. User Experience

### UX flow

```
Command Hub / entry point
        ↓
  Cutting List screen  (build the list of required pieces)
        ↓  [Optimize]
  Optimization Results screen  (review proposed plan, per board)
        ↓  [Confirm]
  Execution Summary screen  (what actually happened)
        ↓
  back to Cut Optimizer home / Dashboard
```

### Screen layout (low-fidelity — structure, not visual design)

**1) Cutting List**

```
┌──────────────────────────────────────────┐
│ ← Cut Optimizer                    [?]    │
├──────────────────────────────────────────┤
│  Pieces needed                            │
│  ┌────────────────────────────────────┐  │
│  │ 600×400  H3303  qty 4   [rotate: N]│  │
│  │ 300×300  H3303  qty 2   [rotate: Y]│  │
│  └────────────────────────────────────┘  │
│                                            │
│           [ + Add piece ]                 │
│                                            │
│  ┌────────────────────────────────────┐  │
│  │          Optimize  →                │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

**2) Optimization Results**

```
┌──────────────────────────────────────────┐
│ ← Results                                 │
├──────────────────────────────────────────┤
│  Summary: 5 of 6 pieces satisfied         │
│  1 existing offcut reused · 1 board cut   │
│  Waste: 340 mm² (4.1%)                    │
├──────────────────────────────────────────┤
│  Board #1 (2800×2070)                     │
│  ┌────────────────────────────────────┐  │
│  │ [600x400] [600x400] [300x300]      │  │
│  │ [600x400] [600x400] [300x300]      │  │
│  │ ░░░░░░░░░░ waste ░░░░░░░░░░░░░░░░  │  │
│  └────────────────────────────────────┘  │
│                                            │
│  ⚠ 1 piece unmatched — see below          │
│                                            │
│  [ Discard ]          [ Confirm & Cut ]   │
└──────────────────────────────────────────┘
```

**3) Execution Summary**

```
┌──────────────────────────────────────────┐
│  ✓ Cutting plan executed                  │
├──────────────────────────────────────────┤
│  1 offcut archived (consumed)             │
│  1 board archived (fully consumed)        │
│  2 new offcuts created                    │
│  5 pieces ready for use                   │
│                                            │
│           [ Done ]                        │
└──────────────────────────────────────────┘
```

### Navigation

Entry point is an open question (Section 11) — whether Cut Optimizer
becomes a 7th tile in the Command Hub's module grid (Handbook Ch.
5.2, which currently names exactly six: Dashboard, Warehouses,
Shopping List, Calculators, Export, Settings) or ships through an
interim entry point decoupled from Chapter 5's own pending approval.

### User journey (concrete example)

An operator needs four 600×400mm pieces in decor H3303 for a job.
They open Cut Optimizer, add one cutting-list row (`600×400 × 4,
H3303`), tap Optimize. The system finds one existing Offcut already
satisfying one piece, and a layout using one new Board for the
remaining three. The operator reviews the diagram, confirms, and the
one Offcut is archived while the Board is cut into three pieces plus
a leftover — all as one action from the operator's perspective, one
atomic transaction underneath it.

---

## 4. Architecture

### Required modules (naming follows existing project convention, not final)

| Layer | New | Reuses |
|---|---|---|
| `domain/entities/` | `CuttingJob`, `CuttingPieceRequest`, `CutPlacement`, `CutLayout` | `Board`, `Offcut`, `Decor` (unchanged) |
| `domain/services/` | `CutOptimizationEngine` (pure, stateless — same shape as `BoardMeasurementCalculator`, `OffcutMatchFinder`) | `OffcutMatchFinder` (Krok 14, called as the first-pass search, not reimplemented) |
| `domain/repositories/` | `CuttingJobRepository` (own contract, not `BaseRepository` — see below) | — |
| `domain/usecases/` | `ExecuteCuttingPlanUseCase` (interface) | Same pattern as `DeleteWarehouseUseCase`/`DeleteRackUseCase`/`DeleteSlotUseCase` |
| `data/repositories/` | `CuttingJobRepositoryImpl` | Standard repository-implementation shape (Ch. 20.1) |
| `data/usecases/` | `ExecuteCuttingPlanUseCaseImpl` | Operates on `DatabaseService.transaction()` directly, same reasoning as `cascade_archive_helpers.dart` (Handbook Ch. 20.5) — sqflite has no nested transactions, so this can't be built by calling `BoardRepository`/`OffcutRepository` methods from inside each other |
| `data/database/migrations/` | `v9_add_cutting_jobs.dart` (not created now — see Section 5) | Same versioned-file convention as `v1`–`v8` (Ch. 20.4) |
| `presentation/cut_optimizer/` | Three screens (Section 3), now with save/resume behavior | `WF*` component library exclusively (Handbook Ch. 4) — no new UI patterns |

**Why `CuttingJobRepository` gets its own contract, not `BaseRepository`:**
same reasoning already applied to `BoardRepository`/`OffcutRepository`
— a `CuttingJob`'s lifecycle (`draft → planned → executed`, with
`executed` effectively frozen once written) is not plain CRUD, so
forcing it into the generic four-method interface would fight the
shape of the problem rather than fit it.

### Responsibilities

- `CutOptimizationEngine` — pure computation. Given a source pool
  (Boards + already-available Offcuts) and a cutting list, returns a
  proposed `CutLayout`. No database access, no I/O — identical shape
  to every existing pure calculator in this codebase. Unaffected by
  persistence — it still knows nothing about how its output gets
  saved.
- `CuttingJobRepositoryImpl` — persists the working document: creating
  a `draft`, saving a computed `CutLayout` (→ `planned`), reading a job
  back for review/resume. This is *not* where inventory actually
  changes — a `planned` job has touched no `Board`/`Offcut` row yet.
- `ExecuteCuttingPlanUseCaseImpl` — the only class that mutates real
  inventory for this feature. Takes a persisted, `planned`
  `CuttingJob`, re-validates its referenced sources are still
  available (Section 2's new stale-plan handling), then archives
  consumed Offcuts, cuts selected Boards, creates new Offcuts, writes
  Ledger entries, and transitions the job to `executed` — atomically,
  all or nothing.
- Presentation screens — UI only. Per the precedent set by
  `DashboardService`/`OwnerDashboardScreen` (Ch. 15), the screen does
  **zero** computation; it renders what the engine/use case produced,
  now including a resumed-from-persistence state on reopen.

### Integration with existing architecture

- `domain/` never imports `data/` or Flutter (Ch. 20.1) — the
  optimization engine is pure Dart, testable without a device or a
  database.
- `get_it` registration follows the existing convention (Ch. 20.2) —
  one new block in `service_locator.dart`, no new DI mechanism.
- `Result<T>` used throughout (Ch. 20.3) — optimization can fail
  (insufficient stock), execution can fail (a piece no longer fits by
  the time of confirmation); neither throws.

### Separation of concerns

Algorithm (pure) → orchestration/persistence (use case) →
presentation (screens): the same three-layer split every other
non-trivial feature in this codebase already uses. No new
architectural pattern is being introduced.

### Performance considerations

This is the first feature in the codebase doing genuinely
nontrivial computation (cutting-stock optimization is NP-hard in the
general case — see Section 6). Everything else so far is lookup,
aggregation, or simple arithmetic. If the algorithm's runtime is ever
non-trivial for a realistic cutting list, it must not block the UI
thread — flagged as a real, new-to-this-project consideration, not
assumed away (Handbook Ch. 19's 60 FPS/no-jank rule applies here for
the first time in a way that actually requires engineering
attention, not just discipline).

---

## 5. Data Model

**Persistence is now decided (Open Question 2: persisted).** This
section describes the required schema — still design only, no
migration file created.

### Required entities

| Entity | Fields | Persisted? |
|---|---|---|
| `CuttingJob` | `id`, optional `label`, `status` (`draft` \| `planned` \| `executed` \| `discarded`), `warehouseId` (nullable — depends on Open Question 6, not resolved), `kerfMm` (the value actually used, captured regardless of where it came from — see Open Question 7), `createdAt`, `updatedAt`, `executedAt` (nullable) | **Yes** |
| `CuttingPieceRequest` | `id`, `cuttingJobId` (FK), `lengthMm`, `widthMm`, `thicknessMm`, `decorId`, `quantity`, `allowRotation` | **Yes** |
| `CutPlacement` | `id`, `cuttingJobId` (FK), `pieceRequestId` (FK, **nullable** — null means this row is a leftover/waste region, not a satisfied piece), `sourceType` (`existingOffcut` \| `newBoardCut`), `sourceBoardId` or `sourceOffcutId`, `xMm`, `yMm`, `rotationDegrees` (`0` or `90` only — guillotine layouts are axis-aligned, Section 6), `exceedsUsefulThreshold` (bool, evaluated at planning time — see Open Question 4 dependency below) | **Yes** |

One table (`CutPlacement`) serves both placed pieces and leftover
regions, distinguished by a nullable `pieceRequestId`, rather than two
near-identical tables — the same "don't introduce a second structure
for the same shape of problem" reasoning Chapter 2 already applies to
documentation, applied here to schema.

### Required relationships

- `CuttingJob` 1→N `CuttingPieceRequest`.
- `CuttingJob` 1→N `CutPlacement` (populated once status ≥ `planned`).
- `CutPlacement` N→1 `CuttingPieceRequest` (nullable, as above).
- `CutPlacement` N→1 `Board` **or** N→1 `Offcut` (whichever
  `sourceType` says) — a *reference* to the existing row, never a
  copy of its data, the same "one location field, never duplicated"
  discipline `Board.slotId` already follows (Handbook Ch. 10).
- `CuttingJob` ↔ `LedgerEntry`: **no new foreign key.** Ledger entries
  written during execution (`ExecuteCuttingPlanUseCaseImpl`) include
  `cuttingJobId` in their existing generic `payloadJson` — reusing
  `ledger_entries`' own documented design ("generic... so future
  entities can log into this same table without a schema change,"
  Ch. 20.6) rather than adding a new relational link for something
  the table was already built to accommodate.

**No new "kind of stock" entity is introduced.** Execution still only
ever produces real `Board`/`Offcut` rows — everything else in the app
keeps working without learning a new concept.

### What data is stored

- The cutting list itself (`CuttingPieceRequest` rows) — survives
  leaving the screen, per the approved decision.
- The computed plan, once optimization runs (`CutPlacement` rows,
  covering both satisfied pieces and leftover regions) plus the
  `kerfMm` value actually used.
- The execution outcome — `status`/`executedAt` on `CuttingJob`, with
  the detailed trail living in `ledger_entries` (linked via payload,
  not a new table).
- **Not stored:** the optimization algorithm's internal working state
  (search order, intermediate rejected placements) — only the final
  proposed/accepted layout. This keeps the schema stable even if the
  algorithm's *implementation* changes later (Ch. 20.1's layering
  discipline: persisted data shouldn't leak algorithm internals).

### What constitutes a persisted optimization result

Precisely: a `CuttingJob` row at `status = 'planned'` **together with
its complete set of `CutPlacement` rows** (every satisfied piece and
every leftover region). That pairing is sufficient to redraw the
Section 3 results diagram, recompute the summary, or resume review
without recomputation — satisfying your stated requirement that
results "survive leaving the screen and support later review."
Summary statistics (total waste, boards used, offcuts reused) are
derived from these rows on read; whether to also cache them
denormalized on `CuttingJob` for display speed is an implementation
detail for Phase B, not a schema requirement.

### Is a database migration required?

**Yes.** Unlike Krok 14 (Ch. 16, "purely a read-orchestration
feature... no new persisted state"), this decision requires a genuine
schema change: three new tables (`cutting_jobs`,
`cutting_piece_requests`, `cut_placements`). This is the largest
single schema addition since the original Krok 1–8 buildout — sized
accordingly in Section 8's risk list.

### How this fits the existing append-only migration/versioning rules

Two distinct "append-only" ideas apply here, worth separating clearly:

1. **The migration file itself** follows the existing convention
   exactly (Ch. 20.4): one new versioned file, `v9_add_cutting_jobs.dart`
   (name indicative, not final), `AppConstants.dbVersion` bumped
   `8 → 9`, never edited once shipped — a correction would be `v10`,
   not a rewrite of `v9`. No new versioning mechanism needed; this is
   the same rule already governing `v1`–`v8`.
2. **Whether `CuttingJob` *rows* are append-only like the Ledger is a
   separate question, and the answer differs by status.** While
   `draft`/`planned`, a `CuttingJob` is a mutable working document —
   editing a cutting list or recomputing a plan updates its own rows,
   the same way `Warehouse.name` is editable today. Once `executed`,
   the job and its placements should be treated as frozen — any
   further audit trail lives in `ledger_entries` (which *is*
   append-only), not by mutating the now-historical `CuttingJob`
   further. This mirrors the existing Board/Offcut split exactly:
   mutable while active, settled and reference-only once an
   irreversible action (cut, in this case) has happened.

---

## 6. Optimization Algorithm

**No implementation below — approach and reasoning only, per your
instruction.**

### Optimization strategy

This is a variant of the classic **2D Cutting Stock Problem**,
**now fixed by the Product Owner as guillotine-only (Open Question 1,
resolved)** — free-form nesting is explicitly out of scope and must
not be implemented or assumed anywhere in this feature.

### What constitutes a valid guillotine cut

A guillotine cut is a straight cut spanning the **full width or full
length** of the piece currently being cut — edge to edge, no partial
or interior cuts. Formally, recursively: starting from the full
Board, each cut splits the current rectangle into exactly two smaller
rectangles (a horizontal or vertical split); every subsequent cut is
a further full-length split of one of the resulting rectangles. This
produces a binary "guillotine cut tree" whose leaves are either a
placed piece or a leftover region. This is the standard definition
used in the cutting-stock literature, and it matches how a real panel
saw physically operates — each pass cuts all the way across the
material on the saw's rail; there is no such thing as a partial pass.

### What is explicitly out of scope

- Any placement requiring a partial/interior cut (an L-shaped or
  notched cutout, a "hole") — not expressible as a guillotine sequence,
  never proposed.
- Non-rectangular pieces.
- Free rotation at arbitrary angles.
- CNC-style nesting that packs pieces at non-axis-aligned positions to
  reach waste levels beyond what a guillotine sequence can achieve.

### How the algorithm handles rotation

Only two orientations are ever considered per piece — as-specified,
or rotated 90° — never an arbitrary angle, since guillotine cuts are
axis-aligned by definition. Rotation is attempted only when
`CuttingPieceRequest.allowRotation` is `true`. **Dependency on Open
Question 3 (not resolved here):** per your future-reference note,
once `Decor` gains a grain-directionality field, `allowRotation` will
most likely be *derived* from that field (defaulting to "directional,"
i.e. rotation disallowed, when unset) unless a specific piece request
overrides it — that derivation is not implemented now; today
`allowRotation` remains the only rotation control, set directly by
the operator per piece.

### How waste/offcuts are represented

Every leaf of the guillotine cut tree that isn't a placed piece is a
leftover region, persisted as a `CutPlacement` row with a `null`
`pieceRequestId` (Section 5). At execution:
- A leftover **above** the minimum-useful-offcut threshold (Open
  Question 4, not resolved) becomes a new `Offcut` row — consistent
  with how `cutFromBoard` already works today.
- A leftover **below** that threshold is genuine waste — reflected in
  the summary total, never persisted as stock.
`exceedsUsefulThreshold` is evaluated and recorded at planning time,
but the threshold itself could still change before execution — an
explicit, named consequence of Open Question 4 remaining open,
carried into Section 8's risk list rather than papered over.

### What assumptions are being made about the cutting equipment

- A panel saw capable of straight, full-length cuts only — no CNC
  routing, no curved or interior cuts.
- A single blade, single kerf width per job (not variable mid-job).
- Flat 2D panel cutting only — thickness is tracked as a matching
  constraint, not as a 3D placement dimension.
- Manual or semi-automated operation: the app produces a **plan for a
  human to follow**, not machine-control output (e.g. G-code) — that
  would be a materially larger, different feature, not assumed or
  implied anywhere in this spec.

### Algorithm choice

Recommended: a **heuristic**, not an exact solver. Cutting-stock
optimization is NP-hard in general; an exact (ILP/branch-and-bound)
solver doesn't belong on a phone and would conflict with this
project's standing preference for minimal dependencies and
deterministic, explainable logic (Ch. 20.2/20.3, and the same
reasoning Krok 14 used to stay deterministic rather than reach for
ML). Concretely: sort pieces largest-first, then greedily place each
into the first region it fits — **Best-Fit Decreasing**, a
well-established heuristic that typically reaches 85–95% of optimal
for realistic cutting-stock instances, at a fraction of the
implementation and runtime cost of an exact solver.

### Priorities (in order)

1. Satisfy from existing Offcuts before opening a new Board (Krok
   14's `OffcutMatchFinder`, reused as the first pass).
2. Minimize the number of new Boards opened.
3. Minimize total waste area.
4. Respect grain-direction constraints before allowing rotation.

### Constraints

Same `decorId` and exact thickness match per source (physically real
constraints, not policy choices); kerf subtracted at every cut;
rotation only where explicitly allowed per piece.

### Waste minimization

A leftover region above the minimum-useful-offcut threshold (open
question, Section 11) becomes a new `Offcut` — consistent with how
`cutFromBoard` already works today. Below that threshold, it's
genuine waste, reported in the summary but not persisted as stock.

### Performance expectations

Best-Fit Decreasing is `O(n log n)` for the sort plus roughly
`O(n × m)` for placement (n = pieces, m = candidate boards) —
trivially fast at realistic workshop scale (a real cutting list is
plausibly 5–50 pieces, not thousands).

### Scalability

Explicitly out of scope for v1: if cutting lists ever needed to scale
to hundreds or thousands of pieces (large industrial batch runs), this
heuristic would need revisiting. Not a v1 blocker — flagged so it
isn't silently assumed to scale forever.

---

## 7. Integration

| Module | Integration |
|---|---|
| **Warehouse** | Cutting scope is bounded to Board stock within a chosen Warehouse (or across all — open question); reuses `BoardRepository.getByWarehouse` unchanged. |
| **Boards** | The primary raw material. No new fields on `Board`. Consumed Boards follow the exact same status/archive model already governing them (Ch. 9/10). |
| **Slots** | New Offcuts default to their parent Board's slot, matching `cutFromBoard`'s existing default — operator can move afterward via the existing `moveOffcut` flow, unchanged. |
| **Shopping List** | Real, valuable integration: a Shopping List shortage (Ch. 12) could seed a cutting-list row directly. Persistence doesn't change this — still **not required for v1**, a natural fast-follow. |
| **Export** | A cutting plan is a natural candidate for a printable "cutting sheet" PDF for the workshop floor, reusing the existing `ExportGenerator` pattern (Ch. 14). **Persistence makes this materially easier** — a `planned`/`executed` `CuttingJob`'s `CutPlacement` rows are exactly the data an export would need, whereas under the ephemeral option that data would have vanished by export time. Feasibility improved; **still not required for v1** — this doesn't newly mandate it, only removes a reason it would have been hard. |
| **Dashboard** | Aggregate waste-reduction metrics could extend `DashboardService` (Ch. 15) — extension of the existing aggregator, never a parallel stats path, per the architecture-boundary rule already enforced for every prior Dashboard-adjacent feature (Krok 9/13/14). Same reasoning as Export: persistence means the source data will already exist once this is scheduled, but it isn't required for v1. |
| **QR** | Optional safety check: scanning a Board's QR to confirm it's the one about to be cut, before execution — reuses the existing scan-resolves-to-entity pattern (Ch. 11). Not required for v1. |
| **Existing workflows** | `cutFromBoard()` (already exists on `OffcutRepository`) is the primitive `ExecuteCuttingPlanUseCase` orchestrates repeatedly within one transaction — Cut Optimizer does not replace it, it composes it, the same relationship `DeleteWarehouseUseCase` has to the plain repository `archive()`/`delete()` methods it wraps. |

### Output & Machine Integration (Printer / Saw)

**What Stage 1 actually needs for output:** the core Stage 1 requirement
is that an operator can see and correctly follow the proposed cutting
plan at a real saw. That requirement is satisfied by a standardized,
human-readable cutting plan — something the operator reads or prints —
not by the app controlling a machine directly.

**Why standardized PDF / human-readable output satisfies the core
requirement:** every workflow this spec describes (Section 3's
Optimization Results screen, Section 6's placement/waste output) ends
in information a human reviews and then physically executes on
existing equipment. A PDF cutting sheet carries that same information
in a form that's printable, shareable, and archivable, with no
dependency on any specific saw's capabilities.

**Why output generation belongs to the existing `ExportGenerator`
pattern:** `ExportGenerator` (Ch. 14) is already this app's generic
content-generation abstraction — interface + `get_it`-registered
implementations (`export_pdf`/`export_csv`/`export_rtf`),
`presentation/` never importing a concrete generator directly. A
cutting-plan/cutting-sheet document is content in a target format —
exactly what `ExportGenerator` already exists to produce (Export row,
above; Section 10 Phase F). This analysis introduces no new
content-generation abstraction.

**The correct role and boundary of `PrinterService`:** `PrinterService`
is a transport-layer abstraction — it sends an already-generated
document to physical hardware (Bluetooth/Wi-Fi/USB), the same
interface+`get_it` shape as `LabelGenerator`/`ExportGenerator`. Full,
authoritative record: `docs/adr/printer-integration.md` (also Ch.
20.7, Ch. 24.2, and the Decision Log, Ch. 25) — not restated here.
`PrinterService` remains scoped to label printing (Krok 7.3) today,
has never been implemented, and this analysis does not make it a
dependency of Cut Optimizer. Cut Optimizer output should be routed
through `PrinterService` only if and when that output is literally
being sent as a printable document to a physical printer. The app's
existing `Printing.layoutPdf()` OS-native print-dialog integration
(already used in `slot_detail_screen.dart`) is a separate,
already-available "print this PDF" path that needs no new
abstraction for this feature.

**Generic output vs. manufacturer-specific integration (Level 0–3):**

| Level | Description | Stage 1 status |
|---|---|---|
| 0 | Standardized, human-readable cutting-plan PDF (extends `ExportGenerator`, Ch. 14) | The only level Stage 1's core workflow needs. Not yet scheduled — Phase F, Section 10, unchanged by this analysis |
| 1 | Manufacturer-neutral, machine-importable export format | Future capability, not Stage 1. Still content generation — would extend `ExportGenerator` (Ch. 14) the same way `export_pdf`/`export_csv`/`export_rtf` do today, not a new abstraction. No requirement established yet; what's needed is product justification and scheduling, not new architecture |
| 2 | Manufacturer-specific export formats/protocols (e.g. a Homag- or Biesse-specific file) | Out of scope for Stage 1. Not assumed, not researched. If ever pursued, sits behind a generic abstraction — same extensibility pattern as `ExportGenerator`'s three format implementations and the per-manufacturer decor-catalog precedent (Ch. 12/20.7/24.3) — never embedded in `CutOptimizationEngine` |
| 3 | Direct machine communication/control | Out of scope for Stage 1 and not planned. No manufacturer protocols, APIs, or machine capabilities are assumed or invented anywhere in this spec |

**Consequences of not making direct machine integration part of Step
15:**
- *Product:* the operator still gets the full value this spec promises
  — a correct, minimal-waste cutting plan — executed manually on
  existing equipment, consistent with Section 6's stated equipment
  assumption ("the app produces a plan for a human to follow, not
  machine-control output").
- *Technical:* no new hardware-protocol layer, no new manufacturer
  dependency, no G-code or machine-specific format generation — the
  whole feature stays inside already-proven patterns
  (`ExportGenerator`, pure domain services).
- *Maintenance:* no added maintenance burden from hardware/protocol
  support; the only generation surface stays a PDF, already maintained
  under Ch. 14.
- *Scope:* Step 15 stays a software-only, Stage 1/FREE-tier feature —
  consistent with Ch. 1/26's Stage 1 roadmap framing and the
  printer-integration ADR's own principle that printing/machine output
  is always optional, never a dependency.

**What would require separate future technical research** (explicitly
not undertaken here — no protocols, APIs, formats, or machine
capabilities are invented): whether a genuine Level 1
manufacturer-neutral machine-importable format is ever justified by
real customer demand; which specific manufacturers (Homag, Biesse,
SCM, Morbidelli, Scheer, Stefani, or others) would need Level 2
support, and what their actual import formats/protocols are; whether
Level 3 direct communication is ever in scope for any future Stage.
None of this is assumed, scheduled, or designed by this document.

**Dependency / Open Question created by this analysis:** none. This
subsection records an already-completed analysis and its conclusion
(Level 0 sufficient for Stage 1; Level 1 a future `ExportGenerator`-pattern
extension if ever product-justified; Levels 2–3 out of scope, requiring
separate future research into undocumented manufacturer protocols if
ever pursued) — it is a scope/architecture
record, not an unresolved product decision, and it does not affect
Open Questions 1–7 (Section 11), which concern the optimization
algorithm and data model, not output/machine integration. The Export
row's existing "still not required for v1" status is unchanged; Phase
F (Section 10) remains where a cutting-sheet PDF export would
eventually be scheduled.

---

## 8. Risks

| Risk | Category | Mitigation |
|---|---|---|
| Multi-piece, multi-board atomic execution is the most complex transaction this codebase has attempted | Technical | Follow the exact pattern already proven in `cascade_archive_helpers.dart` (Ch. 20.5) rather than inventing a new transaction approach |
| Algorithm bug produces a placement that doesn't actually fit (e.g. an off-by-kerf error) | Technical | Independent geometric validation pass before execution, separate from the algorithm that proposed the layout — never trust the proposer's own math as the only check |
| A 2D cutting diagram is more visually complex than anything else in this app | UX | Low-fidelity review with `wood-industry-expert`/`mobile-ux-expert` before high-fidelity design; consider a text-list fallback alongside the visual diagram, consistent with Ch. 18's "never rely on one signal alone" principle |
| Heuristic performs poorly or slowly on unusual inputs | Performance | Bound algorithm runtime; fall back to a simpler first-fit strategy rather than let the UI hang, per Ch. 19 |
| This is the most algorithmically complex domain logic in the codebase to date | Maintenance | Keep the algorithm fully isolated and pure (Ch. 20.1) so it's independently testable and replaceable without touching persistence or UI; this document is the design record for *why* Best-Fit Decreasing was chosen |
| Concurrent cutting plans against the same Board | Technical | Addressed structurally by the atomic use case (Section 4) plus a final pre-execution re-check that source material is still available — not left as an unhandled race |
| **A persisted, `planned` plan goes stale** — its referenced Offcut/Board is consumed by something else before execution (new risk, direct consequence of Open Question 2's resolution) | Technical | Re-validate every referenced source's current availability at execution time, independent of the persisted plan's own assumptions (Section 2); fail cleanly, never execute against stale state |
| **Schema growth** — three new tables is the largest single addition since the original Krok 1–8 buildout (new risk, direct consequence of Open Question 2's resolution) | Technical / Maintenance | The *mechanism* is unchanged and already proven (Ch. 20.4's versioned-migration convention) — the added risk is more surface area to test, not a new kind of risk; covered by Section 9's new migration/persistence test requirements |
| **Guillotine cut-tree representation** is more structurally complex to persist/query than a flat rectangle list (new risk, direct consequence of Open Question 1's resolution) | Technical | Persist only the flattened outcome (`CutPlacement` position/size rows, Section 5) — the tree structure itself is working state internal to `CutOptimizationEngine`, not persisted. Whether the operator needs to see actual *cut order* (not just final positions) is a real, open implementation question for Phase A/D, not a blocking product decision |

---

## 9. Testing Strategy

- **Unit tests** — `CutOptimizationEngine`: pure, no DB, exhaustive
  geometry fixtures (exact fit, kerf-boundary cases, rotation
  allowed/disallowed, decor/thickness mismatch rejection, multi-board
  spillover, zero-match scenario). Same convention as
  `offcut_match_finder_test.dart`/`board_measurement_calculator_test.dart`
  (Ch. 21.2).
- **Repository/persistence tests (new)** — `CuttingJobRepositoryImpl`:
  DB-backed, in-memory `sqflite_common_ffi`, covering the full
  `draft → planned → executed`/`discarded` lifecycle, correct
  `CuttingPieceRequest`/`CutPlacement` persistence and retrieval.
  Direct precedent: existing repository test files (e.g.
  `rack_slot_repository_test.dart`).
- **Migration test (new)** — `v9` adds `cutting_jobs`,
  `cutting_piece_requests`, `cut_placements`: verify via
  `PRAGMA table_info` after `MigrationRunner.run()`, same convention as
  every prior migration test (e.g. `rack_slot_repository_test.dart`'s
  "v2 migration creates racks and slots tables").
- **Integration tests** — `ExecuteCuttingPlanUseCaseImpl`: DB-backed,
  in-memory `sqflite_common_ffi`, verifying atomicity, correct
  archive/creation of Board/Offcut rows, correct Ledger entries (now
  including the `cuttingJobId` payload link, Section 5).
  Direct precedent: `delete_warehouse_use_case_test.dart`.
- **Stale-plan re-validation test (new, direct consequence of Open
  Question 2's resolution):** execute a persisted `planned` job after
  its source Board/Offcut was consumed by an unrelated action in the
  interim — must fail cleanly, must not corrupt state or partially
  execute.
- **Guillotine-validity tests (new, direct consequence of Open
  Question 1's resolution):** explicit unit tests asserting
  `CutOptimizationEngine` never proposes a non-guillotine (interior-cut)
  placement — this is now a hard correctness constraint, not a
  preference to spot-check.
- **Edge-case testing:** zero-fit, exact-fit-zero-waste,
  kerf-consumes-remaining-space, mismatched decor/thickness correctly
  rejected, concurrent-execution race.
- **Performance testing:** benchmark against a realistic 50-piece
  cutting list on a representative low-end Android device, confirm no
  UI-thread jank (Ch. 19).
- **Acceptance criteria:** no proposed plan is ever geometrically or
  guillotine-invalid; execution is all-or-nothing, never partial (Ch.
  20.5); waste % is computed and displayed accurately; existing
  Offcuts are always preferred over cutting new stock wherever a valid
  match exists; **Krok 14's own existing test suite passes unchanged**
  — this feature must extend `OffcutMatchFinder`'s usage, not alter
  its contract; **a persisted `CuttingJob` is fully reconstructable
  after an app restart**, not just within the same in-memory session —
  a concrete, testable consequence of Open Question 2's resolution.

---

## 10. Implementation Plan

Every phase below still requires its own Ch. 23 verification
(`flutter analyze`/`flutter test`/`flutter build`) and explicit
approval before starting the next. **No phase begins now** — this
entire plan is Phase 1 material.

**Restructured** from the original four-phase plan — persistence
(Open Question 2) introduces a genuine new phase (B) rather than
fitting inside the original Phase B, since a migration + repository
is a distinct unit of work from the atomic execution use case.

| Phase | Scope | Outcome | Dependencies | Validation checklist |
|---|---|---|---|---|
| **A** | Data model entities + pure, guillotine-only `CutOptimizationEngine`, unit tests only | A fully tested, standalone optimization engine, callable from a test harness, touching no UI or database | None beyond existing `OffcutMatchFinder`/`BoardRepository` | Unit tests green; algorithm produces valid, guillotine-only (non-overlapping, in-bounds, no interior cuts) placements against a hand-checked fixture set |
| **B** *(new)* | `v9` migration (`cutting_jobs`, `cutting_piece_requests`, `cut_placements`) + `CuttingJobRepository(Impl)`, repository and migration tests | A working persistence layer for cutting jobs and computed layouts, independent of execution | Phase A (needs the entities it's persisting) | Migration test green (`PRAGMA table_info`); repository tests green covering the full status lifecycle |
| **C** | `ExecuteCuttingPlanUseCase(Impl)` + integration tests, including stale-plan re-validation | A persisted, `planned` job reliably becomes real, atomic Board/Offcut/Ledger changes, or fails cleanly if stale | Phase A + B | Integration tests green; matches the existing atomic-use-case verification bar (Ch. 23.3) |
| **D** | Presentation: Cutting List, Results, Confirmation screens, now with save/resume, `WF*` components only | A working, on-device-testable feature, minus its permanent navigation entry point | Phase A + B + C | On-device manual QA (this project's established `adb`-driven pattern); full 21-language l10n (Ch. 21.1) |
| **E** | Command Hub integration (or interim entry point) | Cut Optimizer is reachable through the app's real navigation | Phase D + resolution of Open Question 5 (and Chapter 5's own approval, if the Hub is the chosen path) | Consistent with whichever navigation pattern is approved by then |
| **F** *(not required for v1, explicitly deferred)* | Shopping List seeding, Export cutting-sheet PDF, Dashboard waste metrics, QR confirm-scan | Each is an independent, later enhancement — now easier for Export/Dashboard specifically (Section 7), still not required | Phases A–E | Each gets its own Phase 1 pass when scheduled, not bundled into this one |

---

## 11. Independent Review

Per the Decision Framework's Independent Reviewer role: challenging
this proposal, not resolving the challenges.

### Weaknesses

- ~~The guillotine-vs-free-nesting assumption is the single
  highest-leverage unknown in this document~~ — **resolved**:
  guillotine-only, by explicit Product Owner decision (Open Question
  1). The residual weakness is narrower now, not eliminated: this
  spec still has not independently confirmed *why* guillotine matches
  the real target equipment — the decision is authoritative regardless,
  but the reasoning behind it lives with you, not in this document.
- ~~`CuttingJob` persistence is unresolved~~ — **resolved**: persisted
  (Open Question 2). The residual weakness: persistence introduces a
  new class of bug (stale plans, Section 8) this codebase hasn't had
  to handle before — the mitigation is specified (Section 2/8) but
  unproven until Phase B/C actually exist and are tested.
- **Grain/pattern directionality** still has no home on `Decor` today
  (Section 2) — assumed to matter, without a field to express it, and
  without knowing whether it matters for *this* product line at all.
  **Unaffected by decisions 1–2** — still fully open (Open Question 3
  below).

### Alternative designs considered, not chosen here

- **Unified single-pass algorithm** treating Offcuts and Boards as one
  pool of "available rectangles," rather than this spec's two-pass
  design (match Offcuts first via Krok 14, then optimize the
  remainder against Boards). The two-pass design is simpler and
  reuses `OffcutMatchFinder` untouched, but a greedy first pass could
  lock in an Offcut choice that blocks a better *combined* plan.
  Worth evaluating during Phase A, not decided here.
- **An existing open-source cutting-stock library**, if one exists and
  is license-compatible, instead of a hand-rolled heuristic — trades
  "don't reinvent" against "new dependency," which cuts directly
  against this project's stated minimal-dependency preference (Ch.
  20.2/20.3). Not evaluated in this document; flagged as worth a
  short search before Phase A commits to hand-rolling.

### Trade-offs

Best-Fit Decreasing is simple, fast, and explainable — and
deliberately *not* optimal. A more sophisticated algorithm (genetic
search, simulated annealing) would waste less material at real cost
in complexity, runtime, and explainability. Recommending the simple
heuristic for Stage 1/FREE is a deliberate choice consistent with
Krok 14's own "deterministic, no ML" precedent — not a free win, a
named trade-off.

### Assumptions not verified

- That guillotine cutting matches the real target equipment — no
  longer an open *question* (Open Question 1 is decided), but the
  underlying real-world fact this decision rests on is still asserted,
  not independently verified by this document.
- That a realistic cutting list stays in the 5–50 piece range
  (Section 6's performance reasoning depends on this) — unaffected by
  decisions 1–2.
- That "reuse Offcuts before cutting new stock" is always the right
  priority — plausible, but not confirmed against real cost/waste
  data — unaffected by decisions 1–2.
- That a workshop job realistically spans an interruption long enough
  to need persistence rather than just a longer single session — the
  premise behind Open Question 2's resolution, asserted in this
  document's original recommendation and now acted on, but still not
  independently verified against real workshop behavior.

### Resolved by the Product Owner

1. **Guillotine cuts only.** Free-form nesting is explicitly out of
   scope for Step 15/Stage 1 and must not be implemented or assumed —
   reconciled throughout Sections 2, 6, 8, 9, 10 above. Kept as item 1
   here, marked resolved rather than renumbered, so every existing
   cross-reference to "Open Question 1" in this document and any
   future discussion stays traceable to the same item.
2. **`CuttingJob` and its optimization results are persisted.** Must
   survive leaving the screen and support later review, export, and
   integration — reconciled throughout Sections 2, 4, 5, 7, 8, 9, 10
   above. Same numbering-stability reasoning as item 1.

**Both approvals are answers to these two questions only — not
approval to begin implementation.** Phase 2 remains gated on your
explicit go-ahead per Chapter 23.

### Still open — not resolved, not silently narrowed beyond what's noted

3. **Does `Decor` need a grain/pattern-directionality field, and if
   so, is that a v1 requirement or can v1 assume non-directional?**
   Narrowed, not resolved, by decision 1: because guillotine layouts
   only ever consider 0°/90° rotation (Section 6), whatever this
   question eventually decides only needs to express a directional
   yes/no per decor, not an arbitrary angle. **Planning note for
   whenever this is addressed, not a resolution now:** grain
   directionality must default to **"directional" (rotation
   disallowed) when unset**, never "non-directional" — stated here so
   it isn't lost before Open Question 3 is actually taken up.
4. **Where does the minimum-useful-offcut-size threshold live** — a
   new Settings value (Ch. 5.8 item 4, itself not yet scoped), a
   per-decor value, or a fixed constant for v1? Newly touched by
   decision 2: because plans now persist between planning and
   execution, the threshold used at planning time and the threshold
   in effect at execution time could disagree if this ever becomes a
   mutable setting — a new reason to eventually resolve this
   cleanly, not a resolution of it now.
5. **Does Cut Optimizer need its own Command Hub module slot** (a
   7th, where Ch. 5.2 currently names six), **or should it ship
   through an interim entry point** decoupled from Chapter 5's own
   pending approval? Unaffected by decisions 1–2.
6. **Cutting scope: one Warehouse at a time, or cross-warehouse
   search?** Unaffected by decisions 1–2 in how the question itself
   resolves, but decision 2 adds a minor schema-shape dependency: the
   persisted `CuttingJob.warehouseId` field (Section 5) is nullable
   specifically because this is still open — if resolved to
   single-warehouse scope, it becomes required; if cross-warehouse, it
   may need to become a list instead. Not decided here.
7. **Kerf width: a global setting, per-saw, or per-job input?**
   Newly touched by decision 2: regardless of where the value
   ultimately comes from, the persisted `CuttingJob.kerfMm` field
   (Section 5) now exists specifically so whatever value was actually
   used for a given plan is captured and reviewable later — a
   persistence-driven requirement, not a resolution of the sourcing
   question. **Planning note for whenever this is addressed, not a
   resolution now:** per your instruction, the eventual default should
   be a **hardcoded application constant**, not framed as a "system
   setting" — consistent with Settings infrastructure itself being
   deferred (Open Question 4/Ch. 5.8 item 4).

---

## 12. Final Recommendation

**Confidence level:**
- **~90%** in the architectural approach (pure algorithm + dedicated
  atomic use case + `WF*` presentation) — directly modeled on proven,
  already-shipped precedent (`Delete*UseCase`, `OffcutMatchFinder`,
  the `WF*` component library).
- **~90%**, up from ~60%, in the algorithm variant and persistence
  model specifically — no longer this document's own best guess, now
  your explicit decisions (Section 11).
- **~60%** remains for the still-open product/domain details
  (grain-directionality default mechanics, threshold source, Hub
  integration, cutting scope, kerf source) — these still require your
  confirmation before they're safe to build against.

**Implementation readiness:** **not ready for Phase 2.** Open
Questions 1 and 2 — the two that determined the algorithm's and data
model's fundamental shape — are now resolved (Section 11). This
removes the specific blocker that previously stood in front of Phase
A starting *once approved*, but it does not, on its own, constitute
that approval. Open Questions 3–7 remain, and per your explicit
instruction this update itself is not a green light for Phase 2.

**Recommendation:** approve the architecture, data model, and
algorithm approach (Sections 4, 5, 6) as directionally sound and now
fully specified against decisions 1–2. Questions 3 and 7 carry
concrete planning notes (defaults) for whenever they're eventually
addressed, but remain unresolved. Questions 4–6 affect later phases
(C onward in the revised plan) and don't need to block Phase A's
eventual start once you separately approve moving to Phase 2.

Waiting for your review.
