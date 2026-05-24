---
title: "Open Decisions — Front Main Bed"
date: "May 2026"
---

# Open Decisions

Living list. Update in place as items resolve. Other docs reference back to this file rather than restating the criteria.

---

## 1. Row 3 species (7 tall flowers) — **PENDING pH TEST**

**What it is:** the 7 plants in Row 3 (centers 36" off yew front face, 22" o.c.) are unspecified until the soil pH test comes back.

**Gating:** Luster Leaf Rapitest 1601 kit (ordered). Sample 3–4 spots across the bed length (west, middle, east, near foundation) and average.

**Resolution criteria:**

| pH reading | Decision | Why |
|---|---|---|
| **> 7.0 (alkaline)** | All 7 → **Japanese anemone** (`Anemone × hybrida 'Honorine Jobert'` or `'Robustissima'`) | Astilbe sulks in alkaline soil. Anemone tolerates 6.5–8.0 and prefers part shade. |
| **6.0 – 6.8 (mildly acid → neutral)** | **Drifted: 4 astilbe west + 3 anemone east** | Sun gradient supports the split: west is shadier (astilbe loves shade + moist), east is brighter (anemone handles more sun). |
| **< 6.0 (acid)** | All 7 → **Astilbe** (`'Visions in Pink'` or `'Bridal Veil'`) | Astilbe thrives at low pH. Anemone tolerates but doesn't prefer it. |

**Swap path in the Ruby script:**
- Current state: `landscape_plan.rb` uses `build_tall_placeholder` for these 7 positions (gray disc + "?" glyph). Layer = `06_TBD_Tall_Flowers`.
- When pH is known: replace the helper call with `build_shrub(...)` using the appropriate height/radius/color per species (astilbe ~24"/8"/pink, anemone ~36"/10"/white-pink). Keep the same 7 X coordinates from the existing `tall_xs` array — spacing math doesn't change.

**Status:** ⏳ Awaiting kit delivery. Test in the next dry window after delivery (do not sample after heavy rain).

---

## 2. Install plan — **DIY vs. Hybrid vs. Hire Chalet**

**What it is:** who actually installs the bed. Three options spelled out in [install_plan.md](install_plan.md).

**Gating:**
1. Outcome of the Chalet warranty conversation ([chalet_warranty_conversation.md](chalet_warranty_conversation.md)). A credit or replacement offer changes the math significantly.
2. Budget reality check: $700–$950 plants-only target vs. ~$2,500–$4,000 if hiring out.
3. Time availability (full DIY = 1.5–2 weekends of physical work).

**Resolution criteria:**

| Scenario | Pick |
|---|---|
| Chalet offers meaningful credit/replacements toward redesign | **Hire Chalet** (use credit, leverage their plant warranty) |
| Chalet declines, you have weekend bandwidth | **Full DIY** |
| Chalet declines, you have budget but not time, or the boxwood hedge feels finicky | **Hybrid:** DIY everything except hire someone to plant the 10 boxwood in a clean straight line |

**Status:** ⏳ Awaiting warranty conversation.

---

## 3. Final boxwood pot size — **#1 vs. #2 vs. #3**

**What it is:** which size to buy for the 10 'Green Velvet'.

**Resolution criteria:**

| Size | Approx price each | Fill-in time | When to pick |
|---|---|---|---|
| **#1 (1-gal)** | $15–$25 | 3–4 years to read as hedge | Tight budget, patient |
| **#2 (2-gal)** | $30–$45 | 2 years to read as hedge | **Default recommendation** — best value/speed |
| **#3 (3-gal)** | $55–$80 | 1 year to read as hedge | You want instant hedge look (and have the budget) |

**Status:** Leaning #2 unless Chalet has #3s on sale or in good warranty-replacement stock.

---

## 4. (Open slot) — Items added later

Use this section as new decisions surface during install. Date each entry.
