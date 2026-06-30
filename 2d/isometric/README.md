# Isometric Game

This demo shows a traditional isometric view with depth sorting.

A character can move around the level and will also slide around objects,
as well as be occluded when standing in front or behind them.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2718

## How does it work?

The level uses a [`TileMap`](https://docs.godotengine.org/en/latest/classes/class_tilemap.html#class-tilemap)
in which the tiles have different vertical offsets.
The walls, doors, and pillars each have
[`StaticBody2D`](https://docs.godotengine.org/en/latest/classes/class_staticbody2d.html)
and [`CollisionPolygon2D`](https://docs.godotengine.org/en/latest/classes/class_collisionpolygon2d.html)
at their base. The player also has a collider at its base,
which makes the player collide with the level.

2D lighting effects are achieved using a mixture of PointLight2D nodes (which provide real-time shadows)
and pre-placed Polygon2Ds with sprites. To provide additional ambient shading, the goblin also has a blob
shadow below its feet (a Sprite2D with a texture).

## Screenshots

![Screenshot](screenshots/isometric.webp)

## How to Learn This Project

> Part of **Ch. 3 – Tilemaps** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches
How to build a **depth-sorted isometric world** — everything needed to make flat tiles read as a 3D-looking space: a diamond-shaped `TileSet`, correct draw order via Y-sorting, collision baked into the tile data, 8-direction character movement and animation matched to the isometric projection, and real-time 2D lighting with shadows. It is the richest single tilemap demo in the repo and the natural place to study how all these systems cooperate in one scene.

> **Note:** the upstream text above calls the grid a `TileMap`, but the scene has been migrated to Godot 4's **`TileMapLayer`** node (one layer per node). The grid *shape* is configured on the shared **`TileSet`** resource.

### Key nodes & classes to understand
- **`TileSet` (isometric)** — open `tileset/tileset.tres`: `tile_shape = ISOMETRIC`, `tile_layout = DIAMOND_RIGHT`, `tile_size = 128×64` (a 2:1 ratio — the signature of iso tiles). It also carries a **physics layer** (`physics_layer_0/collision_layer = 1`) so wall/door/pillar tiles collide, plus per-tile polygons and occluders.
- **`TileMapLayer`** — the world (`dungeon.tscn`) is built from several of these — `Floor/Layer0`, `Walls/TileMapLayer`, `HighWalls`, `HighWalls2` — all sharing the one `TileSet`. Splitting walls across multiple layers is what lets tall objects render *above* the floor and player.
- **Y-sorting** — the engine's depth trick. Every sorting group (`Floor`, `Walls`) sets `y_sort_enabled = true` on both the layer *and* its parent `Node2D`, and each layer sets `y_sort_origin = 32`. That origin is the key detail: it tells the sorter to compare tiles/objects by a point near their *base* (where they meet the ground), so a pillar sorts in front of a goblin standing behind it and behind one standing in front.
- **`CharacterBody2D` (goblin)** — `player/goblin.gd` reads the four `move_*` input actions, builds a vector, and **halves the vertical axis** (`motion.y /= 2`) *before* normalizing so diagonal movement lands correctly on the iso grid. `move_and_slide()` makes the goblin slide along walls instead of sticking.
- **8-direction animation** — `goblin.gd` keeps an `anim_directions` dictionary of 8 entries (one per 45° slice) for both `idle` and `walk`. `update_animation()` converts the last movement vector to an angle, adds 22.5°, and does `floor(angle / 45)` to pick the right slice — a compact way to drive an `AnimatedSprite2D` from any facing direction.
- **`goblin.tscn` node tree** — `Shadow` (a blob `Sprite2D` using a radial `GradientTexture2D`), the `AnimatedSprite2D` (16 animations: 8 directions × idle/walk), a `CollisionShape2D` with a rotated `CapsuleShape2D` placed at the feet, a `Camera2D` (`process_callback` physics), and a `LightOccluder2D` so the goblin casts shadows from scene lights.
- **2D lighting** — under `Ambient` in `dungeon.tscn`: `PointLight2D` nodes with `shadow_enabled = true` and `shadow_filter`, `LightOccluder2D` nodes whose polygons block that light, `light_mask` controlling which sprites each light touches, and `CanvasItemMaterial` with `light_mode = 1` (lit) or `blend_mode = 1` (additive glow). The pre-placed `Polygon2D` "external shadows" are darkened, light-reactive decals.

### Recommended reading order
1. **`project.godot`** — note `physics/common/physics_ticks_per_second = 120` and `physics_interpolation = true` (smooth motion), plus the four `move_*` input actions under `[input]`.
2. **`tileset/tileset.tres`** — skim the `TileSet` header to see `tile_shape` / `tile_layout` / `tile_size` and the physics layer. This is where the "isometric-ness" actually lives.
3. **`player/goblin.tscn`** — the character. Trace the node tree: `Shadow`, `AnimatedSprite2D`, `CollisionShape2D` (rotated capsule at the feet), `Camera2D`, `LightOccluder2D`.
4. **`player/goblin.gd`** — only ~55 lines. Read `_physics_process()` (input → `motion.y /= 2` → `move_and_slide`) then `update_animation()` (angle → 45° slice → `play()` + `flip_h`).
5. **`dungeon.tscn`** — the world. Don't read top-to-bottom; jump between the layer groups: `Floor` (glow sprites + floor `TileMapLayer`), `Walls` (wall `TileMapLayer`, collision decorations, the `Goblin` instance), `HighWalls`, then `Decorations` and `Ambient` (the lights and occluders). Notice how `y_sort_enabled` repeats at each level.
6. **`tileset/tileset_edit.tscn`** — the editor scene used to author the `TileSet`; open it in Godot to see how individual tiles get their collision polygons, occluders, and Y-sort origins painted.

### Hands-on exercise
1. In `goblin.gd`, change `motion.y /= 2` to `/ 1` (or remove the line) and run — the goblin will move too fast vertically relative to the tiles, which makes the role of that single line viscerally clear.
2. Make the goblin face a finer 16 directions instead of 8: extend `anim_directions` to 16 entries and change the slice math to `floor((angle + 11.25) / 22.5) % 16`. (You'll need 16 walk + 16 idle animation sets to actually see it.)
3. Add a second `PointLight2D` as a child of the `Goblin` node so the character carries its own moving light source, and confirm the `LightOccluder2D` on the walls correctly shadows it.
