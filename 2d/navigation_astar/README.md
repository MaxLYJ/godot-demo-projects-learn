# Grid-based Navigation with AStarGrid2D

This is an example of using AStarGrid2D for navigation in 2D,
complete with Steering Behaviors in order to smooth the movement out.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2723

## Screenshots

![Screenshot](screenshots/navigation_astar.webp)

## How to Learn This Project

> Part of **Ch. 5 – Navigation & Pathfinding** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

A **grid-based pathfinder that bypasses the NavigationServer2D entirely.** There is no navmesh and no `NavigationAgent2D` here — a `TileMapLayer` script owns an `AStarGrid2D`, marks every painted tile as a solid obstacle, and returns a waypoint list on demand. The "character" is a plain `Marker2D` (not a physics body) that walks those waypoints with a hand-written **steering-behavior** integrator, so its turns curve smoothly instead of snapping. It is the deliberate counterpoint to 5.1: same goal, a fundamentally different (and often cheaper, grid-bound) tool.

### Key nodes & classes to understand

- `AStarGrid2D` — the **grid A\* solver**. Configured with a `region` (`Rect2i`), `cell_size`, `offset` (so waypoints land at tile centers), a heuristic (`HEURISTIC_MANHATTAN` for both compute and estimate), and `diagonal_mode = DIAGONAL_MODE_NEVER` (4-directional movement). `set_point_solid()` marks obstacles; `get_point_path(start, end)` returns the waypoint list.
- `TileMapLayer` (the pathfinder's host) — its painted cells *are* the obstacles. `get_used_cells()` feeds the solid-set; `local_to_map()` / `map_to_local()` convert between world and grid coordinates.
- `TileMapLayer._draw()` — overridden to paint the live path as connected lines + waypoint circles (the `queue_redraw()` calls in `find_path`/`clear_path` trigger it).
- `Marker2D` character — a non-physics node moved by **manual integration**: `position += velocity * delta`, with `rotation = velocity.angle()` so the ship faces its travel direction.
- **Steering behaviors** — the smoothing math in `_move_to()`: `steering = desired_velocity - velocity; velocity += steering / MASS`. `MASS` acts as inertia: higher values give lazier, wider turns.
- An `IDLE` / `FOLLOW` **state enum** driven by the `teleport_to` (right-click) and `move_to` (left-click) input actions; teleport also calls `round_local_position()` + `reset_physics_interpolation()` to snap cleanly to a tile.

### Recommended reading order

1. `pathfind_astar.gd` — the pathfinding engine. Read the `AStarGrid2D` setup in `_ready()` first (region, cell_size, heuristic, diagonal mode), then the `get_used_cells()` loop that marks obstacles solid, then `find_path()` / `clear_path()` / `is_point_walkable()` / `round_local_position()`, and finally `_draw()` for how the path is rendered.
2. `game.tscn` — note the structure: the `TileMapLayer` carries the `pathfind_astar.gd` script (so the map *is* the pathfinder), and the `Character` is a `Marker2D` (not a `CharacterBody2D`) with a `CPUParticles2D` trail and a `Sprite2D`.
3. `character.gd` — the steering follower. Read the `State` enum and constants, then `_change_state()` (how `FOLLOW` calls `_tile_map.find_path(...)` and skips the start cell), then `_physics_process()` (advance the waypoint list, removing `_path[0]` on arrival), and finally `_move_to()` for the steering math.
4. `project.godot` — the `[input]` section defines `teleport_to` (button 2) and `move_to` (button 1).

> **Why `AStarGrid2D` over a navmesh?** No editor baking step, obstacle data comes straight from your tilemap, and the search is cheap and perfectly grid-aligned. The trade-off: movement is constrained to grid centers and you write your own movement code. Reach for it for tile-based tactics games, grid RPGs, and puzzle boards.

### Hands-on exercise

1. In `pathfind_astar.gd`, change `diagonal_mode` from `NEVER` to `ALWAYS` and the heuristic from `MANHATTAN` to `EUCLIDEAN`, then watch the path cut diagonally across open tiles.
2. Add a new row of solid tiles to the `TileMapLayer` in the editor (or call `_astar.set_point_solid()` at runtime on a chosen cell) and confirm the path reroutes around it.
3. Stretch goal: the comment in `pathfind_astar.gd` hints at a TileSet **Custom Data Layer** for grouping tiles. Add a custom-data field and mark a tile type "slow" — then make the character reduce `speed` while standing on those tiles (you can also feed per-tile weights via `AStarGrid2D.set_point_weight_scale`).
