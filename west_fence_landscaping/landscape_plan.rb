# ============================================================================
#  landscape_plan.rb
#  SketchUp Ruby script — West Fence Line Landscape Plan
#
#  Draws: stepped fence + STRAIGHT-FRONT-EDGE planting bed
#         + 12 Karl Foerster grasses (5 north + 7 south alcoves)
#         + 24 Echinacea coneflowers (front line, sunny sections)
#         + 5 Geranium macrorrhizum (front line, pear canopy zone)
#         + pear tree at north jut corner
#         + dimension annotations
#
#  USAGE
#   1. Open SketchUp (any version 2017+).
#   2. Window → Ruby Console.
#   3. Type:  load "/full/path/to/landscape_plan.rb"
#      (Mac:   load "/Users/you/Desktop/landscape_plan.rb")
#      (Win:   load "C:/Users/you/Desktop/landscape_plan.rb"  ← forward slashes)
#   4. Press Enter. The drawing builds in a few seconds.
#   5. Hit "Zoom Extents" (Shift+Z) to frame it.
#
#  COORDINATES
#   X axis = along the fence (south → north, 0 to 549 inches)
#   Y axis = depth into yard (0 = property line, positive = toward viewer/lawn)
#   Z axis = up
#
#  FENCE GEOMETRY
#   South section: Y =  0, X from   0 to 228   (property line)
#   Middle (jut):  Y = 33, X from 228 to 381   (juts 33" toward viewer)
#   North section: Y =  0, X from 381 to 549   (property line)
#
#  BED GEOMETRY (key change from v1)
#   The bed's FRONT EDGE is a single straight line at Y = 63
#   (= 33" jut + 30" jut bed depth).
#   This means the north and south alcoves are ~63" deep
#   while the middle (jutting) section is ~30" deep.
#
#  PLANT POSITIONS
#   Grasses: 6" off the property-line fence (Y = 6), back of alcoves only.
#            None in the jut section.
#   Front line: 8" inside the front edge (Y = 55), continuous straight line.
#            Coneflowers in sun, Geraniums in the pear canopy zone.
#
#  PEAR TREE
#   Trunk at X = 381 (north jut corner), Y = -84 from front edge
#   ... actually positioned 7 ft (84") east of the north section fence,
#   at the north jut inside corner. In our coordinates that's:
#     X = 381 (north jut corner X)
#     Y = 84 (east of north section fence, which is at Y=0)
#   Canopy spread: 10 ft (5 ft radius).
#
#  SOIL NOTE (per corrected plan)
#   Soil is Urban land–Psamments — sand below ~10". Excessively drained.
#   DO NOT use the rock-bar protocol from the v1 of this plan.
#   See landscape_design_plan.md sections 5 (planting protocol) and
#   7 (year-1 watering) for the corrected install approach.
# ============================================================================

require 'sketchup.rb'

