# Navigation Polygon 2D

Example of using 2D navigation using:
- [`NavigationRegion2D`](https://docs.godotengine.org/en/latest/classes/class_navigationregion2d.html)
- [`NavigationPolygon`](https://docs.godotengine.org/en/latest/classes/class_navigationpolygon.html)
- [`NavigationAgent2D`](https://docs.godotengine.org/en/latest/classes/class_navigationagent2d.html)

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2722

## Screenshots

![Screenshot](screenshots/navigation.png)

## How to Learn This Project

> Part of **Ch. 5 – Navigation & Pathfinding** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

The **high-level, node-driven face of Godot 2D navigation.** A character walks to wherever you click, routing *around* obstacles automatically. The clever part is that your script never runs any pathfinding math: you hand a destination to a `NavigationAgent2D`, and each frame it hands you back the next waypoint along a path that `NavigationServer2D` computed for you over an editor-baked `NavigationPolygon`. This demo is the cleanest possible "I want a clickable moving character" recipe, and the foundation every other navigation demo builds on or departs from.

### Key nodes & classes to understand

- `NavigationPolygon` — a resource describing the **walkable surface** as a polygon (with obstacle "holes" cut out). Here it was baked in the editor and saved as `navigation_polygon.res`; double-click it in the FileSystem dock to see the green walkable outline.
- `NavigationRegion2D` — the node that **registers** a `NavigationPolygon` with `NavigationServer2D`, turning it into part of the world's navigation map.
- `NavigationAgent2D` — the per-actor **path requester/follower**. You set `target_position`; you read `get_next_path_position()` and `is_navigation_finished()`. Its `path_desired_distance` / `target_desired_distance` tune how close the agent must get to a waypoint before advancing, and `debug_enabled` draws the live path.
- `CharacterBody2D` + `move_and_slide()` — the actor. The navigation loop is just `velocity = position.direction_to(next_path_position) * speed` then `move_and_slide()`.
- `NavigationServer2D` — the engine service doing the actual A* search over the navmesh. The nodes above are conveniences on top of it; you don't call it directly here (5.3 does).
- The custom **`click` input action** — defined in *Project Settings → Input Map*, mapped to the left mouse button, and read in `_unhandled_input`.

### Recommended reading order

1. `navigation.tscn` — read the node tree first: a `Map` `Sprite2D`, the `NavigationRegion2D` (note its `navigation_polygon` ext-resource pointing at the baked `.res`), and the instanced `Character`. Open `navigation_polygon.res` in the editor to *see* the walkable polygon the demo routes over.
2. `character.tscn` — the reusable character: a `CharacterBody2D` with `Sprite2D` + `CollisionShape2D` + a `NavigationAgent2D` child. The agent is a **child of the moving body** — that's how it tracks the actor's position.
3. `character.gd` — the whole demo in ~40 lines. Read `_ready()` (tune the agent's desired distances + enable debug), `_unhandled_input()` (click → `set_movement_target`), `set_movement_target()` (one line: `navigation_agent.target_position = …`), and `_physics_process()` (the `is_navigation_finished` guard → `direction_to(get_next_path_position())` → `move_and_slide`).
4. `project.godot` — the `[input]` section shows how the `click` action is defined, and `[physics]` shows 120 Hz ticks + interpolation for smooth motion.

> **The one-line contract:** set `target_position`, then steer toward `get_next_path_position()` each frame until `is_navigation_finished()`. That is all the navigation API you need for most games.

### Hands-on exercise

1. With `debug_enabled = true`, click into the "dead-end" corners of the map and watch the green debug path hug polygon edges — then turn debug off and confirm the character still routes correctly.
2. Add a second `NavigationObstacle2D` (or redraw `navigation_polygon.res` with a new hole in the editor) so a previously direct click now forces a detour. Observe the path recompute automatically.
3. Stretch goal: replace the single hardcoded `movement_speed` with slowing near the goal — when `global_position.distance_to(target_position)` drops below a threshold, scale speed down for a smooth "arrive and stop" instead of an abrupt halt.
