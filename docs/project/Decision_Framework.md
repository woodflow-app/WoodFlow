# Decision Framework

**Version:** 1.0
**Status:** Living Document
**Owner:** Piotr
**Scope:** WoodFlow project governance — this document is **not** part
of the WoodFlow Handbook and does not describe the product. See
"Relationship with the Handbook" below.

## Purpose

Every important product decision — a new feature, a change to
architecture, a visual direction, a scope expansion — is reviewed
before implementation begins, not after. The risk this manages isn't
hypothetical: a specification built and implemented without
independent review tends to accumulate the blind spots of whoever
wrote it, unchallenged, until they surface as rework later — at which
point the cost of fixing them is much higher than the cost of
catching them before a line of implementation existed.

This document exists so that review process is itself something the
project can point to, examine, and improve — not an implicit habit
that varies by mood, deadline pressure, or who happens to be involved
in a given decision.

## Roles

Three roles, deliberately defined by responsibility, not by who or
what fills them. Nothing below names a specific person, tool, or AI
model as a permanent part of this architecture — the roles are the
durable part; who occupies them can change without this document
needing to.

### Product Owner

Responsibilities:
- Defines product vision.
- Sets priorities.
- Approves specifications.
- Makes final product decisions.
- Accepts completed work.

The Product Owner is the only role with actual decision authority.
Every other role in this framework is structured to feed that
decision with better information, not to share or dilute it.

### Implementation Team

Responsibilities:
- Implements approved specifications.
- Prepares technical documentation.
- Identifies technical risks.
- Reports implementation constraints.
- Never expands scope without approval.

The Implementation Team may — and should — surface problems with a
specification once work begins (an assumption that turns out false,
a constraint nobody anticipated). What it may not do is quietly
resolve those problems by expanding or reinterpreting scope on its
own judgment; a discovered problem goes back through Discussion and
Approval, even if the fix seems obvious.

### Independent Reviewer

Responsibilities:
- Critically reviews specifications.
- Searches for inconsistencies.
- Challenges assumptions.
- Evaluates architecture.
- Evaluates UX.
- Identifies risks.
- Proposes alternatives.

**The reviewer is advisory only.** A reviewer's conclusions are
limited by the information available during the review — a review is
a considered opinion formed from what was visible at the time, not a
verdict binding on anyone. This is also why a review is never treated
as the final word on its own: it's an input to Discussion, weighed
alongside everything else, not a gate that silently approves or
blocks by itself.

## Decision Process

Every major decision follows this sequence:

```
Idea
  ↓
Specification
  ↓
Independent Review
  ↓
Discussion
  ↓
Product Owner Approval
  ↓
Implementation
  ↓
Verification
  ↓
Acceptance
```

- **Idea** — a problem or opportunity is named, concretely enough to
  be evaluated (not yet a plan).
- **Specification** — the idea becomes a written proposal: what it
  is, why it matters, what it costs, what it deliberately doesn't
  cover. A specification with no reasoning behind its choices isn't
  reviewable — it's just an assertion.
- **Independent Review** — examined for inconsistency, weak
  assumptions, architectural conflicts, and simpler alternatives, per
  the Reviewer role above.
- **Discussion** — findings from the review, and any other input, are
  weighed openly. Disagreement here is expected and useful, not a
  formality to get through.
- **Product Owner Approval** — an explicit decision: approved,
  rejected, or sent back for revision. Silence, enthusiasm about the
  general direction, or approval of an earlier related idea are not
  substitutes for approval of *this* specification.
- **Implementation** — the approved specification is built. Anything
  encountered that the specification didn't anticipate returns to
  Discussion, not to ad hoc judgment.
- **Verification** — the completed work is checked against objective,
  repeatable criteria appropriate to what was built. Verification is
  a separate step from Acceptance — it confirms the work is correct,
  not that it's wanted.
- **Acceptance** — the Product Owner confirms the delivered work
  matches the approved specification and closes the decision.

**No implementation begins before explicit approval.** This is the
one non-negotiable checkpoint in the sequence — every other step can
be revisited or repeated; this one cannot be skipped.

**This is a high-level governance sequence, not a procedure manual.**
The detailed WoodFlow implementation workflow — including
specification phases, approval gates, verification steps, commit
discipline, and the implementation process itself — is defined
exclusively in Chapter 23 of the WoodFlow Handbook. This document
intentionally does not duplicate those procedures. If any conflict
exists, the Handbook is authoritative for WoodFlow.

## Core Principle

Arguments are evaluated on their quality, not on who proposed them.
The best-supported solution wins. No participant is considered
infallible — including the Product Owner's own first instinct, the
Implementation Team's estimate of what's easy, and the Independent
Reviewer's own conclusions, which are only as good as the information
available when the review happened. Every participant may question
every proposal, at any stage, before Approval.

None of this dilutes where the decision actually lands: **the Product
Owner always makes the final decision, after considering all
evidence.** Open challenge is what makes that final decision
well-informed — it isn't a vote, and it isn't consensus-seeking for
its own sake.

## Relationship with the Handbook

- The **WoodFlow Handbook** defines the product — vision, design
  system, modules, architecture, coding standards, and the detailed
  WoodFlow implementation workflow (Chapter 23).
- This **Decision Framework** defines project governance — the roles
  and the high-level sequence a decision moves through, independent
  of any specific product or tool.
- The **Handbook is the single source of truth for WoodFlow-specific
  processes.** Nothing in this document overrides or duplicates it.
- This document **intentionally references the Handbook instead of
  duplicating it** — see the Decision Process section above. If the
  two ever appear to disagree on a WoodFlow-specific procedure, the
  Handbook wins.
