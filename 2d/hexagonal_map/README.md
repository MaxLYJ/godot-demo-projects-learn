# Hexagonal Game

Very simple demo showing a hexagonal TileMap and TileSet.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2717

## Screenshots

![Screenshot](screenshots/hex.png)

## How to Learn This Project

> Part of **Ch. 3 – Tilemaps** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches
The smallest possible **non-square tilemap**: a flat-top hex grid with a single character that walks around. By stripping away lighting, depth sorting, and multiple layers, it isolates the two things that actually change when your grid is hexagonal — the `TileSet` shape settings, and how you scale the vertical input axis to match the projection.

> **Note:** the upstream text calls it a `TileMap`; the scene now uses a **`TileMapLayer`** node, and the hex *shape* is defined on the shared **`TileSet`**.

### Key nodes & classes to understand
- **`TileSet` (hexagonal)** — in `tileset.tres`: `tile_shape = HEXAGON`, `tile_offset_axis = OFFSET_AXIS_VERTICAL` (flat-top hexes that offset vertically column-to-column), `tile_size = 110×94`. This is the only place the "hex-ness" is configured.
- **`TileMapLayer`** — `map.tscn` has exactly one layer (plus the `Troll` instance). Contrast this with the isometric demo's many layers — minimal on purpose.
- **`CharacterBody2D` (troll)** — `troll.gd` reads the `move_*` axes, then **scales the vertical axis by `tan(30°)`** (`motion.y *= TAN30DEG`, ≈ 0.577) *before* normalizing, so up/down movement matches the compressed height of a hex grid (the hex counterpart of the isometric demo's `motion.y /= 2`).
- **Acceleration + friction movement** — unlike the isometric goblin (which sets velocity directly), the troll *accumulates* velocity (`velocity += motion.normalized() * MOTION_SPEED`) and then **decays it** each tick (`velocity *= FRICTION_FACTOR`, 0.89). The result is a momentum/inertia feel: release the keys and the troll coasts to a stop instead of halting instantly.
- **`troll.tscn` node tree** — a `Sprite2D` body, a blob `Shadow` `Sprite2D`, a `CollisionShape2D` with a `CircleShape2D`, and a `Camera2D` (`process_callback` physics). In `map.tscn` the instance is HDR-brightened (`modulate = Color(1.5, 1.5, 1.5)`, which reads >1.0 only on Forward+/Mobile).

### Recommended reading order
1. **`tileset.tres`** — read first to see `tile_shape = HEXAGON` and `tile_offset_axis`. The grid shape lives here, not in the scene.
2. **`troll.gd`** — the whole demo in ~15 lines. Read the input lines, the `motion.y *= TAN30DEG` hex correction, then the `velocity += …` / `velocity *= FRICTION_FACTOR` friction loop and `move_and_slide()`.
3. **`troll.tscn`** — the character tree: `Sprite2D`, `Shadow`, `CircleShape2D` collider, `Camera2D`.
4. **`map.tscn`** — one `TileMapLayer` (opaque `tile_map_data`) plus the `Troll` instance with its brightened `modulate`. Notice how little there is compared to the isometric dungeon.
5. **`tileset_edit.tscn`** — open in Godot to see how the hex tiles and their properties were authored.

### Hands-on exercise
1. In `troll.gd`, comment out `motion.y *= TAN30DEG` and run — vertical movement will overshoot the hex grid, showing why that scaling is needed.
2. Swap the movement feel: replace the `velocity += …` / `velocity *= FRICTION_FACTOR` lines with the isometric goblin's instant-velocity style (`velocity = motion.normalized() * MOTION_SPEED`) and feel the difference in control.
3. Change `tile_offset_axis` in the `TileSet` from vertical to horizontal (pointy-top hexes) and watch the whole grid re-orient — then re-tune `TAN30DEG` if movement feels off on the new axis.
