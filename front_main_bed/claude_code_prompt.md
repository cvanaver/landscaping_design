# Claude Code Prompt — Front Main Bed Design Package

Paste everything below this line into Claude Code.

---

You are helping me build a complete design + implementation package for a front yard landscape bed redesign at **1013 Colfax St, Evanston, IL** (USDA Zone 5b–6a, North Shore Chicago).

The deliverables go in a new subfolder **`front_main_bed/`** in my existing GitHub repo. **Do not initialize a new repo.** Add the subfolder and its contents to the working tree.

## What I want you to produce

A complete package consisting of:

1. **`landscape_plan.rb`** — A SketchUp Ruby script that builds a scaled 3D model of the bed when loaded via the Ruby Console. Modeled on the structure of `west_fence_landscaping/landscape_plan.rb` in my prior work (organized into a module, layered geometry, named groups, dimension annotations, auto-runs on load, idempotent enough to re-run without dirtying the model).
2. **`landscape_design_plan.md`** — The master design document. Includes site summary, design concept, plant selection with rationale, spacing math, soil strategy, install sequence, year-1 care, gotchas. Modeled on `west_fence_landscaping/landscape_design_plan.md`.
3. **`buy_list_and_sourcing.md`** — Detailed buy list with where to source each item (local nurseries with addresses, online bulb vendors with order timing), rough budget bands, what to look for at the nursery, and red flags.
4. **`install_plan.md`** — Three install options (full DIY, hybrid DIY + hire boxwood, hire Chalet) with cost estimates, time estimates, and decision criteria. Independent doc because the install choice gates sourcing.
5. **`chalet_warranty_conversation.md`** — A prep doc for the conversation with Chalet about the 2020 install warranty (6 of 8 Bobo Hydrangeas dead, plus other losses). Includes facts to bring, the ask, fallback positions, and a polite-but-firm script.
6. **`rendering_workflow.md`** — How to take the SketchUp output and produce realistic visualizations. Modeled on `west_fence_landscaping/rendering_workflow.md` (Paths A/B/C: D5 Render, Enscape, Reimagine Home AI). Adapt for this bed's geometry and the part-shade north-facing aesthetic.
7. **`contractor_handoff.md`** — A one-page summary a contractor or helper could install from without reading anything else. Plant counts, spacing, locations, install order. Print-friendly.
8. **`README.md`** — Top-level navigation in the folder, explaining what each doc is for and the recommended reading order.
9. **`open_decisions.md`** — Track of decisions still pending (Row 3 species pending pH test, etc.) with the criteria that will resolve them.

## Site information (locked, do not re-debate)

