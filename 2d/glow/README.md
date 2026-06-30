# Glow for 2D

This showcases how to use glow in a 2D game via the WorldEnvironment node.

Slide the cave image left and right to observe the glow effect at work. Press <kbd>G</kbd>
to toggle the glow map (lens dirt) effect.

The Label is on a separate CanvasLayer, so that it is not affected by glow.

Language: GDScript

Renderer: Mobile

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2715

## Screenshots

![Screenshot](screenshots/left.png)

![Screenshot](screenshots/right.png)

## How to Learn This Project

> Part of **Ch. 6 – Shaders & Lighting** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

**The glow (bloom) effect you *don't* write yourself.** Unlike the hand-coded shaders elsewhere in this chapter, bloom here comes entirely from a `WorldEnvironment` node holding an `Environment` resource with `glow_enabled = true` — Godot's renderer does the blurring and compositing. The demo's real lesson is *what feeds the bloom*: only pixels brighter than white (HDR values `> 1.0`) spill outward, so the bright beach sprite is `modulate = Color(2, 2, 2)`. It also shows a **glow map** — a "lens dirt" texture that masks *where* the bloom is allowed to appear — and the importance of putting UI on a separate `CanvasLayer` so the HUD text doesn't bloom too.

### Key nodes & classes to understand

- **`WorldEnvironment`** — the node that applies an `Environment` to the whole 2D/3D scene. This is where screen-space post effects live.
- **`Environment`** resource — `glow_enabled`, the **`glow_levels`** (per-mip bloom strengths; here levels 5/6/7 carry the bloom), `glow_intensity`, and `glow_map` (the lens-dirt mask texture); plus **tonemapping** (`tonemap_mode = 4` = AGX with `tonemap_agx_contrast`) that compresses the HDR result back to a displayable range *after* glow.
- **HDR overbright** — `modulate`/`self_modulate = Color(2, 2, 2)` pushes the sprite above white. This only reads as `> 1.0` (and thus blooms) on the **Mobile/Forward+** renderer; a Compatibility demo could not bloom this way, which is why this project uses Mobile.
- `Environment.background_mode = BG_CANVAS` — lets the 3D environment show the 2D canvas behind it.
- **`CanvasLayer`** — the HUD `Label` lives on one so the glow pass skips it.
- `beach_cave.gd` — toggles the glow map at runtime (`environment.glow_map = …`) and compensates by **doubling `glow_intensity`** when the darkening map is on, and pans the `Cave` sprite by dragging.

### Recommended reading order

1. `beach_cave.tscn` — read the node tree: `Beach` Sprite2D (note `modulate = Color(2,2,2)` and the `region_rect`), the darker `Cave` Sprite2D, `WorldEnvironment`, `Camera2D`, and the `CanvasLayer`/`Label` for the instructions.
2. The `WorldEnvironment`'s `Environment` sub-resource — the heart of the demo. Note `glow_enabled`, the three `glow_levels`, `glow_intensity`, the AGX `tonemap_mode`, and `background_mode`.
3. `beach_cave.gd` — short. See `_unhandled_input`: the mouse-drag pans `cave.position.x` (clamped), and the `toggle_glow_map` action swaps the glow map on/off and rebalances `glow_intensity` (0.8 ↔ 1.6).
4. `project.godot` — the `[input]` section defines `toggle_glow_map`, and `renderer/rendering_method = "mobile"` confirms why HDR bloom works here.

### Hands-on exercise

1. With the project running, press <kbd>G</kbd> to toggle the glow map and drag the cave left/right — watch how the bloom only leaks past the cave edge where the bright beach shows, and how the lens-dirt map confines it.
2. In the editor, lower the `Beach` sprite's `modulate` back to `Color(1, 1, 1)` and re-run: the bloom should largely disappear, proving that HDR overbright is what drives it.
3. Stretch goal: add a second overbright element (e.g. a `Sprite2D` with `modulate = Color(3, 3, 3)`) and tune `glow_levels` so *only* that element blooms strongly while the beach stays subtle — demonstrating per-level bloom tuning.
