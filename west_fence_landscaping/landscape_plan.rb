# ============================================================================
#  landscape_plan.rb
#  SketchUp Ruby script — Backyard Fence Line Landscape Plan
#  Draws: stepped fence + 30" planting bed + 17 Karl Foerster grasses
#         + 36 perennial flowers + dimension annotations
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
#   X axis = along the fence (left → right, 0 to 549 inches)
#   Y axis = depth into yard (0 = fence line of left/right sections,
#                             positive = toward viewer/lawn)
#   Z axis = up
#
#  GEOMETRY
#   Left section fence:   Y =  0, X from   0 to 168
#   Middle section fence: Y = 33, X from 168 to 321   (juts 33" toward viewer)
#   Right section fence:  Y =  0, X from 321 to 549
#   Bed = fence line offset 30" toward the viewer (so middle bed front
#         sits at Y = 33 + 30 = 63, left/right at Y = 30)
# ============================================================================

require 'sketchup.rb'

module LandscapePlan
  # ---------- CONFIG ---------------------------------------------------------

  # Lengths in inches
  LEFT_LEN    = 168.0
  MID_LEN     = 153.0
  RIGHT_LEN   = 228.0
  STEP_DEPTH  = 33.0     # how far the middle juts toward viewer

  BED_DEPTH   = 30.0
  FENCE_H     = 72.0     # 6 ft fence
  FENCE_T     = 1.5      # fence thickness for visualization

  # Plant placement
  GRASS_OFFSET_FROM_FENCE = 6.0    # grass center is 6" from fence face
  GRASS_SPACING           = 32.0   # midpoint of 30–36" range
  FLOWER_OFFSET_FROM_EDGE = 8.0    # flower center is 8" from bed front edge
  FLOWER_SPACING          = 14.0

  # Plant visual dimensions (stylized)
  GRASS_HEIGHT    = 54.0    # 4.5 ft plume
  GRASS_BASE_W    = 4.0
  GRASS_TOP_W     = 18.0    # plume splay
  GRASS_BLADES    = 8

  FLOWER_STEM_H   = 28.0
  FLOWER_HEAD_R   = 3.5
  FLOWER_LEAF_R   = 5.0

  # Colors
  COLOR_GROUND   = Sketchup::Color.new(120, 160, 90)
  COLOR_BED      = Sketchup::Color.new(78, 52, 36)      # mulch brown
  COLOR_FENCE    = Sketchup::Color.new(140, 110, 80)    # weathered cedar
  COLOR_GRASS    = Sketchup::Color.new(150, 165, 80)    # olive-green
  COLOR_GRASS_T  = Sketchup::Color.new(210, 195, 130)   # tan plume tip
  COLOR_FLOWER   = Sketchup::Color.new(190, 90, 140)    # coneflower pink
  COLOR_LEAF     = Sketchup::Color.new(60, 110, 55)     # deep green

  # ---------- HELPERS --------------------------------------------------------

  def self.in(x); x.inch; end       # shorthand: convert number-of-inches → length

  def self.pt(x, y, z); Geom::Point3d.new(x.inch, y.inch, z.inch); end

  def self.add_layer(model, name)
    layer = model.layers[name] || model.layers.add(name)
    layer
  end

  # Draws a 6-sided "blade clump" — a tapered cone, base small, top wider
  def self.build_grass(parent_group, x, y)
    grp = parent_group.entities.add_group
    grp.name = "Karl Foerster Grass"
    base_center = pt(x, y, 0)
    top_center  = pt(x, y, GRASS_HEIGHT)

    # Build several upright blades radiating outward
    GRASS_BLADES.times do |i|
      ang = (2.0 * Math::PI / GRASS_BLADES) * i
      tip_x = x + (GRASS_TOP_W / 2.0) * Math.cos(ang)
      tip_y = y + (GRASS_TOP_W / 2.0) * Math.sin(ang)
      base_x = x + (GRASS_BASE_W / 2.0) * Math.cos(ang)
      base_y = y + (GRASS_BASE_W / 2.0) * Math.sin(ang)

      # A blade is a narrow quad standing up
      p1 = pt(base_x, base_y, 0)
      p2 = pt(base_x + 0.3 * Math.sin(ang), base_y - 0.3 * Math.cos(ang), 0)
      p3 = pt(tip_x, tip_y, GRASS_HEIGHT)
      face = grp.entities.add_face(p1, p2, p3)
      next unless face
      face.material = COLOR_GRASS
      face.back_material = COLOR_GRASS
    end

    # Plume cap: a small disc at top
    cap = grp.entities.add_circle(top_center, [0, 0, 1], (GRASS_TOP_W / 2.0).inch, 12)
    cap_face = grp.entities.add_face(cap)
    cap_face.material = COLOR_GRASS_T if cap_face
    grp
  end

  # Flower: short stem + leafy base + bloom on top
  def self.build_flower(parent_group, x, y)
    grp = parent_group.entities.add_group
    grp.name = "Perennial Flower"

    # Leafy base (low green circle)
    base_center = pt(x, y, 0.5)
    leaf_circle = grp.entities.add_circle(base_center, [0,0,1], FLOWER_LEAF_R.inch, 10)
    leaf_face = grp.entities.add_face(leaf_circle)
    leaf_face.material = COLOR_LEAF if leaf_face

    # Stem (thin extruded line)
    stem_top = pt(x, y, FLOWER_STEM_H)
    stem = grp.entities.add_line(pt(x, y, 0), stem_top)
    stem.material = COLOR_LEAF if stem.respond_to?(:material=)

    # Bloom (small sphere approximated by stacked circles)
    head_center = pt(x, y, FLOWER_STEM_H + FLOWER_HEAD_R)
    head_circle = grp.entities.add_circle(head_center, [0,0,1], FLOWER_HEAD_R.inch, 12)
    head_face = grp.entities.add_face(head_circle)
    if head_face
      head_face.material = COLOR_FLOWER
      head_face.pushpull(2.5.inch)  # dome upward
      grp.entities.grep(Sketchup::Face).each do |f|
        f.material = COLOR_FLOWER if f.material.nil?
      end
    end

    grp
  end

  # Evenly distributes n plants along a 1D segment of length L,
  # centered (equal margins on both ends).
  def self.spaced_centers(length, count)
    return [] if count <= 0
    margin = (length - (count - 1) * (length / count.to_f)) / 2.0 # placeholder
    # Use equal-margin centering: positions = margin, margin+step, ...
    step = (length - 2 * (length / (count * 2.0))) / [count - 1, 1].max
    # Simpler: divide segment so each plant gets equal share
    share = length / count.to_f
    (0...count).map { |i| share * (i + 0.5) }
  end

  # ---------- MAIN BUILD -----------------------------------------------------

  def self.build!
    model = Sketchup.active_model
    model.start_operation("Build Landscape Plan", true)
    begin
      # Set units to architectural inches if possible
      model.options["UnitsOptions"]["LengthUnit"] = 0   # inches
      model.options["UnitsOptions"]["LengthFormat"] = 1 # architectural

      # Layers
      layer_ground   = add_layer(model, "01_Ground")
      layer_fence    = add_layer(model, "02_Fence")
      layer_bed      = add_layer(model, "03_Bed_Mulch")
      layer_grass    = add_layer(model, "04_Grasses")
      layer_flower   = add_layer(model, "05_Flowers")
      layer_dims     = add_layer(model, "06_Annotations")

      ents = model.active_entities

      # ----- 1. Ground plane (lawn) -----
      lawn_pts = [
        pt(-24, -24, 0),
        pt(LEFT_LEN + MID_LEN + RIGHT_LEN + 24, -24, 0),
        pt(LEFT_LEN + MID_LEN + RIGHT_LEN + 24, BED_DEPTH + STEP_DEPTH + 120, 0),
        pt(-24, BED_DEPTH + STEP_DEPTH + 120, 0)
      ]
      lawn_face = ents.add_face(lawn_pts)
      lawn_face.material = COLOR_GROUND
      lawn_face.back_material = COLOR_GROUND
      lawn_face.layer = layer_ground

      # ----- 2. Fence (stepped) -----
      fence_grp = ents.add_group
      fence_grp.name = "Fence"
      fence_grp.layer = layer_fence

      # Three fence panels. Each: a thin box FENCE_T thick.
      # Left:   x in [0, LEFT_LEN], y in [-FENCE_T, 0]
      # Middle: x in [LEFT_LEN, LEFT_LEN+MID_LEN], y in [STEP_DEPTH-FENCE_T, STEP_DEPTH]
      # Right:  x in [LEFT_LEN+MID_LEN, LEFT_LEN+MID_LEN+RIGHT_LEN], y in [-FENCE_T, 0]

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
        # Apply color to all faces of this panel
        group.entities.grep(Sketchup::Face).each do |f|
          f.material = COLOR_FENCE if f.material.nil?
        end
      end

      add_fence_panel(fence_grp, 0,                 LEFT_LEN,                       0)
      add_fence_panel(fence_grp, LEFT_LEN,          LEFT_LEN + MID_LEN,             STEP_DEPTH)
      add_fence_panel(fence_grp, LEFT_LEN + MID_LEN, LEFT_LEN + MID_LEN + RIGHT_LEN, 0)

      # Connector walls at the two step corners (so the fence looks continuous)
      # Step 1: from (LEFT_LEN, 0) outward to (LEFT_LEN, STEP_DEPTH)
      connector1 = [
        pt(LEFT_LEN - FENCE_T, 0, 0),
        pt(LEFT_LEN,           0, 0),
        pt(LEFT_LEN,           STEP_DEPTH, 0),
        pt(LEFT_LEN - FENCE_T, STEP_DEPTH, 0)
      ]
      f1 = fence_grp.entities.add_face(connector1)
      f1.reverse! if f1.normal.z < 0
      f1.pushpull(FENCE_H.inch)

      connector2 = [
        pt(LEFT_LEN + MID_LEN,           0, 0),
        pt(LEFT_LEN + MID_LEN + FENCE_T, 0, 0),
        pt(LEFT_LEN + MID_LEN + FENCE_T, STEP_DEPTH, 0),
        pt(LEFT_LEN + MID_LEN,           STEP_DEPTH, 0)
      ]
      f2 = fence_grp.entities.add_face(connector2)
      f2.reverse! if f2.normal.z < 0
      f2.pushpull(FENCE_H.inch)

      fence_grp.entities.grep(Sketchup::Face).each do |f|
        f.material = COLOR_FENCE if f.material.nil?
      end

      # ----- 3. Planting bed (mulch) -----
      bed_grp = ents.add_group
      bed_grp.name = "Planting Bed (Mulch)"
      bed_grp.layer = layer_bed

      # Bed is a stepped strip 30" deep in front of each fence panel.
      # We build it as one continuous face by tracing the outline.
      bed_outline = [
        pt(0, 0, 0.1),
        pt(LEFT_LEN, 0, 0.1),
        pt(LEFT_LEN, STEP_DEPTH, 0.1),
        pt(LEFT_LEN + MID_LEN, STEP_DEPTH, 0.1),
        pt(LEFT_LEN + MID_LEN, 0, 0.1),
        pt(LEFT_LEN + MID_LEN + RIGHT_LEN, 0, 0.1),
        pt(LEFT_LEN + MID_LEN + RIGHT_LEN, BED_DEPTH, 0.1),
        pt(LEFT_LEN + MID_LEN, BED_DEPTH, 0.1),
        pt(LEFT_LEN + MID_LEN, BED_DEPTH + STEP_DEPTH, 0.1),
        pt(LEFT_LEN, BED_DEPTH + STEP_DEPTH, 0.1),
        pt(LEFT_LEN, BED_DEPTH, 0.1),
        pt(0, BED_DEPTH, 0.1)
      ]
      bed_face = bed_grp.entities.add_face(bed_outline)
      bed_face.material = COLOR_BED if bed_face
      bed_face.back_material = COLOR_BED if bed_face

      # ----- 4. Plant placement -----
      grass_grp = ents.add_group
      grass_grp.name = "All Grasses"
      grass_grp.layer = layer_grass

      flower_grp = ents.add_group
      flower_grp.name = "All Flowers"
      flower_grp.layer = layer_flower

      # Section definitions:
      # [x_start, x_end, y_back_of_bed, y_front_of_bed, n_grasses, n_flowers, label]
      sections = [
        [0,                  LEFT_LEN,                       0,          BED_DEPTH,          5,  11, "Left"],
        [LEFT_LEN,           LEFT_LEN + MID_LEN,             STEP_DEPTH, STEP_DEPTH + BED_DEPTH, 5, 10, "Middle"],
        [LEFT_LEN + MID_LEN, LEFT_LEN + MID_LEN + RIGHT_LEN, 0,          BED_DEPTH,          7,  15, "Right"]
      ]

      sections.each do |x1, x2, y_back, y_front, n_g, n_f, label|
        seg_len = x2 - x1

        # Grasses: y = y_back + GRASS_OFFSET_FROM_FENCE
        gy = y_back + GRASS_OFFSET_FROM_FENCE
        spaced_centers(seg_len, n_g).each do |dx|
          build_grass(grass_grp, x1 + dx, gy)
        end

        # Flowers: y = y_front - FLOWER_OFFSET_FROM_EDGE  (8" off front lawn edge)
        fy = y_front - FLOWER_OFFSET_FROM_EDGE
        spaced_centers(seg_len, n_f).each do |dx|
          build_flower(flower_grp, x1 + dx, fy)
        end
      end

      # ----- 5. Dimension annotations -----
      dim_grp = ents.add_group
      dim_grp.name = "Dimensions"
      dim_grp.layer = layer_dims

      def self.add_dim(group, p1, p2, label_text)
        # Visual line + text. SketchUp's DimensionLinear is the proper way,
        # but it's awkward from Ruby; we draw a guide line + text instead.
        group.entities.add_cline(p1, p2)
        mid = Geom::Point3d.linear_combination(0.5, p1, 0.5, p2)
        text = group.entities.add_text(label_text, mid)
        text
      end

      # Section length labels (below the lawn)
      label_y = -18
      add_dim(dim_grp,
        pt(0, label_y, 0),
        pt(LEFT_LEN, label_y, 0),
        "Left: 168\"  (5 grasses, 11 flowers)")
      add_dim(dim_grp,
        pt(LEFT_LEN, label_y, 0),
        pt(LEFT_LEN + MID_LEN, label_y, 0),
        "Middle: 153\"  (5 grasses, 10 flowers)")
      add_dim(dim_grp,
        pt(LEFT_LEN + MID_LEN, label_y, 0),
        pt(LEFT_LEN + MID_LEN + RIGHT_LEN, label_y, 0),
        "Right: 228\"  (7 grasses, 15 flowers)")

      # Step depth label
      add_dim(dim_grp,
        pt(LEFT_LEN - 6, 0, 0),
        pt(LEFT_LEN - 6, STEP_DEPTH, 0),
        "Step: 33\"")

      # Bed depth label
      add_dim(dim_grp,
        pt(-6, 0, 0),
        pt(-6, BED_DEPTH, 0),
        "Bed: 30\"")

      # Title
      title_pt = pt(LEFT_LEN + MID_LEN / 2.0, BED_DEPTH + STEP_DEPTH + 60, 0)
      title = dim_grp.entities.add_text(
        "Backyard Fence Line Landscape Plan\n" \
        "Total: ~46 ft  |  17 Karl Foerster grasses  |  36 perennials\n" \
        "Grasses 32\" o.c., 6\" off fence  |  Flowers 14\" o.c., 8\" off lawn edge",
        title_pt)

      model.commit_operation
      model.active_view.zoom_extents

      puts "============================================================"
      puts "Landscape plan built successfully."
      puts "  17 grasses, 36 flowers placed."
      puts "  Layers: 01_Ground, 02_Fence, 03_Bed_Mulch,"
      puts "          04_Grasses, 05_Flowers, 06_Annotations"
      puts "  Toggle layers from Window > Default Tray > Tags."
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
