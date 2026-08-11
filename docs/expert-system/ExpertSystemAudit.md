# Expert System Audit

Read-only audit of every skill in `.claude/skills/` as of this commit
— 14 experts, roster verified complete against the expected list
(WoodFlow Architect, Flutter Expert, Database Architect, Warehouse
Expert, Wood Industry Expert, Security Reviewer, Performance Reviewer,
Code Reviewer, UI/UX Reviewer, Design System Expert, Mobile UX Expert,
Website Expert, Product Manager, AI Architect). No skill files were
modified to produce this report. See `ExpertSystemOverview.md` for the
roster table, execution order, and dependency graph this audit assumes.

---

## 1. product-manager

**Purpose:** Own the roadmap; stop scope/roadmap changes from happening silently.

**Trigger:** Always.

**Weaknesses:** Overlaps with `woodflow-architect`'s "protect existing decisions" language — real but implicit boundary.

**Suggested improvements:** Add a line cross-referencing `woodflow-architect` (should-we vs. how-to).

**Final score:** clarity 8, usefulness 9, maintainability 9, scalability 8 — **8.5/10**. Already proven directly this session (caught the Krok-15 roadmap mismatch before any code existed).

---

## 2. woodflow-architect

**Purpose:** Chief architecture authority; 5-year maintainability.

**Trigger:** Always.

**Weaknesses:**
- ~~Factual error: "Use Riverpod correctly."~~ **Fixed** — now states the actual convention (`get_it` + `StatefulWidget`, no Riverpod).
- Its Database/Flutter/Performance/UX sections still substantially duplicate `database-architect`, `flutter-expert`, `performance-reviewer`, `ui-ux-reviewer` near-verbatim (not in scope of this fix pass — factual errors only).

**Suggested improvements:** Trim the four duplicated subsections to one-line pointers at the dedicated specialists.

**Final score:** clarity 7, usefulness 8, maintainability 7, scalability 6 — **7/10** (up from 6.25 — the factual error was the main maintainability drag).

---

## 3. database-architect

**Purpose:** Schema/migration design for long-term scalability.

**Trigger:** Schema/migration/query-pattern changes only.

**Weaknesses:** "Think about millions of records" overstates WoodFlow's realistic scale and risks contradicting the codebase's own demonstrated YAGNI discipline. Duplicates `woodflow-architect`'s Database section.

**Suggested improvements:** Rescale to WoodFlow's real ceiling; endorse the existing "defer and document" optimization pattern already proven in this codebase.

**Final score:** clarity 9, usefulness 8, maintainability 9, scalability 7 — **8.25/10**.

---

## 4. warehouse-expert

**Purpose:** Warehouse-operations domain correctness.

**Trigger:** Inventory/storage/warehouse-workflow changes.

**Weaknesses:** Generic enough to apply to any warehouse app — doesn't name WoodFlow's actual entity model. Latent, not yet directly exercised.

**Suggested improvements:** Name the real Warehouse→Rack→Slot→Board/Offcut hierarchy and `slotId`-only location rule explicitly.

**Final score:** clarity 8, usefulness 7, maintainability 9, scalability 8 — **8/10**.

---

## 5. wood-industry-expert

**Purpose:** Wood/furniture-industry material and production correctness.

**Trigger:** Materials/boards/offcuts/production changes.

**Weaknesses:** Same genericness issue as `warehouse-expert`. Minor overlap with it on remnants/logistics.

**Suggested improvements:** Reference WoodFlow's real `Board`/`Offcut`/`Decor` entities and the already-imported EGGER catalog.

**Final score:** clarity 8, usefulness 7, maintainability 9, scalability 8 — **8/10**.

---

## 6. ai-architect

**Purpose:** Right-sized AI decisions; prevent unnecessary AI complexity.

**Trigger:** AI/ML/decision-engine-shaped changes.

**Weaknesses:** Longest of the newer skills, more surface to go stale. Never yet invoked through the real pipeline mechanism.

**Suggested improvements:** Revisit and trim after 2–3 more real AI features ship.

**Final score:** clarity 9, usefulness 9, maintainability 7, scalability 8 — **8.25/10**.

---

## 7. flutter-expert

**Purpose:** Flutter/Dart implementation quality.

**Trigger:** Registered as conditional ("Flutter/Dart implementation changes") but this is true of nearly every change in a Flutter app — should probably just be "always."

