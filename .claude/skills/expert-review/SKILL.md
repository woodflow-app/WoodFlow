\# Expert Review



\## What this is



A Claude Code development-process pipeline — not a WoodFlow application feature. Nothing here is read by, imported into, or shipped inside the Flutter app. This exists to make "consult the right specialists before implementing" a repeatable, extensible, documented process instead of an ad-hoc judgment call made differently every session.



\---



\## When to run this



Before implementing anything non-trivial: a new feature, an architectural change, anything touching more than one layer (domain/data/presentation), or anything explicitly described as needing multi-specialist review. Skip it for small, obviously-scoped fixes — this pipeline is for decisions worth getting a second (and third, and fourth) opinion on before code exists, not a mandatory gate on every change.



\---



\## The pipeline



1\. Read `.claude/skills/expert-review/registry.md`. That table is the entire list of registered experts — this file never hardcodes a specific expert's name, focus, or logic. Adding, removing, or reordering experts means editing the registry, not this file.



2\. For each row, in priority order: check the \*\*Applicability\*\* column against the plan under review. Run the expert if it applies or if you're genuinely unsure; skip it only when applicability is clearly unrelated. Rows marked "always" always run.



3\. For each applicable expert, invoke it with the Skill tool (skill name = the registry's "Skill folder" column) and evaluate the plan under review through that expert's lens. Extract, where relevant:

&#x20;  - \*\*issues\*\* — concrete problems with the plan as written

&#x20;  - \*\*recommendations\*\* — changes that would make it better

&#x20;  - \*\*warnings\*\* — things that aren't blocking but should be known going in

&#x20;  - \*\*architectural conflicts\*\* — contradictions with an existing ADR, invariant, or established pattern

&#x20;  - \*\*long-term risks\*\* — costs that don't show up until later (maintenance burden, scaling limits, lock-in)



&#x20;  Not every expert will have something in every category for every plan — an empty category for one expert is a normal, honest result, not a gap to fill.



4\. Combine every expert's output into ONE report, grouped by category (not by expert) so overlapping concerns from different experts naturally merge instead of repeating. Attribute each point to the expert(s) who raised it.



5\. Present the combined report before writing any implementation code. If the report contains a genuine architectural conflict or a roadmap-scope issue (from `product-manager` or `woodflow-architect`), treat that as blocking — resolve it with the user before proceeding, don't implement around it.



\---



\## Combined report format



```

\## Expert Review — <one-line description of what's being reviewed>



\### Architectural conflicts

\- \[expert(s)] <conflict, and which ADR/invariant/pattern it contradicts>



\### Issues

\- \[expert(s)] <concrete problem>



\### Recommendations

\- \[expert(s)] <suggested change>



\### Warnings

\- \[expert(s)] <non-blocking, worth knowing>



\### Long-term risks

\- \[expert(s)] <cost that shows up later>



\### Experts consulted

<list of which registry rows ran, and which were skipped as inapplicable, with one clause each explaining why skipped>

```



Omit a category entirely if nothing was raised for it — an empty "Architectural conflicts" section is worth keeping as an explicit "none found," but a report with all five categories forced to non-empty by padding is worse than one that's honestly shorter.



\---



\## What this pipeline is not



Not a substitute for the user's own sign-off — a clean expert review is input to a decision, not the decision itself. Not a code-generation tool — experts review a \*plan\*, they don't write the implementation. Not mandatory ceremony for trivial changes — see "When to run this" above.

