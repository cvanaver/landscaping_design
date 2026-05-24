# ============================================================================
#  landscape_plan.rb
#  SketchUp Ruby script — Front Main Bed (1013 Colfax St, Evanston IL)
#  Draws: 13' x 13' rectangular bed envelope along north-facing house wall.
#         House wall (back) + stone retaining wall (east) + existing yews
#         + 10 Boxwood 'Green Velvet' + 7 placeholder tall flowers
#         + 9 Heuchera 'Plum Royale' + east-end existing mass (geranium,
#         alliums, daffodils) + drifted bulb clusters + dimension annotations.
#
#  NOTE: the real lawn-facing front edge is curved, not straight. We model
#        the rectangular envelope (13' x 13') because that's what plant
#        spacing math is derived from. The curved lawn edge is a finish
#        detail, not a spacing decision.
#
#  USAGE
#   1. Open SketchUp (any version 2017+).
#   2. Window → Ruby Console.
#   3. Type:  load "/full/path/to/landscape_plan.rb"
#      (Mac:  load "/Users/you/landscaping_design/front_main_bed/landscape_plan.rb")
#   4. Press Enter. The drawing builds in a few seconds.
#   5. Hit "Zoom Extents" (Shift+Z) to frame it.
#
#  COORDINATES (inches)
#   X axis = east-west along house wall (0 = west / design boundary,
#                                        156 = east / stone retaining wall)
#   Y axis = north-south depth (0 = front lawn edge,
#                               156 = house wall / back of bed)
#   Z axis = up
#
#  ROW GEOMETRY
#   House wall:             y = 156
#   Yew front face (post-prune): y = 96    (yews 5 ft deep from wall)
#   Row 2 boxwood centers:  y = 78         (18" off yew front face)
#   Row 3 tall flowers:     y = 60         (36" off yew front face)
#   Row 4a heuchera:        y = 12         (12" off front lawn edge)
#   East existing mass:     x = 120..156   (easternmost ~3 ft of Row 4)
# ============================================================================

require 'sketchup.rb'

