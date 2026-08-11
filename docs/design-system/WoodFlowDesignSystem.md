# WoodFlow Design System

Status: **proposed, not yet applied to any screen.** This document is
the deliverable of a full audit + design pass requested explicitly
*before* touching UI code — see the "Audit findings" section for the
evidence behind every rule below. Nothing in `lib/` has been changed
to produce this document.

## Why this document exists

`WarehouseListScreen`'s own header comment already says it plainly:
*"Deliberately plain Material widgets — no WoodFlow Design Tokens
applied here yet... Restyle once Design Tokens exist."* Every screen
built since then inherited that same "prove it works, don't polish it
yet" posture. That was the right call for shipping 15 roadmap steps
fast — it stops being the right call once the backlog of small
inconsistencies is large enough that the app reads as "assembled,"
not designed. This document is that restyle, planned once instead of
redone per-screen.

---

## Audit findings

Evidence gathered from `lib/presentation/` (grep, not impression),
read through four lenses: `design-system-expert` (visual consistency),
`mobile-ux-expert` (real warehouse-floor usability), `product-manager`
(is this worth doing, and how much of it), `wood-industry-expert`
(does the app's information hierarchy match how a wood/furniture
operator actually thinks about the job).

### Spacing — no scale, ad hoc values
`EdgeInsets` values in current use: `4, 10, 12, 16, 24`, mixed freely
within the same screens with no defined meaning per value. Nothing is
"wrong" per screen, but nothing is *predictable* either — a developer
adding a sixth screen has no rule to follow, only five inconsistent
examples to copy from.

### Typography — theme bypassed
32 inline `TextStyle(...)` literals across `presentation/`, each
picking its own `fontSize`/`fontWeight` combination, instead of
`Theme.of(context).textTheme.*` roles. Material 3's type scale already
exists (the app calls `useMaterial3: true` in `main.dart`) — it's
simply not being used consistently.

### Color — real seed, bypassed by hardcoded values
`main.dart` already sets `colorSchemeSeed: Color(0xFF1F4D3D)`
(Forest Green) — a real, intentional brand color already generating a
full Material 3 tonal palette. Despite that, 24 call sites use raw
`Colors.red`/`Colors.orange`/`Colors.green`/`Colors.grey` directly
instead of the generated `colorScheme.error`/tertiary/etc. roles. This
means **dark mode and any future theme change won't propagate** to
those 24 spots — a real, not cosmetic, defect waiting to happen.

### Corner radius — three unrelated values
`4, 12, 14` in current use (`BorderRadius.circular(...)`), no visible
rule for which shape gets which value.

### FAB behaviour — genuinely inconsistent
`WarehouseListScreen` and `ShoppingListScreen` use a plain icon-only
`FloatingActionButton`. `RackListScreen`, `SlotGridScreen`, and
`SlotDetailScreen` use `FloatingActionButton.extended` (icon + label).
Same control, same general purpose ("add the next thing"), two
different shapes depending on which screen you're on — a `mobile-ux-expert`
finding specifically: a warehouse worker moving between these screens
gets a different-shaped button for the same action for no functional
reason.

### Button hierarchy — no defined rule
`ElevatedButton`, `FilledButton`, `OutlinedButton`, and `TextButton`
are all in active use, sometimes for what reads as the same semantic
role (a primary confirm action) in different dialogs. No file defines
which widget means "this is the primary action here."

### Create-flow pattern — split between two UI shapes
Adding a Warehouse uses a bottom sheet. Adding a Slot uses an
`AlertDialog`. Both are multi-field forms with the same shape of
problem (name + one numeric field); there's no reason for them to be
two different UI patterns.

### Navigation density — `mobile-ux-expert` flag
`WarehouseListScreen`'s `AppBar` carries **seven** action icons (QA
switcher aside) — Shopping List, Calculators, Export, Owner Dashboard,
Scan, Ask AI, plus the overflow of whatever ships next. That's a real
one-handed-reach and discoverability question, not just a visual one:
on a real device, seven equally-weighted icons in one row asks a
worker to find the right one by memory every time, every shift. This
document doesn't resolve it (see "Open question" below) — it flags it
as exactly the kind of finding this audit exists to surface.

### Empty / loading / error states — mostly fine, worth codifying
Loading (`CircularProgressIndicator`, centered) and error (message +
retry button) states are already reasonably consistent across
screens — low risk, just needs writing down so it stays that way.
Empty states repeat the same three-line pattern (icon-less centered
text) on every list screen with no shared widget — a
`design-system-expert` finding: not broken, but a missed chance to
add a CTA button ("Add your first warehouse") where one would help,
which today would require editing N screens instead of one widget.

### Wood-industry / warehouse-operator lens
The entity-icon hierarchy fixed earlier this session (Warehouse → Rack
→ Slot → Board → Offcut reading as a visual "zoom in") is the right
foundation and this document builds on it rather than changing it. The
one gap from that lens: `SlotGridScreen`'s occupancy chips communicate
fill level by color (green/orange/red) but nothing else — color alone
is not accessible (see Accessibility below), and a color-blind
operator or one glancing quickly in bad lighting has no fallback
signal today.