module LandscapePlan
  # ---------- CONFIG ---------------------------------------------------------

  # Lengths in inches
  SOUTH_LEN   = 228.0
  MID_LEN     = 153.0
  NORTH_LEN   = 168.0
  STEP_DEPTH  = 33.0     # how far the middle juts toward viewer/yard
  FRONT_EDGE  = 63.0     # straight front edge: 33" jut + 30" bed = 63" off property line

  FENCE_H     = 72.0     # 6 ft fence
  FENCE_T     = 1.5      # fence thickness for visualization

  # Plant placement
  GRASS_OFFSET_FROM_FENCE = 6.0    # grass center is 6" from property-line fence
  GRASS_SPACING           = 32.0   # midpoint of 30–36" range
  FRONT_LINE_OFFSET       = 8.0    # front-row plants 8" inside front edge → Y = 55
  CONEFLOWER_SPACING      = 14.0
  GERANIUM_SPACING        = 24.0

  # Pear tree (north jut inside corner)
  PEAR_TRUNK_X = 381.0   # at the X position of the north jut corner
  PEAR_TRUNK_Y = 84.0    # 7 ft east of north section fence
  PEAR_CANOPY_RADIUS = 60.0  # 5 ft radius (10 ft spread)
  PEAR_TRUNK_RADIUS = 4.0    # ~8" trunk diameter

  # Pear shade zone along the front line (X coordinates where geraniums replace coneflowers)
  # Front line is at Y = 55. Pear trunk at (381, 84). Canopy radius 60.
  # Distance from front line Y to pear Y = 84 - 55 = 29.
  # Half-width of canopy intersection with front line = sqrt(60^2 - 29^2) = sqrt(3600 - 841) = sqrt(2759) ≈ 52.5
  # So geranium zone runs X = 381 - 52.5 to X = 381 + 52.5 = roughly X 328.5 to X 433.5
  # That's ~105" of front line, fitting ~5 geraniums at 24" centers.
  GERANIUM_ZONE_START_X = 328.5
  GERANIUM_ZONE_END_X   = 433.5

  # Plant visual dimensions (stylized)
  GRASS_HEIGHT    = 54.0
  GRASS_BASE_W    = 4.0
  GRASS_TOP_W     = 18.0
  GRASS_BLADES    = 8

  FLOWER_STEM_H   = 28.0
  FLOWER_HEAD_R   = 3.5
  FLOWER_LEAF_R   = 5.0

  GERANIUM_HEIGHT = 10.0   # low mounding habit
  GERANIUM_R      = 8.0    # mat-forming spread

  PEAR_HEIGHT     = 240.0  # ~20 ft mature pear

  # Colors
  COLOR_GROUND   = Sketchup::Color.new(120, 160, 90)
  COLOR_BED      = Sketchup::Color.new(78, 52, 36)      # mulch brown
  COLOR_FENCE    = Sketchup::Color.new(140, 110, 80)    # weathered cedar
  COLOR_GRASS    = Sketchup::Color.new(150, 165, 80)    # olive-green
  COLOR_GRASS_T  = Sketchup::Color.new(210, 195, 130)   # tan plume tip
  COLOR_FLOWER   = Sketchup::Color.new(190, 90, 140)    # coneflower pink-purple
  COLOR_LEAF     = Sketchup::Color.new(60, 110, 55)     # deep green
  COLOR_GERANIUM = Sketchup::Color.new(150, 60, 110)    # geranium magenta
  COLOR_PEAR_LEAF = Sketchup::Color.new(80, 130, 60)    # pear canopy green
  COLOR_PEAR_TRUNK = Sketchup::Color.new(90, 60, 40)    # brown

  # ---------- HELPERS --------------------------------------------------------

  def self.pt(x, y, z); Geom::Point3d.new(x.inch, y.inch, z.inch); end

  def self.add_layer(model, name)
    layer = model.layers[name] || model.layers.add(name)
    layer
  end

  # Draws a stylized Karl Foerster grass clump
  def self.build_grass(parent_group, x, y)
    grp = parent_group.entities.add_group
    grp.name = "Karl Foerster Grass"
    top_center  = pt(x, y, GRASS_HEIGHT)

    GRASS_BLADES.times do |i|
      ang = (2.0 * Math::PI / GRASS_BLADES) * i
      tip_x = x + (GRASS_TOP_W / 2.0) * Math.cos(ang)
      tip_y = y + (GRASS_TOP_W / 2.0) * Math.sin(ang)
      base_x = x + (GRASS_BASE_W / 2.0) * Math.cos(ang)
      base_y = y + (GRASS_BASE_W / 2.0) * Math.sin(ang)

      p1 = pt(base_x, base_y, 0)
      p2 = pt(base_x + 0.3 * Math.sin(ang), base_y - 0.3 * Math.cos(ang), 0)
      p3 = pt(tip_x, tip_y, GRASS_HEIGHT)
      face = grp.entities.add_face(p1, p2, p3)
      next unless face
      face.material = COLOR_GRASS
      face.back_material = COLOR_GRASS
    end

    cap = grp.entities.add_circle(top_center, [0, 0, 1], (GRASS_TOP_W / 2.0).inch, 12)
    cap_face = grp.entities.add_face(cap)
    cap_face.material = COLOR_GRASS_T if cap_face
    grp
  end

  # Stylized coneflower
  def self.build_coneflower(parent_group, x, y)
    grp = parent_group.entities.add_group
    grp.name = "Echinacea Coneflower"

    base_center = pt(x, y, 0.5)
    leaf_circle = grp.entities.add_circle(base_center, [0,0,1], FLOWER_LEAF_R.inch, 10)
    leaf_face = grp.entities.add_face(leaf_circle)
    leaf_face.material = COLOR_LEAF if leaf_face

    stem_top = pt(x, y, FLOWER_STEM_H)
    stem = grp.entities.add_line(pt(x, y, 0), stem_top)

    head_center = pt(x, y, FLOWER_STEM_H + FLOWER_HEAD_R)
    head_circle = grp.entities.add_circle(head_center, [0,0,1], FLOWER_HEAD_R.inch, 12)
    head_face = grp.entities.add_face(head_circle)
    if head_face
      head_face.material = COLOR_FLOWER
      head_face.pushpull(2.5.inch)
      grp.entities.grep(Sketchup::Face).each do |f|
        f.material = COLOR_FLOWER if f.material.nil?
      end
    end

    grp
  end

  # Stylized geranium (low mounding mat)
  def self.build_geranium(parent_group, x, y)
    grp = parent_group.entities.add_group
    grp.name = "Geranium macrorrhizum"

    # Low dome of foliage
    base_center = pt(x, y, 0.5)
    foliage_circle = grp.entities.add_circle(base_center, [0,0,1], GERANIUM_R.inch, 14)
    foliage_face = grp.entities.add_face(foliage_circle)
    if foliage_face
      foliage_face.material = COLOR_LEAF
      foliage_face.pushpull(GERANIUM_HEIGHT.inch)
      grp.entities.grep(Sketchup::Face).each do |f|
        f.material = COLOR_LEAF if f.material.nil?
      end
    end

    # Small magenta bloom indicators on top
    3.times do |i|
      ang = (2.0 * Math::PI / 3) * i
      bx = x + (GERANIUM_R * 0.5) * Math.cos(ang)
      by = y + (GERANIUM_R * 0.5) * Math.sin(ang)
      bloom_center = pt(bx, by, GERANIUM_HEIGHT + 1)
      bloom = grp.entities.add_circle(bloom_center, [0,0,1], 1.5.inch, 8)
      bloom_face = grp.entities.add_face(bloom)
      bloom_face.material = COLOR_GERANIUM if bloom_face
    end

    grp
  end

  # Pear tree — trunk + simplified canopy
  def self.build_pear(parent_group)
    grp = parent_group.entities.add_group
    grp.name = "Pear Tree"

    # Trunk
    trunk_center = pt(PEAR_TRUNK_X, PEAR_TRUNK_Y, 0)
    trunk_circle = grp.entities.add_circle(trunk_center, [0,0,1], PEAR_TRUNK_RADIUS.inch, 16)
    trunk_face = grp.entities.add_face(trunk_circle)
    if trunk_face
      trunk_face.pushpull(PEAR_HEIGHT.inch)
      grp.entities.grep(Sketchup::Face).each do |f|
        f.material = COLOR_PEAR_TRUNK if f.material.nil?
      end
    end

    # Canopy (simplified as a flattened sphere ~ flat-bottomed dome)
    canopy_center = pt(PEAR_TRUNK_X, PEAR_TRUNK_Y, PEAR_HEIGHT - 36)
    canopy_circle = grp.entities.add_circle(canopy_center, [0,0,1], PEAR_CANOPY_RADIUS.inch, 24)
    canopy_face = grp.entities.add_face(canopy_circle)
    if canopy_face
      canopy_face.material = COLOR_PEAR_LEAF
      canopy_face.pushpull(48.inch)
      grp.entities.grep(Sketchup::Face).each do |f|
        f.material = COLOR_PEAR_LEAF if f.material.nil?
      end
    end

    grp
  end

  # Evenly space n plants across a 1D segment of length L (equal-share centering)
  def self.spaced_centers(length, count)
    return [] if count <= 0
    share = length / count.to_f
    (0...count).map { |i| share * (i + 0.5) }
  end

  # Spaced centers along the front line between two X coordinates,
  # excluding a forbidden zone (the geranium zone, when placing coneflowers).
  # We compute positions across the full 549" run at 14" centers,
  # then split into coneflower positions (outside geranium zone) and geranium positions.
  def self.front_line_positions
    total_len = SOUTH_LEN + MID_LEN + NORTH_LEN
    coneflower_centers = []
    geranium_centers = []

    # Coneflowers at 14" centers, but skipped where the geranium zone lives
    # We'll lay out a 14" grid across the full length and assign each position
    # to coneflower OR (in the geranium zone) skip — geraniums get their own 24" grid
    n_positions = (total_len / CONEFLOWER_SPACING).floor
    share = total_len / n_positions.to_f
    n_positions.times do |i|
      x = share * (i + 0.5)
      if x >= GERANIUM_ZONE_START_X && x <= GERANIUM_ZONE_END_X
        # Skip — geranium zone
      else
        coneflower_centers << x
      end
    end

    # Geraniums at 24" centers across the geranium zone
    zone_len = GERANIUM_ZONE_END_X - GERANIUM_ZONE_START_X
    n_geraniums = (zone_len / GERANIUM_SPACING).round
    g_share = zone_len / n_geraniums.to_f
    n_geraniums.times do |i|
      x = GERANIUM_ZONE_START_X + g_share * (i + 0.5)
      geranium_centers << x
    end

    [coneflower_centers, geranium_centers]
  end

  # ---------- MAIN BUILD -----------------------------------------------------

  def self.build!
    model = Sketchup.active_model
    model.start_operation("Build West Fence Landscape Plan", true)
    begin
      model.options["UnitsOptions"]["LengthUnit"] = 0
      model.options["UnitsOptions"]["LengthFormat"] = 1

      layer_ground   = add_layer(model, "01_Ground")
      layer_fence    = add_layer(model, "02_Fence")
      layer_bed      = add_layer(model, "03_Bed_Mulch")
      layer_grass    = add_layer(model, "04_Grasses")
      layer_flower   = add_layer(model, "05_Coneflowers")
      layer_geranium = add_layer(model, "06_Geraniums")
      layer_pear     = add_layer(model, "07_Pear_Tree")
      layer_dims     = add_layer(model, "08_Annotations")

      ents = model.active_entities

      # ----- 1. Ground plane (lawn) -----
      lawn_pts = [
        pt(-24, -24, 0),
        pt(SOUTH_LEN + MID_LEN + NORTH_LEN + 24, -24, 0),
        pt(SOUTH_LEN + MID_LEN + NORTH_LEN + 24, FRONT_EDGE + 120, 0),
        pt(-24, FRONT_EDGE + 120, 0)
      ]
      lawn_face = ents.add_face(lawn_pts)
      lawn_face.material = COLOR_GROUND
      lawn_face.back_material = COLOR_GROUND
      lawn_face.layer = layer_ground

      # ----- 2. Fence (stepped) -----
      fence_grp = ents.add_group
      fence_grp.name = "Fence"
      fence_grp.layer = layer_fence

      def self.add_fence_panel(group, x1, x2, y_front)
        y_back = y_front - FENCE_T
        base = [
          pt(x1, y_back, 0),
          pt(x2, y_back, 0),
          pt(x2, y_front, 0),
          pt(x1, y_front, 0)
        ]
        face = group.entities.add_face(base)
        face.reverse! if face.normal.z < 0
        face.pushpull(FENCE_H.inch)
        group.entities.grep(Sketchup::Face).each do |f|
          f.material = COLOR_FENCE if f.material.nil?
        end
      end

      add_fence_panel(fence_grp, 0,                    SOUTH_LEN,                       0)
      add_fence_panel(fence_grp, SOUTH_LEN,            SOUTH_LEN + MID_LEN,             STEP_DEPTH)
      add_fence_panel(fence_grp, SOUTH_LEN + MID_LEN,  SOUTH_LEN + MID_LEN + NORTH_LEN, 0)

      # Connector walls at the two step corners
      connector1 = [
        pt(SOUTH_LEN - FENCE_T, 0, 0),
        pt(SOUTH_LEN,           0, 0),
        pt(SOUTH_LEN,           STEP_DEPTH, 0),
        pt(SOUTH_LEN - FENCE_T, STEP_DEPTH, 0)
      ]
      f1 = fence_grp.entities.add_face(connector1)
      f1.reverse! if f1.normal.z < 0
      f1.pushpull(FENCE_H.inch)

      connector2 = [
        pt(SOUTH_LEN + MID_LEN,           0, 0),
        pt(SOUTH_LEN + MID_LEN + FENCE_T, 0, 0),
        pt(SOUTH_LEN + MID_LEN + FENCE_T, STEP_DEPTH, 0),
        pt(SOUTH_LEN + MID_LEN,           STEP_DEPTH, 0)
      ]
      f2 = fence_grp.entities.add_face(connector2)
      f2.reverse! if f2.normal.z < 0
      f2.pushpull(FENCE_H.inch)

      fence_grp.entities.grep(Sketchup::Face).each do |f|
        f.material = COLOR_FENCE if f.material.nil?
      end

      # ----- 3. Planting bed (mulch) with STRAIGHT FRONT EDGE -----
      bed_grp = ents.add_group
      bed_grp.name = "Planting Bed (Mulch)"
      bed_grp.layer = layer_bed

      # Bed outline: follows fence on the back (with steps), straight on the front
      bed_outline = [
        pt(0, 0, 0.1),                                          # SW corner at property line
        pt(SOUTH_LEN, 0, 0.1),                                  # follow south fence
        pt(SOUTH_LEN, STEP_DEPTH, 0.1),                         # step east into jut
        pt(SOUTH_LEN + MID_LEN, STEP_DEPTH, 0.1),               # follow jut fence
        pt(SOUTH_LEN + MID_LEN, 0, 0.1),                        # step back west
        pt(SOUTH_LEN + MID_LEN + NORTH_LEN, 0, 0.1),            # follow north fence
        pt(SOUTH_LEN + MID_LEN + NORTH_LEN, FRONT_EDGE, 0.1),   # NE corner of bed
        pt(0, FRONT_EDGE, 0.1)                                  # straight front edge back to SW
      ]
      bed_face = bed_grp.entities.add_face(bed_outline)
      bed_face.material = COLOR_BED if bed_face
      bed_face.back_material = COLOR_BED if bed_face

      # ----- 4. Grasses (south and north alcoves only — none in jut) -----
      grass_grp = ents.add_group
      grass_grp.name = "All Grasses"
      grass_grp.layer = layer_grass

      # South alcove: X from 0 to SOUTH_LEN (228"), 7 grasses
      south_grass_xs = spaced_centers(SOUTH_LEN, 7)
      south_grass_xs.each do |x|
        build_grass(grass_grp, x, GRASS_OFFSET_FROM_FENCE)
      end

      # North alcove: X from SOUTH_LEN + MID_LEN to total length, 5 grasses
      north_start_x = SOUTH_LEN + MID_LEN
      north_grass_xs = spaced_centers(NORTH_LEN, 5).map { |dx| north_start_x + dx }
      north_grass_xs.each do |x|
        build_grass(grass_grp, x, GRASS_OFFSET_FROM_FENCE)
      end

      # ----- 5. Front line: coneflowers and geraniums -----
      flower_grp = ents.add_group
      flower_grp.name = "Coneflowers"
      flower_grp.layer = layer_flower

      geranium_grp = ents.add_group
      geranium_grp.name = "Geraniums"
      geranium_grp.layer = layer_geranium

      coneflower_xs, geranium_xs = front_line_positions
      front_y = FRONT_EDGE - FRONT_LINE_OFFSET   # Y = 55

      coneflower_xs.each do |x|
        build_coneflower(flower_grp, x, front_y)
      end

      geranium_xs.each do |x|
        build_geranium(geranium_grp, x, front_y)
      end

      # ----- 6. Pear tree -----
      pear_grp = ents.add_group
      pear_grp.name = "Pear Tree"
      pear_grp.layer = layer_pear
      build_pear(pear_grp)

      # ----- 7. Dimension annotations -----
      dim_grp = ents.add_group
      dim_grp.name = "Dimensions"
      dim_grp.layer = layer_dims

      def self.add_dim(group, p1, p2, label_text)
        group.entities.add_cline(p1, p2)
        mid = Geom::Point3d.linear_combination(0.5, p1, 0.5, p2)
        text = group.entities.add_text(label_text, mid)
        text
      end

      label_y = -18
      add_dim(dim_grp,
        pt(0, label_y, 0),
        pt(SOUTH_LEN, label_y, 0),
        "South alcove: 228\"  (7 grasses)")
      add_dim(dim_grp,
        pt(SOUTH_LEN, label_y, 0),
        pt(SOUTH_LEN + MID_LEN, label_y, 0),
        "Middle (jut): 153\"  (no grasses)")
      add_dim(dim_grp,
        pt(SOUTH_LEN + MID_LEN, label_y, 0),
        pt(SOUTH_LEN + MID_LEN + NORTH_LEN, label_y, 0),
        "North alcove: 168\"  (5 grasses)")

      # Front edge label
      add_dim(dim_grp,
        pt(-6, 0, 0),
        pt(-6, FRONT_EDGE, 0),
        "Bed depth (alcove): 63\"")

      # Step depth label
      add_dim(dim_grp,
        pt(SOUTH_LEN - 6, 0, 0),
        pt(SOUTH_LEN - 6, STEP_DEPTH, 0),
        "Fence jut: 33\"")

      # Pear tree label
      pear_label_pt = pt(PEAR_TRUNK_X + 12, PEAR_TRUNK_Y + 12, 0)
      dim_grp.entities.add_text(
        "Pear tree\n7 ft off fence\n~10 ft canopy",
        pear_label_pt)

      # Title
      title_pt = pt(SOUTH_LEN + MID_LEN / 2.0, FRONT_EDGE + 60, 0)
      dim_grp.entities.add_text(
        "West Fence Landscape Plan — 1013 Colfax St\n" \
        "Total: ~46 ft  |  12 Karl Foerster (5N + 7S) + 24 Echinacea + 5 Geranium\n" \
        "Straight front edge  |  Sandy ridge soil — see landscape_design_plan.md",
        title_pt)

      model.commit_operation
      model.active_view.zoom_extents

      puts "============================================================"
      puts "West fence landscape plan built successfully."
      puts "  12 grasses (5 north + 7 south alcoves)"
      puts "  #{coneflower_xs.size} coneflowers (front line, sunny sections)"
      puts "  #{geranium_xs.size} geraniums (front line, pear canopy zone)"
      puts "  Pear tree at north jut corner, ~10 ft canopy"
      puts ""
      puts "  Layers: 01_Ground, 02_Fence, 03_Bed_Mulch, 04_Grasses,"
      puts "          05_Coneflowers, 06_Geraniums, 07_Pear_Tree,"
      puts "          08_Annotations"
      puts "  Toggle layers from Window > Default Tray > Tags."
      puts ""
      puts "  NOTE: This is the v2 design (straight front edge, sand-soil-corrected)."
      puts "  See landscape_design_plan.md for the full install spec."
      puts "============================================================"
    rescue => e
      model.abort_operation
      puts "ERROR: #{e.message}"
      puts e.backtrace.first(10).join("\n")
    end
  end
end

# Auto-run on load
LandscapePlan.build!
