# WoodFlow — Entity Editing Specification

**Status:** DRAFT — FOR REVIEW ONLY. No code, schema, or new fields
have been implemented against this document. Nothing here proposes a
new entity, a new field, a new migration, or a new product feature.
This document describes and standardizes editing behaviour for
entities that **already exist** in the current production
architecture — nothing more.

Per your clarification: entities that are not yet real, persisted
business entities are listed separately under §4, "Future candidates
(not part of this specification)," and are not otherwise discussed.

## 0. Method

Reviewed as: `woodflow-architect` (does this match the existing
invariants), `database-architect` (what the schema actually supports
today), `warehouse-expert`/`wood-industry-expert` (does locking a
field match how physical stock actually behaves),
`design-system-expert`/`mobile-ux-expert` (is there already one
consistent UI pattern in use, or several), `product-manager` (keep
this to what exists, reject scope creep).

Every claim below was checked directly against the current codebase
— domain entities (`lib/domain/entities/`), repository contracts
(`lib/domain/repositories/`), repository implementations
(`lib/data/repositories/`), and every screen under
`lib/presentation/` — not assumed.

### 0.1 What the domain layer actually supports today

| Entity | `copyWith`/`update` exposes | Structurally locked (not a parameter) |
|---|---|---|
| Warehouse | `name`, `address`, `qrCode`, `updatedAt` | `organizationId` |
| Rack | `name`, `qrCode`, `updatedAt` | `warehouseId` |
| Slot | `name`, `capacity`, `qrCode`, `updatedAt` | `rackId` |
| Board | `slotId`, `status`, `updatedAt` | `decorId`, `length`, `width`, `thickness`, `qrCode` |
| Offcut | `slotId`, `status`, `updatedAt` | `decorId`, `length`, `width`, `thickness`, `qrCode`, `parentBoardId` |
| Decor | `name`, `minimumStockQuantity`, `updatedAt` | `code`, `manufacturer` |

No entity has a `notes` field or any metadata mechanism. No
`User`/`Role`/`Permission` entity exists anywhere in `lib/`.

### 0.2 What the UI actually exposes today (this is narrower than 0.1)

Repository-level capability and reachable-from-a-screen capability
are not the same thing — checked separately by grepping every call
site in `lib/presentation/`:

- **The only field-edit UI that exists anywhere in the app today**
  is `ShoppingListScreen._openThresholdSheet()`, which calls
  `_decors.update(decor.copyWith(minimumStockQuantity: newValue))`.
  It shows one field (the quantity). `Decor.name` is not shown or
  editable in that sheet, despite being repository-editable.
- **No screen edits `Warehouse.name`, `Warehouse.address`,
  `Rack.name`, or `Slot.name`/`Slot.capacity`** — all four are
  repository-editable (0.1) but have zero UI today.
- **Rack has no delete UI at all.** `rack_list_screen.dart` only
  calls `_racks.getByWarehouse()` and `_racks.create()` — no delete
  button, no confirmation dialog, nothing. (`Rack.delete()` exists on
  the repository and is unconditional — see §3, Finding 1 — but
  nothing in the UI can reach it today.)
- **Slot delete UI exists** (`SlotDetailScreen._confirmDelete()` →
  `_slots.delete(slot.id)`), gated by a `showWFConfirmationDialog`,
  but the underlying `SlotRepositoryImpl.delete()`
  (`slot_repository_impl.dart:165`) is an unconditional `DELETE` —
  no check for boards/offcuts still occupying the slot.
- **Warehouse delete UI exists** via `DeleteWarehouseUseCaseImpl` — a
  single-transaction cascade that archives contained Boards/Offcuts
  and deletes Racks/Slots atomically. Built this session, the one
  entity whose delete path was deliberately hardened.
- **Decor delete has no UI anywhere** — `delete()` exists only
  because `DecorRepository` implements `BaseRepository`.