---

## 1. Spacing scale

4dp base grid (Material 3 default), each value given one defined role
— not new numbers, the existing ones with a rule attached:

| Token | Value | Role |
|---|---|---|
| `xs` | 4dp | icon-to-text gap, tight inline spacing |
| `sm` | 8dp | gap between closely related elements (chip internal padding) |
| `md` | 12dp | list-tile internal padding, gap between form fields |
| `lg` | 16dp | screen edge padding, standard section padding — the default |
| `xl` | 24dp | gap between distinct sections on the same screen, empty-state padding |
| `xxl` | 32dp | rare — only for deliberately generous empty/onboarding-style screens |

Rule: pick from this table, never a bare number. If nothing fits,
that's a signal to add a token, not to write `EdgeInsets.all(19)`.

## 2. Typography scale

Use `Theme.of(context).textTheme.*` — stop writing inline `TextStyle`.
Mapping from current ad hoc usage to Material 3 roles:

| Current usage | Role |
|---|---|
| Screen/dialog titles | `titleLarge` |
| List-tile primary text (entity name, decor code) | `titleMedium` / `bodyLarge` |
| List-tile subtitle (dimensions, breadcrumb) | `bodyMedium` |
| Section headers ("PŁYTY", "ŚCINKI") | `labelMedium`, letter-spacing left as-is |
| Counts, timestamps, captions | `labelSmall` |

Color for these roles comes from the theme too (`onSurface`/
`onSurfaceVariant`), not hardcoded `Colors.grey`.

## 3. Color palette

The seed color is already right — `0xFF1F4D3D` (Forest Green) in
`main.dart`. The fix is usage, not the palette itself:

| Semantic role | Use instead of | Material 3 source |
|---|---|---|
| Destructive / error (delete confirmations, validation errors) | `Colors.red` | `colorScheme.error` |
| Warning (low stock, stale materials) | `Colors.orange` | `colorScheme.tertiary` |
| Success / good fill level | `Colors.green` | `colorScheme.primary` |
| Secondary/muted text | `Colors.grey` | `colorScheme.onSurfaceVariant` |

This is the one rule in this document with a real, non-cosmetic payoff:
without it, dark mode and any future rebrand silently don't apply to
24 existing call sites.

## 4. Elevation rules

Material 3 defaults, not custom overrides — the current code mostly
already does this by not touching elevation explicitly, which is
correct. Written down so it stays that way: cards = 1dp (default
`Card()`), dialogs/bottom sheets = 3dp (default), FAB = 3dp (default),
app bar = 0dp flat (Material 3 default, already in effect).

## 5. Corner radius

| Token | Value | Use |
|---|---|---|
| `small` | 8dp | chips, small inline controls |
| `medium` | 12dp | cards, dialogs, list-item containers (matches the majority of current usage) |
| `large` | 16dp, top corners only | bottom sheets |

Resolves the current `4/12/14` scatter into three defined values.

## 6. Icon rules

Builds on the entity-icon audit already committed this session (`docs/EXPERT_SYSTEM_AUDIT.md` predecessor work) — not repeated here, just sized:

