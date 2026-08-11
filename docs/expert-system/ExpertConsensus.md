# Expert Consensus

Development infrastructure only — same status as the rest of the
Expert System (see `docs/adr/expert-system-foundation.md`). Nothing
described here is imported into Flutter, registered in
`service_locator.dart`, or shipped in the APK. The operational
instructions live at `.claude/skills/expert-consensus/SKILL.md`; this
page is the reference explanation for humans browsing `docs/`.

## Governance

> **Expert Consensus is advisory, never authoritative. Experts
> analyze, identify risks, explain trade-offs and provide
> recommendations. The final architectural and product decision
> always belongs to the Project Owner.**

Every consensus report ends with a mandatory "Decision required from
Project Owner" section for exactly this reason — the report's job is
to make a good decision easy to make, not to make it.

## Why this exists, separately from `expert-review`

`expert-review` (see `ExpertSystemOverview.md`) is the default
pre-implementation pass — run applicable experts, combine their
findings into one categorized report, done. It's proportionate for
most nontrivial changes.

Some decisions are bigger than that: getting them wrong is expensive
to undo, or several experts are likely to have genuinely different —
not just complementary — opinions about the right call. For those,
`expert-review`'s simple aggregation isn't enough; the findings need
to be reconciled into one engineering judgment, with disagreements
named and explained rather than left sitting side by side.

## When consensus is required

Automatically, for:

- architecture changes
- database changes
- AI features
- major UI redesign
- website redesign
- performance-critical code
- security-sensitive code
- roadmap decisions
- breaking changes (API changes, database migrations, cross-module refactoring, public interface changes)
- major product decisions (new modules, ERP/MES/CAD-CAM integrations, platform architecture, strategic roadmap decisions)

Everything else uses `expert-review`. Run Expert Consensus **only**
when one of these triggers is actually matched — for ordinary
implementation tasks, the standard `expert-review` pipeline is not
just sufficient but preferred, since running the heavier process
unnecessarily costs tokens and review time for no real benefit.

The list above isn't arbitrary — each item maps onto one of the
roster's high-stakes domains (architecture → `woodflow-architect`,
database → `database-architect`, AI → `ai-architect`, UI redesign →
the screen-level triad, website → `website-expert`, performance →
`performance-reviewer`, security → `security-reviewer`, roadmap/major
product decisions → `product-manager`, breaking changes →
`woodflow-architect` plus whichever domain expert owns the affected
module).

## Execution flow

1. Detect participants from `.claude/skills/expert-review/registry.md` — the one source of truth for the roster, shared with `expert-review`, never duplicated.
2. Run each selected expert independently, so one expert's framing doesn't bias another's.
3. Collect every finding, tagged by source expert.
4. Group into Agreements / Conflicts / Risks (by category) / Recommendations / Open Questions — not a flat list.
5. Synthesize one report at `docs/expert-system/ExpertConsensus.md` (this file — overwritten per use; git history is the log of past consensus runs, not a running append).

## Priority rules

Not every expert's opinion carries equal weight in a genuine conflict:

| Expert(s) | Weight |
|---|---|
| `product-manager`, `woodflow-architect` | Veto — a real roadmap-scope or architectural-invariant conflict blocks the recommendation outright |
| `security-reviewer` | Veto for anything identified as a genuine vulnerability |
| Domain experts (`wood-industry-expert`, `database-architect`, `warehouse-expert`, etc.) | Authoritative within their own domain only |
| Everyone else | Weighed and merged into the synthesis, not a veto |

## Conflict resolution

A genuine conflict (not just two complementary lenses) gets: both
positions stated and attributed, an explanation of *why* they differ
(priority, assumption, or risk-tolerance difference — not just "they
disagree"), and either a resolution via the priority rules above
(stated explicitly) or an honest Open Question if priority rules don't
settle it. Silently picking a side without explanation is the one
thing this process explicitly exists to prevent — see
`expert-consensus/SKILL.md`'s "Rules" section for the full list.
A minority opinion is never hidden: if one expert disagrees with
every other participant, that expert's position and reasoning still
appear in full — being outvoted is not the same as being wrong, and
weighing that is the Project Owner's call, per Governance above, not
the synthesis step's.

## Mandatory report sections

Every consensus report — regardless of how simple the decision turns
out to be — must include: **Facts**, **Assumptions**, **Risks**,
**Alternative solutions**, **Recommendation**, and **Decision required
from Project Owner**. The full section list and format live in
`expert-consensus/SKILL.md`; these six are the ones that may never be
dropped even when brief.

Every recommendation and alternative carries a cost tag — **Small**
(minutes) / **Medium** (hours) / **Large** (days) / **Major** (weeks)
— so the Project Owner can weigh impact against cost before deciding,
not just merit in isolation.
