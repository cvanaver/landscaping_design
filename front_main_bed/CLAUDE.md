# CLAUDE.md — Front Main Bed (session handoff)

This file tells the next Claude session (on another machine) where this project stands so it can resume cleanly without re-deriving anything.

---

## Project

A complete design + implementation package for the **front main bed at 1013 Colfax St, Evanston IL** (USDA Zone 5b–6a). Lives in this `front_main_bed/` subfolder of the `landscaping_design` repo. Sister project: `west_fence_landscaping/` (already complete, use as style reference).

The full original brief is in `claude_code_prompt.md` in this directory — **read that file first** to understand the scope and locked-in design decisions.

## Status (as of 2026-05-23)

3 of 9 deliverables done. Remaining 6 to build, in this order, per the original brief's working sequence:

| # | File | Status |
|---|---|---|
| 1 | `landscape_plan.rb` | ✅ Done |
| 2 | `open_decisions.md` | ✅ Done |
| 3 | `landscape_design_plan.md` | ✅ Done |
| 4 | `buy_list_and_sourcing.md` | ⏳ TODO |
| 5 | `install_plan.md` | ⏳ TODO |
| 6 | `chalet_warranty_conversation.md` | ⏳ TODO |
| 7 | `rendering_workflow.md` | ⏳ TODO |
| 8 | `contractor_handoff.md` | ⏳ TODO |
| 9 | `README.md` | ⏳ TODO (build last so it can describe the others) |

## Locked-in numbers (the geometry / spacing source of truth)

These are all already in `landscape_plan.rb` constants. Don't re-derive — read from there.

- Bed envelope: **13' × 13'** (156" × 156"), rectangular working plan; real lawn edge is curved (cosmetic)
- Coordinates: X = east-west (0 west / 156 east at stone wall), Y = north-south (0 front lawn / 156 house wall)
- **Row 1** Yews (existing, keep): front face at y=96 after March prune (~5 ft deep)
- **Row 2** Boxwood 'Green Velvet': **10 plants** @ **15" o.c.**, centers at y=78 (18" off yew face)
- **Row 3** Tall flowers (**TBD pending pH**): **7 plants** @ **22" o.c.**, centers at y=60 (36" off yew face)
- **Row 3 drift** Bulbs: **40 total** = 10 each of Ice Follies, Thalia, Hawera, Pink Impression. Irregular clusters of 3–7, drifted through y=48..78 band, skipping easternmost ~3 ft
- **Row 4a** Heuchera 'Plum Royale': **9 plants** @ **14" o.c.**, centers at y=12 (12" off front edge), **western 10 ft only** (x=0..120)
- **Row 4b** East existing mass (keep): x=120..156, contains 2–3 Max Frei geranium clusters + Millennium alliums + daffodil mass

## Open decisions (gating items)

See `open_decisions.md`. Three open items:

1. **Row 3 species** — pending pH test (Luster Leaf Rapitest 1601 ordered). Resolution: pH>7.0 → all anemone; pH 6.0–6.8 → drifted 4 astilbe west + 3 anemone east; pH<6.0 → all astilbe.
2. **Install plan** — DIY / hybrid / hire Chalet. Gated on warranty conversation outcome.
3. **Boxwood pot size** — leaning #2 (2-gal) for 2-year hedge fill.

## Style / voice for the remaining docs

Match the **`west_fence_landscaping/`** docs (they're in the sibling directory; read them as the gold-standard reference):

- `west_fence_landscaping/landscape_design_plan.md` — voice/structure template for any markdown
- `west_fence_landscaping/rendering_workflow.md` — template for `rendering_workflow.md` (Paths A/B/C)
- YAML frontmatter, headings 1–3 deep only, tables for counts/spacing/budgets, code blocks for shell/Ruby, sparingly use `> 💡` and `> ⚠️` callouts
- No fluff, no "in conclusion", opinionated where it matters

## What to do next session

1. Read `claude_code_prompt.md` for the full brief.
2. Read `west_fence_landscaping/landscape_design_plan.md` and `west_fence_landscaping/rendering_workflow.md` for voice/structure.
3. Read the 3 completed files in this directory to stay consistent (`landscape_plan.rb`, `open_decisions.md`, `landscape_design_plan.md`).
4. Build the remaining 6 files in the order listed in the status table above.
5. After each file, briefly note what you built and any decisions made that weren't fully spec'd in the brief.
6. End with `ls -la front_main_bed/` and show the final tree.

## Reminders specific to the remaining files

- **`buy_list_and_sourcing.md`** — local nurseries (Chalet, Pesche's, Gethsemane, Growing Place), online bulb vendors (Brent & Becky's, Van Engelen, John Scheepers — order by **June** for fall delivery), per-plant inspection criteria, red flags, low/mid/high budget table.
- **`install_plan.md`** — three options (full DIY / hybrid DIY+hire boxwood / hire Chalet) with cost + time + decision criteria. This is independent because the install choice gates sourcing.
- **`chalet_warranty_conversation.md`** — facts (2020 install, 6/8 Bobo Hydrangeas dead, coneflowers/calamintha/anemone all gone, chokeberry gone), likely Chalet position (1-year warranty expired), stronger position (design failure not random plant death), realistic asks, polite-but-firm script.
- **`rendering_workflow.md`** — Paths A (D5 Render, Windows), B (Enscape, Mac), C (Reimagine Home AI). Adapt for part-shade north-facing aesthetic, late-spring scene (bulb→perennial transition), sidewalk-approach camera, year-3 mature camera at 110% plant scale.
- **`contractor_handoff.md`** — 1–2 pages max, print-friendly, plant counts + spacing + install order + "do not do this" list.
- **`README.md`** — 3-sentence project summary, reading order, status of open decisions (link to `open_decisions.md`), how to regenerate the SketchUp model from `landscape_plan.rb`.

## Important DO-NOTs (from the original brief)

- Do not initialize a new repo — this lives as a subfolder.
- Do not commit or push automatically — leave staging to the user. **(Exception: user has already requested a push at the pause point. Future sessions: revert to the default and let the user stage.)**
- Do not create branches.
- Match the rectangular envelope assumption — don't try to model the curved front edge.

## Files in this directory

- `claude_code_prompt.md` — original full brief (source of truth)
- `landscape_plan.rb` — SketchUp Ruby (built)
- `open_decisions.md` — gating decisions (built)
- `landscape_design_plan.md` — master design doc (built)
- `IMG_6661.HEIC` through `IMG_6677.HEIC` — site reference photos
- `CLAUDE.md` — this handoff file
