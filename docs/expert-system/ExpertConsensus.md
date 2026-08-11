# Expert Consensus

Development infrastructure only — same status as the rest of the
Expert System (see `docs/adr/expert-system-foundation.md`). Nothing
described here is imported into Flutter, registered in
`service_locator.dart`, or shipped in the APK. The operational
instructions live at `.claude/skills/expert-consensus/SKILL.md`; this
page is the reference explanation for humans browsing `docs/`.

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

Everything else uses `expert-review`. The list above isn't arbitrary —
each item maps onto one of the roster's high-stakes domains
(architecture → `woodflow-architect`, database → `database-architect`,
AI → `ai-architect`, UI redesign → the screen-level triad, website →
`website-expert`, performance → `performance-reviewer`, security →
`security-reviewer`, roadmap → `product-manager`).

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
