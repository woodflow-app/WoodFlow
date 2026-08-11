\# Expert Consensus



Development-only Claude Code process — not a runtime feature. Nothing here is imported into Flutter, registered in `service\_locator.dart`, or shipped in the APK. Verified as of this revision: still true, no exceptions.



\---



\## Governance — read this before anything else



\*\*Expert Consensus is advisory, never authoritative. Experts analyze, identify risks, explain trade-offs and provide recommendations. The final architectural and product decision always belongs to the Project Owner.\*\*



This is not a formality — every consensus report ends with a "Decision required from Project Owner" section precisely because the report's job is to make a good decision easy, not to make the decision itself.



\---



\## What this is, and how it differs from `expert-review`



`expert-review` is the default, lightweight pass: run applicable experts, combine findings into one categorized report (issues/recommendations/warnings/conflicts/risks), done. It's built for most nontrivial changes.



`expert-consensus` is heavier, and reserved for decisions important enough to justify it: instead of one combined report, it produces a synthesized engineering review that names where experts agree, where they genuinely disagree and why, weighs the disagreement, and commits to one recommended solution with a stated confidence level. Use `expert-review` by default; escalate to `expert-consensus` only when a trigger below applies.



\---



\## Automatic triggers



Run Expert Consensus, not just `expert-review`, for:



\- architecture changes

\- database changes

\- AI features

\- major UI redesign

\- website redesign

\- performance-critical code

\- security-sensitive code

\- roadmap decisions

\- breaking changes (API changes, database migrations, cross-module refactoring, public interface changes)

\- major product decisions (new modules, ERP/MES/CAD-CAM integrations, platform architecture, strategic roadmap decisions)



These map directly onto the roster's high-stakes domains (architecture → `woodflow-architect`, database → `database-architect`, AI → `ai-architect`, UI redesign → the screen-level triad, website → `website-expert`, performance → `performance-reviewer`, security → `security-reviewer`, roadmap/major product decisions → `product-manager`, breaking changes → `woodflow-architect` + whichever domain expert owns the module being broken). If none of these apply, `expert-review` is sufficient — don't run the heavier process on a small change just because it's available.



\---



\## Process



1\. \*\*Detect participants.\*\* Read `.claude/skills/expert-review/registry.md` — same source of truth as the standard pipeline, never a separate list. Select every expert whose applicability matches the decision, exactly as `expert-review` does.



2\. \*\*Execute independently.\*\* Invoke each selected expert (via the Skill tool) and evaluate the decision through that expert's lens \*\*without\*\* letting one expert's framing bias another's — each should reach its finding as if it were the only one consulted.



3\. \*\*Collect findings.\*\* Gather every expert's issues/recommendations/warnings/risks, tagged with which expert raised each one.



4\. \*\*Group, don't concatenate.\*\* Sort every finding into:

&#x20;  - \*\*Agreements\*\* — the same conclusion reached independently by 2+ experts

&#x20;  - \*\*Conflicts\*\* — experts reaching genuinely incompatible conclusions

&#x20;  - \*\*Risks\*\* — categorized by type (architecture/UX/performance/security/business)

&#x20;  - \*\*Recommendations\*\* — single-expert findings with no conflict, folded into the synthesis

&#x20;  - \*\*Open questions\*\* — things no expert could resolve from the plan as given



5\. \*\*Synthesize one report\*\* using the format below. This is the step that makes consensus more than aggregation: merge overlapping points into single statements, resolve what can be reasoned about, and name explicitly what can't.



\---



\## Priority rules (who wins a genuine conflict)



\- \*\*`product-manager` and `woodflow-architect` carry veto weight.\*\* A real roadmap-scope conflict or architectural-invariant conflict blocks the recommended solution regardless of what other experts prefer — these aren't "one opinion among several."

\- \*\*`security-reviewer` carries veto weight for anything it identifies as a genuine vulnerability\*\* — a real security issue isn't a tradeoff to weigh against convenience.

\- \*\*Domain experts carry authority within their own domain\*\* — `wood-industry-expert` on material/grain correctness, `database-architect` on schema/migration safety, `warehouse-expert` on warehouse workflow — a generalist's guess doesn't outweigh a domain specialist's finding inside that specialist's own domain.

