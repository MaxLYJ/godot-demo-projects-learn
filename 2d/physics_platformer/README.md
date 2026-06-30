# Physics Platformer

This demo uses [`RigidBody2D`](https://docs.godotengine.org/en/latest/classes/class_rigidbody2d.html)
for the player and enemies.
These character controllers are more powerful than
[`CharacterBody2D`](https://docs.godotengine.org/en/latest/classes/class_characterbody2d.html),
but can be more difficult to handle, as they require
manual modification of the RigidDynamicBody velocity.

Language: GDScript

Renderer: Forward+

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2725

## How does it work?

The player and enemies use dynamic character
controllers for movement, made with
[`RigidBody2D`](https://docs.godotengine.org/en/latest/classes/class_rigidbody2d.html),
which means that they can perfectly interact with physics
(there is a see-saw, and you can even ride enemies).
Because of this, all movement must be done in sync with
the physics engine, inside of `_integrate_forces()`.

## Screenshots

![Screenshot of the beginning](screenshots/beginning.png)

![Screenshot of the seesaw and the player riding an enemy](screenshots/seesaw-riding.png)

## Music

"Pompy" by Hubert Lamontagne (madbr) https://soundcloud.com/madbr/pompy

## How to Learn This Project

> Part of **Ch. 4 – 2D Physics** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

The rigid-body alternative to a `CharacterBody2D` platformer. Here the player and enemies are **`RigidBody2D`s controlled inside `_integrate_forces(state)`** — they push, get pushed, ride a `PinJoint2D` seesaw, and physically react to bullet impacts. This is the more powerful (and harder) physics model; compare it directly with the `CharacterBody2D`-based `platformer` demo to see *why* most platformers choose kinematic bodies.

> **Renderer note:** the upstream "Renderer: Forward+" line above is inaccurate — `project.godot` sets `renderer/rendering_method = "gl_compatibility"` (the Compatibility renderer), with nearest texture filtering for the pixel art.

### Key nodes & classes to understand

- `RigidBody2D` with **`custom_integrator = true`** — the player and enemies. Because the integrator is custom, the script owns *all* motion (including gravity, which it re-applies itself).
- `_integrate_forces(state: PhysicsDirectBodyState2D)` — the single entry point for movement: `state.get_linear_velocity()` → mutate → `state.set_linear_velocity()`.
- `contact_monitor` + `max_contacts_reported` — required so the body *reports* its contacts; the player scans `state.get_contact_count()` / `get_contact_local_normal()` to detect the floor (a contact whose normal points up: `normal.dot(Vector2.DOWN) > 0.6`).
- `SeparationRayShape2D` (a downward "foot" ray) + `lock_rotation` + `physics_material_override` (friction = 0) — the trio that tames a tumbling rigid body into something that *feels* like a platformer character.
- `PinJoint2D` — the seesaw: a `RigidBody2D` plank pinned to a `StaticBody2D` pillar so it rotates freely under weight.
- `AnimationPlayer`-driven `CharacterBody2D` — the moving platforms (position is animated; the rigid player reads their velocity through its floor contact).
- `StaticBody2D` with `CollisionShape2D.one_way_collision = true` — one-way platforms.
- `Area2D` — the coins (sensor pickups, contrasted with the physics bodies).
- `PhysicsDirectBodyState2D` helpers: `get_total_gravity()`, `get_step()`, `get_contact_collider_velocity_at_position()`, `set_angular_velocity()`.

### Recommended reading order

1. `project.godot` — physics tuning: `physics_ticks_per_second = 120`, `default_gravity = 900`, physics interpolation on; plus the real renderer (`gl_compatibility`).
2. `player/player.gd` — **the heart of the demo.** Read `_integrate_forces()` end to end: how it finds the floor via contacts, applies a coyote-time grace window (`MAX_FLOOR_AIRBORNE_TIME`), does force-like accel/decel scaled by `state.get_step()`, sets the jump velocity, samples the platform's velocity to ride moving platforms, and finally re-applies gravity and writes the velocity back.
3. `player/player.tscn` — see the `RigidBody2D` flags (`custom_integrator`, `contact_monitor`, `lock_rotation`, mass 1.5), the `SeparationRayShape2D` + triangle `CollisionPolygon2D`, and friction = 0.
4. `enemy/enemy.gd` + `enemy.tscn` — a second rigid-body controller: `_integrate_forces` patrol with `RayCast2D` ledge detection, a compound body of three `CircleShape2D`s, and bullet detection done **by iterating contacts** (not `body_entered`) — the bullet then triggers a death-spin via `set_angular_velocity()` and an `explode` animation.
5. `player/bullet.gd` + `bullet.tscn` — a rigid bullet with **continuous collision detection** (`continuous_cd`) so fast shots don't tunnel; `add_collision_exception_with` so it won't hit the player that fired it; lifetime via a `Timer` + `disable()` + animation.
6. `coin/coin.gd` + `coin.tscn` — the `Area2D` pickup (`body_entered`, `body is Player`).
7. `background/seesaw.tscn` — the `PinJoint2D` (`node_a`/`node_b` join plank and pillar).
8. `platform/moving_platform.tscn` and the `MovePlatforms` `AnimationPlayer` in `stage.tscn` — animated platforms; `platform/one_way_platform.tscn` for one-way collision.
9. `stage.tscn` — composition: 42 coins, moving platforms, the seesaw, enemies, parallax.

### Hands-on exercise

1. In `player/bullet.gd`, override `_integrate_forces` to detect a wall contact (normal mostly horizontal) and reflect the velocity (`velocity.x = absf(velocity.x) * signf(normal.x)`), counting bounces and calling `disable()` after 3 — reusing the exact contact-scanning pattern from `enemy.gd`. Set `physics_material_override.bounce = 0.6` in `bullet.tscn`.
2. Clone `seesaw.tscn` into a `spike_ball.tscn` whose plank becomes a heavy circular `RigidBody2D` pinned by a `PinJoint2D`, so it swings like a pendulum — no script needed; gravity + the joint do the work.
3. Place the swinging hazard over a gap in `stage.tscn` for the player to dodge.