**Weaknesses:** ~~Same Riverpod factual error as `woodflow-architect`~~ **Fixed** — now states the actual convention.

**Suggested improvements:** Change registry applicability to "always" (still open — not a factual issue, out of scope for this fix pass).

**Final score:** clarity 9, usefulness 8, maintainability 8, scalability 7 — **8/10** (up from 7 — this was the single highest-value fix in the audit).

---

## 8. ui-ux-reviewer

**Purpose:** Usability and cognitive-load review.

**Trigger:** Screen or user-facing-flow changes.

**Weaknesses:** Overlaps with `design-system-expert` and now `mobile-ux-expert` — all three fire on most screen changes. The three-way distinction is real (usability / visual consistency / physical floor conditions) but only written down in `ExpertSystemOverview.md`, not cross-referenced in the skill files themselves.

**Suggested improvements:** Add a line distinguishing itself from the other two screen-level experts.

**Final score:** clarity 8, usefulness 8, maintainability 9, scalability 8 — **8.25/10**.

---

## 9. design-system-expert

**Purpose:** Visual-language consistency (icons, color, typography, components, navigation, layout, elevation, spacing, tokens, accessibility) across the whole app.

**Trigger:** Visual-language-element changes.

**Weaknesses:** Three-way overlap with `ui-ux-reviewer`/`mobile-ux-expert` (see above). Expanded scope (this revision) now explicitly includes accessibility and future design-token documentation — genuinely useful additions, but widens an already-broad mandate further.

**Suggested improvements:** Add the boundary line vs. the other two screen-level experts. Actually invoke it via the `Skill` tool on the next real UI change rather than applying its principles manually, to validate the pipeline mechanism end-to-end.

**Final score:** clarity 8, usefulness 8, maintainability 8, scalability 7 — **7.75/10** (scalability marked down slightly from the prior revision — the expanded responsibility list is now the broadest of the three screen-level experts and will need active curation to stay focused).

---

## 10. mobile-ux-expert *(new this revision)*

**Purpose:** Real-world floor usability — gloves, noise, one-hand operation, tap-count, production speed — distinct from general usability or visual consistency.

**Trigger:** Screens/forms/scanning flows actually used on the warehouse or production floor.

**Weaknesses:** Brand new, zero track record yet. Its boundary against `ui-ux-reviewer` (which already asks "can this require fewer taps?") is close enough that the two could feel redundant on a screen with no genuinely floor-specific concern (e.g. a settings screen used only in an office) — worth watching in practice, not yet a proven problem.

**Suggested improvements:** After 2–3 real invocations, confirm it's actually surfacing floor-specific findings `ui-ux-reviewer` wouldn't have caught on its own (glove-sized tap targets, outdoor contrast, noisy-environment glanceability) — if it never does, fold it into `ui-ux-reviewer` instead of maintaining two overlapping files.

**Final score:** clarity 8, usefulness n/a (0 real invocations, expected for a brand-new expert), maintainability 8, scalability 7 — **not fully scored** pending real use.

---

## 11. security-reviewer

**Purpose:** Pre-merge security risk identification.

**Trigger:** Always.

**Weaknesses:** ~~Factual mismatch: Firebase Security Rules/Firestore/Storage permissions~~ **Fixed** — now references the real stack (local SQLite data-at-rest, the already-documented missing permission enforcement on `regenerateQrCode()`, and explicit no-auth-yet awareness) instead of a cloud backend this app doesn't have.

**Suggested improvements:** None outstanding from the factual-accuracy pass. Longer-term: could still add SQL-injection-via-`rawQuery` awareness as this app's queries grow more dynamic — not urgent today (queries are parameterized throughout).

