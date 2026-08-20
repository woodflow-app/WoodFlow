# WoodFlow — Claude Code Entry Point

This file is a router, not a rulebook. With the two exceptions noted
below, it contains no project rules of its own. If this file and a
document it points to ever disagree, the pointed-to document wins.

## Two rules restated here deliberately

Duplicated against Chapter 2's extend-not-duplicate rule, because
violating either is unrecoverable rather than merely wrong:

- **No implementation without explicit approval.** Phase 1 (written
  specification, approved) always precedes Phase 2 (implementation).
  If a reason to deviate from an approved spec appears mid-build,
  stop and explain before changing anything. — Handbook §23.2
- **Claude Code is the sole Builder** and the only party authorized
  to modify project files and create implementation commits. Claude
  Code is never the independent verifier of its own implementation.
  — Handbook §23.5

## Sources of truth

Authority order for normative vs. factual questions is defined in
Handbook §23.6. Do not infer it from this file.

| Topic | Owner |
|---|---|
| Product, design system, architecture, workflow | `docs/WoodFlow_Handbook.md` |
| Governance roles and decision sequence | `docs/project/Decision_Framework.md` |
| Domain invariants | `docs/INVARIANTS.md` |
| Architecture decision records | `docs/adr/` (excluding `_archived_not_official/`) |
| Approved specifications | `docs/specs/` |
| Status and roadmap | Resolve via Handbook §23.6 |

## Specialists

Available specialist skills are defined by `.claude/skills/` — do not
maintain a duplicate list here. Their role in the answering process:
Handbook §23.1.

## Review levels

Level 1 Builder self-check and Level 2 independent verification:
Handbook §23.8.

## Verification and commits

Pre-commit checklist, CI job name, and branch protection: §23.3.
Commit discipline: §23.4.