| Context | Size |
|---|---|
| Standard list-tile leading icon | 24dp (Flutter default — don't override) |
| Dense/nested list icon (offcut rows inside a slot) | 20dp |
| Large display icon (QR code display) | 96dp |
| Inline action-button icon | 18–20dp |

Style: outlined family, one concept → one icon, never reused across
two entity types — both rules already established and enforced this
session, carried forward here as the canonical reference.

## 7. Card styles

Two distinct, intentional patterns — not one accidental one:

- **List card** — standard `Card` (elevation 1, radius `medium`), used for entity list rows presented as a vertical list (Warehouse/Rack lists).
- **Grid chip** — bordered container (no elevation, radius `medium`), used specifically for dense grid layouts (`SlotGridScreen`'s occupancy chips). The border-not-elevation choice stays — it reads as "compact status tile," which is the right register for a grid of many small items — but the fill-ratio color (see Accessibility) needs a second signal, not a restyle of the shape.

## 8. Dialog styles

- **Confirmation dialogs** (delete, destructive actions) — already consistent, keep exactly as-is: `AlertDialog`, title = question, content = consequence, actions = `TextButton` (Cancel) + red-styled `TextButton` (destructive verb, never generic "OK").
- **Create/edit forms** — standardize on the **bottom sheet** pattern (`WarehouseListScreen`'s add-warehouse sheet), not `AlertDialog`. Reasoning (`mobile-ux-expert`): a bottom sheet gives a form more vertical room for the keyboard, scales better past 2 fields, and is the more thumb-reachable pattern on a phone. `SlotGridScreen`'s add-slot dialog moves to this pattern during implementation.

## 9. List styles

`ListTile`-based, standard density for top-level entity lists
(Warehouse/Rack), `dense: true` for nested sub-lists (Boards/Offcuts
inside a Slot) — matches current practice, written down as the rule
rather than left implicit.

## 10. Navigation rules

- Back navigation: automatic (`AppBar`'s default back button) — no change.
- Primary actions live in `AppBar.actions`, ordered by frequency of real-world use, most-frequent closest to the leading edge.
- **Open question, not resolved by this document:** `WarehouseListScreen`'s 7-icon `AppBar` is a genuine information-architecture question (which actions are frequent enough to stay one-tap-visible vs. which move to an overflow menu), not a visual-token question. Flagged for a separate decision before Phase 2 touches that screen — see "Open questions" at the end.

## 11. Button hierarchy

| Role | Widget |
|---|---|
| Primary action (the one thing this screen/dialog wants you to do) | `FilledButton` |
| Secondary alternative action | `OutlinedButton` |
| Tertiary / cancel / dismiss | `TextButton` |
| Destructive | `TextButton`, red-styled (matches existing delete-confirmation precedent — stays a text button, not a filled red button, so it doesn't visually shout louder than the primary action) |

`ElevatedButton` is retired from the palette — every current use maps
cleanly onto one of the four rows above.

## 12. Empty states

New shared widget, `EmptyStateView` (icon + title + description +
optional CTA button, centered, `xl` padding) — replaces the
independently-written empty-state `Text` blocks on every list screen.
One widget, N call sites, each supplying its own icon/copy/optional
action.

## 13. Loading states

Centered `CircularProgressIndicator()`, no size/color override — already
consistent, codified as the rule rather than changed.

## 14. Error states

Icon (new — currently text-only) + `l10n.errorPrefix(message)` +
retry button, centered — same shape as `EmptyStateView` so the two
states are visually related (an error is not just "an empty list with
different words," it should look like a different, warning-toned
state) but distinguishable via icon and color (`colorScheme.error`
tinting, per the color-palette rule above).

## 15. Component catalogue

| Component | Status | Where used today | Action for Phase 2 |
|---|---|---|---|
| `EmptyStateView` | New | — | Extract; replace ad hoc empty-state `Text` blocks on every list screen |
| Confirmation dialog | Already correct | Warehouse/Slot delete | No change — reference pattern |
| Create-form bottom sheet | Already correct (Warehouse) | Warehouse add | Extend to Slot's add flow |
| Entity list tile | Already correct pattern | Warehouse/Rack lists | Apply spacing/typography tokens |
| Entity grid chip | Already correct pattern | Slot grid | Add non-color fill-level signal (see Accessibility) |
| Section header label | Already correct pattern | Board/Offcut lists inside Slot | Apply typography token (`labelMedium`) |
| Primary/secondary/tertiary buttons | Needs standardization | Everywhere | Migrate `ElevatedButton` → `FilledButton`/`OutlinedButton` per role |

---

## Accessibility

- Color is never the only signal. `SlotGridScreen`'s fill-level chips need a second cue (a numeric ratio is already shown as text — verify it's always present, not just on non-empty/non-full states) alongside the green/orange/red tint, so the state reads correctly without color.
- Tap targets stay at Flutter's Material default minimum (48×48dp) — no shrinking icon buttons below default size for density; this was already flagged by `mobile-ux-expert` in `mobile-ux-expert/SKILL.md` itself ("gloved hands, imprecise taps").
- Text scaling: none of the 32 inline `TextStyle` literals set a fixed, non-scaling size that would break with the system font-size setting — moving to `textTheme` roles fixes this automatically, since Material's type scale already respects text-scale settings.

## One-handed operation

Primary per-row actions (delete, the FAB) stay reachable in the lower
two-thirds of the screen — already true today (list rows, bottom FAB)
and preserved, not changed, by this document. The one identified gap
is the AppBar's icon count (see Navigation rules) — that's a reach
problem at the *top* of the screen, the harder one-handed zone, which
is exactly why it's flagged as needing a separate decision rather than
folded into a token rule.

## Warehouse operator workflow

The existing entity hierarchy (Warehouse → Rack → Slot → Board/Offcut)
and its icon "zoom in" already matches how an operator actually thinks
about finding material (which building, which aisle, which shelf,
which board) — this document doesn't change that structure, only the
visual consistency of how it's presented. No workflow-order changes
are proposed here.

---

## Open questions for the Project Owner

1. **AppBar icon count.** Should `WarehouseListScreen`'s 7 action icons all stay directly visible, or should some (candidates: Export, Calculators — lower-frequency than Scan/AI/Shopping List) move to an overflow menu? This is an information-architecture decision, not a token decision — needs a call before Phase 2 touches that screen.
2. **Scope of Phase 2.** This document proposes token *values* and *rules*. Applying them means touching every screen in `presentation/` (per your instruction: not one at a time, the whole app at once). Confirm that's still the intended scope before it starts — it's a `Large` (days), not `Medium` (hours), body of work given the number of screens involved.

## Next step

This document is the deliverable of the "design before implementing"
phase you asked for. No screens have been touched. Once approved (and
the two open questions above resolved), Phase 2 applies these rules
across every screen in one consistent pass.