**Final score:** clarity 9, usefulness 8, maintainability 8, scalability 7 — **8/10** (up from 6 — was the lowest score in the audit, now describes the application it's actually reviewing).

---

## 12. performance-reviewer

**Purpose:** Runtime performance review.

**Trigger:** Always.

**Weaknesses:** Generic — doesn't reference the codebase's own already-established "defer and document" optimization precedent (`DashboardService`'s N+1 TODO, `LedgerEntryFormatter`'s batching). Minor overlap with `woodflow-architect`'s Performance section.

**Suggested improvements:** Point explicitly at the existing precedents as house style.

**Final score:** clarity 9, usefulness 7, maintainability 9, scalability 8 — **8.25/10**.

---

## 13. code-reviewer

**Purpose:** Final code-quality gate.

**Trigger:** Always.

**Weaknesses:** Purely generic — doesn't name WoodFlow's specific conventions (`Result<T>` over exceptions, `get_it` as sole DI, archive-not-delete) as concrete tripwires.

**Suggested improvements:** Add 1–2 WoodFlow-specific architecture violations to check for by name.

**Final score:** clarity 9, usefulness 8, maintainability 10, scalability 9 — **9/10**. Highest score in the roster — a generic quality checklist can't go stale, and it's correctly positioned as the final gate.

---

## 14. website-expert

**Purpose:** Public marketing website — explicitly separate from the WoodFlow app.

**Trigger:** Never for the WoodFlow Flutter app (registry-enforced).

**Weaknesses:** None identified — no website work exists yet to evaluate this expert against. Dormant by design, not by defect. Revised this session to the full 6-section format with no material content change.

**Suggested improvements:** None needed now.

**Final score:** clarity 9, usefulness n/a (0 real invocations, expected), maintainability 9, scalability 8 — **not scored** pending real use.

---

## Overlap summary

| Overlap | Experts involved | Real problem? |
|---|---|---|
| Database guidance duplicated | `woodflow-architect`, `database-architect` | Yes — near-verbatim in places |
| Flutter/rebuild guidance duplicated | `woodflow-architect`, `flutter-expert`, `performance-reviewer` | Yes — same points made 2–3 times |
| Screen-level triad | `ui-ux-reviewer`, `design-system-expert`, `mobile-ux-expert` | Complementary by design — needs explicit boundary lines in each file, not a merge, unless `mobile-ux-expert` proves redundant in practice (see its entry above) |
| Warehouse/wood-industry "remnants" | `warehouse-expert`, `wood-industry-expert` | Minor, adjacent domains, acceptable |

~~Riverpod factual error appears independently in two files~~ **Fixed in both** — `woodflow-architect` and `flutter-expert` now correctly state `get_it` + `StatefulWidget`, no Riverpod anywhere.

---

## Missing experts

Still standing from the prior audit pass — `mobile-ux-expert` filled the
one gap explicitly identified as missing from the expected roster;
these three are additional, lower-priority gaps grounded in actual
session events, not part of the "expected 14":

1. **Release/deployment expert** — this session's repeated `adb`/build/install/launch friction (a widget-test FFI deadlock, a recurring compatibility dialog, a tap colliding with an unrelated overlay app) has no current owner.
2. **Localization expert** — two Kroki this session each manually extended all 21 ARB files with no dedicated process owner.
3. **Testing-strategy expert** — the FFI/widget-test hang this session was a real, costly debugging session; neither `code-reviewer` nor `flutter-expert` currently owns test-infrastructure strategy specifically.

**Not yet needed:** a data-privacy/compliance expert — no real auth or PII handling exists yet. Worth planning for once Auth (already referenced as "v2.5" in existing code comments) actually lands.

---

## Long-term risks

- The screen-level triad (`ui-ux-reviewer`/`design-system-expert`/`mobile-ux-expert`) is the roster's biggest structural bet: three lenses on the same change is valuable if each stays disciplined to its own lens, and confusing/redundant if they drift into repeating each other. Worth a re-audit after several real invocations, not just at creation time.
- The three now-fixed factual errors (Riverpod ×2, Firebase ×1) got in because these skills started from generic/templated content not fully adapted to WoodFlow's real stack. Worth a one-pass sweep across the remaining files for similar unadapted boilerplate as a future, lower-urgency check — none found so far beyond the three already fixed.

---

## Verdict — rerun after the 2026-08-11 factual-fix pass

**READY FOR V2.**

All three factually wrong statements identified in the prior audit
pass are confirmed fixed (verified by grepping the full skill roster
for `Riverpod`/`Firebase`/`Firestore` — the only remaining matches are
the corrected lines explicitly stating they're *not* used). Roster is
complete (14/14 expected experts exist). No remaining factual
inconsistencies found.

Two non-blocking improvements remain open from the prior pass, neither
a factual error: `woodflow-architect`'s duplication with four other
skills, and the screen-level triad's missing explicit boundary lines.
Both are real but were explicitly out of scope for this fix pass
(factual accuracy only, per instruction) — carried forward as the next
lowest-priority improvement, not a blocker to using the roster as-is.