- **Board/Offcut** have real, reachable UI for `moveBoard`/
  `moveOffcut` (location) and `archive()` (status) — both wired,
  both tested. No UI touches `decorId` or dimensions, matching 0.1.
- `ledger_entries` is written to only by Board and Offcut (`create`,
  `moved`, `archived`, `cut`, `qrRegenerated` — via
  `BoardRepositoryImpl`/`OffcutRepositoryImpl`). Warehouse, Rack,
  Slot, and Decor never write to it — a `Warehouse.update()` or
  `Decor.update()` call only changes `updated_at` on the row itself,
  silently, with no separate record of what changed or when.
- The only existing "permission" language in the codebase is
  `regenerateQrCode()`'s doc comment — *"admin-only,"* per
  `docs/QR_CODES.md` — enforced by nothing, wired to no UI button, on
  any of the five entities that have the method.

Everything below documents and standardizes exactly this — no
additions.

---

## 1. Cross-cutting facts (apply to every entity below)

### F1 — There is exactly one editing UI pattern in the app today

`ShoppingListScreen`'s threshold sheet — the only field-edit UI that
exists — uses `showWFBottomSheet` + `WFTextField` (with a
`validator`) + a primary `WFButton`. This is the same shape every
**create** flow in the app already uses (`_openAddWarehouseSheet`,
`_openAddRackSheet`, `_openAddSlotSheet`, etc.). There is no second,
different editing pattern anywhere to reconcile — the "standard" is
already singular by accident of how little editing UI exists. Noted
here as fact, not as a recommendation to build more of it.

### F2 — Validation actually enforced today

The only editing form that exists validates one thing: the threshold
quantity must parse as an integer `>= 0`
(`_ThresholdSheetAction`/`invalidQuantityMessage` in
`shopping_list_screen.dart`). Creation forms validate non-empty
`name` (implicitly, via `if (name.isEmpty) return;` — not a
`WFTextField` validator, just a silent no-op). No other validation
rule (max length, capacity-vs-occupancy, etc.) exists in the codebase
today for any entity.

### F3 — Permissions: none enforced, for any entity, on any field

No Auth/Role system exists (confirmed: no matching class anywhere in
`lib/`). Every repository method that changes data is reachable by
anyone with the app open. The single documented exception
(`regenerateQrCode`, "admin-only") is unenforced and has no UI, on
every one of the five entities that expose it.

### F4 — Audit log: Board/Offcut only

`ledger_entries` currently records lifecycle events for Board and
Offcut only (five event types total across both:
`created`/`moved`/`archived`/`cut`/`qrRegenerated`). Warehouse, Rack,
Slot, and Decor have never written to this table. Their `updated_at`
timestamp is the only trace that a change happened, and it's
silently overwritten on every update with no history of the prior
value.

### F5 — Delete/Archive: three different behaviours exist today, not one

- Board, Offcut: archive-only, never physically deleted. Enforced by
  `copyWith` not exposing a delete path at all — structural, not just
  a convention.
- Warehouse: physical delete, but only via a single-transaction
  cascade (`DeleteWarehouseUseCaseImpl`) that archives contained
  Boards/Offcuts first and blocks partial deletion.
- Rack: repository supports unconditional physical delete; no UI
  calls it.
- Slot: unconditional physical delete, reachable from the UI today,
  with no occupancy check.
- Decor: repository supports unconditional physical delete; no UI
  calls it.

These are not variations of one rule — they are three structurally
different behaviours coexisting today (see §3, Finding 1).

---

## 2. Per-entity specification (current state only)

### 2.1 Warehouse

- **Editable fields:** `name`, `address` (repository-level, 0.1) —
  **no UI edits either today** (0.2).
- **Non-editable fields:** `id`, `organizationId`, `qrCode`
  (system-generated), `createdAt`.
- **Validation rules:** none exist — there is no edit form to
  validate against.