### Bed envelope
- Rectangular working assumption: **13 ft wide (east-west, along house) × 13 ft deep (north-south, into yard)**
- House wall is the **back/north** boundary
- Stone retaining wall is the **east** boundary (the wall has steps and is part of the front entry pavers; the bed terminates at the wall's lawn-facing face)
- Design boundary (porch, mature tree, surviving hydrangea — leave-alone zone) is the **west** boundary
- Lawn is the **front/south** boundary
- The actual bed has a more irregular curved front, but we work the rectangular envelope for planning. The Ruby script should model the rectangular envelope; add a comment in the script noting the real lawn edge is curved.

### Existing conditions
- **Yews** along the house wall, currently extending ~5–5.5 ft into the bed depth from the house wall. Healthy. Plan calls for **light shaping prune in March** to define a cleaner ~5 ft front face. Keep all yews; do not remove.
- **Max Frei geranium** (purple-pink low spreader): 2–3 surviving clusters concentrated at the **east end** near the stone wall. Keep, may divide.
- **Millennium alliums** (purple drumstick, July–August bloom): some of original 4 survived, exact count TBD. Tidy grassy foliage. Keep what's there.
- **Existing daffodils**: substantial mass at east end (in dieback phase mid-spring). Keep, do not relocate.
- The rest of the bed (middle and parts of east): degraded since 2020 Chalet install. 6 of 8 Bobo Hydrangeas died. Coneflowers, calamintha, anemone all gone. Mulch degraded to leaf litter.

### Light / soil
- **North-facing.** Part shade overall. West end shadier (tree canopy). East end gets more sun (open to south near stone wall).
- **Soil suspected alkaline.** pH test pending (Luster Leaf Rapitest 1601 ordered). Take 3–4 samples across bed length (west, middle, east, near foundation) once the kit arrives.
- **Soil is workable clay**, no rock layer noted at this site (unlike my west fence project).

## Locked design decisions

### Row 1 (back, against house) — KEEP
- Existing yews
- Light shaping prune in March before install
- After pruning: ~5 ft deep front face

### Row 2 — Boxwood
- **10 × Boxwood 'Green Velvet'** at **15" on-center**, in front of the yews
- Centers ~18" off the new yew front face (after pruning)
- 'Green Velvet' is winter-hardy in Zone 5b, holds color through cold without bronzing as badly as 'Green Mountain'
- Buy #2 or #3 (2- or 3-gallon) for a faster-filling hedge; #1 acceptable for budget

### Row 3 — Tall flowers + bulbs (SPECIES PENDING pH)
- **7 tall flowers at ~22" o.c.** along the bed length
- Center spacing ~36" off the yew front face
- **SPECIES TBD.** Three candidates pending pH result:
  - Astilbe alone (if pH < 6.8)
  - Japanese anemone alone (pH-tolerant, late-summer bloom)
  - Drifted: 4 astilbe west + 3 anemone east (zoned by sun gradient)
- Ruby script: use **placeholder generic perennial geometry** for these 7 positions. Add comment in script and prominent note in design doc that these slots resolve when pH test comes back. Document the swap path in `open_decisions.md`.
- **Bulbs drifted through Row 3**, not in Row 4:
  - 10 × Daffodil 'Ice Follies' (early-mid April, white + pale yellow)
  - 10 × Daffodil 'Thalia' (mid-late April, white triandrus)
  - 10 × Daffodil 'Hawera' (late April-May, miniature yellow)
  - 10 × Tulip 'Pink Impression' (Darwin Hybrid, mid-late April, rose pink)
  - Drifted in irregular clusters of 3–7 bulbs each, not single line
  - Plant late October to mid-November

### Row 4a — Heuchera ribbon
- **9 × Heuchera 'Plum Royale'** at **14" o.c.** along the **western 10 ft** of the front
- Centers ~12" off the front lawn edge
- Burgundy foliage, harmonizes with Max Frei geranium pink at east end
- Reasoning: persistent attractive foliage = the bed's visual "clean baseline" that screens Row 3's seasonal mess (especially bulb dieback)

### Row 4b — East end existing mass (keep)
- Easternmost **~3 ft** of Row 4 = existing Max Frei geranium + surviving alliums + daffodils
- Do NOT plant heuchera in this zone
- Self-contained layered mass: bulbs in spring, allium July-Aug, geranium throughout summer

## Open decisions to track in `open_decisions.md`

1. **Row 3 species** — pending pH test result. Resolution criteria: pH > 7.0 → anemone only. pH 6.0–6.8 → drifted (4 astilbe west + 3 anemone east). pH < 6.0 → astilbe only.
2. **Install plan** — DIY / hybrid / hire Chalet. Depends on warranty conversation outcome and budget.
3. **Final boxwood pot size** — #1 (cheaper, slower fill) vs #2/#3 (more $, faster hedge).

## Failure history (the cautionary tale, use it in docs)

The 2020 Chalet install lost most of its showy perennials within 4 years:
- 8 Bobo Hydrangeas → 6 dead, 2 surviving
- 1 replacement Bobo across sidewalk → never thrived
- 6 coneflowers → all gone (sun-loving plant in a part-shade bed)
- 5 calamintha → all gone (same problem)
- 3 anemone → all gone (install / pH problem?)
- 1 black chokeberry → gone
- **Survived:** the yews, geraniums, alliums, 2 of 8 hydrangeas

Three likely root causes to call out in the design doc and in `chalet_warranty_conversation.md`:
1. **Plant palette was sun-bed plants in a part-shade bed** — coneflowers and calamintha need 6+ hrs sun
2. **Possible alkaline soil intolerance** for hydrangeas (foliage chlorosis is common in alkaline soil)
3. **Root-ball install issues** — plants that all die within 1–2 years often indicate planting too deep, J-rooted nursery stock, or watering failure during establishment

The redesign explicitly addresses all three: part-shade-tolerant plant selection, pH-test-gated species choices for Row 3, and a more careful per-plant install protocol.

## Budget target
$700–$950 for plants + soil amendments + mulch (excluding labor / contractor if hiring).

## File-specific requirements

### `landscape_plan.rb`
- Module-scoped (`module FrontMainBed` or similar)
- Constants block at top: bed dimensions, plant counts, spacing, plant geometry
- Layers: `01_Ground`, `02_House`, `03_StoneWall`, `04_Yews`, `05_Boxwood`, `06_TBD_Tall_Flowers`, `07_Heuchera`, `08_Existing_East_Mass`, `09_Bulbs_Drift`, `10_Annotations`
- Build helper methods for each plant type (stylized but recognizable)
- Auto-run on load (`FrontMainBed.build!` at file end)
- Wrap in `model.start_operation` / `commit_operation` for clean undo
- Include unit setting to architectural inches
- Print a build summary to the Ruby Console (plant counts, layer names)
- Place plant centers at the exact spacing math from this brief
- For Row 3 placeholder plants: visually distinguish them (e.g. dashed-outline circles or a question-mark glyph) so it's obvious they're TBD
- Include dimension annotations on the `10_Annotations` layer

### `landscape_design_plan.md`
- Match the structure of `west_fence_landscaping/landscape_design_plan.md` (which you have in context):
  - YAML frontmatter with title, subtitle, date
  - Site summary
  - Design concept (with ASCII or markdown diagram)
  - Plant selection by row, with locked-in choices and rationale
  - Spacing and counts table
  - Soil strategy (per-hole protocol, accounting for the lighter-than-west-fence-site conditions but still careful)
  - Install sequence (Day 0 prep through Day 2 mulch+water)
  - First-year care calendar
  - Year 2–3 outlook
  - Gotchas (call out the 2020 failure lessons specifically)
- Reference `open_decisions.md` for Row 3 instead of repeating the pH conversation here

### `buy_list_and_sourcing.md`
Local nurseries (Chicago North Shore):
- **Chalet Nursery** (3132 Lake Ave, Wilmette IL) — closest, where to *not* go for replacement plants while warranty conversation is open, but useful for boxwood
- **Pesche's Garden Center** (170 River Rd, Des Plaines IL)
- **Gethsemane Garden Center** (5739 N Clark St, Chicago)
- **The Growing Place** (Aurora / Naperville) — natives specialist
- Big-box (Home Depot, Lowes) — last resort for perennials, fine for boxwood

Online bulb vendors:
- Brent and Becky's Bulbs (brentandbeckysbulbs.com)
- Van Engelen (vanengelen.com) — wholesale minimums
- John Scheepers (johnscheepers.com)
- Order **by June** for fall delivery

For each plant: what to inspect at purchase, red flags. Budget table with low/mid/high columns.

### `install_plan.md`
Three options with:
- Scope of work
- Cost estimate range
- Time estimate
- Pros/cons
- Decision criteria
- Recommended sequence within each option

### `chalet_warranty_conversation.md`
- The facts (plant list, install date, mortality counts)
- The likely Chalet position ("plants are warranted 1 year, that period has passed")
- Your stronger position (a designed bed of mostly-failed plants suggests a design or install problem, not random plant deaths)
- The realistic ask (some credit toward this redesign, or replacement plants at cost, or design service comp)
- A short polite-but-firm script for the in-person or phone conversation
- Fallback positions if they decline
- When to walk away

### `rendering_workflow.md`
Three paths like the west fence doc, but adapted:
- Path A: SketchUp + D5 Render — primary, Windows
- Path B: SketchUp + Enscape — Mac alternative
- Path C: Reimagine Home AI — fast preview from actual photos
- Aesthetic notes specific to this bed: part-shade lighting (avoid harsh sun rendering), late spring / early summer scene to show bulb-to-perennial transition, camera angle from sidewalk approach (the view a visitor sees)
- Include a "Year 3 mature" camera that scales plants up 110%

### `contractor_handoff.md`
- One page if possible (two max)
- Top-down plan view reference (link to a PNG export from the SketchUp model)
- Plant counts and spacing
- Install order
- "Do not do this" list

### `README.md`
- Project summary in 3 sentences
- Reading order
- Status of each open decision (link to `open_decisions.md`)
- How to regenerate the SketchUp model from `landscape_plan.rb`

### `open_decisions.md`
- Each decision: what it is, what gates it, resolution criteria, current status
- Update this file in place when decisions resolve

## Style and tone

- Match the voice of the `west_fence_landscaping/` docs you have in context: practical, specific, opinionated where it matters, with tables and numbered lists where they aid scanning
- No fluff, no "in conclusion" sections
- Use code blocks for shell commands and Ruby code
- Use tables for plant counts, spacing, budgets, comparison
- Prefer markdown headings 1–3 deep; avoid heading 4+
- Use callouts (`> ⚠️` and `> 💡`) sparingly for warnings and tips

## Working sequence (please execute in this order)

1. Confirm you have the `west_fence_landscaping/` files visible for style reference. If not, note it and proceed using the structure described in this brief.
2. Create the `front_main_bed/` folder.
3. Build `landscape_plan.rb` first — the geometry is the source of truth for spacing decisions referenced in the docs.
4. Build `open_decisions.md` next — short, sets up the unresolved items the other docs will reference.
5. Build `landscape_design_plan.md`.
6. Build `buy_list_and_sourcing.md`.
7. Build `install_plan.md`.
8. Build `chalet_warranty_conversation.md`.
9. Build `rendering_workflow.md`.
10. Build `contractor_handoff.md`.
11. Build `README.md` last so it can accurately describe the other files.
12. Run `ls -la front_main_bed/` and show me the final tree.

After each file, briefly state what you built and any decisions you made that weren't fully specified in this brief.

Do not commit or push — leave the staging to me. Do not create branches. Just write the files into the working tree.
