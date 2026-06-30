# Dynamic TileMap Layers

Example of how to make a fake wall using TileMap's
`_tile_data_runtime_update()` method. It shows how
to disable collisions per layer.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2713

## Note

The new TileMapLayer introduced in Godot 4.3 allows disabling collisions for a layer dynamically using a checkbox in the inspector.
For earlier Godot versions use the procedure described here.

## Screenshots

![Screenshot](screenshots/fake_wall.png)

## How to Learn This Project

> Part of **Ch. 3 – Tilemaps** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches
How to change **what a tile *does* while the game is running** — specifically, how to make a "fake wall": a solid-looking tile layer that turns semi-transparent and loses its collision when the player steps into a trigger zone, revealing a secret room. It is the chapter's runtime/scripting capstone and your introduction to per-frame `TileData` mutation.

> **Note:** the README above points out the modern shortcut — Godot 4.3+ `TileMapLayer` can disable a whole layer's collision with an Inspector checkbox. This demo instead shows the scriptable, per-tile technique using `TileMapLayer`'s runtime-update hooks, which still works and is far more flexible.

### Key nodes & classes to understand
- **`TileMapLayer` (scripted)** — `level/tile_map.gd` extends `TileMapLayer` directly and is attached to the `Secret` layer in `world.tscn`. The `Ground` layer next to it is a plain, always-solid layer.
- **`_use_tile_data_runtime_update(coords) → bool`** — Godot calls this to ask "should this tile be re-evaluated every physics frame?" Returning `true` (for every coord) opts the layer into runtime updates. Without it, the next hook never fires.
- **`_tile_data_runtime_update(coords, tile_data)`** — the actual per-frame mutation. Here it calls `tile_data.set_collision_polygons_count(0, 0)` to **delete the collision polygon** on physics layer 0, making the secret tiles non-solid so the player walks through. (Comment this line out and the player bonks against the secret wall even while it's faded.)
- **Layer fade animation** — `player_in_secret` toggles `_process()` on; `_process()` uses `move_toward()` to slide `layer_alpha` between `1.0` and `0.3` and applies it via `self_modulate = Color(1, 1, 1, layer_alpha)`. `self_modulate` (not `modulate`) fades only this layer, not its children. `set_process(false)` stops the work once the target alpha is reached.
- **`Area2D` "SecretDetector"** — in `world.tscn`, a trigger `Area2D` + `CollisionShape2D` sitting in the secret room. Its `body_entered` / `body_exited` signals are wired (see the `[connection ...]` block) to `_on_secret_detector_body_entered/exited` on the `Secret` layer, which flip `player_in_secret` and guard on `body is CharacterBody2D` so only the player triggers it.
- **Platformer player** — `player/player.gd` is a standard gravity side-scroller: `WALK_FORCE` / `STOP_FORCE` acceleration + `move_toward` deceleration, `gravity` pulled from `ProjectSettings`, `move_and_slide()`, and an `is_on_floor()` + `jump` check. It exists to give you a body that actually walks *into* the trigger and *through* the disabled wall.

### Recommended reading order
1. **`world.tscn`** — the layout: `Ground` (solid `TileMapLayer`), `Secret` (scripted `TileMapLayer` with `tile_map.gd`), a `Camera2D`, the `Player` instance, and the `SecretDetector` `Area2D`. Read the two `[connection ...]` lines at the bottom — they are the wiring that ties the trigger to the secret layer.
2. **`level/tile_map.gd`** — the heart of the demo (~50 lines). Read it top-to-bottom: `_use_tile_data_runtime_update` (opt-in) → `_tile_data_runtime_update` (strip collision) → `_process` (fade `self_modulate` via `move_toward`) → the two `_on_secret_detector_*` signal handlers.
3. **`player/player.gd`** then **`player/player.tscn`** — the platformer body (gravity, jump, `move_and_slide`) and its `RectangleShape2D` collider. You don't need to study it deeply; it's the trigger probe.
4. **`project.godot`** — confirm the renderer and the `move_*` / `jump` input actions.

### Hands-on exercise
1. In `tile_map.gd`, temporarily comment out `tile_data.set_collision_polygons_count(0, 0)` and run — the wall will still fade visually but the player will collide with the now-invisible solid, proving the collision strip is what actually makes it passable.
2. Change the trigger: instead of removing collision automatically on entry, flip a custom-data flag in `_tile_data_runtime_update` and require the player to press a key inside the area to reveal the secret.
3. Add a second `TileMapLayer` that starts *invisible* (`visible = false`) and only fades in (reusing the same `move_toward` alpha technique) when the secret is discovered — a revealed reward room.
