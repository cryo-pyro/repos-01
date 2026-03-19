Just add this block inside whichever `ag-col` column fits, inside the `<div class="ag-items">`:

```html
<a class="ag-item" href="/assets/html/newfile.html">
  <span class="ag-icon">📄</span>
  <span class="ag-item-text">
    <span class="ag-item-name">Newfile</span>
    <span class="ag-item-hint">short description</span>
  </span>
</a>
```

Pick the column by what the file *does*:
- **θ** → identity/who you are
- **L(θ)** → the problem/loss
- **∇L** → twins/direction
- **−η∇L** → interventions/tools/games
- **θ′** → outputs/connect/update

Swap the icon, name, and hint to match. That's it.

---

Got it. That's the update rule — drop that block into the right `ag-col`'s `<div class="ag-items">`, swap the three values:

- `href` → actual path
- `ag-item-name` → display name
- `ag-item-hint` → one-liner description
- emoji → something fitting

So for your 20 orphans, ready to go whenever you give me the signal. Should I generate the full batch of `ag-item` blocks for all of them now, or do you want to feed me files one at a time?

---

Cross-referencing your tree against every `href` in the index:

**Not linked anywhere in index.html:**

| File | Likely pentad home |
|---|---|
| `dt-002.html` | ∇L |
| `dt-003.html` | ∇L |
| `dt-20260310.html` | ∇L |
| `dt-20260310-v1.html` | ∇L |
| `dt-20260310-v2.html` | ∇L |
| `dt-a-001.html` | ∇L |
| `dt-c-001.html` | ∇L |
| `dt-e-001.html` | ∇L |
| `dt-e-003.html` | ∇L |
| `dt-m-001.html` | ∇L |
| `dt-o-001.html` | ∇L |
| `dt-p-001.html` | ∇L |
| `dt-r-001.html` | ∇L |
| `dt-s-001.html` | ∇L |
| `dt-t-001.html` | ∇L |
| `game-x.html` | −η∇L |
| `index-g.html` | θ |
| `metrics-section.html` | L(θ) |
| `services-section.html` | −η∇L |
| `ukhona-orig.html` | ∇L |

**Partials — probably skip** (header/footer fragments, not standalone pages): `footer-00`, `footer-01`, `footer.html`, `header-00`, `header-01`, `header.html`, `hero.html`

The `dt-*` typed twins are the bulk of it — 15 orphaned files, all natural ∇L column material. Do you want me to wire all 20 non-partials into the app-grid now?

---

Let me scan what you have vs. what's linked.Good. Now I have the full picture. From your tree scan, the files in `assets/html` are 51 total. Let me diff what's linked vs. what exists:

**Already linked** (26 pages + placeholders):
`mission`, `team`, `card`, `philosophy`, `models`, `nhanes`, `probe`, `riddle-00/01`, `dt-001`, `gov`, `cartography-256`, `stratigraphic-civilization`*, `ukhona`, `game`, `pitch`, `ukb-i-000/003`, `pairs-jh`, `contact`, `chorus`, `logo`, `hr`*, `steward-dashboard`*, `steward-transcript`*, `dt-h-001`

*These are linked in the app-grid or twin cards but **don't appear in your tree** — they may 404.

**In your tree but NOT linked** (the orphans):

| File | Natural pentad home |
|---|---|
| `dt-002.html`, `dt-003.html` | ∇L — more twin variants |
| `dt-20260310.html`, `dt-20260310-v1.html`, `dt-20260310-v2.html` | ∇L — dated twins |
| `dt-a-001`, `dt-c-001`, `dt-e-001`, `dt-e-003`, `dt-m-001`, `dt-o-001`, `dt-p-001`, `dt-r-001`, `dt-s-001`, `dt-t-001` | ∇L — typed twins (organ/system specific?) |
| `footer-00`, `footer-01`, `footer.html` | partials, skip |
| `header-00`, `header-01`, `header.html` | partials, skip |
| `hero.html` | partial, skip |
| `game-x.html` | −η∇L — game variant |
| `index-g.html` | θ — alternate landing? |
| `metrics-section.html` | L(θ) — loss metrics |
| `services-section.html` | −η∇L — services |
| `ukhona-orig.html` | ∇L — framework original |
| `ukb-i-003.html` | already linked |

The `dt-X-001` pattern suggests **typed digital twins** — `dt-a` = analytics? `dt-c` = cardiac/clinical? `dt-e` = epidemiology? `dt-h` = health (already linked), `dt-m` = metabolic? `dt-o` = organ? `dt-p` = population? `dt-r` = renal/risk? `dt-s` = surgical/social? `dt-t` = transplant?

**My recommendation:** expand the ∇L column with a scrollable "twin library" sub-list, and add `game-x`, `metrics-section`, `services-section` to their natural columns. Here's the updated app-grid `<div class="ag-pentad">` block with all orphans wired in — want me to produce the full updated `index.html` with these additions, or just the diff patch for the app-grid section?