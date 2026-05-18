---
title: "Rendering Workflow: From SketchUp Spec to Photorealistic Image"
subtitle: "Backyard Fence Line Landscape Plan"
date: "May 2026"
---

# Rendering Workflow

Three workflows, ranked by output quality. Pick the one that matches your time budget and tool comfort.

| Path | Time | Quality | Tool cost |
|---|---|---|---|
| **A. D5 Render** (primary, from SketchUp) | 2–4 hrs | Photoreal | Free tier OK |
| **B. SketchUp + Enscape** (alternative) | 2–3 hrs | Photoreal, real-time | $39/mo |
| **C. Reimagine Home AI** (skip SketchUp) | 15–30 min | Stylized, less precise | $15/mo |

Read all three first. Most people end up doing **A** for the master rendering and **C** for fast variations.

---

## PATH A — SketchUp + D5 Render (recommended)

### Step 1 — Prepare the SketchUp file

After running `landscape_plan.rb`:

1. **Turn off the Annotations layer** (Window → Default Tray → Tags → uncheck `06_Annotations`). Dimensions don't belong in a rendering.
2. **Save the file** as `landscape_plan.skp`.
3. (Optional but recommended) **Replace the stylized plant blocks with proper SketchUp Components** — see Step 2.

### Step 2 — Swap stylized plants for realistic components

The Ruby script gives you correctly-positioned **placeholder geometry**. For a photoreal render you'll want real plant models in those exact positions.

**Source of components:**
- **3D Warehouse** (built into SketchUp: Window → 3D Warehouse). Search:
  - `"Karl Foerster"` or `"feather reed grass"` — pick a model under 2MB
  - `"echinacea purpurea"` or `"coneflower"` (or `"rudbeckia goldsturm"`)
- **D5 Asset Library** (inside D5, after install) — has dozens of grasses and perennials, higher quality than 3DW, free with the app

**Swap procedure (manual but fast):**

1. Download one good Karl Foerster component into your model.
2. Right-click one of the existing stylized grass groups → **Replace Selected**... or just:
   - Select all groups named "Karl Foerster Grass" using Edit → Select All with same Name (or use Outliner)
   - Delete them
   - Use the **Make Component** + **Copy Array** approach: place the realistic component at each X,Y coordinate from the spec
3. Easier: skip this step. D5 has an in-app **"Scatter"** and **"Replace"** tool that swaps geometry at render time — see Step 4.

> **Pragmatic shortcut:** The stylized markers from the Ruby script are at the exact correct positions. You can render them as-is in D5 and use D5's **Object Replace** feature to swap them for D5 library plants without editing the .skp file.

### Step 3 — Install D5 Render

