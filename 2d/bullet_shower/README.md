# Bullet Shower

This demonstrates how to manage large amounts of objects efficiently using
low-level Servers.

See
[Optimization using Servers](https://docs.godotengine.org/en/latest/tutorials/performance/using_servers.html)
in the documentation for more information.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2711

## Screenshots

![No collision](screenshots/no_collision.png)

![Collision](screenshots/collision.png)

## How to Learn This Project

> Part of **Ch. 4 – 2D Physics** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

How to manage **thousands of objects efficiently** by bypassing the scene tree entirely. 500 bullets stream across the screen and react to a mouse-controlled player — yet there is **not a single bullet `Node`** in the scene. Each bullet is a raw `PhysicsServer2D` body (an `RID`) and all of them are painted in one `Node2D._draw()` pass. This is the canonical "use the Servers" optimization, and the direct counter-example to instancing thousands of `RigidBody2D`/`Sprite2D` nodes.

### Key nodes & classes to understand

- `PhysicsServer2D` — the **low-level physics server**. Bodies are created and driven here, not as nodes: `body_create()`, `body_set_space()`, `body_add_shape()`, `body_set_state(..., BODY_STATE_TRANSFORM, ...)`, and `free_rid()` on cleanup.
- `RID` — the opaque "resource ID" handle into the engine's servers. Each bullet *is* a body `RID`; one shared `CircleShape2D` `RID` is reused by all 500 bodies.
- A **custom inner `class Bullet`** (a plain GDScript object holding `position`, `speed`, and `body: RID`) stored in a `var bullets := []` `Array` — *not* a `MultiMesh` and *not* a pool of nodes.
- `Node2D._draw()` + `queue_redraw()` — all 500 bullet textures are drawn in a single `draw_texture` loop on one node, re-queued once per frame.
- `body_set_collision_mask(body, 0)` — bullets are given a mask of 0 so they **never collide with each other** (the single biggest physics win); only the player `Area2D` interacts with them.
- `Area2D` `body_shape_entered`/`body_shape_exited` — these *still fire* for server-only bodies because they live in the same physics space; the player uses a `touching` counter (not a boolean) to handle many simultaneous overlaps.
- `_exit_tree()` — **mandatory manual cleanup** of every `RID` (bodies + the shared shape), because server resources are not garbage-collected with the scene tree.

### Recommended reading order

1. `bullets.gd` — **the entire point of the demo.** Read the header comment first (it states the philosophy verbatim), then `class Bullet`, then `_ready()` (create 500 `RID` bodies, reuse one shape, mask = 0), `_physics_process()` (advance `position.x`, wrap off-screen bullets, push each `Transform2D` back to the server), `_draw()` (the single batched `draw_texture` loop), and `_exit_tree()` (free every `RID`).
2. `shower.tscn` — see how minimal the tree is: a root `Node2D`, the `Bullets` `Node2D`, and the `Player` `Area2D` — just three nodes for 500+ entities. Note the `[connection]` lines wiring the player's `body_shape_entered/exited` onto itself.
3. `player.gd` — short: the player follows the mouse (`Input.set_mouse_mode(MOUSE_MODE_HIDDEN)` + `InputEventMouseMotion`), and the `touching` counter flips an `AnimatedSprite2D` between happy/sad frames.
4. `README.md` — points to the official [Optimization using Servers](https://docs.godotengine.org/en/latest/tutorials/performance/using_servers.html) doc.

> **The two performance levers, in order of impact:** (1) `body_set_collision_mask(body, 0)` removes the O(n²) bullet-vs-bullet broadphase; (2) one `Node2D` doing all drawing avoids 500 `CanvasItem`s. Removing *either* tanks the framerate — try it.

### Hands-on exercise

1. Bump `BULLET_COUNT` from 500 to 5000 and add a live FPS readout (`Engine.get_frames_per_second()`) in `_process`.
2. Re-enable bullet self-collision by commenting out the `body_set_collision_mask(body, 0)` line and watch the FPS collapse from the O(n²) broadphase — then restore it.
3. Stretch goal: replace the `_draw()` texture loop with a `MultiMeshInstance2D` (`multimesh.instance_count = BULLET_COUNT`, updating each instance transform from the same `bullets` array in `_physics_process`) and benchmark which rendering path is faster on the Compatibility renderer.
