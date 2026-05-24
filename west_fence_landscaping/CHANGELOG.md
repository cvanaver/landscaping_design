# Changelog

## May 2026 — Sandy ridge redesign

Major revision to the landscape plan based on corrected USDA soil data and a re-read of the site geometry. The original plan was written for the wrong soil profile and didn't account for the pear tree, the actual fence-bed orientation, or the spring flooding pattern.

If you're looking at the previous version of these files in Git history and wondering why everything changed, this is the reason.

### What changed

**Soil understanding (the big one)**
- v1 assumed clay-over-rock soil with poor drainage. **Actually:** USDA Soil Data Access API confirms Urban land–Psamments complex — 10" of loamy lawn topsoil over essentially pure sand (95%) down to 60"+. Excessively drained, old Lake Chicago beach ridge.
- pH 6.7–7.0 confirmed, no carbonates.
- Spring transient flooding pattern noted (sandy plateau, not a trough — floods briefly during snowmelt then drains within hours to a day).

**Site orientation correction**
- v1 was ambiguous about which side of the fence the bed sat on, and the sun analysis treated the bed as part-sun west-facing.
- **Corrected:** Fence runs N–S along the west property line. Bed is on the **east (yard) side** of the fence. Plants get morning sun + early-afternoon sun, with the fence shading the bed in mid-to-late afternoon. Net ~5–7 hrs direct sun, all on the gentle side of the day.

**Bed geometry redesign**
- v1 traced the fence — three separate bed sections following the stepped fence with inside corners at each jog.
- **v2:** Single bed with **one straight front edge** running the full 549" (46 ft), level with the easternmost face of the jut. North and south alcoves become ~63" deep; middle (jut) stays at ~30". No inside corners. One continuous front planting line.

**Pear tree integration**
- v1 didn't mention the pear tree. The "mature tree" reference was about a different tree at the back of the lot — which, on review, doesn't actually exist on this property.
- **v2:** Pear tree at the north jut inside corner, ~7 ft east of the north section fence, ~10 ft canopy spread. Treated as a feature, not an obstacle. The ~10 ft of front line under canopy gets a different plant.

**Plant palette adjustments**
- v1: 17 Karl Foerster grasses + 36 perennials (Echinacea OR Goldsturm — choose at nursery).
- **v2:**
  - **12 Karl Foerster grasses** (5 north alcove + 7 south alcove; none in jut, none under pear canopy edge)
  - **24 Echinacea purpurea** along the sunny portions of the front line (decision locked in — sandy soil tilts the Echinacea-vs-Goldsturm call clearly toward Echinacea)
  - **5 Geranium macrorrhizum** under the pear canopy (new plant; replaces what would have been struggling coneflowers there)
- Total plant count: 41 (was 53). Buy 47 with buffer.

**Installation protocol inversion**
- v1: rock-bar protocol, slow careful digging through rubble, "shift plant if you hit a rock," stockpile excavated rock.
- **v2:** Easy shovel dig through loam and sand. No rocks. Focus shifts from rock removal to compost-heavy backfill (50% native / 40% compost / 10% leaf mold/peat) and bed-wide broadforking in the pear zone.
- Hole depths increased (16" × 14" for grasses, 10" × 10" for front row) to encourage downward rooting on sand.
- **Crown placement changed:** ½" above grade instead of level with grade, to handle spring transient flooding.

**Mulch and amendment**
- v1: 2–3" mulch.
- **v2:** 3" minimum (sand needs the evaporation barrier and temperature buffer more than clay does). Annual mulch refresh ~1" expected.
- v1: "compost optional."
- **v2:** ~30 cu ft of compost is a required line item. Mushroom compost preferred. Cheap big-box "compost" explicitly rejected.

**Year-1 watering rewrite**
- v1: 2–3× weekly for 4 weeks, then taper.
- **v2:** 4 events in week 1, 3× weekly weeks 2–4, 2× weekly weeks 5–8, 1× weekly weeks 9–12, deeper each time. Pear zone gets one extra weekly watering all year 1. Soaker hose recommended. Screwdriver test for adequacy.

**Fertilizer logic changed**
- v1 didn't really address fertilizer beyond a passing mention.
- **v2:** Light slow-release organic starter at planting (none for geraniums). Light spring feed year 2. None thereafter unless growth is weak. Explicit warning against over-fertilizing sandy beds.

**Gotchas section rewritten** for sandy-ridge specifics: spring flooding adjustments, pear root competition, "wet snow exception" to the don't-cut-grass-in-fall rule, plastic edging heaving out of sandy soil.

### What stayed the same

- The two-layer concept (grasses behind, lower flowering plants in front)
- Karl Foerster as the structural grass
- Echinacea purpurea as the primary front-line flower
- Don't-till protocol (different reason now — surface organic layer protection, not rock avoidance)
- 3" mulch depth was *also* in v1, just emphasized more in v2
- Don't-cut-grass-in-fall rule (winter interest)
- General installation rhythm (prep day, layout, dig, plant, mulch)
- Rendering workflow (`rendering_workflow.md`) — unaffected by design changes
- The Flux Fill Pro rendering pipeline (`render_landscape.py`, `make_mask.py`, etc.) — still works the same way; just point it at a current photo and update the prompts in `render_landscape.py` to mention geraniums under the pear

### Files affected

| File | Status in this revision |
|---|---|
| `landscape_design_plan.md` | **Rewritten** |
| `landscape_plan.md` | **Rewritten** (condensed version) |
| `landscape_plan.rb` | **Rewritten** (new geometry, plant placement, pear tree) |
| `buy_list.md` | **New file** (didn't exist in v1) |
| `CHANGELOG.md` | **New file** (this file) |
| `rendering_workflow.md` | Unchanged — workflow is design-agnostic |
| `make_mask.py` | Unchanged |
| `render_landscape.py` | Unchanged code; prompts may want updating to reflect new plant palette (geraniums under pear, no Goldsturm option) |
| `CLAUDE.md` | Unchanged |
| `SETUP.md` | Unchanged |
| `requirements.txt` | Unchanged |

### If you want to see the old version

`git log` and `git show <commit>:west_fence_landscaping/landscape_design_plan.md` for the previous state. The old version of the install spec is preserved in Git history rather than as a separate file in the working tree.
