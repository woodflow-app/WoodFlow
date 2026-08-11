# Expert Consensus Report — Premium UI/UX Rebuild vs. In-Progress Design System Rollout

## Summary

A new request asks for a ground-up "premium" visual rebuild of every
screen (Apple/Linear/Notion/Figma/Stripe/Shopify-tier), a much larger
component catalogue, a full CRUD-everywhere matrix (including making
History editable), and explicit multi-expert consensus before
continuing. This arrives while the previously-approved, smaller-scope
Design System work (`docs/design-system/WoodFlowDesignSystem.md`) and
its component library are already built and mid-rollout (1 of ~12
screens migrated). Consensus triggered per `expert-consensus`'s own
"major UI redesign" rule.

## Experts involved

`design-system-expert`, `mobile-ux-expert`, `ui-ux-reviewer`,
`warehouse-expert`, `product-manager` — as requested. `woodflow-architect`
also weighed in (not requested by name, but its veto authority applies
directly to the invariant conflict found below, per `expert-consensus`'s
priority rules). `wood-industry-expert` and `security-reviewer` skipped
— nothing in this decision touches material/production correctness or
security surface.

## Facts

- `docs/design-system/WoodFlowDesignSystem.md` already exists, already
  covers spacing/typography/color/elevation/radius/icons/buttons/cards/
  dialogs/lists/navigation/empty/loading/error states/component
  catalogue, and was produced by this exact multi-expert-audit process
  in the immediately preceding turn.
- A 16-component `WF*` library already exists at
  `lib/presentation/design_system/`, verified via `flutter analyze`
  with 0 issues.
