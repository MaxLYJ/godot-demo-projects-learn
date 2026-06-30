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
| 6 | [Shaders & Lighting](#chapter-6--shaders--lighting) | Advanced | sprite_shaders, glow, light2d_as_mask, lights_and_shadows, screen_space_shaders |
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

## Chapter 5 — Navigation & Pathfinding ✅

*Making agents find their way around obstacles. The chapter tours three levels of abstraction: the high-level node API with an editor-baked navmesh, then a grid-only alternative that needs no navmesh at all, then the low-level server API that bakes the mesh at runtime and chunks it for large worlds. Reading order: **navigation → navigation_astar → navigation_mesh_chunks**.*

This chapter's arc is a descent through the abstraction stack: 5.1 drives navigation through friendly **nodes** (`NavigationAgent2D` + an editor-baked `NavigationPolygon`), 5.2 swaps the whole system for a self-contained **`AStarGrid2D`** grid solver with a hand-rolled steering follower, and 5.3 peels the nodes off to **bake and chunk navmeshes directly on `NavigationServer2D`** at runtime.

---

### 5.1 — Navigation (NavigationPolygon + NavigationAgent2D)

- **Folder:** [`2d/navigation/`](2d/navigation/) · **README:** [`2d/navigation/README.md`](2d/navigation/README.md#how-to-learn-this-project)
- **Summary:** The minimal "click to move" navigation demo. A `CharacterBody2D` carries a `NavigationAgent2D` child; clicking anywhere sets the agent's `target_position`, and each physics frame the character steers toward `get_next_path_position()` until `is_navigation_finished()` returns true. The walkable area is a single editor-baked `NavigationPolygon` assigned to a `NavigationRegion2D`. This is the high-level, node-driven face of Godot's navigation.
- **Core concepts:** `NavigationPolygon` (the walkable surface, baked in the editor and saved as a `.res` resource); `NavigationRegion2D` (registers that polygon with `NavigationServer2D`); `NavigationAgent2D` as the per-actor path requester (`target_position`, `get_next_path_position()`, `is_navigation_finished()`, the `path_desired_distance` / `target_desired_distance` tuning knobs, and `debug_enabled` to visualize the path); the navigation movement loop (`global_position.direction_to(next_path_position) * movement_speed` → `move_and_slide()`); `NavigationServer2D` doing the real A* over the navmesh *under* those nodes; and a custom `click` input action (left mouse button).
- **Why here first:** The smallest, cleanest expression of the node-based navigation API. Everything in 5.2 and 5.3 is either an alternative to it or a low-level peel-back of it.

---

### 5.2 — Navigation A-star (grid-based)

- **Folder:** [`2d/navigation_astar/`](2d/navigation_astar/) · **README:** [`2d/navigation_astar/README.md`](2d/navigation_astar/README.md#how-to-learn-this-project)
- **Summary:** A grid pathfinder that does **not** use `NavigationServer2D` or a navmesh at all. A `TileMapLayer` script owns an `AStarGrid2D`, marks every painted tile solid with `set_point_solid()`, and answers `get_point_path(start, end)`. A `Marker2D` "character" follows the returned waypoint list with a hand-written **steering-behavior** integrator (`steering = desired_velocity - velocity; velocity += steering / MASS`). Right-click teleports and snaps to the grid; left-click sets a destination.
- **Core concepts:** `AStarGrid2D` (the grid A*: `region`, `cell_size`, `offset`, `default_compute_heuristic` / `default_estimate_heuristic` = `HEURISTIC_MANHATTAN`, `diagonal_mode = DIAGONAL_MODE_NEVER`, `set_point_solid()`, `get_point_path()`); driving pathfinding from a `TileMapLayer` (`get_used_cells()`, `local_to_map()` / `map_to_local()`); a `TileMapLayer._draw()` overlay drawing the path as lines + circles; the **steering-behavior** movement model on a non-physics `Marker2D` (manual `position += velocity * delta`, `rotation = velocity.angle()`, smoothed by `MASS`); an `IDLE` / `FOLLOW` state enum; grid snapping via `round_local_position()` + `reset_physics_interpolation()`; and the `teleport_to` / `move_to` input actions.
- **Why here second:** The contrast pair to 5.1 — same goal (find a path, walk it), but grid-based and server-less. It teaches *when* `AStarGrid2D` (cheap, strict grid, no baking) is the right tool over a navmesh (free-form surfaces that need baking).

---

### 5.3 — Navigation Mesh Chunks

- **Folder:** [`2d/navigation_mesh_chunks/`](2d/navigation_mesh_chunks/) · **README:** [`2d/navigation_mesh_chunks/README.md`](2d/navigation_mesh_chunks/README.md#how-to-learn-this-project) · **Requires Godot 4.3+.**
- **Summary:** The low-level capstone. Instead of one editor-baked polygon, it **bakes the navigation mesh at runtime via `NavigationServer2D`** from parsed collision geometry, then **chunks** the world into a grid of separately-baked `NavigationRegion2D`s whose edges align and merge across borders. Three `NavigationAgent2D` debug agents visualize the three `path_postprocessing` modes (corridor-funnel, edge-centered, none) over the same start → target. Mouse-left sets the path start; the cursor position is the target.
- **Core concepts:** Runtime **navmesh baking** (`NavigationServer2D.bake_from_source_geometry_data()`) from a `NavigationMeshSourceGeometryData2D` filled by `parse_source_geometry_data()` (collecting `PARSED_GEOMETRY_STATIC_COLLIDERS`) plus a hand-added `add_traversable_outline()`; the `NavigationPolygon` baking properties `parsed_geometry_type`, `baking_rect` (limit the bake to a region), `border_size` (pull in neighbor geometry so edges meet), and `agent_radius` (inflate obstacles); the **chunking** strategy — rasterize world bounds into a chunk grid, `grow()` each chunk's bake rect by one chunk so adjacent chunks share geometry, snap vertices with `snappedf()` to kill float-precision artifacts, then add one runtime-created `NavigationRegion2D` per chunk; `map_set_use_edge_connections(map, false)` (well-aligned edges merge by edge key, so the costly edge-connection feature is unneeded); `path_postprocessing` (`PATH_POSTPROCESSING_CORRIDOR_FUNNEL` / `_EDGE_CENTERED` / `_NONE`) shown as three colored debug paths; and the `NavigationServer2D` query API (`map_get_closest_point()`, the `map_get_iteration_id()` sync guard, `map_set_cell_size()`).
- **Why read it last:** It drops down to the server level 5.1 hid behind its nodes, and shows the pattern you need for *large or streaming* worlds — many baked regions instead of one, with edge-merge as the glue across chunk borders.

---

## Chapter 6 — Shaders & Lighting ✅

*GPU programming for 2D: per-sprite fragment shaders, the engine's built-in screen-space bloom, the 2D light/shadow system, and finally full-screen post-processing. Reading order: **sprite_shaders → glow → light2d_as_mask → lights_and_shadows → screen_space_shaders**.*

This chapter's arc runs from a shader you write *on one sprite* to a shader you write *on the whole screen*, with the engine's lighting system as the middle. You begin by hand-authoring a `canvas_item` fragment shader that samples a sprite's own texture (**6.1**), then see the glow effect you *don't* write yourself — Godot's built-in bloom driven by an `Environment` and HDR pixel values (**6.2**) — then meet `Light2D` used as a reveal mask (**6.3**), then the full light + shadow + normal-map rig (**6.4**), and finally you read the already-rendered frame back into a shader for full-screen post-processing (**6.5**).

---

### 6.1 — Sprite Shaders

- **Folder:** [`2d/sprite_shaders/`](2d/sprite_shaders/) · **README:** [`2d/sprite_shaders/README.md`](2d/sprite_shaders/README.md#how-to-learn-this-project) · **Renderer:** Compatibility.
- **Summary:** One sprite (`godotea.png`) shown ten times, each with a different `canvas_item` fragment shader: **outline**, **aura**, **blur**, **fatty**, **drop shadow**, **offset shadow**, **silhouette**, **glow**, and **disintegrate** (plus a normal copy). Each effect is a standalone `.gdshader` file assigned to the sprite via a `ShaderMaterial`. It is the Rosetta stone for "how do I write a 2D pixel shader that reads the sprite it's attached to."
- **Core concepts:** The `shader_type canvas_item;` program and the `fragment()` function; the built-ins `TEXTURE`, `UV`, `COLOR`, and especially **`TEXTURE_PIXEL_SIZE`** (the size of one texel, used to offset neighbor samples); `render_mode` (`blend_mix`, `blend_premul_alpha`); **`uniform`** parameters exposed to the Inspector as `shader_parameter/…` (e.g. `outline_width`, `aura_color`, `radius`, `amount`, `fattyness`, `offset`); the `: source_color` hint for color uniforms; the two recurring techniques — **multi-tap neighbor sampling** for outline/blur/glow (sampling `TEXTURE` at `UV ± offset * TEXTURE_PIXEL_SIZE` and `max`/`min`-ing or averaging the alpha), and a **hash-based pseudo-noise** for disintegrate (`fract(sin(dot(UV, …)) * 438.5453)` modulating alpha); assigning a shader to a `Sprite2D` through a `ShaderMaterial` sub-resource in the `.tscn`; and the parent `Node2D`'s own `ShaderMaterial` (the outline) inherited by all children.
- **Why here first:** It is the foundational "write a fragment shader" exercise — every shader later in the chapter reuses `TEXTURE`/`UV`/`TEXTURE_PIXEL_SIZE` and `uniform` parameters you first see here.

---

### 6.2 — Glow (WorldEnvironment bloom)

- **Folder:** [`2d/glow/`](2d/glow/) · **README:** [`2d/glow/README.md`](2d/glow/README.md#how-to-learn-this-project) · **Renderer:** Mobile (HDR glow is a Forward+/Mobile feature).
- **Summary:** A beach/cave scene whose bright areas bloom — but you write **no shader at all**. The bloom comes from a `WorldEnvironment` node holding an `Environment` resource with `glow_enabled = true` and per-level `glow_levels/5/6/7` intensities. Pixels brighter than 1.0 (the beach sprite is `modulate = Color(2, 2, 2)` — HDR overbright) spill into surrounding pixels. Press <kbd>G</kbd> to toggle a **glow map** (a "lens dirt" texture that masks *where* the bloom appears); drag to pan.
- **Core concepts:** `WorldEnvironment` + the **`Environment`** resource as the home of 2D/3D post effects; **`glow_enabled`**, the **`glow_levels`** (bloom mip levels and their strengths), `glow_intensity`, and `glow_map` (the lens-dirt texture); **HDR overbright** — `modulate`/`self_modulate` values `> 1.0` only read as brighter than white on the Forward+/Mobile renderer, which is what *feeds* the bloom (a Compatibility demo could not bloom this way); **tonemapping** (`tonemap_mode = 4` = AGX, plus `tonemap_agx_contrast`) which compresses the HDR range back to displayable color after glow; `Environment.background_mode = BG_CANVAS` so the 3D environment shows the 2D canvas; and a separate **`CanvasLayer`** for the HUD `Label` so the text is *not* bloomed. The script (`beach_cave.gd`) toggles the glow map live and compensates by doubling `glow_intensity` when the map is on.
- **Why here second:** After hand-writing a per-pixel shader in 6.1, this is the opposite pole — a major screen-space effect you get "for free" by configuring an `Environment`, no GLSL required.

---

### 6.3 — Light2D as Mask

- **Folder:** [`2d/light2d_as_mask/`](2d/light2d_as_mask/) · **README:** [`2d/light2d_as_mask/README.md`](2d/light2d_as_mask/README.md#how-to-learn-this-project) · **Renderer:** Compatibility.
- **Summary:** A photograph (`burano.png`) that is **invisible except where three moving lights touch it** — a "flashlight revealing a picture" effect. The trick is one `CanvasItemMaterial` property: the photo's material is `light_mode = LIGHT_MODE_ONLY_LIGHT`, so it renders *only* where a `Light2D` illuminates it. Three animated `PointLight2D`s (each textured with a `splat.png` blob and `blend_mode = MIX`) sweep across the image, carving it out of black.
- **Core concepts:** `CanvasItemMaterial.light_mode` and its **`LIGHT_MODE_ONLY_LIGHT`** value (the surface is black where unlit, visible only inside a light's coverage — the actual "masking" mechanism); `PointLight2D` with a **`texture`** that shapes the light's falloff (here an organic splat blob instead of the default radial gradient); the light's **`blend_mode`** (`MIX` reveals the photo at its true color rather than `ADD`-ing brightness on top); driving the lights from an **`AnimationPlayer`** that animates each light's `position` on a loop; and the contrast with 6.4 — this demo uses *no shadows, no occluders, no normal maps*, just the mask, isolating that one idea.
- **Why read it third:** The smallest possible lighting demo. It introduces `Light2D` and the `CanvasItemMaterial` light modes before the full light/shadow rig in 6.4 loads on every concept at once.

---

### 6.4 — Lights and Shadows

- **Folder:** [`2d/lights_and_shadows/`](2d/lights_and_shadows/) · **README:** [`2d/lights_and_shadows/README.md`](2d/lights_and_shadows/README.md#how-to-learn-this-project) · **Renderer:** Compatibility.
- **Summary:** The comprehensive 2D lighting reference. A dark scene lit by **three colored `PointLight2D`s** (red/green/blue) that cast real **shadows** from 15 shadow-casting blocks, plus a slowly-rotating **`DirectionalLight2D`**. Sprites use a **`CanvasTexture`** with a normal map so the lights shade them with real surface relief, shown in four flip variants (normal / flip-X / flip-Y / flip-both). `CanvasModulate` sets the dark ambient. Input toggles lights on/off and cycles **shadow-filter quality** live.
- **Core concepts:** **`PointLight2D`** (`color`, `texture`, `range`, `energy`) and **`DirectionalLight2D`** (parallel rays, `height`, `energy`); **shadows** — `shadow_enabled`, `shadow_filter` (`SHADOW_FILTER_NONE`/`_PCF5`/`_PCF13`), and `shadow_filter_smooth`, cycled at runtime via `wrapi(…, 0, 3)`; **`LightOccluder2D`** + **`OccluderPolygon2D`** defining each shadow caster's silhouette; **`CanvasModulate`** for global ambient tint; **`CanvasTexture`** as a richer texture type — `diffuse_texture`, **`normal_texture`** (per-pixel surface normals the lights shade against), and `specular_shininess` (cheap specular highlight); node **groups** (`point_light`) toggled with `get_nodes_in_group()`; **`AnimationPlayer`** moving the lights along looping tracks and rotating the sun; and the **important caveat** that 2D lights are ignored by sprites whose `CanvasItemMaterial.light_mode = LIGHT_MODE_UNSHADED`.
- **Why read it fourth:** The exhaustive lighting rig — every 2D-light concept in one scene — so it is the place to *see* shadows, occluders, and normal/specular shading working together after 6.3 introduced the bare `Light2D`.

---

### 6.5 — Screen-space Shaders

- **Folder:** [`2d/screen_space_shaders/`](2d/screen_space_shaders/) · **README:** [`2d/screen_space_shaders/README.md`](2d/screen_space_shaders/README.md#how-to-learn-this-project) · **Renderer:** Compatibility.
- **Summary:** A full-screen post-processing gallery. Two `OptionButton` dropdowns pick a source photo and an effect; 11 effects (vignette, blur, pixelize, whirl, sepia, negative, contrasted, normalized, BCS, mirage, **old film**) each process the **entire rendered frame** through a `canvas_item` shader. The key difference from 6.1: these shaders don't read the sprite's own texture — they read **the screen itself** via a `hint_screen_texture` uniform sampled at `SCREEN_UV`.
- **Core concepts:** The **`hint_screen_texture`** uniform (`uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;`) that gives a fragment shader access to the already-rendered frame; **`SCREEN_UV`** (the screen-space coordinate) vs the sprite's `UV`; sampling the back-buffer with **`textureLod(screen_texture, SCREEN_UV, lod)`** — and using its **mip levels** for cheap Gaussian blur (the vignette shader blurs by raising the LOD by the vignette darkness); implementing the effect families: **color math** (sepia/negative/BCS/contrasted/normalized via `dot(lum_weights)`, contrast, brightness, saturation), **coordinate warping** (whirl's polar rotation, mirage's sine wobble, pixelize's `mod()` quantization), **multi-tap blur**, and **time-driven effects** (`old_film` keys its grain/scratch/flicker to `TIME` quantized by an `fps` uniform for a choppy film look); the **full-screen-quad pattern** — a full-rect `TextureRect` with a blank `white.png` texture whose `material` (`ShaderMaterial`) overrides `COLOR` from the screen; and the `_ready()`/`item_selected` show-one-hide-all UI driven by node-children enumeration.
- **Why read it last:** The capstone — it takes the `fragment()` shader you wrote per-sprite in 6.1 and scales it to the whole screen, completing the chapter's journey from "shader on one node" to "shader on the entire frame."

---

## Chapter 7 — Animation, Skeletons & Particles ✅

*Two very different kinds of procedural motion: **cut-out skeletal animation** (a character rigged with bones and skinned polygons, blended through an `AnimationTree`) and **GPU particle effects** (the engine's particle system in its full breadth). Reading order: **skeleton → particles**.*

This chapter's arc moves from animating *a single character in depth* to animating *hundreds of short-lived sprites at once*. **7.1** is the rigging and animation-tree capstone: one GBot robot whose art is 7 `Polygon2D` skin pieces weighted to a 14-bone `Skeleton2D`, with 8 hand-authored clips blended live by an `AnimationTree` so walk/run sync to movement speed and jumps/lands fire as one-shots. **7.2** then widens the lens to a gallery of 17 `GPUParticles2D` emitters that isolate every feature of 2D particles — emission shapes, masks, sub-emitters, turbulence, collision, trails, flipbooks — in one scene.

---

### 7.1 — Skeleton (2D cut-out animation)

- **Folder:** [`2d/skeleton/`](2d/skeleton/) · **README:** [`2d/skeleton/README.md`](2d/skeleton/README.md#how-to-learn-this-project) · **Renderer:** Compatibility.
- **Summary:** A fully rigged GBot robot is a `CharacterBody2D` you walk, run, jump, and land with. Its visible "art" is not a sprite but **7 `Polygon2D` skin pieces weighted to a 14-bone `Skeleton2D`**; the `AnimationPlayer` animates each bone's `rotation`, and the skinned polygons deform to follow. A second animation node — the **`AnimationTree`** — blends the 8 clips at runtime so the *right* animation plays for the current state, with walk/run sped up or slowed down to match `velocity.x` and jumps/lands layered on top as one-shots. It is the complete 2D character-rigging pipeline in one runnable project.
- **Core concepts:** **`Skeleton2D`** + the **`Bone2D`** hierarchy — `Hip → Chest → {Head → Chin, LeftArm/RightArm → Forearm → Hand}`, `Hip → {LeftLeg/RightLeg → LowerLeg → Foot}` (14 bones, each with a `rest` pose); **`Polygon2D` as a skinned mesh** — each polygon's `skeleton` property points at the `Skeleton2D`, and its `bones` array stores a per-vertex weight for every bone (e.g. an elbow vertex is split `0.5/0.5` between the upper-arm and forearm bones so the joint bends smoothly); the **`AnimationPlayer`** holding 8 clips (`idle`/`walk`/`run`/`fly`/`fall`/`jump`/`land`/`land_hard`) that key each `Bone2D`'s `rotation_degrees` (and `Hip.position` for crouch) — *animating the bones, not the polygons*; the **`AnimationTree`** whose root is an **`AnimationNodeBlendTree`** wiring together an **`AnimationNodeTransition`** (the 5-state `idle`/`walk`/`run`/`fly`/`fall` locomotion blend), three **`AnimationNodeOneShot`** nodes (`jump`/`land`/`land_hard` — `land_hard` even uses a track *filter* so only some bones react), and two **`AnimationNodeTimeScale`** nodes that scale `walk`/`run` playback to `velocity.x`; driving the tree from code via parameter paths — `parameters/state/transition_request`, `parameters/jump/request = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE`, `parameters/run_timescale/scale`; facing the character by negating `sprite.scale.x` (the rig lives under a `Node2D` *named* "Sprite2D", not a `Sprite2D` node); `CharacterBody2D` locomotion (`move_toward` accel/decel, manual gravity + terminal velocity, **variable jump height** via `velocity.y *= 0.6` on early release, `floor_snap_length`); a `Camera2D` zoomed 4× whose limits are read from `Marker2D`s in `level.gd`; and `physics_interpolation_mode` on the body.
- **Why here first:** It is the rigging-and-blending capstone — bones, skinning, the AnimationPlayer/AnimationTree split, blend trees, one-shots, and time-scaling all appear in one character, so it is the place to *see* the whole 2D cut-out animation pipeline working together.

---

### 7.2 — Particles (2D GPU particles)

- **Folder:** [`2d/particles/`](2d/particles/) · **README:** [`2d/particles/README.md`](2d/particles/README.md#how-to-learn-this-project) · **Renderer:** Mobile (2D particle trails and HDR glow are Forward+/Mobile features).
- **Summary:** A wall of **17 labeled `GPUParticles2D`** emitters that each isolate one feature of Godot's 2D particle system: fire, smoke, magic sparks, an animated **flipbook** texture, **mask-shaped emission** (fill / outline / outline-with-direction), a **sub-emitter chain**, **turbulence**, all three **collision modes**, and a moving emitter showing **global-coordinate** particles. The only script (`pause.gd`) toggles pause, trails, and the `WorldEnvironment` glow. It is the reference catalog — open it next to the docs whenever you need a specific particle effect.
- **Core concepts:** The **`GPUParticles2D`** node — `amount`, `lifetime`, `explosiveness` (`1.0` = a single one-shot burst, used by *Explosion*), `randomness`, **`preprocess`** (pre-simulate so particles are already mid-stream at startup — *Fire* = 1 s, *Flipbook* = a full lifetime), `texture`, `interpolate` (several emitters set it `false`), and node-level **trails** (`trail_enabled`/`trail_lifetime`/`trail_sections`, toggled on the `trailable_particles` group); the **`ParticleProcessMaterial`** — the *same* material class 2D and 3D share, which is why you must tick **`particle_flag_disable_z = true`** for 2D (9 emitters do); the **emission-shape enum** exercised across the gallery (`SPHERE`, `SPHERE_SURFACE`, `BOX`, `POINTS`, `POINTS_NORMALS`, `DIRECTED_POINTS`) plus **mask emission** via `emission_point_texture`/`emission_normal_texture` (*EmitMask* / *OutlineMask* / *DirectionMask* emit from a shape's fill, outline, and outline-with-direction); the velocity/force params (`direction`+`spread`+`initial_velocity_min/max`, `gravity`, `scale_curve` driven by a `CurveTexture`, `color`); **sub-emitters** — a `sub_emitter` `NodePath` + `sub_emitter_mode` (`AT_END` fires when a particle dies, `AT_COLLISION` fires on contact) with `sub_emitter_keep_velocity`, shown as the *ParticlesWithSubemitter → Sparks → Smoke* chain and the collide-and-spawn *CollisionSubemitter*; **turbulence** (`turbulence_enabled` + noise strength/speed/random = a swirling vector field); the three **collision modes** against `LightOccluder2D` colliders — `RIGID` (bounce), `HIDE_ON_CONTACT` (vanish on touch), and the collide→spawn-subemitter combo — controlled by `collision_mode` and `collision_base_size`; **global vs. local coordinates** (*MagicGlobalCoordinates* rides a `Path2D`/`PathFollow2D` so its particles stay in world space as the emitter moves); the **flipbook** sprite-sheet texture; and the **renderer caveat** — trails are Forward+/Mobile only, so `pause.gd` gates the trail controls on `not is_compatibility`, shows an `UnsupportedLabel` on the Compatibility renderer, and bumps `glow_intensity` to compensate for its lower dynamic range. Like 6.2, the bright particle colors (e.g. magic's blue channel `> 1.0`) bloom via the `WorldEnvironment`'s HDR glow.
- **Why read it last:** The exhaustive particle reference — every 2D-particle feature in one scene — and a natural companion to 6.2 (glow), since the overbright particle colors bloom here too.

---

## Chapter 8 — Game Architecture & Larger Projects ✅

*Patterns for non-trivial games: the finite state machine pattern, and a full top-down RPG that ties many systems together. Reading order: **finite_state_machine → role_playing_game**.*

### 8.1 — Finite State Machine (the HFSM + pushdown-automaton pattern)

- **Folder:** [`2d/finite_state_machine/`](2d/finite_state_machine/) · **README:** [`2d/finite_state_machine/README.md`](2d/finite_state_machine/README.md#how-to-learn-this-project) · **Renderer:** Compatibility (120 Hz physics + interpolation).
- **Summary:** A top-down `CharacterBody2D` that walks, runs, jumps, attacks (with a 3-hit sword combo), and gets staggered — and *every one of those behaviors is its own script*. The demo teaches the **State pattern** as a reusable *engine* (a generic `StateMachine` Node + an abstract `State` Node), then layers two refinements on top: **hierarchical states**, where states `extends` other states so shared logic (movement input, the "simulate damage" key) lives once at the top of an inheritance chain and trickles down through `super.handle_input()`; and a **pushdown automaton**, where interrupt states (`jump`/`attack`/`stagger`) are *pushed onto a stack* on top of the locomotion state and pop back to it when they finish, instead of each state needing to remember what to return to. There is even a **second, independent state machine** inside the `Sword` that owns the combo timing — the player FSM decides *when* to swing, the sword FSM decides *how* the swing plays. It is a complete, runnable answer to "how do I keep a growing game organized?"
- **Core concepts:** the abstract **`State`** interface (`state.gd`) — `enter()`/`exit()`/`handle_input()`/`update()`/`_on_animation_finished()` plus a **`finished(next_state_name)`** signal; the generic **`StateMachine`** (`state_machine.gd`) — a plain `Node` that holds a **`states_map`** (name→node) and a **`states_stack`**, picks its initial state from an `@export start_state` `NodePath` (or `get_child(0)`), wires **every child State's `finished` signal to `_change_state`**, and *delegates* `_unhandled_input`→`current_state.handle_input()` and `_physics_process`→`current_state.update()` so states never inherit from the body; the **`_change_state(name)`** contract — `current_state.exit()`, then `"previous"` **pops the stack** (pushdown) or else **swaps the stack's top** to `states_map[name]`, emits `state_changed`, and calls `enter()`; the player specialization (`player_state_machine.gd`) that **overrides** `_change_state` to *push* the interrupt states (`stagger`/`jump`/`attack`) onto the stack before delegating to `super`, and to seed `jump` with `move`'s speed/velocity — and **overrides** `_unhandled_input` so the `attack` key can interrupt *any* state; the **hierarchy** via `extends` — `motion.gd → on_ground.gd → {idle.gd, move.gd}` and `motion.gd → jump.gd`, with `return super.handle_input(input_event)` propagating events *up* the chain (so `on_ground` handles the jump key, `motion` handles the damage key, and only the leftover reaches the leaf); the **`owner`** convention — every State reads/writes the body through `owner.` (`owner.velocity`, `owner.move_and_slide()`, `owner.get_node("AnimationPlayer")`), keeping the body (`player_controller.gd`) and the FSM cleanly separated; the **`Die` state** as a terminal example (`set_dead(true)` disables input/physics/collision); the **`Sword` as a second FSM** (`sword.gd`) with its own `States`/`AttackInputStates` enums, a 3-step `combo` table, `hit_objects` de-dup so one swing can't hit twice, and combo windows driven by **AnimationPlayer function tracks** (`set_attack_input_listening`/`set_ready_for_next_attack`) — fired when the player FSM's `state_changed` signal reports the `Attack` node, and reporting back via `attack_finished` so the player FSM pops `"previous"`; the **`Bullet` spawner** (`set_as_top_level(true)` projectiles that free themselves off-screen or on contact); the `WeaponPivot` that rotates the sword to `look_direction.angle()` and drops its `z_index` when facing up; and the **debug UI** (`states_stack_displayer.gd`) that prints the live `states_stack` so you can *watch* the pushdown push and pop.
- **Why here first:** Every earlier chapter taught an *engine feature* (nodes, drawing, tilemaps, physics, navigation, shaders, animation). This one teaches a *software-architecture pattern* that makes those features scale — and it is the structural prerequisite for the demo right after it, which runs a whole game on the same "many small cooperating objects talking over signals" idea.

---

### 8.2 — Role Playing Game (grid movement + dialogue + turn-based combat)

- **Folder:** [`2d/role_playing_game/`](2d/role_playing_game/) · **README:** [`2d/role_playing_game/README.md`](2d/role_playing_game/README.md#how-to-learn-this-project) · **Renderer:** Compatibility.
- **Summary:** A miniature JRPG you can actually finish: walk a slime around a tiled overworld, bump into an NPC to read branching **JSON dialogue**, get whisked into a **fade-to-black** turn-based battle (Attack / Defend / Flee with health bars and a turn queue), and read a win-or-lose line on return. Its real lesson is **project-scale architecture** — how to compose a multi-screen game out of self-contained systems (exploration grid, dialogue player, combat arena, turn queue) that communicate almost entirely through **signals**, and how to switch between whole "screens" by `add_child`/`remove_child`-ing scene instances rather than juggling visibility flags. It is the capstone: grid movement reuses the Chapter 3 TileMapLayer, the combat reuses animation and UI, and the whole flow is stitched together with the signal-driven thinking Chapter 8.1 just introduced.
- **Core concepts:** **`Grid`** (`grid.gd`) — a `TileMapLayer` that doubles as the collision/occupancy authority via a `CellType` enum (`ACTOR`/`OBSTACLE`/`OBJECT`) painted into cells in `_ready()`, exposing **`request_move(pawn, direction)`** which maps the pawn to a cell, inspects the target cell's `source_id`, and either returns the new `map_to_local` position or triggers dialogue with whatever `ACTOR`/`OBJECT` is in the way; the **`Pawn → Walker → {Player, Opponent}`** inheritance chain — `Pawn` owns `type` + an `active` setter that toggles `set_process`/`set_process_input`, `Walker` adds grid-aware **tweened cell-to-cell movement** (`move_to` builds a `create_tween()` whose duration is read from the `walk` animation's `length`, so the slide and the step stay in sync) plus a `bump()` for blocked moves, and `Player`/`Opponent` only override input vs. passivity; the **`AnimationTree` + `AnimatedSprite2D`** pair (`AnimationNodeStateMachinePlayback` started on `walk`/`idle`/`bump`, an `AnimatedSprite2D` "Slime" whose `SpriteFrames` are assigned from an exported `pose_anims`); **`game.gd`** as the orchestrator that owns both `combat_screen` and `exploration_screen`, **swaps them by `remove_child`/`add_child`** (the inactive screen isn't just hidden, it's detached from the tree), and brackets each swap with a `fade_to_black` `AnimationPlayer` tween driven by `await animation_finished`; the **JSON dialogue system** — `DialoguePlayer` loads a `.json` file with `FileAccess`, parses it with `JSON.new().parse()`, and walks `dialogue_keys` on `next_dialogue()`, emitting `dialogue_started`/`dialogue_finished`; the **`interface.gd`** that uses **`.bind()`** when connecting `dialogue_started`/`dialogue_finished` to `player.set_active` (so the player freezes during conversation) and **disconnects** them on completion — a clean example of temporary, scoped signal wiring; **turn-based combat** — `combat.gd` instantiates each combatant from a `PackedScene`, connects its `Health.dead` signal, and the **`TurnQueue`** (`turn_queue.gd`) drives rounds with a recursive `play_turn()` that `await`s the active combatant's `turn_finished` signal then `pop_front`/`append`s the queue (a rotating queue, not a fixed initiative order); the **`Combatant`** (`combatant.gd`) with `attack`/`defend`/`flee` actions that each **`emit turn_finished`** (the cue the TurnQueue awaits), an `active` setter that resets armor each round, and an **`opponent.gd`** AI that `await`s a `Timer` then attacks — i.e. the enemy "takes its turn" by yielding on time; the **`Health`** node (`life`/`max_life`/`armor`, `take_damage`/`heal`, emits `health_changed` and `dead`) shared by overworld pawns and combatants; and the **`CanvasLayer` combat UI** (`ui.gd`) that builds a health-bar row by listening to each `Health.health_changed`, and routes the Attack/Defend/Flee buttons to the `Player` combatant when it is `active`.
- **Why read it last:** It is the capstone — a single runnable game that reuses grid movement (Ch. 3), scene instancing (Ch. 1), animation (Ch. 7), UI, and the signal-driven, many-small-objects architecture from 8.1. If you can read `game.gd` and follow how a bump becomes dialogue becomes combat becomes a win line, you can structure a Godot game of your own.

---

*This is a living document. **All 8 chapters (27 demos) are complete.***
