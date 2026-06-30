# 2D Polygons and Lines

A demo of solid and textured 2D polygons and lines using
[Polygon2D](https://docs.godotengine.org/en/stable/classes/class_polygon2d.html) and
[Line2D](https://docs.godotengine.org/en/stable/classes/class_line2d.html).

In this project, solid Line2Ds are antialiased by using a specially crafted texture.
By using a texture that is solid white on all its pixels except the top and bottom edges
(which are fully transparent white), the border appears smooth thanks to bilinear filtering.
A more extensive variation of this concept (which works better with variable-width lines) can be found
in the unofficial
[Antialiased Line2D add-on](https://github.com/godot-extended-libraries/godot-antialiased-line2d).

2D multisample antialiasing (MSAA) is also supported when using the Forward+ and Mobile rendering
methods. This is a slower approach, but it works on all 2D drawing performed within the viewport,
including Polygon2D nodes or [custom drawing](https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html).
This approach can be used at the same time as the aforementioned Line2D antialiasing technique.

Language: GDScript

Renderer: Mobile

## Screenshots

![Screenshot](screenshots/polygons_lines.webp)

## How to Learn This Project

> Part of **Ch. 2 – Custom Drawing & Vector Graphics** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches
The **node-based** counterpart to `custom_drawing`: instead of calling `draw_*` from code, you place **`Polygon2D`** and **`Line2D`** nodes in the scene and configure their properties in the Inspector. It showcases solid and textured polygons (including UV-mapped and "inverted" cut-out polygons) and lines with variable width, gradients, textures, and joints — plus two techniques for smoothing their edges.

### Key nodes & classes to understand
- **`Polygon2D`** — a filled, optionally textured polygon defined by a `polygon` point array. Properties to study: `color`, `texture` + `uv` (texture mapping), `texture_offset`, `antialiased`, and **`invert_enabled` / `invert_border`** (fills everything *except* the polygon, like a cut-out stencil).
- **`Line2D`** — a thick, styled polyline. Properties to study, each best understood by comparing the sibling line nodes in the scene:
  - `width` and **`width_curve`** (`Curve` resource) — taper a line along its length.
  - **`gradient`** (`Gradient` resource) — color the line along its length.
  - `texture` + **`texture_mode`** (`LINE_TEXTURE_STRETCH` / `LINE_TEXTURE_TILE`) — wrap an image along the line.
  - `joint_mode` (sharp / bevel / round), `begin_cap_mode` / `end_cap_mode` (none / box / round), `round_precision`, `sharp_limit` — how corners and ends are shaped.
- **The crafted line textures** (`line_10px.png`, `line_30px.png`) — the clever bit: a texture that is solid white everywhere except fully-transparent top/bottom edges. Bilinear filtering blurs those edges, so the line border renders smooth without MSAA. (The same trick, generalized, lives in the antialiased Line2D add-on linked in the README above.)
- **2D MSAA** — the second antialiasing approach (`get_viewport().msaa_2d`), toggled by the on-screen `OptionButton`. It works on *all* 2D drawing but only on the Forward+/Mobile renderers.
- **`Camera2D`** — frames the otherwise off-center shapes.
- Sub-resources to notice in the scene: `FastNoiseLite` → `NoiseTexture2D` (the textured polygon's image), `Gradient` / `GradientTexture2D`, and `Curve`.

### Recommended reading order
1. **`polygons_lines.tscn`** — almost everything lives here. Read the nodes top-to-bottom and group them:
   - `Polygon2DInvertedTextured` / `Polygon2DInverted` — same outline, one textured; note `invert_enabled` + `invert_border`.
   - `Polygon2DTextured` / `Polygon2D` — a complex organic shape; compare their `polygon` vs `uv` arrays to see how UV mapping pins the texture to the outline.
   - The four `Line2D…` nodes — compare them pairwise: `Line2DVariableWidthColor` vs `Line2DTexturedVariableWidthColor` (different `texture`/`texture_mode`), and `Line2DSharpNone` vs `Line2DBevelBox` vs `Line2DRoundRound` (identical points, different `joint_mode`/cap modes). This is the fastest way to learn what each property does.
2. **The `[sub_resource]` blocks at the top** — `Curve` (the width taper), the two `Gradient`s, the `NoiseTexture2D`. These are the data feeding the node properties.
3. **`polygons_lines.gd`** — tiny. `_ready()` hides the MSAA control and shows `UnsupportedLabel` when running on `gl_compatibility` (MSAA 2D isn't supported there); `_on_msaa_option_button_item_selected()` sets `get_viewport().msaa_2d`.

### Hands-on exercise
1. Duplicate one of the three corner-mode line nodes and give it a `width_curve` so it tapers to a point at both ends — a "brush stroke."
2. Take `Polygon2DTextured` and edit its `uv` array in the Inspector; watch how the texture slides/rotates across the shape.
3. Toggle `invert_enabled` off and on (and change `invert_border`) on one of the inverted polygons to see the cut-out effect flip.