- **Permissions:** F3 — none.
- **Audit log behaviour:** F4 — none. A `Warehouse.update()` call
  (if one existed in the UI) would silently overwrite `updated_at`
  with no ledger trace.
- **Rename workflow:** does not exist. `name` is repository-editable
  but no screen exposes it.
- **Notes support:** none — no field exists.
- **Metadata support:** none — no field or mechanism exists.
- **Delete/archive rules:** F5 — the one entity with a hardened,
  cascading delete path (`DeleteWarehouseUseCaseImpl`).
- **UX flow:** delete only — `WFListTile` trailing delete icon on
  `WarehouseListScreen` → `showWFConfirmationDialog` → use case call.
  No edit flow exists.
- **Required dialogs:** the existing delete confirmation dialog only.

### 2.2 Rack

- **Editable fields:** `name` (repository-level, 0.1) — **no UI edits
  today.**
- **Non-editable fields:** `id`, `warehouseId`, `qrCode`, `createdAt`.
- **Validation rules:** none exist.
- **Permissions:** F3 — none.
- **Audit log behaviour:** F4 — none.
- **Rename workflow:** does not exist.
- **Notes support:** none.
- **Metadata support:** none.
- **Delete/archive rules:** F5 — repository supports unconditional
  delete; **no delete UI exists at all** (0.2) — the only entity in
  this document with zero delete affordance anywhere.
- **UX flow:** none — Rack has no edit or delete UI today, only
  create (`_openAddRackSheet`) and navigate-to-children.
- **Required dialogs:** none exist.

### 2.3 Slot

- **Editable fields:** `name`, `capacity` (repository-level, 0.1) —
  **no UI edits today.**
- **Non-editable fields:** `id`, `rackId`, `qrCode`, `createdAt`.
- **Validation rules:** none exist for editing. (`capacity` is only
  ever set at creation, defaulting to `20`, with no validation beyond
  `int.tryParse(...) ?? 20`.)
- **Permissions:** F3 — none.
- **Audit log behaviour:** F4 — none.
- **Rename workflow:** does not exist.
- **Notes support:** none.
- **Metadata support:** none.
- **Delete/archive rules:** F5 — unconditional physical delete, **and
  this is the one entity where that unconditional delete IS reachable
  from the UI today** (`SlotDetailScreen._confirmDelete`), with no
  check for boards/offcuts still inside it.
- **UX flow:** delete only — `WFButton` (destructive role) at the
  bottom of `SlotDetailScreen` → `showWFConfirmationDialog` →
  `_slots.delete(slot.id)`. No edit flow exists.
- **Required dialogs:** the existing delete confirmation dialog only.

### 2.4 Board

- **Editable fields:** `slotId` (via the dedicated `moveBoard()` UI
  flow, not a generic edit), `status` (via the dedicated `archive()`
  UI flow, not a generic edit).
- **Non-editable fields:** `decorId`, `length`, `width`, `thickness`,
  `qrCode` — not exposed by `copyWith` at all (0.1); this is
  structural, not a missing screen.

  **Why, factually, per the existing codebase:** `docs/INVARIANTS.md`
  documents (as "not yet enforced") that an Offcut can never be
  larger than its parent Board. `offcut.dart`'s own doc comment
  states `decorId` is deliberately copied onto Offcut at cut time
  specifically so Offcut never has to stay in sync with a Board's
  material identity after the fact. Both existing, already-written
  rules depend on Board's dimensions and `decorId` staying fixed
  after creation — that's why the entity was built without a
  `copyWith` path for them, not an oversight.
- **Validation rules:** none exist — there is no field-edit form.
- **Permissions:** F3 — none.
- **Audit log behaviour:** F4 (Board side) — Board is one of the two
  entities that already writes to `ledger_entries`, for `created`,
  `moved`, `archived`, `cut` (as the parent of a cut), and
  `qrRegenerated` (method exists, no UI).
