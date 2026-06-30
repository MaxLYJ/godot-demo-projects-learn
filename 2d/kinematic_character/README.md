# Kinematic Character 2D

Example of how to make a kinematic character controller in 2D using
[`CharacterBody2D`](https://docs.godotengine.org/en/latest/classes/class_characterbody2d.html).
The character moves around, is affected by moving platforms,
can jump through one-way collision platforms, etc.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2719

## Screenshots

![Screenshot](screenshots/kinematic.png)

## How to Learn This Project

> Part of **Ch. 4 – 2D Physics** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

The Godot 4 `CharacterBody2D` contract — the single most important pattern for hand-controlled 2D movement. You set a body's `velocity`, call `move_and_slide()`, and the engine moves the body, slides it along surfaces, and tracks whether it's on the floor. This demo is the distilled, comment-rich version of that contract, plus one-way collisions and moving/rotating platforms.

### Key nodes & classes to understand

- `CharacterBody2D` — the player *and* every moving/rotating platform (so the engine's platform-carry logic applies to them). `move_and_slide()` takes **no arguments** in Godot 4; `velocity`, `up_direction`, `floor_snap_length`, etc. are all node properties now.
- `CollisionShape2D.one_way_collision` — the four `OneWay` platforms; you jump up *through* them and land *on* them.
- `StaticBody2D` — the angled ramps (bodies that never move).
- `Area2D` — the `Princess` goal, a non-solid trigger that detects the player via `body_entered`.
- `AnimationPlayer` with `callback_mode_process = PHYSICS` — drives the moving/rotating platforms in sync with the physics tick.
- `Input.get_axis()`, `Input.is_action_just_pressed()`, `move_toward()`, `clamp()`, `is_on_floor()`.

### Recommended reading order

1. `project.godot` — the constants the scripts depend on (`default_gravity = 500`, `physics_ticks_per_second = 120`, the `move_left`/`move_right`/`jump` input actions).
2. `player/player.tscn` — a tiny scene: `CharacterBody2D` + `Sprite2D` + a 14×14 `RectangleShape2D`, with `player.gd` attached. No signals.
3. `player/player.gd` (~33 lines) — **the heart of the demo.** Horizontal movement is acceleration + friction (`velocity.x += walk * delta` to speed up, `move_toward(velocity.x, 0, STOP_FORCE * delta)` to slow down, `clamp()` to cap it); `velocity.y += gravity * delta` integrates gravity; `move_and_slide()` moves the body; and `is_on_floor()` is checked **after** `move_and_slide()` before applying the jump impulse. *(Ignore the stale `TODO` comments — they describe the old Godot 3 `move_and_slide` argument list.)*
4. `level/princess.gd` — the smallest script; shows an `Area2D` trigger reacting to `body_entered` and showing a sibling `Label` via `$"../WinText"`.
5. `world.tscn` — read **last**; it assembles everything: the static `TileMapLayer`, the four one-way platforms, the two linear moving platforms, the rotating `Circle`, the static ramps, the `Princess` trigger, and the instanced `Player`. The `[connection signal="body_entered" from="Princess" to="Princess" method="_on_body_entered"]` line at the bottom is the only signal wiring in the whole demo.

> **The subtle headline feature:** the player script never calls `get_platform_velocity()`. The carry onto moving/rotating platforms happens *inside* `move_and_slide()`, automatically, because those platforms are themselves `CharacterBody2D`s animated in physics mode. Stand on the rotating turntable to feel it.

### Hands-on exercise

1. Add **coyote time**: in `player/player.gd`'s `_physics_process`, track a small counter (or `Timer`) that resets whenever `is_on_floor()` is true, and allow jumping for ~0.1 s *after* walking off a ledge.
2. Add **variable jump height**: when the player *releases* the jump key while moving upward (`velocity.y < 0` and `is_action_just_released("jump")`), halve the upward velocity (`velocity.y *= 0.5`) — a tap gives a short hop, a hold gives the full jump.
3. Both edits live entirely in `player.gd` and force you to reason about floor state across frames — the two things the demo deliberately leaves on the table.
