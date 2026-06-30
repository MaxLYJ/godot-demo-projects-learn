# 2D Physics Tests

This demo contains a series of tests for the 2D
physics engine.

They can be used for different purpose:

- Functional tests to check for regressions and
  behavior of the 2D physics engine
- Performance tests to evaluate performance
  of the 2D physics engine

Language: GDScript

Renderer: Mobile

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2726

## Screenshots

![Screenshot](screenshots/physics_tests.webp)

## How to Learn This Project

> Part of **Ch. 4 – 2D Physics** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

This is **not a game** — it is Godot's official 2D physics **test and benchmark harness** (Mobile renderer). It is the reference room for the whole engine: every body type, every collision shape, all three 2D joints, raycasting, one-way collisions, and stacking — plus performance benchmarks. Use it to *see* each physics primitive in isolation and to *measure* the engine under load. The concepts from the other physics demos (`kinematic_character`, `platformer`, `physics_platformer`) are all individually configurable here.

### Key nodes & classes to understand

- The **framework spine**: `tests.gd` (a hardcoded list of test scenes) → `utils/option_menu.gd` (a reusable `OptionMenu` that builds nested slash-path menus like `"Functional Tests/Shapes"`) → `tests_menu.gd` (loads a chosen `.tscn`, frees the previous one, and reparents the new test under `get_tree().root`).
- `test.gd` (`class_name Test`) — the **base class every test scene inherits**. It provides shared scaffolding: a one-shot `Timer`, `wait_for_physics_ticks(n)` (a physics-tick countdown that emits `wait_done`), debug-draw helpers (`add_line`/`add_circle`/`add_shape`), rigid-body factories (`create_rigidbody_box`, optionally with mouse-drag picking), and force-enables `debug_collisions_hint`.
- **Functional tests** (each isolates one concept): `test_shapes` (all collision shapes), `test_stack` / `test_pyramid` (resting/contact-solver stability), `test_collision_pairs` (`PhysicsDirectSpaceState2D.collide_shape()` + `PhysicsShapeQueryParameters2D`), `test_raycasting` (`intersect_ray()`, `hit_from_inside`, concave internal faces), `test_character` + its subclasses (`CharacterBody2D` vs `RigidBody2D` controllers incl. ray-shape variants and snap/stop-on-slope/constant-speed options), `test_one_way_collision` (a `@tool` harness that sweeps a one-way platform 0→345°), and `test_joints` (all three joints: `PinJoint2D`, `GrooveJoint2D`, `DampedSpringJoint2D`).
- **Performance tests**: `test_perf_broadphase` (add/move/remove **10,000 bodies** with `gravity_scale = 0` — pure broadphase throughput) and `test_perf_contacts` (contact-solving cost cycled across shape types). Both report per-physics-tick time in ms via `Time.get_ticks_usec()` to the on-screen `PanelLog`.
- **HUD & tuning** (`utils/`): `label_fps` (`Engine.get_frames_per_second()`), `label_engine` (which physics engine is active), and sliders for `Engine.physics_ticks_per_second`, `Engine.time_scale`, `Engine.max_physics_steps_per_frame`, and `Engine.physics_interpolation`. Autoloads `Log` and `System` provide global logging and key handling.

### Recommended reading order

1. `README.md` then `main.tscn` — the purpose and the on-screen layout (corner HUD labels, options VBox, scrolling log).
2. `utils/system.gd` + `utils/option_menu.gd` — the autoload services and the reusable slash-path menu builder.
3. `tests.gd` → `tests_menu.gd` → `test.gd` — **the framework spine**; understand how a test is listed, loaded, and what the base class gives it for free.
4. The HUD/tuning scripts (`utils/label_fps.gd`, `ticks_per_second.gd`, `time_scale.gd`, `max_steps_per_frame.gd`).
5. **Functional tests, easiest → hardest:** `test_shapes.tscn` → `test_stack.gd` / `test_pyramid.gd` → `test_collision_pairs.gd` → `test_raycasting.gd` → `test_character.gd` (then `test_character_tilemap.gd`, `test_character_pixels.gd`) → `test_one_way_collision.gd` → `test_joints.gd`.
6. **Performance tests:** `test_perf_broadphase.gd` then `test_perf_contacts.gd`.

> **Best experienced interactively:** run the project, browse the `TestsMenu`, and toggle the `Options` sliders (try dropping `physics_ticks_per_second` or raising `time_scale`) to *feel* each engine knob. The `System` autoload binds global keys: pause, toggle debug-collision drawing, fullscreen, restart test.

### Hands-on exercise

1. Create `tests/functional/test_friction.gd` extending `Test`. Build two `StaticBody2D` ramps at different angles and spawn boxes with the inherited `create_rigidbody_box()`, varying `physics_material_override.friction` (0.0 / 0.5 / 1.0).
2. Add an `OptionMenu` (instance `tests/test_options.tscn`) with radio items like `"Material/Ice"`, `"Material/Wood"`, log each box's slide distance with `Log.print_log()`, and visualize resting contacts with the inherited `add_circle()`.
3. Register it in `tests.gd`'s list (`{ "id": "Functional Tests/Friction", "path": "res://tests/functional/test_friction.tscn" }`), then run the project and pick your test from the `TestsMenu`.