- **Rename workflow:** N/A — Board has no `name` field; it's
  identified by decor + dimensions + QR code, per the existing
  convention.
- **Notes support:** none.
- **Metadata support:** none.
- **Delete/archive rules:** F5 — archive-only, structurally (no
  delete path exists on `BoardRepository` at all).
- **UX flow:** Move (`BoardDetailScreen` → `SimpleDialog` slot
  picker) and Archive (`BoardDetailScreen` →
  `showWFConfirmationDialog`) — both existing, both reachable.
- **Required dialogs:** the existing `SimpleDialog` slot picker
  (move) and `showWFConfirmationDialog` (archive).

### 2.5 Offcut

- **Editable fields:** `status` (via `archive()`, reachable from
  `OffcutDetailScreen`). `slotId` is repository-editable via
  `moveOffcut()`, but — confirmed by grep, zero matches — **no screen
  anywhere in `lib/presentation/` calls it.** Unlike Board, where
  `moveBoard()` is wired to a real UI, Offcut's own repository has
  the identical capability sitting completely unused.
- **Non-editable fields:** `decorId`, `length`, `width`, `thickness`,
  `qrCode`, `parentBoardId` — same structural reasoning as Board
  (§2.4), and arguably stronger here: Offcut IS the record of an
  already-completed cut; its own stored dimensions are the fact being
  preserved, not a draft value.
- **Validation rules:** none exist.
- **Permissions:** F3 — none.
- **Audit log behaviour:** F4 (Offcut side) — writes `cut`, `moved`,
  `archived`, `qrRegenerated` (method exists, no UI).
- **Rename workflow:** N/A — no `name` field, same as Board.
- **Notes support:** none.
- **Metadata support:** none.
- **Delete/archive rules:** F5 — archive-only, structurally.
- **UX flow:** Archive only, on `OffcutDetailScreen`. No move flow
  exists in the UI despite Board having one.
- **Required dialogs:** `showWFConfirmationDialog` (archive) only.

### 2.6 Decor

- **Editable fields:** `minimumStockQuantity` — the only field with
  **both** repository support and real UI
  (`ShoppingListScreen._openThresholdSheet`). `name` is
  repository-editable (0.1) but has no UI (0.2) — the same
  editable-in-repo-but-not-in-UI gap as Warehouse/Rack/Slot's `name`.
