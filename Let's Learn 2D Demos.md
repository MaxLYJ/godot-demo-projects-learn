# Let's Learn 2D Demos

A structured learning curriculum built from the **27 official Godot 2D demo projects** in this repository's [`2d/`](2d/) directory. Each demo is a self-contained, runnable Godot project. This document is your map: it groups the demos into chapters that flow from **basic fundamentals** (nodes, scenes, instancing, scripts) to **advanced topics** (shaders, physics, navigation, finite state machines, custom drawing, particles).

Read top-to-bottom and you will build real, transferable Godot skills — every chapter assumes the concepts of the ones before it.

---

## How to use this curriculum

- **Per-project READMEs.** Every demo folder has a `README.md`. Once you reach a demo in this guide, open its README's **"How to Learn This Project"** section for the concept it teaches, the key nodes/classes to focus on, the recommended code-reading order, and a hands-on exercise.
- **Read code, don't just run it.** Open the `.tscn` (scene) and `.gd` (script) files in the Godot editor and follow the reading order given in each README.
- **Renderer & language.** Most demos are GDScript on the *Compatibility* renderer. Exceptions are noted where relevant (e.g. `glow` and `physics_platformer` use Forward+; `particles` uses the Mobile renderer).
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

## Chapter 3 — Tilemaps 🔧

*Building worlds out of grid tiles, including non-square grids. Reading order: **isometric → hexagonal_map → dynamic_tilemap_layers**.*

| Demo | Folder | README |
|------|--------|--------|
| Isometric | [`2d/isometric/`](2d/isometric/) | [`README`](2d/isometric/README.md) |
| Hexagonal Map | [`2d/hexagonal_map/`](2d/hexagonal_map/) | [`README`](2d/hexagonal_map/README.md) |
| Dynamic TileMap Layers | [`2d/dynamic_tilemap_layers/`](2d/dynamic_tilemap_layers/) | [`README`](2d/dynamic_tilemap_layers/README.md) |

> Detailed per-demo entries will be added in a later pass.

---

## Chapter 4 — 2D Physics 🔧

*Moving bodies that collide, from a hand-controlled character to thousands of simulated objects. Reading order: **kinematic_character → platformer → physics_platformer → physics_tests → bullet_shower**.*

| Demo | Folder | README |
|------|--------|--------|
| Kinematic Character (2D) | [`2d/kinematic_character/`](2d/kinematic_character/) | [`README`](2d/kinematic_character/README.md) |
| Platformer | [`2d/platformer/`](2d/platformer/) | [`README`](2d/platformer/README.md) |
| Physics Platformer | [`2d/physics_platformer/`](2d/physics_platformer/) | [`README`](2d/physics_platformer/README.md) |
| Physics Tests | [`2d/physics_tests/`](2d/physics_tests/) | [`README`](2d/physics_tests/README.md) |
| Bullet Shower | [`2d/bullet_shower/`](2d/bullet_shower/) | [`README`](2d/bullet_shower/README.md) |

> Detailed per-demo entries will be added in a later pass.

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

*This is a living document. Chapters 1 and 2 are complete; chapters 3–8 are outlined above and will be expanded with detailed per-demo entries (summary, core concepts, and a README link) as the curriculum is built out.*
