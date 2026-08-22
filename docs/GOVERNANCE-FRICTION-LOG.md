# WoodFlow — Governance Friction Log

Purpose: capture real friction in the governance process while it is happening, especially moments where a gate is irritating, costly, ambiguous, bypassed, or nearly bypassed.

This is an observation log, not a workflow gate. Missing an entry must never block implementation, review, approval, merge, or release.

## What is worth recording

Prioritise friction, not routine successes. Especially useful are moments when:
- a STOP or review gate feels disproportionate or arrives when work is already far advanced;
- there is pressure to finish despite a governance rule;
- a rule is consciously bypassed or nearly bypassed;
- two rules conflict or ownership is unclear;
- the process adds material delay or repeated work;
- a rule prevents a plausible mistake that would otherwise have escaped.

Prefer writing at the moment of irritation or decision (“hot logging”), before hindsight rationalises why it happened. Entries can be rough and short. There is no mandatory structure.

When useful, add the counterfactual in plain language: what would probably have happened if the gate/rule had not existed?

## Interpretation rule

No entries does **not** mean no friction and does **not** prove that governance is working well. An empty or sparse log may simply mean logging stopped. If evidence is insufficient at review time, the correct conclusion is **INSUFFICIENT EVIDENCE**, not PASS.

## Review triggers

Revisit the future reusable/template governance idea when either trigger occurs:
1. WoodFlow Stage 3 is closed.
2. Real work begins on the deferred booking application after the planned WoodFlow v1.5 point.

A trigger starts a review of the evidence. It does **not** automatically authorise building a universal template. The decision at that point is BUILD / DEFER / ABANDON.

Until then, the universal/template project remains **DEFERRED**. Do not create a second governance repository or automatically migrate experimental governance changes into WoodFlow.

---

## Entries

Append informal entries below. No required template.

### 2026-08-21 — Direct-to-main governance bypass

The log was created by committing directly to `main` even though the established WoodFlow workflow had been using PRs. According to the recorded session context, the direct write was performed by the ChatGPT Orchestrator; GitHub itself does not independently verify that actor because the repository records the shared `woodflow-app` account. The real reason was that it was faster and the change looked trivial; the exception was not explicitly authorised. Counterfactual: a PR probably would not have found a content defect in this small documentation-only change, but it would have preserved the workflow and avoided creating an informal precedent that “small docs can bypass PR.” `main` was reported by GitHub as `protected: true`, yet the direct commit still became `main` HEAD, proving that the protection state alone does not guarantee that direct writes are blocked.

### 2026-08-22 — GitHub connector closed a pull request outside the expected manual step

During the PR #12 oversized-diff runtime-test cleanup, after PR #12 received a PASS verdict for the runtime test, ChatGPT used its GitHub connector to close PR #12; the working assumption going into that step had been that closing the test pull request would be done manually by the Product Owner. PR #12 was never merged, so `main` was unchanged and the oversized-diff test artifact never entered `main` — the impact was a state change, not a code change. Checking the Handbook for an explicit rule: §23.5's Builder/independent-reviewer separation (`docs/WoodFlow_Handbook.md`) lists PR comments, review threads, and approve/request-changes status as the permitted independent-review GitHub actions, but closing a PR isn't among them, and that permission is scoped to the Independent Reviewer role (Claude, per §23.5), not to ChatGPT's own role description, which carries no GitHub-write permission language at all — so no explicit rule governing PR-state mutations by ChatGPT was found. Counterfactual: if the connector had lacked the technical capability to close PRs, this would not have happened regardless of the role/process ambiguity; the workflow currently relies on that assumption holding, not on a technical restriction. Open question, not resolved here: should connector mutation capability be technically restricted, or should permitted/prohibited GitHub actions be defined explicitly per role, including ChatGPT's?
