# Custom drawing in 2D

A demo showing how to draw 2D elements in Godot without using nodes. This can be done
to create procedural graphics, perform debug drawing to help troubleshoot issues in
game logic, or to improve performance by not creating a node for every visible element.

Antialiasing can be performed using two approaches: either by enabling the `antialiasing`
parameter provided by some of the CanvasItem `draw_*` methods, or by enabling 2D MSAA
in the Project Settings. 2D MSAA is generally slower, but it works with any kind of line-based
or polygon-based 2D drawing, even for `draw_*` methods that don't support an `antialiasing`
parameter. Note that 2D MSAA is only available in the Forward+ and Mobile
renderers, not Compatibility.

See [Custom drawing in 2D](https://docs.godotengine.org/en/latest/tutorials/2d/custom_drawing_in_2d.html)
in the documentation for more information.

Language: GDScript

Renderer: Mobile

## Screenshots

![Screenshot](screenshots/custom_drawing.webp)

## How to Learn This Project

> Part of **Ch. 2 – Custom Drawing & Vector Graphics** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches
The complete catalog of **procedural 2D drawing** — rendering shapes, textures, text, and animations purely from code with the `CanvasItem.draw_*` methods, instead of placing `Sprite2D` or `Polygon2D` nodes. The UI is a `TabContainer` where each tab (`Panel`) is one category (Lines, Rectangles, Polygons, Meshes, Textures, Text, Animation), and each tab has its own `@tool` script that overrides `_draw()`. It is the reference manual for "I want to draw X with code."

### Key nodes & classes to understand
- **`_draw()` and `queue_redraw()`** — the core contract. `_draw()` runs *once* and the result is cached; the only way to redraw is to call `queue_redraw()` (see `animation.gd` doing it every frame in `_process()`).
- **`@tool`** — makes the `_draw()` output visible *inside the editor*, not just at runtime, so you can see each tab's output without pressing Play.
- The `draw_*` families, grouped by tab:
  - *Lines* (`lines.gd`): `draw_line()`, `draw_dashed_line()`, `draw_circle()` (filled vs. outline), `draw_arc()`, and the `TAU` constant (a full turn in radians).
  - *Rectangles* (`rectangles.gd`): `draw_rect()`, `draw_style_box()` with a hand-built `StyleBoxFlat`.
  - *Polygons* (`polygons.gd`): `draw_primitive()`, `draw_polygon()` / `draw_colored_polygon()` (multi-color vertex blending), `draw_polyline()` / `draw_polyline_colors()`, `draw_multiline()` / `draw_multiline_colors()` (batched, disconnected segments).
  - *Meshes* (`meshes.gd`): `draw_mesh()` with a `TextMesh`/`SphereMesh`, and `draw_multimesh()` with a `MultiMesh` for many instances in one call.
  - *Textures* (`textures.gd`): `draw_texture()`, `draw_texture_rect()` (tile/stretch), `draw_texture_rect_region()` (a sub-rectangle of a texture).
  - *Text* (`text.gd`): `draw_char()` (manual glyph advance via `TextServerManager`), `draw_string()`, `draw_string_outline()` (outline must be drawn *before* the fill).
  - *Animation* (`animation.gd`, `animation_slice.gd`): a `time` variable + `queue_redraw()` for continuous motion, and `draw_animation_slice()` for frame-based cel animation.
- **`draw_set_transform()` / `draw_set_transform_matrix()`** — *stateful* commands that translate/rotate/scale/skew every subsequent `draw_*` call until reset with `draw_set_transform(Vector2())`. Several scripts rely on these because `draw_rect()`, `draw_primitive()`, etc. have no rotation parameter.
- **Antialiasing** — two approaches controlled by the bottom bar in `custom_drawing.gd`: the per-command `antialiasing` argument (labels highlighted in green support it) vs. viewport-wide 2D MSAA (`get_viewport().msaa_2d`). MSAA works on every line/polygon but only exists on Forward+/Mobile.
- **Holding resource references** — `meshes.gd` keeps its `TextMesh`, `NoiseTexture2D`, etc. as member variables; if it didn't, they'd be freed and the renderer couldn't draw them.

### Recommended reading order
1. **`custom_drawing.tscn`** — the scene *is* the table of contents. Read the `TabContainer` children: seven `Panel`s, each with a `script = ExtResource(...)` and a green `Label` listing that tab's `draw_*` functions. Note the two `[connection ...]` lines wiring the MSAA `OptionButton` and the antialiasing `CheckButton` to the root.
2. **`custom_drawing.gd`** (root) — only ~15 lines. `_on_msaa_2d_item_selected()` sets `get_viewport().msaa_2d`; `_on_draw_antialiasing_toggled()` flips `use_antialiasing` on every tab and calls `queue_redraw()` — a clean example of propagating one setting across many nodes.
3. **`lines.gd`** — start here for the fundamentals: `draw_line`, `draw_circle`, `draw_arc`, plus the first use of `draw_set_transform()` to stretch a circle. Watch how `offset += Vector2(...)` lays shapes out in a row.
4. **`rectangles.gd`** then **`polygons.gd`** — same pattern, new shapes. `rectangles.gd` introduces `draw_set_transform_matrix()` for skewing; `polygons.gd` shows multi-color vertex interpolation.
5. **`textures.gd`** and **`text.gd`** — drawing images and fonts. `text.gd`'s per-character loop with `TextServerManager` is the most intricate; skim it.
6. **`meshes.gd`** — the most advanced static tab: `_ready()` configures resources, `_draw()` places them. Notice the Y-flip (`Vector2(1, -1)`) so the `TextMesh` reads upright.
7. **`animation.gd` + `animation_slice.gd`** — read together. `animation.gd`'s `_process()` → `queue_redraw()` loop is the canonical "animate via `_draw`" pattern; `animation_slice.gd` shows frame slicing with `remap()`.

### Hands-on exercise
1. In `lines.gd`, add a new `draw_arc()` that sweeps a full circle (`0` to `TAU`) and color it with a `Color.from_hsv()` so it forms a rainbow ring.
2. Turn `animation.gd` into a real circular progress bar: make the arc's sweep length grow from empty to full over ~2 seconds, then loop.
3. Add an eighth tab (`Panel` + new `@tool` script) that draws a grid of `draw_rect` cells whose colors are driven by a `FastNoiseLite` value — a tiny procedural terrain preview.
