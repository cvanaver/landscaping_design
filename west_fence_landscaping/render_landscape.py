#!/usr/bin/env python3
"""
render_landscape.py — Generate photoreal landscape preview renders.

Uses fal.ai's FLUX.1 [pro] Fill (inpainting) model to render the planned
fence-line garden onto your actual yard photo.

USAGE:
  1. pip install fal-client pillow requests
  2. Get a fal.ai API key: https://fal.ai/dashboard/keys
  3. export FAL_KEY="your-key-here"
  4. Provide two files in this directory:
       - hero.jpg  (your yard photo)
       - mask.png  (white where bed goes, black everywhere else)
  5. python render_landscape.py
  6. Renders save to ./renders/

COST: ~$0.05 per megapixel.
  A 1500×1100 photo (~1.6MP) = $0.08 per render.
  Default config below renders 4 variations = ~$0.32 total.

MAKING THE MASK (one-time, 2-min job):
  Use make_mask.py in this directory (interactive painter).
  Alternative: Mac Preview, Photoshop, GIMP, Pixelmator — any image editor.
  The mask must be the SAME PIXEL DIMENSIONS as hero.jpg.

PROMPTS:
  The PROMPTS list below reflects the v2 design (geraniums under the pear,
  Echinacea everywhere else, no Goldsturm option). If the design changes,
  edit the PROMPTS list — that's where all the plant-language lives.
"""

import os
import sys
import base64
from pathlib import Path

try:
    import fal_client
    import requests
    from PIL import Image
except ImportError as e:
    print(f"Missing dependency: {e}")
    print("Run: pip install fal-client pillow requests")
    sys.exit(1)


# ----------------------------------------------------------------------------
# CONFIG — edit prompts here to taste
# ----------------------------------------------------------------------------

HERO_PATH = Path("hero.jpg")
MASK_PATH = Path("mask.png")
OUTPUT_DIR = Path("renders")
NUM_IMAGES_PER_PROMPT = 1   # set to 2-4 for more variations per prompt

# Base scene description — fence/tree preservation language is critical
PRESERVE_CLAUSE = (
    "Keep the existing wood privacy fence with lattice top, mature pear tree, "
    "lawn, climbing dome, and house exactly as in the source image. "
    "Only modify the masked strip of grass directly along the fence."
)

# Shared phrasing for the v2 plant palette
ECHINACEA_DESCRIPTION = (
    "front row of purple coneflowers (Echinacea purpurea), pink-purple "
    "daisy blooms on 30-inch stems, spaced 14 inches apart along a "
    "straight front bed edge"
)

KARL_FOERSTER_DESCRIPTION = (
    "back row of Karl Foerster feather reed grass, 4-foot tall upright "
    "ornamental grasses with vertical green-gold blades and tan plumes, "
    "spaced 32 inches apart, 6 inches off the fence, in the north and "
    "south alcove sections only"
)

GERANIUM_DESCRIPTION = (
    "under the pear canopy at the north end, a low mat of "
    "Geranium macrorrhizum (Bigroot cranesbill), scalloped green foliage "
    "with small magenta flowers, 10 inches tall, replacing coneflowers "
    "in the shaded zone"
)

PROMPTS = [
    {
        "name": "summer_golden_hour",
        "prompt": (
            "A planting bed along an existing wood fence with a straight front edge. "
            f"{KARL_FOERSTER_DESCRIPTION}. "
            f"A continuous {ECHINACEA_DESCRIPTION}. "
            f"{GERANIUM_DESCRIPTION}. "
            "Shredded dark hardwood mulch ground cover, clean straight bed edge. "
            "Late July, peak summer bloom, warm golden hour evening light, "
            "long shadows, photorealistic residential backyard, "
            "professional landscape photography, sharp focus, high detail. "
            + PRESERVE_CLAUSE
        ),
    },
    {
        "name": "summer_midday",
        "prompt": (
            "A planting bed along an existing wood fence with a straight front edge. "
            f"{KARL_FOERSTER_DESCRIPTION}. "
            f"A continuous {ECHINACEA_DESCRIPTION}. "
            f"{GERANIUM_DESCRIPTION}. "
            "Shredded dark hardwood mulch ground cover. "
            "Mid-July midday, bright natural daylight, slight cloud cover, "
            "photorealistic residential backyard, high detail. "
            + PRESERVE_CLAUSE
        ),
    },
    {
        "name": "late_spring_geranium_bloom",
        "prompt": (
            "A planting bed along an existing wood fence with a straight front edge. "
            f"{KARL_FOERSTER_DESCRIPTION}, just emerging green plumes. "
            "Coneflowers in the front row not yet blooming, just green foliage. "
            f"Under the pear canopy, a low mat of Geranium macrorrhizum in full "
            "magenta-pink bloom, the showcase plant of this season. "
            "Pear tree in late spring foliage. "
            "Shredded dark hardwood mulch ground cover. "
            "Late May, morning light, photorealistic residential backyard. "
            + PRESERVE_CLAUSE
        ),
    },
    {
        "name": "autumn_seedheads",
        "prompt": (
            "A planting bed along an existing wood fence with a straight front edge. "
            f"{KARL_FOERSTER_DESCRIPTION}, plumes turned wheat-tan. "
            "Coneflowers (Echinacea purpurea) with spent black seedheads on dried stems, "
            "structural and architectural, no remaining petals. "
            "Under the pear canopy, Geranium macrorrhizum foliage flushed red-bronze. "
            "Pear tree in autumn foliage with some leaves on the ground. "
            "Shredded dark hardwood mulch ground cover. "
            "Mid-October, golden afternoon light, photorealistic residential backyard, "
            "high detail. "
            + PRESERVE_CLAUSE
        ),
    },
]