- Download from [d5render.com](https://www.d5render.com/) (Windows only — Mac users see Path B)
- Install the **D5 Converter for SketchUp** plugin during setup
- D5 has a free tier — fine for a few interior/exterior shots

### Step 4 — Send model from SketchUp to D5

1. In SketchUp: **Extensions → D5 Converter → Sync to D5**
2. D5 opens with your geometry already imported and materials roughly mapped.

### Step 5 — Apply materials in D5

- **Lawn:** D5 Library → Vegetation → Lawn Grass (any "Bermuda" or "Fescue" preset)
- **Mulch:** D5 Library → Ground → Bark Mulch / Hardwood Mulch
- **Fence:** D5 Library → Wood → Weathered Cedar or Aged Pine
- **Plants:** Select each stylized group → right-click → **Replace with Asset** → pick the realistic library version

### Step 6 — Scatter additional plants (optional realism)

If the bed looks sparse, use **D5 Scatter** to add filler:
- Low groundcover (creeping thyme, low sedum) between the spec'd plants
- Mulch texture variation

Don't overdo it — your spec is intentionally clean and linear.

### Step 7 — Set up the camera

Reproduce the angle of your reference photo (Image 1 — the dome view):

- **Camera height:** 5'6" (eye level, standing on the lawn)
- **Camera position:** Stand on the lawn ~15 ft back from the bed, slightly to the left so you see the step
- **Focal length:** 35mm equivalent (D5 default is usually 50mm — change to 35 for the wider yard feel)
- Save as **Camera 1: Hero Shot**

Add 2–3 more cameras:
- **Camera 2: Top-down plan view** (orthographic, looking straight down)
- **Camera 3: Walking the bed** (3 ft off the fence, eye level, looking down the row)
- **Camera 4: Year 3 mature** (same as Camera 1 but with plants scaled 110%)

### Step 8 — Lighting

Use D5's **Sun & Sky**:
- **Time of day:** 4:30 PM (warm side-light, long shadows — most flattering for grasses)
- **Date:** July 15 (peak bloom for both Echinacea and Goldsturm)
- **Cloud cover:** 20–30% (avoid blown-out skies)
- **Sun direction:** Approximate your real yard orientation. If the fence runs east-west, sun should come from south. Eyeball it.

### Step 9 — Render settings

For a final image (not a draft):
- **Resolution:** 3840×2160 (4K) for hero, 1920×1080 for variations
- **Quality:** "High" or "Ultra"
- **Render time per frame:** 30 sec to 2 min on a decent GPU

### Step 10 — Export

- PNG for sharing
- Optionally render a **before/after pair** by hiding the bed/plants for the "before"

---

## PATH B — SketchUp + Enscape (Mac alternative)

D5 is Windows-only. If you're on Mac, use **Enscape** (now SketchUp-native, $39/mo).

Differences from D5:
- Real-time render preview (no render-button wait)
- Smaller built-in asset library — supplement with [Quixel Bridge](https://quixel.com/bridge) free assets
- Mac native, works fine on Apple Silicon
- Steps 1–4 are the same; replace D5 steps 5–10 with Enscape's equivalent menus

Workflow:
1. Run the Ruby script in SketchUp
2. Open Enscape (Extensions → Enscape → Start Enscape)
3. Real-time view opens; navigate to your hero angle
4. Right-click stylized plants → Replace from Enscape Library
5. Adjust sun position, time of day in Enscape's sky panel
6. Click "Capture Image"

---

## PATH C — Reimagine Home AI (skip SketchUp entirely)

If you want a fast preview before committing to SketchUp/D5, feed your **original yard photos** (the ones you uploaded) directly into an AI redesign tool.

### Tool: [reimaginehome.ai](https://www.reimaginehome.ai/)

1. Upload your hero photo (Image 1, the dome view).
2. Choose mode: **"Replace specific area"** or **"Garden / Backyard makeover"**.
3. Mask the strip of grass along the fence (the future bed area) using their brush tool.
4. Prompt:

> "A 30-inch deep planting bed along the wood fence. Back row: Karl Foerster feather reed grass, 4-foot tall upright ornamental grass with vertical green blades and tan plumes, spaced 32 inches apart, 6 inches off the fence. Front row: purple coneflowers (Echinacea purpurea) with pink-purple daisy blooms, 14 inches apart. Shredded hardwood mulch ground cover. Late summer, peak bloom, golden hour light, photorealistic."

5. Generate 4 variations. Pick the best.
6. Re-prompt with **the same image + tweaks** ("more density," "shorter flowers," "swap to yellow black-eyed Susans") to iterate.

### Pros vs. SketchUp path
- 15 minutes vs. 3 hours
- No software install
- Easy to test Coneflower vs. Goldsturm side by side

### Cons
- Plant counts and spacing are **suggestive, not precise** — the AI won't honor your exact 17/36 spec
- Fence step may get distorted
- Same view only; hard to get the top-down plan or a year-3 mature view
- Bed edge may not be straight

**Best use:** Show this to anyone who needs to *feel* what the finished bed will look like, while you use Path A for the precise install drawing.

---

## RECOMMENDED PIPELINE

Here's the order of operations if you want a complete deliverable package:

1. **Run the Ruby script in SketchUp** → exact installation diagram with verified spacing
2. **Export 2 SketchUp views** as PNG:
   - Top-down plan view (turn ON `06_Annotations` layer, switch to Parallel Projection + Top view)
   - 3D perspective from the dome angle
3. **Use Path C (Reimagine Home)** on your original photo for a "vibe" rendering — fast, photorealistic, shows neighbors what's coming
4. **Use Path A (D5 Render)** if you want the precise photoreal hero image with correct plant positions

The combo of (1) + (3) covers 90% of real use cases (planning + visualization). Add (4) only if you want gallery-quality output for a presentation or contractor review.

---

## SAVE FILES TO KEEP

| File | Purpose |
|---|---|
| `landscape_plan.rb` | Source of truth — re-run any time |
| `landscape_plan.skp` | Editable spec drawing |
| `landscape_plan_top.png` | Plan-view export (for contractor / printing) |
| `landscape_plan_3d.png` | Perspective export |
| `landscape_hero.png` | Final D5 or Reimagine render |
| `landscape_plan.pdf` | Written plan document |

---

## TROUBLESHOOTING

**Ruby script ran but I see nothing**
- Press **Shift+Z** (Zoom Extents)
- Check the Ruby Console for an error message
- Verify SketchUp version is 2017 or later

**Plants are floating above the ground**
- The script places plants at Z=0. If your ground plane is at a different Z, select all groups and use Move to drop them.

**D5 Converter doesn't appear in Extensions menu**
- Reinstall D5 with SketchUp closed first
- Manual install: copy the .rbz from D5's install folder to `~/Library/Application Support/SketchUp [version]/SketchUp/Plugins/`

**Reimagine Home keeps changing the fence**
- Mask MORE tightly around just the grass strip
- Add to prompt: "Keep existing wood fence exactly as in source image, only modify the strip of grass in front of the fence."

**AI render shows wrong plant counts**
- This is expected — AI tools don't count. Use it for vibe, use the Ruby script + SketchUp for spec.

---

## FINAL NOTE

The most common mistake at this stage is **over-investing in the rendering**. Your contractor (or you) installs from the **plan document + the top-down SketchUp view**, not from the pretty render. The render exists to convince yourself and your spouse/neighbor/HOA that the design works. Make it good enough to communicate the idea, then go buy plants.