module FrontMainBed
  # ---------- CONFIG ---------------------------------------------------------

  # Bed envelope (inches)
  BED_W = 156.0    # east-west (along house)
  BED_D = 156.0    # north-south (into yard)

  # House wall + stone wall visualization
  HOUSE_WALL_T   = 6.0      # wall thickness for visual
  HOUSE_WALL_H   = 96.0     # 8 ft visible wall section
  STONE_WALL_T   = 12.0     # retaining wall thickness
  STONE_WALL_H   = 24.0     # 2 ft retaining height

  # Yews (existing, kept)
  YEW_FRONT_Y    = 96.0     # post-prune front face, 5 ft off house wall
  YEW_DEPTH      = BED_D - YEW_FRONT_Y   # = 60"
  YEW_COUNT      = 4        # stylized; existing planting is continuous mass
  YEW_HEIGHT     = 48.0

  # Row 2 — Boxwood 'Green Velvet'
  BOX_COUNT       = 10
  BOX_SPACING     = 15.0
  BOX_OFFSET_FROM_YEW = 18.0           # centers 18" off yew front face
  BOX_Y           = YEW_FRONT_Y - BOX_OFFSET_FROM_YEW   # = 78
  BOX_HEIGHT      = 18.0
  BOX_RADIUS      = 7.0                # ~14" globe young

  # Row 3 — Tall flowers (SPECIES PENDING pH; placeholder geometry)
  TALL_COUNT      = 7
  TALL_SPACING    = 22.0
  TALL_OFFSET_FROM_YEW = 36.0
  TALL_Y          = YEW_FRONT_Y - TALL_OFFSET_FROM_YEW  # = 60
  TALL_HEIGHT     = 30.0
  TALL_RADIUS     = 8.0

  # Row 4a — Heuchera 'Plum Royale' (western 10 ft only)
  HEUCH_COUNT     = 9
  HEUCH_SPACING   = 14.0
  HEUCH_OFFSET_FROM_FRONT = 12.0
  HEUCH_Y         = HEUCH_OFFSET_FROM_FRONT             # = 12
  HEUCH_WEST_LIMIT = 0.0
  HEUCH_EAST_LIMIT = 120.0    # western 10 ft of bed
  HEUCH_HEIGHT    = 8.0
  HEUCH_RADIUS    = 6.0

  # Row 4b — East-end existing mass (~3 ft easternmost)
  EAST_MASS_X_START = 120.0
  EAST_MASS_X_END   = BED_W
  GERANIUM_COUNT    = 3    # surviving Max Frei clusters
  ALLIUM_COUNT      = 4    # original 4 Millennium, exact survivor count TBD
  DAFF_EAST_COUNT   = 12   # mass of existing daffodils at east end

  # Bulb drift through Row 3 (4 varieties x 10 bulbs = 40 bulbs in clusters)
  BULB_VARIETIES = [
    { name: "Daffodil 'Ice Follies'",   color: [255, 250, 220], count: 10 },
    { name: "Daffodil 'Thalia'",         color: [255, 255, 245], count: 10 },
    { name: "Daffodil 'Hawera'",         color: [240, 220, 90],  count: 10 },
    { name: "Tulip 'Pink Impression'",   color: [220, 110, 150], count: 10 }
  ]
  BULB_DRIFT_Y_MIN = TALL_Y - 12.0   # 48
  BULB_DRIFT_Y_MAX = TALL_Y + 18.0   # 78 (touches into row 2 area)

  # Colors
  COLOR_LAWN      = Sketchup::Color.new(120, 160, 90)
  COLOR_MULCH     = Sketchup::Color.new(78, 52, 36)
  COLOR_HOUSE     = Sketchup::Color.new(220, 215, 200)
  COLOR_STONE     = Sketchup::Color.new(150, 140, 125)
  COLOR_YEW       = Sketchup::Color.new(60, 90, 55)
  COLOR_BOXWOOD   = Sketchup::Color.new(90, 130, 75)
  COLOR_TALL_TBD  = Sketchup::Color.new(180, 180, 180)   # gray = placeholder
  COLOR_TALL_EDGE = Sketchup::Color.new(80, 80, 80)
  COLOR_HEUCH     = Sketchup::Color.new(110, 50, 70)     # plum-burgundy
  COLOR_GERANIUM  = Sketchup::Color.new(170, 80, 130)
  COLOR_ALLIUM    = Sketchup::Color.new(140, 90, 170)
  COLOR_DAFF      = Sketchup::Color.new(240, 220, 90)
  COLOR_LEAF      = Sketchup::Color.new(60, 110, 55)

  # ---------- HELPERS --------------------------------------------------------

  def self.pt(x, y, z)
    Geom::Point3d.new(x.inch, y.inch, z.inch)
  end

  def self.add_layer(model, name)
    model.layers[name] || model.layers.add(name)
  end

  # Place plant centers evenly along [x_start, x_end] given a count.
  # Uses equal-margin centering matching the west_fence approach.
  def self.spaced_centers(x_start, x_end, count)
    return [] if count <= 0
    seg_len = x_end - x_start
    return [x_start + seg_len / 2.0] if count == 1
    share = seg_len / count.to_f
    (0...count).map { |i| x_start + share * (i + 0.5) }
  end

  # Generic upright cylinder + dome top, used as a friendly "shrub" symbol
  def self.build_shrub(parent_group, x, y, height, radius, color, name)
    grp = parent_group.entities.add_group
    grp.name = name
    center = pt(x, y, 0)
    circle = grp.entities.add_circle(center, [0, 0, 1], radius.inch, 16)
    face   = grp.entities.add_face(circle)
    if face
      face.reverse! if face.normal.z < 0
      face.pushpull(height.inch)
      grp.entities.grep(Sketchup::Face).each do |f|
        f.material = color
        f.back_material = color
      end
    end
    grp
  end

  # Tall flower placeholder: dashed-outline circle + vertical question-mark
  # glyph (text) so it reads as TBD when you scrub through the model.
  def self.build_tall_placeholder(parent_group, x, y)
    grp = parent_group.entities.add_group
    grp.name = "Tall Flower (TBD pending pH)"

    # Base ring (footprint)
    base = pt(x, y, 0.1)
    ring = grp.entities.add_circle(base, [0, 0, 1], TALL_RADIUS.inch, 24)
    # Don't add a face; leave it as a wireframe ring so it reads as placeholder

    # Stem
    top = pt(x, y, TALL_HEIGHT)
    grp.entities.add_line(pt(x, y, 0), top)

    # Bloom marker: a small gray disc at top
    head_center = pt(x, y, TALL_HEIGHT)
    head_circle = grp.entities.add_circle(head_center, [0, 0, 1], 3.0.inch, 12)
    head_face   = grp.entities.add_face(head_circle)
    if head_face
      head_face.material = COLOR_TALL_TBD
      head_face.back_material = COLOR_TALL_TBD
    end

    # "?" glyph at bloom height
    grp.entities.add_text("?", pt(x, y, TALL_HEIGHT + 4))
    grp
  end

  # Small bulb glyph: low disc with a vertical stub
  def self.build_bulb(parent_group, x, y, color, label)
    grp = parent_group.entities.add_group
    grp.name = label
    base = pt(x, y, 0.2)
    circle = grp.entities.add_circle(base, [0, 0, 1], 1.5.inch, 8)
    face = grp.entities.add_face(circle)
    if face
      face.material = color
      face.back_material = color
    end
    grp.entities.add_line(pt(x, y, 0), pt(x, y, 12))
    grp
  end

  # Deterministic pseudo-random for reproducible bulb drift placement
  def self.prng_seq(seed, count)
    # Simple linear congruential for predictable layout
    a = 1664525
    c = 1013904223
    m = 2**32
    s = seed
    Array.new(count) do
      s = (a * s + c) % m
      s.to_f / m
    end
  end

  # ---------- MAIN BUILD -----------------------------------------------------

  def self.build!
    model = Sketchup.active_model
    model.start_operation("Build Front Main Bed", true)
    begin
      # Architectural inches
      model.options["UnitsOptions"]["LengthUnit"]   = 0
      model.options["UnitsOptions"]["LengthFormat"] = 1

      # Layers
      layer_ground   = add_layer(model, "01_Ground")
      layer_house    = add_layer(model, "02_House")
      layer_stone    = add_layer(model, "03_StoneWall")
      layer_yews     = add_layer(model, "04_Yews")
      layer_box      = add_layer(model, "05_Boxwood")
      layer_tall     = add_layer(model, "06_TBD_Tall_Flowers")
      layer_heuch    = add_layer(model, "07_Heuchera")
      layer_east     = add_layer(model, "08_Existing_East_Mass")
      layer_bulbs    = add_layer(model, "09_Bulbs_Drift")
      layer_dims     = add_layer(model, "10_Annotations")

      ents = model.active_entities

      # ----- 1. Ground plane (lawn surround + bed mulch) -----
      lawn_pts = [
        pt(-48, -48, 0),
        pt(BED_W + 48, -48, 0),
        pt(BED_W + 48, BED_D + 48, 0),
        pt(-48, BED_D + 48, 0)
      ]
      lawn_face = ents.add_face(lawn_pts)
      lawn_face.material = COLOR_LAWN
      lawn_face.back_material = COLOR_LAWN
      lawn_face.layer = layer_ground

      bed_grp = ents.add_group
      bed_grp.name = "Bed Mulch (13' x 13' envelope)"
      bed_grp.layer = layer_ground
      bed_outline = [
        pt(0, 0, 0.1),
        pt(BED_W, 0, 0.1),
        pt(BED_W, BED_D, 0.1),
        pt(0, BED_D, 0.1)
      ]
      bed_face = bed_grp.entities.add_face(bed_outline)
      if bed_face
        bed_face.material = COLOR_MULCH
        bed_face.back_material = COLOR_MULCH
      end

      # ----- 2. House wall (back/north boundary) -----
      house_grp = ents.add_group
      house_grp.name = "House Wall"
      house_grp.layer = layer_house
      wall_pts = [
        pt(0,     BED_D,                0),
        pt(BED_W, BED_D,                0),
        pt(BED_W, BED_D + HOUSE_WALL_T, 0),
        pt(0,     BED_D + HOUSE_WALL_T, 0)
      ]
      wall_face = house_grp.entities.add_face(wall_pts)
      wall_face.reverse! if wall_face.normal.z < 0
      wall_face.pushpull(HOUSE_WALL_H.inch)
      house_grp.entities.grep(Sketchup::Face).each do |f|
        f.material      = COLOR_HOUSE
        f.back_material = COLOR_HOUSE
      end

      # ----- 3. Stone retaining wall (east boundary) -----
      stone_grp = ents.add_group
      stone_grp.name = "Stone Retaining Wall"
      stone_grp.layer = layer_stone
      stone_pts = [
        pt(BED_W,                 0,     0),
        pt(BED_W + STONE_WALL_T,  0,     0),
        pt(BED_W + STONE_WALL_T,  BED_D, 0),
        pt(BED_W,                 BED_D, 0)
      ]
      stone_face = stone_grp.entities.add_face(stone_pts)
      stone_face.reverse! if stone_face.normal.z < 0
      stone_face.pushpull(STONE_WALL_H.inch)
      stone_grp.entities.grep(Sketchup::Face).each do |f|
        f.material      = COLOR_STONE
        f.back_material = COLOR_STONE
      end

      # ----- 4. Yews (existing, kept; ~5 ft front face after March prune) -----
      yew_grp = ents.add_group
      yew_grp.name = "Yews (existing — keep)"
      yew_grp.layer = layer_yews

      # Render as a continuous slab approximation + 4 dome bumps
      yew_slab = [
        pt(0,     YEW_FRONT_Y, 0.2),
        pt(BED_W, YEW_FRONT_Y, 0.2),
        pt(BED_W, BED_D,       0.2),
        pt(0,     BED_D,       0.2)
      ]
      slab_face = yew_grp.entities.add_face(yew_slab)
      slab_face.reverse! if slab_face.normal.z < 0
      slab_face.pushpull((YEW_HEIGHT * 0.75).inch)
      yew_grp.entities.grep(Sketchup::Face).each do |f|
        f.material      = COLOR_YEW
        f.back_material = COLOR_YEW
      end

      spaced_centers(0, BED_W, YEW_COUNT).each do |xc|
        yc = (YEW_FRONT_Y + BED_D) / 2.0
        build_shrub(yew_grp, xc, yc, YEW_HEIGHT, 14.0, COLOR_YEW, "Yew Bump")
      end

      # ----- 5. Row 2 — Boxwood 'Green Velvet' (10 @ 15" o.c.) -----
      box_grp = ents.add_group
      box_grp.name = "Boxwood 'Green Velvet' (10 @ 15\" o.c.)"
      box_grp.layer = layer_box
      box_centers = spaced_centers(0, BED_W, BOX_COUNT)
      # Override to fixed 15" o.c. with equal margins
      total_span  = (BOX_COUNT - 1) * BOX_SPACING
      margin      = (BED_W - total_span) / 2.0
      box_centers = (0...BOX_COUNT).map { |i| margin + i * BOX_SPACING }
      box_centers.each do |xc|
        build_shrub(box_grp, xc, BOX_Y, BOX_HEIGHT, BOX_RADIUS, COLOR_BOXWOOD, "Boxwood")
      end

      # ----- 6. Row 3 — Tall flowers (SPECIES PENDING pH) -----
      tall_grp = ents.add_group
      tall_grp.name = "Tall Flowers — TBD pending pH (7 @ 22\" o.c.)"
      tall_grp.layer = layer_tall
      tall_total  = (TALL_COUNT - 1) * TALL_SPACING
      tall_margin = (BED_W - tall_total) / 2.0
      tall_xs     = (0...TALL_COUNT).map { |i| tall_margin + i * TALL_SPACING }
      tall_xs.each do |xc|
        build_tall_placeholder(tall_grp, xc, TALL_Y)
      end

      # ----- 7. Row 4a — Heuchera 'Plum Royale' (western 10 ft) -----
      heuch_grp = ents.add_group
      heuch_grp.name = "Heuchera 'Plum Royale' (9 @ 14\" o.c., western 10 ft)"
      heuch_grp.layer = layer_heuch
      heuch_total  = (HEUCH_COUNT - 1) * HEUCH_SPACING
      heuch_avail  = HEUCH_EAST_LIMIT - HEUCH_WEST_LIMIT
      heuch_margin = (heuch_avail - heuch_total) / 2.0
      heuch_xs     = (0...HEUCH_COUNT).map { |i| HEUCH_WEST_LIMIT + heuch_margin + i * HEUCH_SPACING }
      heuch_xs.each do |xc|
        build_shrub(heuch_grp, xc, HEUCH_Y, HEUCH_HEIGHT, HEUCH_RADIUS, COLOR_HEUCH, "Heuchera 'Plum Royale'")
      end

      # ----- 8. Row 4b — East existing mass (geranium + alliums + daffodils) -----
      east_grp = ents.add_group
      east_grp.name = "Existing East Mass (geranium + alliums + daffodils)"
      east_grp.layer = layer_east

      ger_xs = spaced_centers(EAST_MASS_X_START + 4, EAST_MASS_X_END - 4, GERANIUM_COUNT)
      ger_xs.each do |xc|
        build_shrub(east_grp, xc, 10, 6, 7, COLOR_GERANIUM, "Max Frei geranium (existing)")
      end

      all_xs = spaced_centers(EAST_MASS_X_START + 6, EAST_MASS_X_END - 6, ALLIUM_COUNT)
      all_xs.each do |xc|
        build_shrub(east_grp, xc, 22, 22, 1.5, COLOR_ALLIUM, "Millennium allium (existing)")
      end

      # Daffodil mass at east end (in dieback mid-spring; stylized as small bulb dots)
      daff_rng = prng_seq(7, DAFF_EAST_COUNT * 2)
      DAFF_EAST_COUNT.times do |i|
        rx = EAST_MASS_X_START + 4 + daff_rng[i*2] * (EAST_MASS_X_END - EAST_MASS_X_START - 8)
        ry = 8 + daff_rng[i*2 + 1] * 50
        build_bulb(east_grp, rx, ry, COLOR_DAFF, "Existing daffodil")
      end

      # ----- 9. Bulb drift through Row 3 -----
      bulb_grp = ents.add_group
      bulb_grp.name = "Bulb Drift (40 bulbs, 4 varieties, irregular clusters)"
      bulb_grp.layer = layer_bulbs

      # Drift across full bed length, but skip the east 3 ft (existing mass)
      drift_x_min = 4.0
      drift_x_max = EAST_MASS_X_START - 4.0

      seed = 42
      BULB_VARIETIES.each_with_index do |v, vi|
        color = Sketchup::Color.new(*v[:color])
        rng = prng_seq(seed + vi * 17, v[:count] * 2 + 8)
        # Build irregular clusters of 3-7 bulbs each
        placed = 0
        cluster_idx = 0
        while placed < v[:count]
          cluster_size = 3 + (rng[cluster_idx] * 5).to_i  # 3..7
          cluster_size = [cluster_size, v[:count] - placed].min
          cluster_idx += 1
          # Cluster center
          cx = drift_x_min + rng[cluster_idx] * (drift_x_max - drift_x_min)
          cluster_idx += 1
          cy = BULB_DRIFT_Y_MIN + rng[cluster_idx] * (BULB_DRIFT_Y_MAX - BULB_DRIFT_Y_MIN)
          cluster_idx += 1
          # Scatter cluster members in a small radius
          cluster_size.times do
            jitter_r = 3.0 + rng[cluster_idx % rng.size] * 5.0
            cluster_idx += 1
            jitter_a = rng[cluster_idx % rng.size] * 2 * Math::PI
            cluster_idx += 1
            bx = cx + jitter_r * Math.cos(jitter_a)
            by = cy + jitter_r * Math.sin(jitter_a)
            bx = [[bx, drift_x_min].max, drift_x_max].min
            by = [[by, BULB_DRIFT_Y_MIN].max, BULB_DRIFT_Y_MAX].min
            build_bulb(bulb_grp, bx, by, color, v[:name])
            placed += 1
            break if placed >= v[:count]
          end
        end
      end

      # ----- 10. Annotations -----
      dim_grp = ents.add_group
      dim_grp.name = "Dimensions"
      dim_grp.layer = layer_dims

      def self.add_dim(group, p1, p2, label_text)
        group.entities.add_cline(p1, p2)
        mid = Geom::Point3d.linear_combination(0.5, p1, 0.5, p2)
        group.entities.add_text(label_text, mid)
      end

      # Bed envelope dims
      add_dim(dim_grp, pt(0, -10, 0), pt(BED_W, -10, 0), "Bed width: 13'-0\" (156\")")
      add_dim(dim_grp, pt(-10, 0, 0), pt(-10, BED_D, 0), "Bed depth: 13'-0\" (156\")")

      # Row offset annotations (along the west edge)
      add_dim(dim_grp, pt(-30, YEW_FRONT_Y, 0), pt(-30, BED_D, 0),
              "Yew zone (5'-0\" deep, post-prune)")
      add_dim(dim_grp, pt(-30, BOX_Y, 0), pt(-30, YEW_FRONT_Y, 0),
              "Box centers 18\" off yew face")
      add_dim(dim_grp, pt(-30, TALL_Y, 0), pt(-30, YEW_FRONT_Y, 0),
              "Tall flower centers 36\" off yew face")
      add_dim(dim_grp, pt(-30, 0, 0), pt(-30, HEUCH_Y, 0),
              "Heuchera centers 12\" off front edge")

      # Heuchera vs east-mass split
      add_dim(dim_grp, pt(0, -22, 0), pt(HEUCH_EAST_LIMIT, -22, 0),
              "Western 10' — Heuchera ribbon (9 plants @ 14\" o.c.)")
      add_dim(dim_grp, pt(EAST_MASS_X_START, -22, 0), pt(EAST_MASS_X_END, -22, 0),
              "Easternmost ~3' — existing geranium + allium + daffodil mass")

      # Title block
      title_pt = pt(BED_W / 2.0, BED_D + 30, 0)
      dim_grp.entities.add_text(
        "Front Main Bed — 1013 Colfax St, Evanston IL\n" \
        "13' x 13' envelope (rectangular working plan; real lawn edge is curved)\n" \
        "Row 2: 10 Boxwood 'Green Velvet' 15\" o.c.  |  " \
        "Row 3: 7 TBD tall flowers 22\" o.c. (pending pH)\n" \
        "Row 4a: 9 Heuchera 'Plum Royale' 14\" o.c. (W 10')  |  " \
        "Row 4b: existing east mass kept  |  Bulb drift through Row 3 (40 bulbs)",
        title_pt)

      model.commit_operation
      model.active_view.zoom_extents

      puts "============================================================"
      puts "Front Main Bed plan built successfully."
      puts "  10 boxwood, 7 tall-flower placeholders (TBD pending pH),"
      puts "  9 heuchera, 40 drifted bulbs (10 each x 4 varieties),"
      puts "  + yews / east-end existing mass preserved."
      puts "  Layers: 01_Ground 02_House 03_StoneWall 04_Yews"
      puts "          05_Boxwood 06_TBD_Tall_Flowers 07_Heuchera"
      puts "          08_Existing_East_Mass 09_Bulbs_Drift 10_Annotations"
      puts "  Toggle layers from Window > Default Tray > Tags."
      puts "  Row 3 species resolves when pH test result is in — see"
      puts "  open_decisions.md."
      puts "============================================================"
    rescue => e
      model.abort_operation
      puts "ERROR: #{e.message}"
      puts e.backtrace.first(10).join("\n")
    end
  end
end

# Auto-run on load
FrontMainBed.build!
