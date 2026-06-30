# Instancing Demo

A demo showing how to use scene instancing to
make many duplicates of the same object.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2716

## Screenshots

![Screenshot](screenshots/instancing.png)

## How to Learn This Project

> Part of **Ch. 1 – First Steps: Nodes, Scenes & Scripts** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches
The simplest possible demo of **scene instancing** — Godot's core idea that any scene (a `.tscn` file) can be loaded as a `PackedScene` and duplicated ("instantiated") as many times as you want at runtime. It is also a gentle physics sandbox: the balls are `RigidBody2D` nodes that fall and bounce off a hand-shaped `StaticBody2D` track.

### Key nodes & classes to understand
- `PackedScene` + `preload()` + `instantiate()` — the load→duplicate pipeline. `ball_factory.gd` preloads `ball.tscn` and calls `instantiate()` to clone it.
- `RigidBody2D` — the ball: a physics body that moves on its own under gravity and bounces.
- `StaticBody2D` / `CollisionPolygon2D` — the immovable hand-shaped track the balls bounce on.
- `Sprite2D` + `CollisionShape2D` / `CircleShape2D` — how a visible, collidable object is assembled inside a scene.
- `@export var ball_scene` — exposing a scene to the Inspector so it can be swapped without editing code.
- `_unhandled_input()` + `InputEventMouseButton` — reading a left-click to trigger a spawn.

### Recommended reading order
1. **`ball.tscn`** — meet one ball. It is a `RigidBody2D` with a `Sprite2D` (the picture) and a `CollisionShape2D` (the physics circle). This *is* the reusable template.
2. **`ball_factory.gd`** — the heart of the demo. Read `spawn()`: it calls `ball_scene.instantiate()`, sets the new instance's `global_position`, and `add_child()`s it into the tree. Then read `_unhandled_input()` to see how a click calls `spawn()` at the mouse position.
3. **`scene_instancing.tscn`** — see how ten `Ball1`…`Ball10` nodes are each *instances* of the same `ball.tscn` (note `instance=ExtResource(...)`), plus the `BallFactory`, the static track, a label, and a `Camera2D`.

### Hands-on exercise
1. Make each click spawn **three** balls in a small triangle around the cursor instead of one (call `spawn()` three times with slightly offset positions).
2. Give spawned balls a random bounce value (e.g. `0.1`–`0.9` via `physics_material_override`) so they all react differently.
3. Add a counter label showing how many balls currently exist — increment it in `spawn()`.
