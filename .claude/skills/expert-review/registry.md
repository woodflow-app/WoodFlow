# Expert Registry

Development infrastructure only — read by the `expert-review` pipeline
skill. Not application data, not shipped in the WoodFlow app, not
referenced by any `lib/` code.

**To add a new expert:** create `.claude/skills/<skill-folder>/SKILL.md`
following the format of the existing skills, then add one row below.
Nothing in `expert-review/SKILL.md` needs to change — the runner reads
this table, it never hardcodes an expert's name or logic.

| Priority | Skill folder | Applicability | Focus |
|---|---|---|---|
| 1 | `product-manager` | always | Roadmap fit, scope discipline, what's actually confirmed vs. assumed |
| 2 | `woodflow-architect` | always | Overall architecture fit, long-term maintainability, Clean Architecture layering |
| 3 | `database-architect` | when the change touches schema, migrations, or query patterns | Schema design, migration safety, read/write scaling |
| 4 | `warehouse-expert` | when the change touches inventory, storage, or warehouse workflow | Warehouse operations correctness, workflow efficiency |
| 5 | `wood-industry-expert` | when the change touches materials, boards, offcuts, or production | Wood-industry correctness (materials, grain, edging, nesting) |
| 6 | `ai-architect` | when the change is AI/ML/decision-engine-shaped | Right-sized AI tier, explainability, architecture-boundary protection |
| 7 | `flutter-expert` | when the change touches Flutter/Dart implementation | Flutter/Dart implementation quality |
| 8 | `ui-ux-reviewer` | when the change touches a screen or user-facing flow | Usability, cognitive load, information hierarchy |
| 8 | `design-system-expert` | when the change touches icons, colors, typography, components, spacing, or tokens | Visual-language consistency across the whole app |
| 8 | `mobile-ux-expert` | when the change touches a screen, form, or scanning flow used on the warehouse/production floor | Real-world usability: gloves, noise, one-hand operation, tap-count, production speed |
| 9 | `security-reviewer` | always | Auth, data exposure, injection, secret handling |
| 10 | `performance-reviewer` | always | Rebuilds, query cost, memory, startup time |
| 11 | `code-reviewer` | always | Duplication, naming, dead code, SOLID, testability — final quality gate |
| — | `website-expert` | only for the public marketing website — never for the WoodFlow Flutter app | Landing page, SEO, conversion, public-site performance |

**Priority** is execution/reporting order, not importance — every
applicable expert's findings appear in the combined report regardless
of position. **Applicability** is a plain-language filter: skip an
expert whose stated applicability clearly doesn't match the plan under
review (e.g. skip `database-architect` for a copy-only text change),
but when genuinely unsure, run it anyway rather than guessing it
doesn't apply.
