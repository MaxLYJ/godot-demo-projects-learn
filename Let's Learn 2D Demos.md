# Let's Learn 2D Demos

A structured learning curriculum built from the **27 official Godot 2D demo projects** in this repository's [`2d/`](2d/) directory. Each demo is a self-contained, runnable Godot project. This document is your map: it groups the demos into chapters that flow from **basic fundamentals** (nodes, scenes, instancing, scripts) to **advanced topics** (shaders, physics, navigation, finite state machines, custom drawing, particles).

Read top-to-bottom and you will build real, transferable Godot skills — every chapter assumes the concepts of the ones before it.

---

## How to use this curriculum

- **Per-project READMEs.** Every demo folder has a `README.md`. Once you reach a demo in this guide, open its README's **"How to Learn This Project"** section for the concept it teaches, the key nodes/classes to focus on, the recommended code-reading order, and a hands-on exercise.
- **Read code, don't just run it.** Open the `.tscn` (scene) and `.gd` (script) files in the Godot editor and follow the reading order given in each README.
- **Renderer & language.** All demos are GDScript. Most run on the *Compatibility* (OpenGL) renderer; a handful use the *Mobile* renderer instead (`custom_drawing`, `polygons_lines`, `glow`, `particles`, and `physics_tests`). Per-demo entries note the renderer where it matters. (Note: a few upstream READMEs mislabel their renderer — trust the `project.godot` `rendering_method` line.)
- **Run them.** Each project has a `project.godot`. Open the folder in Godot 4 and press ▶.

> **Status legend:** ✅ = chapter written. 🔧 = chapter outline in place, detailed entries being added in later passes.

---

## Table of Contents

