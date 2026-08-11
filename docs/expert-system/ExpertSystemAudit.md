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
- **Factual error:** "Use Riverpod correctly." This codebase uses plain `get_it` + `StatefulWidget` everywhere, zero Riverpod dependency, confirmed repeatedly this session.
- Its Database/Flutter/Performance/UX sections substantially duplicate `database-architect`, `flutter-expert`, `performance-reviewer`, `ui-ux-reviewer` near-verbatim.

**Suggested improvements:** Fix the Riverpod line; trim the four duplicated subsections to one-line pointers at the dedicated specialists.

**Final score:** clarity 6, usefulness 8, maintainability 5, scalability 6 — **6.25/10**.

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

**Weaknesses:** **Same Riverpod factual error as `woodflow-architect`** — the same wrong advice appears in two files.

**Suggested improvements:** Fix the Riverpod line (highest-value, lowest-risk fix in this whole audit — appears twice). Change registry applicability to "always."

**Final score:** clarity 8, usefulness 7, maintainability 6, scalability 7 — **7/10**.

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

**Weaknesses:** **Factual mismatch:** lists Firebase Security Rules/Firestore/Storage permissions — this app has none of that, it's local SQLite (`sqflite`). Doesn't mention the real, already-documented gap in this codebase: `⚠️ Brak wymuszenia uprawnień` comments already sitting on every `regenerateQrCode()` method, explicitly awaiting Auth in a future version.

**Suggested improvements:** Replace the Firebase bullets with WoodFlow's real surface (local data-at-rest, the documented missing permission enforcement, input validation, no-auth-yet awareness).

**Final score:** clarity 7, usefulness 6, maintainability 5, scalability 6 — **6/10**. Lowest score in the audit — the file doesn't describe this application's actual stack.

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

**Riverpod factual error** appears independently in **two** files (`woodflow-architect`, `flutter-expert`) — the same wrong advice, twice.

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
- Two independently-introduced factual errors (Riverpod ×2, Firebase ×1) suggest these skills started from generic/templated content not fully adapted to WoodFlow's real stack. Worth a one-pass sweep across the remaining files for similar unadapted boilerplate, not just the three found here.

---

## Verdict

**CHANGES REQUIRED.**

Roster is now complete (14/14 expected experts exist). But three lines
across two files still give **factually wrong, verifiable, actionable
advice** about this codebase's actual tech stack (Riverpod ×2,
Firebase/Firestore ×1) — not a style nitpick, a defect in a system
whose entire job is giving correct guidance. Fix those three lines,
trim `woodflow-architect`'s duplication, add the boundary lines for
the screen-level triad, and this roster is genuinely ready. Everything
else here is a real but lower-priority improvement, not a blocker.