- **Non-editable fields:** `code`, `manufacturer` — not exposed by
  `copyWith` (0.1).

  **Why, factually:** `code` is what every existing Board/Offcut's
  `decorId` resolves to for display (e.g. "H3303 — Natural Hamilton
  Oak"). A catalog entry's correctness is currently a data-import
  concern (`lib/data/decor_seeds/`, Krok 12's EGGER import), not an
  in-app field — matching the same "identity field, not casually
  changed" pattern already established for Board/Offcut's `decorId`.
- **Validation rules:** F2 — quantity must parse as integer `>= 0`,
  the one validation rule that exists anywhere in this document.
- **Permissions:** F3 — none.
- **Audit log behaviour:** F4 — none. Setting or clearing a threshold
  today silently overwrites `updated_at` with no ledger trace.
- **Rename workflow:** does not exist — `name` has no UI despite
  repository support (same gap as §2.1–2.3).
- **Notes support:** none.
- **Metadata support:** none.
- **Delete/archive rules:** F5 — repository supports unconditional
  delete; **no delete UI exists at all**, same as Rack.
- **UX flow:** `ShoppingListScreen`'s FAB → decor search sheet → tap a
  decor → threshold sheet → `WFTextField` (quantity) → Save/Clear.
- **Required dialogs:** the existing search bottom sheet and
  threshold bottom sheet — both already built, no new dialog types.

**"Shopping List item" — not a separate entity.** There is no
persisted `ShoppingListItem` row anywhere in the schema.
`shopping_list_item.dart` is a computed value
(`ShoppingListService.build()` joins `Decor` with a live stock count
every time the screen loads). Everything a user can actually touch
from that screen is `Decor.minimumStockQuantity`, documented above —
this isn't a sixth entity, it's the existing UI for editing one field
of Decor.

---

## 3. Inconsistencies found (facts, not proposals)

1. **[Delete behaviour] Three different delete behaviours coexist for
   structurally similar entities.** Warehouse: hardened cascade
   through a dedicated use case. Slot: unconditional, no occupancy
   check, reachable from the UI. Rack: unconditional, no occupancy
   check, but *not* reachable from any UI today. Board/Offcut:
   delete is impossible by design (archive-only). Decor: unconditional,
   not reachable from any UI today. §0.2 confirms every one of these
   against an actual call site.
2. **[Audit trail] Board/Offcut log every lifecycle event to
   `ledger_entries`; Warehouse/Rack/Slot/Decor log nothing, ever,
   for any change** — including the one edit that does exist in
   production today (`Decor.minimumStockQuantity`, via
   `ShoppingListScreen`).
3. **[Editable-in-repository vs. editable-in-UI gap] `name` is a
   `copyWith` parameter on Warehouse, Rack, Slot, and Decor — none of
   the four have any UI that uses it.** The repository layer is
   "ahead of" the UI layer for exactly one field, on exactly four
   entities, in the same way, independently.
4. **[Identity-field locking, consistent but previously unwritten]
   Board/Offcut's dimensions+decor and Decor's code+manufacturer are
   all structurally non-editable (no `copyWith` parameter), for the
   same underlying reason (protecting an existing invariant/
   preventing retroactive identity drift) — but this reasoning was
   never written down anywhere as one shared rule until this
   document. It was three separate, silent design choices that
   happen to agree.
5. **[Unenforced permission language] The only "admin-only" language
   in the codebase (`regenerateQrCode`, all five entities) is backed
   by no check and no UI — a precedent worth being aware of before
   any future editing feature claims a permission boundary it
   doesn't actually enforce.**
6. **[Board vs. Offcut move-UI asymmetry] Both entities have an
   identical repository-level `move*()` method with the same shape
   and the same ledger behaviour. Only Board's is wired to a screen
   (`BoardDetailScreen`'s "Move" button). `moveOffcut()` has zero call
   sites anywhere in `lib/presentation/` — an offcut, once placed in a
   slot, currently cannot be relocated from the UI at all.**

---

## 4. Future candidates (not part of this specification)

Entities or fields that do not currently exist as persisted business
data. Listed here only so the original request's checklist is fully
accounted for — none of these are designed, scoped, or recommended
in this document.

- **Calculator "presets"** — `CalculatorsScreen` is fully stateless.
  No `CalculatorPreset` (or similarly named) table, entity, or
  repository exists anywhere in `lib/domain/` or the database
  migrations. There is nothing to specify editing behaviour for.
- **`notes` field (any entity)** — does not exist on any of the six
  real entities today.
- **Generic metadata (any entity)** — no mechanism exists on any
  entity today.
- **User / Role / Permission entities** — do not exist; there is
  nothing to attach editing permissions to today.

---

## 5. Summary for review

This document adds no new fields, no new tables, no new migrations,
and no new screens. It documents:

- exactly what's editable per entity, at both the repository layer
  and the UI layer, distinguishing the two everywhere they diverge;
- exactly what audit trail exists per entity (Board/Offcut only);
- exactly what delete behaviour exists per entity (three different
  shapes, not one);
- why the currently-locked fields (Board/Offcut dimensions+decor,
  Decor code/manufacturer) are locked, using reasoning already
  present elsewhere in the codebase;
- five factual inconsistencies across entities, none of them fixed
  or designed around here.

No implementation follows from this document. Stopping here per your
instruction — waiting for your review and explicit approval before
any further work (including whether/how to address §3's findings) is
scoped.
