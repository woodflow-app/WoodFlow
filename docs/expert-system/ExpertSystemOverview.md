# Expert System Overview

Development infrastructure only. Every expert below is a Claude Code
skill under `.claude/skills/` — none of this is imported into Flutter,
registered in `service_locator.dart`, or shipped in the APK. See
`docs/adr/expert-system-foundation.md` for why this exists as a
Claude-Code-side process rather than application code.

## Two review tiers

There are two ways experts get run, both reading from the same
registry so the roster never drifts out of sync between them:

- **`expert-review`** (`.claude/skills/expert-review/SKILL.md`,
  `registry.md`) — the default, lightweight pass for most nontrivial
  changes: run applicable experts, combine findings into one
  categorized report, done.
- **`expert-consensus`** (`.claude/skills/expert-consensus/SKILL.md`,
  documented for humans at `ExpertConsensus.md`) — a heavier synthesis
  reserved for architecture changes, database changes, AI features,
  major UI redesign, website redesign, performance-critical code,
  security-sensitive code, and roadmap decisions. It names where
  experts agree, explains genuine disagreements instead of just
  listing them, applies explicit priority/veto rules, and commits to
  one recommended solution with a stated confidence level. See
  `ExpertConsensus.md` for the full process, priority rules, and
  conflict-resolution rules.

Use `expert-review` by default. Escalate to `expert-consensus` only
when one of its triggers applies — most changes don't need it.

## Experts

| # | Expert | Responsibilities | Trigger |
|---|---|---|---|
| 1 | `product-manager` | Roadmap fit, scope discipline, backlog/ADR routing | Always |
| 2 | `woodflow-architect` | Overall architecture, Clean Architecture layering, 5-year maintainability | Always |
| 3 | `database-architect` | Schema design, migration safety, read/write scaling | Schema/migration/query-pattern changes |
| 4 | `warehouse-expert` | Warehouse operations correctness, workflow efficiency | Inventory/storage/warehouse-workflow changes |
| 5 | `wood-industry-expert` | Wood-industry correctness (materials, grain, edging, nesting) | Materials/boards/offcuts/production changes |
| 6 | `ai-architect` | Right-sized AI tier, explainability, AI architecture boundaries | AI/ML/decision-engine-shaped changes |
| 7 | `flutter-expert` | Flutter/Dart implementation quality | Flutter/Dart implementation changes |
| 8 | `ui-ux-reviewer` | Usability, cognitive load, information hierarchy | Screen or user-facing-flow changes |
| 8 | `design-system-expert` | Icons, color, typography, components, spacing, tokens, Material 3 consistency | Visual-language-element changes |
| 8 | `mobile-ux-expert` | Real-world floor usability: gloves, noise, one-hand operation, tap-count | Screen/form/scanning-flow changes used on the warehouse/production floor |
| 9 | `security-reviewer` | Auth, data exposure, injection, secret handling | Always |
| 10 | `performance-reviewer` | Rebuilds, query cost, memory, startup time | Always |
| 11 | `code-reviewer` | Duplication, naming, dead code, SOLID, testability — final gate | Always |
| — | `website-expert` | Public marketing website only | Never for the WoodFlow Flutter app |

## Execution order

Priority number = reporting/execution order when multiple experts are
applicable to the same plan, per `registry.md`. Ties (7 experts share
priority 8) run in registration order and are reported together, not
ranked against each other — they're complementary lenses on the same
kind of change (a screen), not competing for precedence.

```
1  product-manager        — does this belong on the roadmap at all?
2  woodflow-architect     — does this fit the overall architecture?
3  database-architect     — (conditional) schema/migration safety
4  warehouse-expert       — (conditional) warehouse domain correctness
5  wood-industry-expert   — (conditional) wood-industry domain correctness
6  ai-architect           — (conditional) right-sized AI, if applicable
7  flutter-expert         — implementation quality
8  ui-ux-reviewer         ─┐
8  design-system-expert    ├─ (conditional) three lenses on the same
8  mobile-ux-expert       ─┘   user-facing change, run together
9  security-reviewer      — always
10 performance-reviewer   — always
11 code-reviewer          — final quality gate, always
—  website-expert         — separate rotation, public site only
```

## Overlaps

| Overlap | Experts | Nature |
|---|---|---|
| Database guidance | `woodflow-architect`, `database-architect` | Real duplication — see `ExpertSystemAudit.md` |
| Flutter/rebuild guidance | `woodflow-architect`, `flutter-expert`, `performance-reviewer` | Real duplication — see `ExpertSystemAudit.md` |
| Screen-level review | `ui-ux-reviewer`, `design-system-expert`, `mobile-ux-expert` | Complementary, not duplicative — usability vs. visual consistency vs. physical/environmental floor conditions. All three can legitimately fire on the same screen change and say different, non-redundant things. |
| Remnants/logistics | `warehouse-expert`, `wood-industry-expert` | Minor, adjacent domains, acceptable |

## Dependency graph

Experts don't depend on each other's *output* programmatically — each
runs independently against the same plan and the pipeline combines
results afterward (`expert-review/SKILL.md` step 4). What follows is a
**logical** sequencing dependency: which findings should realistically
block or reshape which other reviews, not a data/code dependency.

```
product-manager ──blocks──> everything
   (wrong roadmap fit means nothing downstream matters yet)

woodflow-architect ──blocks──> flutter-expert, database-architect,
                                ui-ux-reviewer/design-system-expert/mobile-ux-expert
   (an architectural conflict should be resolved before implementation-
    quality review of code built on the wrong foundation is meaningful)

domain experts (warehouse-expert, wood-industry-expert, ai-architect)
   run independently, inform woodflow-architect and flutter-expert but
   don't gate them

security-reviewer, performance-reviewer ──inform──> code-reviewer
   (code-reviewer is the final gate; it should see security/performance
    findings before giving a pass/reject verdict)

website-expert
   isolated — no dependency in either direction with the other 13,
   different deliverable entirely
```
