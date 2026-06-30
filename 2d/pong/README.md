# Pong with GDScript

A simple Pong game. This demo shows best practices
for game development in Godot, including
[signals](https://docs.godotengine.org/en/latest/getting_started/step_by_step/signals.html).

Language: GDScript

Renderer: Compatibility

> [!NOTE]
>
> There is a C# version available [here](https://github.com/godotengine/godot-demo-projects/tree/master/mono/pong).

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2728

## How does it work?

The walls, paddle, and ball are all
[`Area2D`](https://docs.godotengine.org/en/latest/classes/class_area2d.html)
nodes. When the ball touches the walls or the paddles,
they emit signals and modify the ball.

## Screenshots

![Screenshot](screenshots/pong.png)

## How to Learn This Project

> Part of **Ch. 1 – First Steps: Nodes, Scenes & Scripts** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches
A complete, tiny game loop built almost entirely on **signals** and `Area2D` overlap detection — with no manual collision math. Everything that matters (paddles, ball, walls, ceiling, floor) is an `Area2D`; when areas overlap they fire `area_entered`, and the connected handler simply rewrites the ball's `direction`. It is the cleanest example of "decoupled objects talking through signals."

### Key nodes & classes to understand
- `Area2D` — used for *everything* here. It detects overlaps but isn't pushed around by physics, so the ball/paddles are moved manually in `_process()`.
- **Signals** — `area_entered` is connected (see the `[connection ...]` lines at the bottom of `pong.tscn`) to per-node handlers that mutate the shared `Ball`.
- `Input.get_action_strength()` — reading named actions (set up in the project's Input Map) for smooth up/down paddle movement.
- `clamp()` — keeping paddles on screen.
- The shared `direction` variable on the ball, modified from the *outside* by other nodes.

### Recommended reading order
1. **`pong.tscn`** — scan the node tree first (two paddles, one ball, walls, ceiling, floor — all `Area2D`). Then read the `[connection ...]` block at the very bottom: that wiring is the architecture of the whole game.
2. **`logic/ball.gd`** — the simplest moving object. `_process()` nudges `position` along `direction` and slowly speeds up; `reset()` snaps it home.
3. **`logic/paddle.gd`** — note how `_ready()` derives its input actions and ball-bounce sign *from its own node name* (`"left"` vs `"right"`), so one script serves both paddles. `_on_area_entered()` bounces the ball.
4. **`logic/ceiling_floor.gd`** and **`logic/wall.gd`** — the two remaining signal handlers: ceiling/floor reflect the ball vertically; walls reset the ball (a goal).
5. Re-trace one full rally through the scene's signal connections to see how a single `direction` write ripples across nodes.

### Hands-on exercise
1. Add **scoring**: when the ball hits a `wall`, increment a score label for the opposite player (the wall already calls `area.reset()` — add a point there).
2. Make the ball speed up *faster* the longer a rally lasts (tweak the `_speed += delta * 2` line) and watch how it changes difficulty.
3. Add an AI opponent: instead of reading input for the right paddle, move it toward the ball's `y` position.