| # | Chapter | Difficulty | Demos |
|---|---------|-----------|-------|
| 1 | [First Steps: Nodes, Scenes & Scripts](#chapter-1--first-steps-nodes-scenes--scripts) | Basic | instancing, pong, dodge_the_creeps, tween |
| 2 | [Custom Drawing & Vector Graphics](#chapter-2--custom-drawing--vector-graphics) | Beginner→Intermediate | custom_drawing, polygons_lines, drawable_textures |
| 3 | [Tilemaps](#chapter-3--tilemaps) | Intermediate | isometric, hexagonal_map, dynamic_tilemap_layers |
| 4 | [2D Physics](#chapter-4--2d-physics) | Intermediate→Advanced | kinematic_character, platformer, physics_platformer, physics_tests, bullet_shower |
| 5 | [Navigation & Pathfinding](#chapter-5--navigation--pathfinding) | Intermediate→Advanced | navigation, navigation_astar, navigation_mesh_chunks |
| 6 | [Shaders & Lighting](#chapter-6--shaders--lighting) | Advanced | glow, light2d_as_mask, lights_and_shadows, screen_space_shaders, sprite_shaders |
| 7 | [Animation, Skeletons & Particles](#chapter-7--animation-skeletons--particles) | Advanced | skeleton, particles |
| 8 | [Game Architecture & Larger Projects](#chapter-8--game-architecture--larger-projects) | Advanced | finite_state_machine, role_playing_game |

**27 demos total** across 8 chapters.

---

## Chapter 1 — First Steps: Nodes, Scenes & Scripts ✅

*The bedrock of every Godot game: the scene tree, reusable scenes (instancing), GDScript fundamentals, input, signals, timers, and assembling a complete game loop. Start here if you are new to Godot.*

Recommended reading order within this chapter: **instancing → pong → dodge_the_creeps → tween**.

---

### 1.1 — Instancing

- **Folder:** [`2d/instancing/`](2d/instancing/) · **README:** [`2d/instancing/README.md`](2d/instancing/README.md#how-to-learn-this-project)
- **Summary:** Click to spawn unlimited bouncing bowling balls. The smallest possible demonstration that a saved scene (`ball.tscn`) can be loaded as a `PackedScene` and cloned at runtime with `instantiate()`.
- **Core concepts:** `PackedScene`, `preload()` / `instantiate()` / `add_child()`, `@export`, `_unhandled_input()`, and the `RigidBody2D` + `Sprite2D` + `CollisionShape2D` anatomy of a reusable object.
- **Why here first:** Instancing is the single most important mechanic in Godot — every enemy, bullet, and item is an *instance*. Master it before anything else.

---

### 1.2 — Pong (with GDScript)

- **Folder:** [`2d/pong/`](2d/pong/) · **README:** [`2d/pong/README.md`](2d/pong/README.md#how-to-learn-this-project)
- **Summary:** A complete Pong game where the paddles, ball, walls, ceiling, and floor are *all* `Area2D` nodes. There is no collision-resolution math — when areas overlap they emit `area_entered`, and the connected handler simply rewrites the ball's `direction`.
- **Core concepts:** Custom **signals** + signal wiring in the scene file, `Area2D` overlap detection, `Input.get_action_strength()`, `_process()` movement, `clamp()`, and one script driving two paddles by reading its own node name.
- **Why read it second:** It shows the idiomatic Godot pattern — decoupled objects that communicate through signals rather than reaching into each other.

---

### 1.3 — Dodge the Creeps

- **Folder:** [`2d/dodge_the_creeps/`](2d/dodge_the_creeps/) · **README:** [`2d/dodge_the_creeps/README.md`](2d/dodge_the_creeps/README.md#how-to-learn-this-project)
- **Summary:** Godot's official ["Your first 2D game"](https://docs.godotengine.org/en/latest/getting_started/first_2d_game/index.html) tutorial, finished. Move a character, dodge randomly-spawned enemies, rack up a score. It combines every Chapter 1 concept into one project.
- **Core concepts:** `Timer`-driven game loops (×3 timers), `Path2D`/`PathFollow2D` for randomized spawn points, a custom `signal hit`, `AnimatedSprite2D`, audio, a `CanvasLayer` HUD, node **groups**, `instantiate()`, `await`, `set_deferred()`, and `call_group()`.
- **Why read it third:** It is the first *full game* in the curriculum and the template most learners will imitate. Everything in later chapters extends patterns you meet here.

---

### 1.4 — Tween Interpolation

- **Folder:** [`2d/tween/`](2d/tween/) · **README:** [`2d/tween/README.md`](2d/tween/README.md#how-to-learn-this-project)
- **Summary:** An interactive playground with ten toggleable animation "steps," each showcasing a different `Tween` technique — chained tweens, parallel tweens, easing/transitions, looping, callbacks, method-tweening along a `Path2D`, and sub-tweens.
- **Core concepts:** `create_tween()` → `Tween`, `Tweener` chaining, `parallel()`, `set_ease()`/`set_trans()`, `set_loops()`, `set_speed_scale()`, `as_relative()`, `tween_method()`, and `%`-prefixed unique-node access.
- **Why read it last in this chapter:** Tweens are foundational for UI and juice, and the demo's UI-driven structure is a gentle lead-in to the control-node work you'll see in later chapters.

---

## Chapter 2 — Custom Drawing & Vector Graphics ✅

*Drawing things procedurally instead of with sprite images: the `_draw()` API, the `Polygon2D`/`Line2D` nodes, and runtime-paintable textures. Three demos, three angles on the same idea.*

Recommended reading order within this chapter: **custom_drawing → polygons_lines → drawable_textures**.

---

### 2.1 — Custom Drawing

- **Folder:** [`2d/custom_drawing/`](2d/custom_drawing/) · **README:** [`2d/custom_drawing/README.md`](2d/custom_drawing/README.md#how-to-learn-this-project)
- **Summary:** A `TabContainer` whose seven tabs (`Panel`s) are each a `@tool` script overriding `_draw()` — one tab per category of the `CanvasItem.draw_*` API: lines, rectangles, polygons, meshes, textures, text, and animation. The reference catalog for "draw X with code."
- **Core concepts:** The `_draw()` / `queue_redraw()` contract, `@tool` scripts, the full `draw_*` family (`draw_line`/`draw_circle`/`draw_arc`/`draw_rect`/`draw_polygon`/`draw_polyline`/`draw_multiline`/`draw_texture`/`draw_string`/`draw_mesh`/`draw_multimesh`), the *stateful* `draw_set_transform()` / `draw_set_transform_matrix()`, `TAU`, `StyleBoxFlat`, `MultiMesh`, and per-command antialiasing vs. 2D MSAA.
- **Why here first:** It is the exhaustive, code-driven foundation; the next two demos show the same drawing concepts expressed as **nodes** and as a **GPU paint target**.

---

### 2.2 — Polygons & Lines

- **Folder:** [`2d/polygons_lines/`](2d/polygons_lines/) · **README:** [`2d/polygons_lines/README.md`](2d/polygons_lines/README.md#how-to-learn-this-project)
- **Summary:** The **node-based** counterpart to `custom_drawing`. Complex shapes are built not with `draw_*` calls but by placing `Polygon2D` and `Line2D` nodes and tuning their Inspector properties — textured and "inverted" (cut-out) polygons, plus lines with width curves, gradients, textures, and bevel/round joints.
- **Core concepts:** `Polygon2D` (`polygon`, `uv`, `texture`, `invert_enabled`/`invert_border`, `antialiased`), `Line2D` (`width_curve`, `gradient`, `texture`/`texture_mode`, `joint_mode`, cap modes, `round_precision`, `sharp_limit`), a hand-crafted line texture for cheap antialiasing, `Curve`/`Gradient`/`NoiseTexture2D` sub-resources, and 2D MSAA (Forward+/Mobile only).
- **Why read it second:** Having seen the raw `draw_*` calls, here you learn the higher-level node wrappers you'll reach for 90% of the time in real projects.

---

### 2.3 — Drawable Textures

- **Folder:** [`2d/drawable_textures/`](2d/drawable_textures/) · **README:** [`2d/drawable_textures/README.md`](2d/drawable_textures/README.md#how-to-learn-this-project)
- **Summary:** A paint program built on `DrawableTexture2D` — a GPU texture you stamp onto at runtime via `blit_rect()`. Every brushstroke on the 2D canvas updates a 3D cube/sphere live, because one shared texture feeds both a `TextureRect` and a `StandardMaterial3D.albedo_texture`.
- **Core concepts:** `DrawableTexture2D` (`new()` + `setup()`), `blit_rect()` GPU blits, sharing one texture across 2D and 3D, `GradientTexture2D` brushes (paint vs. erase), the `gui_input` signal, signal `.bind()` for many swatches → one handler, and embedding 3D with `SubViewport`/`SubViewportContainer`.
- **Why read it last:** It is the most modern and applied of the three — runtime texture painting — and a satisfying capstone that ties 2D drawing into the broader engine.

---

## Chapter 3 — Tilemaps ✅

*Building worlds out of grid tiles — including non-square (isometric and hexagonal) grids — and modifying them at runtime. Reading order: **isometric → hexagonal_map → dynamic_tilemap_layers**.*

> All three demos use Godot 4's dedicated **`TileMapLayer`** node (one layer per node) rather than the older single `TileMap` that held many layers internally; several upstream READMEs still say "TileMap," but the `.tscn` files now instance `TileMapLayer`. The grid *shape* (square / isometric / hexagon) lives in the shared **`TileSet`** resource (`tile_shape`, `tile_layout` / `tile_offset_axis`, `tile_size`).

### 3.1 — Isometric

- **Folder:** [`2d/isometric/`](2d/isometric/) · **README:** [`2d/isometric/README.md`](2d/isometric/README.md#how-to-learn-this-project)
- **Summary:** A fully lit isometric dungeon. A goblin walks in eight directions, slides along walls, and is correctly occluded by — and depth-sorted behind — pillars and tall objects. It is the chapter's flagship because it stacks tile rendering, depth sorting, collision, movement, animation, *and* 2D lighting into a single scene.
- **Core concepts:** The `TileSet` isometric settings (`tile_shape = ISOMETRIC`, `tile_layout = DIAMOND_RIGHT`, `tile_size = 128×64` — the classic 2:1 ratio); multiple `TileMapLayer` nodes (`Floor` / `Walls` / `HighWalls`) sharing one `TileSet`; **Y-sorting** for depth (`y_sort_enabled` on each layer *and* its parent `Node2D`, plus `y_sort_origin` so a tile's sort point is its base, not its top); isometric input (`motion.y /= 2` before `normalized()` so on-screen diagonals match the projection); 8-direction sprite selection by slicing a movement vector into 45° wedges (`floor((rad_to_deg(angle) + 22.5) / 45)`); collision stored in the `TileSet`'s physics layer; and 2D lighting (`PointLight2D` with `shadow_enabled`, `LightOccluder2D`, `light_mask`, and `CanvasItemMaterial.light_mode` / `blend_mode` for additive glows and masked shadows).
- **Why read it first:** The most complete tilemap demo in the whole repo and the one most worth reverse-engineering; the two simpler demos below isolate individual techniques you'll first see combined here.

---

### 3.2 — Hexagonal Map

- **Folder:** [`2d/hexagonal_map/`](2d/hexagonal_map/) · **README:** [`2d/hexagonal_map/README.md`](2d/hexagonal_map/README.md#how-to-learn-this-project)
- **Summary:** A minimal hex-grid world: one `TileMapLayer`, one walkable troll, no lighting or sorting. The point is to show *only* what changes when the grid is hexagonal — both in the `TileSet` and in how the input axes are read.
- **Core concepts:** The `TileSet` hex settings (`tile_shape = HEXAGON`, `tile_offset_axis = OFFSET_AXIS_VERTICAL` for flat-top hexes, `tile_size = 110×94`); hex-aware input (`motion.y *= tan(deg_to_rad(30))` ≈ 0.577 to compress vertical movement onto the hex projection); an **acceleration + friction** movement model (`velocity += motion.normalized() * SPEED` then `velocity *= 0.89` each physics tick, rather than setting velocity directly); `CharacterBody2D` + `CircleShape2D` + `Camera2D`; and HDR-bright sprites (`modulate = Color(1.5, 1.5, 1.5)`, which only reads as >1.0 on Forward+/Mobile).
- **Why read it second:** A stripped-down sibling of 3.1 that isolates the *non-square grid* idea and contrasts a different movement feel (inertial friction vs. the goblin's instant velocity) so the isometric demo doesn't have to carry every concept alone.

---

### 3.3 — Dynamic TileMap Layers

- **Folder:** [`2d/dynamic_tilemap_layers/`](2d/dynamic_tilemap_layers/) · **README:** [`2d/dynamic_tilemap_layers/README.md`](2d/dynamic_tilemap_layers/README.md#how-to-learn-this-project)
- **Summary:** A side-scrolling level with a hidden room: walking into a region fades the "secret" wall semi-transparent *and* disables its collision so the player passes straight through. It demonstrates modifying **`TileData` per physics frame** to change a tile's behavior at runtime.
- **Core concepts:** The runtime-tile-data override pair `_use_tile_data_runtime_update()` (return `true` to opt a tile into per-frame updates) and `_tile_data_runtime_update()` (mutate the `TileData` — here `set_collision_polygons_count(0, 0)` to strip the collision polygon and make a passable "fake wall"); animating a whole layer's transparency via `self_modulate` alpha driven by `move_toward()` and toggled with `set_process()`; an `Area2D` "secret detector" whose `body_entered` / `body_exited` signals trigger the effect; and classic platformer movement (gravity + `move_and_slide()` + `is_on_floor()` jump). The README also flags the modern shortcut: Godot 4.3+ `TileMapLayer` can disable a layer's collision with an Inspector checkbox — this demo shows the scriptable, per-tile version of the same trick.
- **Why read it last:** The capstone — the only demo that treats the tilemap as *mutable data* rather than static scenery, and a direct lead-in to the runtime/scripting mindset of the physics and navigation chapters that follow.

---

## Chapter 4 — 2D Physics ✅

*Moving bodies that collide — from a hand-tuned `CharacterBody2D` controller, to a full platformer, to a `RigidBody2D` version that interacts with the world for real, to the engine's own physics test/benchmark suite, and finally to thousands of objects rendered *without* Nodes. Reading order: **kinematic_character → platformer → physics_platformer → physics_tests → bullet_shower**.*

This chapter's arc is a tour of *how* you move a body in Godot 2D: the high-level **kinematic** contract (`CharacterBody2D` + `move_and_slide()`), then a **full game** built on it, then the contrasting **rigid-body** approach (`RigidBody2D` + `_integrate_forces()`), then the **reference harness** that isolates every primitive, and finally the **data-oriented** extreme that sidesteps Nodes entirely for scale.

---

### 4.1 — Kinematic Character (2D)

- **Folder:** [`2d/kinematic_character/`](2d/kinematic_character/) · **README:** [`2d/kinematic_character/README.md`](2d/kinematic_character/README.md#how-to-learn-this-project)
- **Summary:** A `CharacterBody2D` (Cubio) explores a level with acceleration + friction movement, a fixed-height jump, four one-way platforms, two linearly-moving platforms, a rotating turntable, and angled ramps — then reaches a `Princess` `Area2D` trigger that reveals a win message. It is the distilled, comment-rich tour of the Godot 4 `CharacterBody2D` contract.
- **Core concepts:** The `CharacterBody2D` `velocity` / `move_and_slide()` contract (no arguments in Godot 4 — what used to be arguments are now node properties); manual gravity integration (`velocity.y += gravity * delta`, gravity read from `ProjectSettings`); an acceleration + friction horizontal model (`move_toward()` for deceleration, additive `+= force * delta` for acceleration, with a `clamp()` cap); `is_on_floor()` as a **post-`move_and_slide()`** query (ordering matters); the jump as an edge-triggered velocity impulse; **one-way collisions** (`CollisionShape2D.one_way_collision = true`); moving/rotating platforms built as `CharacterBody2D`s driven by an `AnimationPlayer` in **physics callback mode** so `move_and_slide()` automatically carries the rider using the platform's velocity; `StaticBody2D` ramps vs. `CharacterBody2D` movers; `Area2D` as a non-solid `body_entered` trigger; signal wiring via the `[connection]` block at the bottom of the `.tscn`; `TileMapLayer` tile collision; and `physics_ticks_per_second = 120` for smoother motion.
- **Why here first:** The smallest, most readable `CharacterBody2D` controller in the repo. Every later physics demo assumes you understand this contract, so lock it in here.

---

### 4.2 — Platformer

- **Folder:** [`2d/platformer/`](2d/platformer/) · **README:** [`2d/platformer/README.md`](2d/platformer/README.md#how-to-learn-this-project)
- **Summary:** A complete pixel-art `CharacterBody2D` platformer: accelerated running, **variable-height + double jump**, slope-snapping gated by a `RayCast2D`, `RigidBody2D` bullets that destroy `CharacterBody2D` enemies, `Area2D` coin pickups, a five-layer collision filtering scheme, a parallax background, a pause menu, and a **two-player splitscreen** mode that renders one shared world from two cameras.
- **Core concepts:** `CharacterBody2D` platformer movement (`move_toward()` accel/decel, terminal velocity, `floor_stop_on_slope` toggled by a `PlatformDetector` `RayCast2D`); variable jump height (`velocity.y *= 0.6` on early release) and a recharging double jump; one-way platforms; **collision layers and masks** as bitmask filtering (five named layers: player / enemies / coins / platforms / ground — masks like `30`, `26`, `24` are their sums); `Area2D` coin pickup via `body_entered` with `monitoring` toggling; a custom **`coin_collected` signal declared on `Player` but emitted by the `Coin`**, wired through the `.tscn` to a `PauseMenu` → `CoinsCounter`; `RigidBody2D` bullets (`contact_monitor` + `body_entered`, instancing with `set_as_top_level` and an initial `linear_velocity`); `AnimationPlayer` tracks driving sprite frames, audio, **method calls** (`queue_free`), and **properties** (`collision_layer`, `monitoring`); `ParallaxBackground`/`ParallaxLayer` `motion_scale`; splitscreen via `SubViewportContainer` + `SubViewport` sharing `world_2d` and redirecting `Camera2D.custom_viewport`; input **action suffixing** (`_p1`/`_p2`) to reuse one `Player` scene for two players; and `tree.paused` + `process_mode` for the pause menu.
- **Why here second:** The first *full game* built on the 4.1 contract — it layers on the production patterns (collision layers, cross-node signals, bullets, parallax, splitscreen) that the minimal demo deliberately omits.

---

### 4.3 — Physics Platformer

- **Folder:** [`2d/physics_platformer/`](2d/physics_platformer/) · **README:** [`2d/physics_platformer/README.md`](2d/physics_platformer/README.md#how-to-learn-this-project)
- **Summary:** The same genre as 4.2, but the player and enemies are **`RigidBody2D` driven by a custom `_integrate_forces(state)` integrator** — so they interact with the world *for real*: standing on one end of a `PinJoint2D` seesaw torques it, moving platforms physically carry them, and bullet impacts knock enemies into a death-spin. The canonical counterpoint to the `CharacterBody2D` approach. *(Renderer note: the upstream README says "Forward+" but the project actually uses the Compatibility renderer — `gl_compatibility` in `project.godot`.)*
- **Core concepts:** `RigidBody2D` as a character with **`custom_integrator = true`** (so the script owns all integration); the `_integrate_forces(PhysicsDirectBodyState2D)` entry point — `get_linear_velocity()`, mutate, `set_linear_velocity()`; re-applying gravity yourself via `state.get_total_gravity() * step`; **contact-based floor detection** (`contact_monitor` + scanning `get_contact_count()` / `get_contact_local_normal()` for an upward-pointing normal) with coyote time; force-like accel/decel scaled by `state.get_step()` with separate air tuning; riding platforms by sampling `state.get_contact_collider_velocity_at_position()`; a `SeparationRayShape2D` "foot" + `lock_rotation` + `physics_material_override` (friction = 0) to tame the rigid body into a platformer feel; `PinJoint2D` hinge (`RigidBody2D` plank + `StaticBody2D` pillar = seesaw); `AnimationPlayer`-driven `CharacterBody2D` moving platforms; `one_way_collision`; bullet/enemy interaction via **contact iteration inside `_integrate_forces`** (not `body_entered`) plus `add_collision_exception_with` and continuous collision detection (`continuous_cd`); compound collision shapes and `RayCast2D` ledge patrol; 120 Hz ticks + physics interpolation.
- **Why here third:** It deliberately contrasts 4.2 — same goal, a fundamentally more powerful (and harder) physics model — so you see *why* most platformers use `CharacterBody2D` and *when* a rigid body is worth the cost.

---

### 4.4 — Physics Tests

- **Folder:** [`2d/physics_tests/`](2d/physics_tests/) · **README:** [`2d/physics_tests/README.md`](2d/physics_tests/README.md#how-to-learn-this-project) · **Renderer:** Mobile.
- **Summary:** Godot's official 2D physics **test and benchmark harness** — a menu of isolated test scenes covering every body type, every collision shape, all three 2D joints, raycasting, one-way collisions (including TileMap corner edge cases) and stack/pyramid stability, plus broadphase and contact-solving performance benchmarks with live FPS and per-tick timing. Not a game: it is the reference room for the entire 2D physics engine.
- **Core concepts:** The **test-framework pattern** itself — a data-driven menu (`tests.gd` list → reusable `OptionMenu` → `tests_menu.gd` frees/loads/instantiates each test scene as a root child) and a shared `Test` base class (timers, `wait_for_physics_ticks()`, debug-draw helpers, rigid-body factories, force-enabled `debug_collisions_hint`); `CharacterBody2D` vs. `RigidBody2D` controller variants including ray-shape variants and floor options (snap, stop-on-slope, constant-speed); every collision **shape type** (Rectangle, Circle, Capsule, ConvexPolygon, ConcaveSegments); manual queries via `PhysicsDirectSpaceState2D.collide_shape()` and `intersect_ray()` with `PhysicsShapeQueryParameters2D`; the three **2D joints** — `PinJoint2D`, `GrooveJoint2D`, `DampedSpringJoint2D`; one-way platforms and one-way TileMap tiles; stack/pyramid stability as a contact-solver regression test; **physics performance tuning** — broadphase add/move/remove of 10,000 bodies, contact-solving cost across shape types, and the `Engine` knobs (`physics_ticks_per_second`, `time_scale`, `max_physics_steps_per_frame`, `physics_interpolation`); and autoload services (`Log`, `System`).
- **Why here fourth:** The exhaustive reference — every primitive from 4.1–4.3 appears here in isolation and is measurable, so it is the place to *see* and *stress* each concept once you understand the demos above.

---

### 4.5 — Bullet Shower

- **Folder:** [`2d/bullet_shower/`](2d/bullet_shower/) · **README:** [`2d/bullet_shower/README.md`](2d/bullet_shower/README.md#how-to-learn-this-project)
- **Summary:** 500 bullets stream across the screen and react to a mouse-controlled player — yet there is **not a single bullet `Node` in the scene tree**. Each bullet is a raw `PhysicsServer2D` `RID` body, and all 500 are painted in one `Node2D._draw()` pass. It is the data-oriented extreme: thousands of colliding objects with zero per-object Node overhead.
- **Core concepts:** *Why Nodes are expensive at scale* (vs. instancing thousands of `RigidBody2D`/`Sprite2D`); the **`PhysicsServer2D`** low-level API (`body_create` / `body_set_space` / `body_add_shape` / `body_set_state` / `free_rid`) and the **`RID`** type as an opaque server handle; one shared `CircleShape2D` `RID` reused by all bodies; disabling bullet-vs-bullet collision via `body_set_collision_mask(body, 0)` as the single biggest physics win; storing bullet state in a plain GDScript `Array` of a custom `Bullet` class (`position` / `speed` / `body`) updated in `_physics_process`; **custom `_draw()` + `queue_redraw()`** for batched `draw_texture` rendering (this is *not* a `MultiMesh` and *not* a Node pool); pushing each server body's `Transform2D` every frame; **mandatory `RID` cleanup in `_exit_tree`**; and `Area2D` `body_shape_entered`/`exited` signals still firing for non-node bodies, tracked with a `touching` counter.
- **Why read it last:** The scalability capstone — after learning every physics body type, here is how to *sidestep them entirely* when you genuinely need thousands of objects.

---

## Chapter 5 — Navigation & Pathfinding 🔧

*Making agents find their way around obstacles. Reading order: **navigation → navigation_astar → navigation_mesh_chunks**.*

| Demo | Folder | README |
|------|--------|--------|
| Navigation | [`2d/navigation/`](2d/navigation/) | [`README`](2d/navigation/README.md) |
| Navigation A-star | [`2d/navigation_astar/`](2d/navigation_astar/) | [`README`](2d/navigation_astar/README.md) |
| Navigation Mesh Chunks | [`2d/navigation_mesh_chunks/`](2d/navigation_mesh_chunks/) | [`README`](2d/navigation_mesh_chunks/README.md) |

> Detailed per-demo entries will be added in a later pass.

---

## Chapter 6 — Shaders & Lighting 🔧

*GPU programming for 2D: per-sprite and full-screen shaders, plus 2D lights and shadows. Reading order: **sprite_shaders → glow → light2d_as_mask → lights_and_shadows → screen_space_shaders**.*

| Demo | Folder | README |
|------|--------|--------|
| Sprite Shaders | [`2d/sprite_shaders/`](2d/sprite_shaders/) | [`README`](2d/sprite_shaders/README.md) |
| Glow | [`2d/glow/`](2d/glow/) | [`README`](2d/glow/README.md) |
| Light2D as Mask | [`2d/light2d_as_mask/`](2d/light2d_as_mask/) | [`README`](2d/light2d_as_mask/README.md) |
| Lights and Shadows | [`2d/lights_and_shadows/`](2d/lights_and_shadows/) | [`README`](2d/lights_and_shadows/README.md) |
| Screen-space Shaders | [`2d/screen_space_shaders/`](2d/screen_space_shaders/) | [`README`](2d/screen_space_shaders/README.md) |

> Detailed per-demo entries will be added in a later pass.

---

## Chapter 7 — Animation, Skeletons & Particles 🔧

*Skeletal cut-out animation and GPU/CPU particle effects. Reading order: **skeleton → particles**.*

| Demo | Folder | README |
|------|--------|--------|
| Skeleton (2D) | [`2d/skeleton/`](2d/skeleton/) | [`README`](2d/skeleton/README.md) |
| Particles | [`2d/particles/`](2d/particles/) | [`README`](2d/particles/README.md) |

> Detailed per-demo entries will be added in a later pass.

---

## Chapter 8 — Game Architecture & Larger Projects 🔧

*Patterns for non-trivial games: the finite state machine pattern, and a full top-down RPG that ties many systems together. Reading order: **finite_state_machine → role_playing_game**.*

| Demo | Folder | README |
|------|--------|--------|
| Finite State Machine | [`2d/finite_state_machine/`](2d/finite_state_machine/) | [`README`](2d/finite_state_machine/README.md) |
| Role Playing Game | [`2d/role_playing_game/`](2d/role_playing_game/) | [`README`](2d/role_playing_game/README.md) |

> Detailed per-demo entries will be added in a later pass.

---

*This is a living document. Chapters 1–4 are complete; chapters 5–8 are outlined above and will be expanded with detailed per-demo entries (summary, core concepts, and a README link) as the curriculum is built out.*