- `WarehouseListScreen` is already migrated to use it (uncommitted, this turn).
- This codebase's Ledger (`ledger_entries`) is append-only by standing,
  documented, repeatedly-enforced invariant (`docs/INVARIANTS.md`:
  "Historia (ledger) jest niezmienna... żaden kod nigdy nie robi
  UPDATE/DELETE na ledger\_entries, tylko INSERT").
- Board/Offcut are archive-only, never hard-deleted — reaffirmed this
  session via the warehouse-deletion feature, which archives contained
  Boards/Offcuts rather than deleting them for exactly this reason.
- No `notes`/`properties` free-text field exists on any entity today.
  No "Duplicate" operation exists anywhere in the domain layer today.

## Assumptions

- The "premium, Apple/Linear/Stripe-tier" visual bar is taken as a
  genuine intent, not verified against any concrete mockup or
  reference the user has shown — there is no fixed, checkable
  "done" state for this goal as currently written.
- "Every entity must support... Edit... History" is assumed to be a
  literal requirement, not figurative language — flagged below because
  taken literally it conflicts with a standing invariant.

## Areas of agreement

- `design-system-expert`, `mobile-ux-expert`, `ui-ux-reviewer`: a
  coherent design system before screen-by-screen changes is the right
  sequencing — already done, this session, before this new message arrived.
- `product-manager`, `woodflow-architect`: "editable History" cannot
  mean literal mutation of existing `ledger_entries` rows without
  either violating the append-only invariant or being reframed into a
  materially smaller, different feature (see Architecture risks).
- All consulted experts: the `WF*` shared-component approach already
  underway is the correct implementation mechanism regardless of how
  large the final visual-scope decision turns out to be.

## Risks

### Architecture risks
- **"History must be editable," read literally, breaks the append-only
  Ledger invariant** — the same class of conflict already surfaced
  and resolved once this session (warehouse deletion). This is not a
  style question; the Ledger's entire value is being a trustworthy,
  tamper-proof audit trail. `woodflow-architect`/`product-manager`
  veto weight applies: this cannot proceed as literally stated without
  an explicit reframing decision (e.g. append a correction/annotation
  entry, never mutate an existing one).
- "Delete" applied literally to Board/Offcut (vs. the existing Archive
  flow) repeats the identical, already-resolved conflict from the
  warehouse-deletion feature.

### UX risks
- `mobile-ux-expert`: a full custom motion/animation system and
  skeleton loaders on every interaction can work *against* "large
  touch targets, minimal typing, fast scanning, few taps" if
  transition time is added between routine, repetitive actions. A
  worker scanning and shelving all shift benefits more from speed and
  predictability than from delight animation — this needs to be
  reconciled explicitly, not assumed automatically compatible.

### Performance risks
- "Maintain 60 FPS" is stated as a goal, but custom shadows/elevation/
  animation for every component is exactly the category of change most
  likely to cost real frame budget if built ahead of measurement — the
  codebase's own established precedent everywhere else is "measure
  before optimizing," which argues against front-loading animation
  work speculatively.

### Business risk
- `product-manager`: this is not a polish pass. It is a full visual
  rebuild of every screen *plus* a large functional expansion
  (Duplicate, Notes, Properties, undo, editable History/QR). Estimated
  cost: **Major (weeks)**, not the `Large (days)` already flagged for
  the (already-approved, already-started) token-application pass
  alone. It also arrives as a scope escalation mid-implementation of
  smaller, already-authorized work from the immediately preceding turn.

## Recommended solution — **Medium** (hours to low days, building on work already done)

1. Keep `WoodFlowDesignSystem.md` and the `WF*` library as the accepted
   foundation — amend it with the genuinely new, valuable additions
   from this request (design philosophy/visual identity framing,
   shadows, skeleton loading, motion system) rather than discarding
   verified, working code to start over.
2. Finish the already-authorized "apply tokens/components consistently
   across every screen" pass — this alone gets most of the way to
   "feels considered and professional" with a fixed, checkable
   finish line (every screen uses `WF*` components), unlike an
   open-ended "match Stripe" target.
3. Treat the full CRUD-everywhere matrix as **separate, later
   decisions** — each capability on its own merits. Several are
   genuinely useful (Rename, Notes) and low-conflict; one (editable
   History) needs an explicit reframing decision before any code
   exists for it.
4. Do not adopt a named competitor's visual language as a literal
   spec — recommend concrete, specific feedback per screen instead
   ("this still feels off because X") once the consistent pass is
   visible, rather than an unbounded aesthetic target.

## Alternative solutions

- **A — Full literal scope as written.** **Major (weeks).** Every
  screen custom-rebuilt to a named-competitor visual bar, full motion
  system, full CRUD matrix including History. Blocks immediately on
  the History-editability conflict, which has no resolution yet.
- **B — Recommended solution above.** **Medium** now, **Large**
  cumulative once every screen is migrated (already flagged and
  accepted in the prior turn). Keeps verified work, defers the
  conflicting/expansive parts as explicit later decisions.
- **C — Pause all screen code, spend a session on pure visual
  exploration** (mockups/references) before any further implementation.
  **Small** to start, but slowest to any visible product progress, and
  most literal reading of "do not continue until consensus is reached."

## Long-term impact

Recommendation B keeps the codebase's demonstrated YAGNI discipline
intact (ship what's proven needed, defer speculative scope) while
still directly addressing "doesn't feel premium yet" through real
consistency. Alternative A, if the History conflict were resolved by
actually weakening the append-only guarantee rather than reframing
around it, would be a significant, hard-to-reverse trust regression —
every other feature built this session (archive-not-delete, the
careful warehouse-deletion design) depends on that guarantee holding.

## Confidence level

**Medium.** High confidence on the architecture-risk finding — the
invariant conflict is a verifiable fact against `docs/INVARIANTS.md`,
not a judgment call. Lower confidence on the "premium visual bar"
question specifically, since it's inherently subjective and there is
no concrete reference to verify against yet — that part of the
recommendation is a process suggestion, not a settled fact.

## Open questions

*(resolved — see Resolution below)*

## Resolution

Project Owner answered directly: History/Ledger stays immutable
(never edited or deleted); corrections are new entries referencing the
prior one; users edit business data (board/slot/warehouse/notes/
metadata), the audit trail records it without ever being rewritten.
This is not a new pattern — it's exactly what `BoardRepository.moveBoard()`/
`archive()` and every other existing mutation already do (write a new
`ledger_entries` row, never touch an old one). No architectural
conflict, no ADR needed. "Continue implementation" authorized on this
basis — proceeding with Recommendation B (finish the consistent WF
rollout, workflow-simplification folded in), entity editing (Rename,
notes/metadata where it fits naturally) added as I reach each screen.

## Addendum — workflow-ambition reinforcement received

A follow-up message reinforced Decision #1 toward ambition (challenge
every screen, reduce taps/scrolling/typing/clutter, benchmark against
best-in-class enterprise software) but did not answer Decisions #2 or
#3 below. This is folded into Recommendation B as elevated ambition
*within* the consistent rollout — "redesign a workflow if it's
genuinely faster" is compatible with, and now explicitly part of,
finishing the token/component pass; it is not, on its own, an answer
to the concrete architecture question in #2, which is a fact-based
yes/no (does this break the append-only invariant), not a matter of
ambition. Proceeding on this basis: the rollout continues now with
workflow-simplification as an explicit goal, not just visual
consistency; the History question remains a hard blocker for that one
specific capability only.

## Decision required from Project Owner

1. **Continue the already-in-progress rollout** (finish applying the
   existing, approved design system consistently across every screen —
   Recommendation B), **or pause it in favor of** the full literal
   rebuild (Alternative A, Major/weeks, no fixed done-state)?
2. **Resolve "editable History" explicitly** — literal Ledger
   mutation (conflicts with the standing invariant, needs its own ADR
   before any code), or an annotation/correction entry appended
   afterward (doesn't conflict, can proceed)?
3. **Confirm scope for Duplicate/Notes/Properties editing** — part of
   this UI work now, or routed to `docs/BACKLOG.md` as their own
   future features, per `product-manager`'s standing scope-discipline rule?