\- \*\*Everything else contributes to the synthesis, not a veto\*\* — `flutter-expert`, the screen-level triad, `performance-reviewer`, `code-reviewer` findings get weighed and merged, and a recommended solution can proceed even if one of these disagrees, as long as the disagreement and its resolution are stated plainly.



\---



\## Conflict resolution



When two experts genuinely disagree (not just different lenses on the same change — an actual contradiction):



1\. State both positions plainly, attributed to the expert that raised each.

2\. Explain WHY they differ — a different priority, a different assumption, a different risk tolerance. "They disagree" is not an acceptable stopping point; the reason is the useful part.

3\. If priority rules above resolve it (one side has veto weight), say so explicitly and explain what changes as a result.

4\. If priority rules don't resolve it, do not silently pick a side — surface it as an Open Question for the user, with both options and their tradeoffs stated.

5\. Never hide a minority opinion. If one expert disagrees with the other four, that one expert's position and reasoning still appears in the report, in full — a minority view being outvoted is not the same as it being wrong, and the Project Owner (see Governance) is the one who gets to weigh that, not the synthesis step.



\---



\## Report format — `docs/expert-system/ExpertConsensus.md`



Overwritten per use (it reflects the most recent consensus run, not a running log — commit history is the log). Sections marked \*\*mandatory\*\* must appear in every report even if brief; the rest are included when there's something real to put in them.



Mandatory: Facts, Assumptions, Risks, Alternative solutions, Recommendation, Decision required from Project Owner. Every recommendation and alternative carries a cost tag — Small (minutes) / Medium (hours) / Large (days) / Major (weeks) — so the Project Owner can weigh impact against cost, not just merit in isolation.



```

\# Expert Consensus Report — <decision under review>



\## Summary

2–3 sentences: what's being decided, why consensus was triggered.



\## Experts involved

Who ran, one-line focus each. Who was skipped, and why.



\## Facts

Verifiable, checkable statements only — no opinion. Cite the file/ADR/test that makes each one true.



\## Assumptions

What this analysis takes as given but did NOT independently verify — flagged explicitly so a wrong assumption is easy to find and fix later.



\## Areas of agreement

What every consulted expert's findings converge on.



\## Areas of disagreement

Real conflicts only. Each with: position A, position B, WHY they differ, and how it was resolved (or why it wasn't).



\## Risks

Architecture / UX / Performance / Security / Business — include only categories where something was actually found; an empty category is omitted, not padded.



\## Recommended solution

The synthesized call. Clearly marked as a recommendation, not a fact. Tagged with an estimated implementation cost: \*\*Small\*\* (minutes) / \*\*Medium\*\* (hours) / \*\*Large\*\* (days) / \*\*Major\*\* (weeks).



\## Alternative solutions

Genuine alternatives considered, and why each wasn't the top recommendation — each also tagged Small/Medium/Large/Major, so the Project Owner can weigh impact against cost when choosing between them, not just against the top recommendation.



\## Long-term impact

What this decision costs or enables 6–12+ months out.



\## Confidence level

High / Medium / Low, with one sentence explaining why — including naming which assumption, if wrong, would most change the recommendation.



\## Open questions

What consensus could not resolve analytically — a genuine unknown, not a decision waiting on the Project Owner.



\## Decision required from Project Owner

\*\*Mandatory, always the closing section.\*\* States plainly what needs the Project Owner's sign-off: which recommendation (or which alternative, if the Project Owner disagrees with the recommendation) to proceed with. Per Governance above, this report never decides — it hands off a decision, clearly framed, to the person who actually makes it.

```



\---



\## Rules



\- Never simply concatenate expert outputs — a consensus report that's just five sections copy-pasted from five skills has not done the synthesis job.

\- If experts disagree, explain why — the reason is more valuable than the fact that they disagree.

\- Keep facts, assumptions, and recommendations in visibly separate sections — never blend "this is true" with "I think this is the right call."

\- A consensus report is input to the user's decision, not the decision itself — end with confidence level and open questions, not a unilateral "implementing now."

\- \*\*Run Expert Consensus only when a trigger above is actually matched.\*\* Every ordinary implementation task uses `expert-review`, not this. Running the heavier process on a small change wastes tokens and review time for no real benefit — efficiency is itself part of this process's job, not a tradeoff against it.