# ----------------------------------------------------------------------------
# HELPERS
# ----------------------------------------------------------------------------

def check_setup():
    """Verify env, inputs, and dimensions before burning API calls."""
    if not os.getenv("FAL_KEY"):
        print("ERROR: FAL_KEY env var is not set.")
        print("  Get a key at https://fal.ai/dashboard/keys")
        print("  Then run: export FAL_KEY='your-key-here'")
        sys.exit(1)

    if not HERO_PATH.exists():
        print(f"ERROR: {HERO_PATH} not found in current directory.")
        print(f"  Place your yard photo here named '{HERO_PATH.name}'.")
        sys.exit(1)

    if not MASK_PATH.exists():
        print(f"ERROR: {MASK_PATH} not found in current directory.")
        print(f"  Create a mask (white on bed area, black elsewhere) named '{MASK_PATH.name}'.")
        print("  See header of this script for instructions.")
        sys.exit(1)

    # Verify dimensions match
    hero_img = Image.open(HERO_PATH)
    mask_img = Image.open(MASK_PATH)
    if hero_img.size != mask_img.size:
        print(f"ERROR: hero.jpg is {hero_img.size}, mask.png is {mask_img.size}.")
        print("  Both files must be exactly the same pixel dimensions.")
        sys.exit(1)

    megapixels = (hero_img.size[0] * hero_img.size[1]) / 1_000_000
    cost_per_image = megapixels * 0.05
    total_cost = cost_per_image * len(PROMPTS) * NUM_IMAGES_PER_PROMPT
    print(f"Hero image: {hero_img.size[0]}×{hero_img.size[1]} ({megapixels:.2f} MP)")
    print(f"Cost per render: ~${cost_per_image:.3f}")
    print(f"Total prompts: {len(PROMPTS)} × {NUM_IMAGES_PER_PROMPT} = {len(PROMPTS) * NUM_IMAGES_PER_PROMPT} images")
    print(f"Estimated total cost: ~${total_cost:.2f}")
    print()
    confirm = input("Proceed? [y/N]: ").strip().lower()
    if confirm != "y":
        print("Aborted.")
        sys.exit(0)


def upload_image(path: Path) -> str:
    """Upload local file to fal.ai's storage and return the URL."""
    print(f"  Uploading {path.name}...")
    url = fal_client.upload_file(str(path))
    return url


def render_one(prompt: dict, hero_url: str, mask_url: str) -> list[Path]:
    """Run one prompt through Flux Fill Pro. Returns list of saved file paths."""
    print(f"\n→ Rendering '{prompt['name']}'...")

    result = fal_client.subscribe(
        "fal-ai/flux-pro/v1/fill",
        arguments={
            "image_url": hero_url,
            "mask_url": mask_url,
            "prompt": prompt["prompt"],
            "num_images": NUM_IMAGES_PER_PROMPT,
            "safety_tolerance": "2",
            "output_format": "png",
        },
        with_logs=True,
        on_queue_update=lambda update: None,  # silence per-step logs
    )

    saved = []
    for i, img_data in enumerate(result.get("images", [])):
        img_url = img_data["url"]
        suffix = f"_{i+1}" if NUM_IMAGES_PER_PROMPT > 1 else ""
        out_path = OUTPUT_DIR / f"{prompt['name']}{suffix}.png"
        print(f"  ↓ Downloading → {out_path}")
        resp = requests.get(img_url, timeout=60)
        resp.raise_for_status()
        out_path.write_bytes(resp.content)
        saved.append(out_path)

    return saved


# ----------------------------------------------------------------------------
# MAIN
# ----------------------------------------------------------------------------

def main():
    print("=" * 60)
    print("Landscape Render Pipeline — fal.ai Flux Fill Pro")
    print("=" * 60)
    print()

    check_setup()
    OUTPUT_DIR.mkdir(exist_ok=True)

    # Upload hero + mask once, reuse across all prompts
    print("\nUploading source files to fal.ai...")
    hero_url = upload_image(HERO_PATH)
    mask_url = upload_image(MASK_PATH)
    print("  Done.")

    all_saved = []
    for prompt in PROMPTS:
        try:
            saved = render_one(prompt, hero_url, mask_url)
            all_saved.extend(saved)
        except Exception as e:
            print(f"  ✗ Failed: {e}")
            continue

    print()
    print("=" * 60)
    print(f"DONE. {len(all_saved)} renders saved to {OUTPUT_DIR.resolve()}/")
    print("=" * 60)
    for p in all_saved:
        print(f"  {p}")


if __name__ == "__main__":
    main()
