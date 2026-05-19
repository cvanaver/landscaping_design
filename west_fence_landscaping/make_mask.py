#!/usr/bin/env python3
"""
make_mask.py — Interactive mask creator for landscape rendering.

Opens a window showing your hero photo. Click-and-drag to paint the bed area
in white. Press 's' to save mask.png. Press 'r' to reset. Press 'q' to quit.

USAGE:
  1. pip install pillow
  2. Place hero.jpg in this directory
  3. python make_mask.py
  4. A window opens — click and drag with the mouse to paint the bed area white
  5. Press 's' to save → creates mask.png in same directory
  6. Press 'q' to quit

CONTROLS:
  Left click + drag    — paint white (bed area)
  Right click + drag   — erase (paint black)
  [ or ]               — decrease / increase brush size
  r                    — reset mask to all black
  s                    — save mask.png
  q                    — quit
"""

import sys
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageTk
    import tkinter as tk
except ImportError as e:
    print(f"Missing dependency: {e}")
    print("Run: pip install pillow")
    print("(tkinter ships with Python on Mac/Windows by default)")
    sys.exit(1)


HERO_PATH = Path("hero.jpg")
MASK_PATH = Path("mask.png")


def main():
    if not HERO_PATH.exists():
        print(f"ERROR: {HERO_PATH} not found in current directory.")
        sys.exit(1)

    # Load hero photo
    hero = Image.open(HERO_PATH).convert("RGB")
    W, H = hero.size

    # Scale down for display if image is huge
    MAX_DISPLAY = 1400
    if max(W, H) > MAX_DISPLAY:
        scale = MAX_DISPLAY / max(W, H)
        display_w = int(W * scale)
        display_h = int(H * scale)
    else:
        scale = 1.0
        display_w, display_h = W, H

    hero_display = hero.resize((display_w, display_h), Image.LANCZOS)

    # Create mask canvas at FULL resolution (will save at original res)
    mask = Image.new("L", (W, H), 0)
    mask_draw = ImageDraw.Draw(mask)

    # Display version of mask for overlay
    mask_display = Image.new("L", (display_w, display_h), 0)
    mask_display_draw = ImageDraw.Draw(mask_display)

    # State
    state = {
        "brush": 30,
        "last": None,
        "dirty": False,
    }

    # Tkinter setup
    root = tk.Tk()
    root.title(f"make_mask — {HERO_PATH.name}  (left=paint, right=erase, s=save, q=quit)")

    canvas = tk.Canvas(root, width=display_w, height=display_h, bg="black")
    canvas.pack()

    status = tk.Label(root, text=f"Brush: {state['brush']}px   |   [/] to resize   |   r=reset   s=save   q=quit",
                      anchor="w", padx=8)
    status.pack(fill=tk.X)

    # Initial composite
    img_tk = [None]  # mutable holder

    def composite():
        """Overlay the mask (semi-transparent red) onto the hero."""
        overlay = hero_display.copy()
        # Convert mask to RGBA where white = red translucent, black = transparent
        red = Image.new("RGBA", (display_w, display_h), (255, 0, 0, 0))
        red.putalpha(mask_display.point(lambda v: 128 if v > 128 else 0))
        overlay = Image.alpha_composite(overlay.convert("RGBA"), red)
        img_tk[0] = ImageTk.PhotoImage(overlay)
        canvas.delete("img")
        canvas.create_image(0, 0, anchor=tk.NW, image=img_tk[0], tags="img")

    def paint(event, color):
        x, y = event.x, event.y
        # Display-resolution paint
        r = state["brush"]
        mask_display_draw.ellipse([x - r, y - r, x + r, y + r], fill=color)
        # Full-resolution paint (scale up)
        fx, fy = int(x / scale), int(y / scale)
        fr = int(r / scale)
        mask_draw.ellipse([fx - fr, fy - fr, fx + fr, fy + fr], fill=color)
        # Connect to last point for smooth strokes
        if state["last"] is not None:
            lx, ly = state["last"]
            mask_display_draw.line([lx, ly, x, y], fill=color, width=r * 2)
            mask_draw.line(
                [int(lx / scale), int(ly / scale), fx, fy],
                fill=color, width=int(r * 2 / scale)
            )
        state["last"] = (x, y)
        state["dirty"] = True
        composite()

    def reset_state(event=None):
        state["last"] = None

    canvas.bind("<B1-Motion>", lambda e: paint(e, 255))
    canvas.bind("<ButtonPress-1>", lambda e: paint(e, 255))
    canvas.bind("<ButtonRelease-1>", reset_state)
    canvas.bind("<B3-Motion>", lambda e: paint(e, 0))
    canvas.bind("<ButtonPress-3>", lambda e: paint(e, 0))
    canvas.bind("<ButtonRelease-3>", reset_state)
    # Mac trackpad: ctrl-click = right click
    canvas.bind("<Control-B1-Motion>", lambda e: paint(e, 0))
    canvas.bind("<Control-ButtonPress-1>", lambda e: paint(e, 0))

    def update_status():
        status.config(text=f"Brush: {state['brush']}px   |   [/] to resize   |   r=reset   s=save   q=quit"
                           + ("  *unsaved changes*" if state["dirty"] else ""))

    def on_key(event):
        key = event.keysym
        if key == "q":
            root.destroy()
        elif key == "s":
            mask.save(MASK_PATH)
            state["dirty"] = False
            update_status()
            print(f"Saved {MASK_PATH} ({W}×{H})")
        elif key == "r":
            mask_draw.rectangle([0, 0, W, H], fill=0)
            mask_display_draw.rectangle([0, 0, display_w, display_h], fill=0)
            state["dirty"] = True
            composite()
            update_status()
        elif key == "bracketleft":
            state["brush"] = max(5, state["brush"] - 5)
            update_status()
        elif key == "bracketright":
            state["brush"] = min(150, state["brush"] + 5)
            update_status()

    root.bind("<Key>", on_key)
    composite()
    update_status()

    print("=" * 60)
    print("Mask editor open. Tips:")
    print("  • Paint a thin strip of white along the fence — that's the bed")
    print("  • Don't paint over the fence itself, the tree, the lawn, or the dome")
    print("  • Use right-click (or Ctrl+click on Mac trackpad) to erase")
    print("  • Press 's' to save when done, 'q' to quit")
    print("=" * 60)
    root.mainloop()


if __name__ == "__main__":
    main()
