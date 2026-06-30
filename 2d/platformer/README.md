# 2D Platformer

This demo is a pixel art 2D platformer with graphics and sound.

It shows you how to code characters and physics-based objects
in a real game context. This is a relatively complete demo
where the player can jump, walk on slopes, fire bullets,
interact with enemies, and more. It contains one closed
level, and the player is invincible, unlike the enemies.

You will find most of the demo’s content in the `level.tscn` scene.
You can open it from the default `game.tscn` scene, or double
click on `level.tscn` in the `src/level/` directory.

We invite you to open the demo's GDScript files in the editor as
they contain a lot of comments that explain how each class works.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/120

## Features

- Side-scrolling player controller using [`CharacterBody2D`](https://docs.godotengine.org/en/latest/classes/class_characterbody2d.html).
    - Can walk on and snap to slopes.
    - Can shoot, including while jumping.
- Enemies that crawl on the floor and change direction when they encounter an obstacle.
- Camera that stays within the level’s bounds.
- Supports keyboard and gamepad controls.
- Platforms that can move in any direction.
- Gun that shoots bullets with rigid body (natural) physics.
- Collectible coins.
- Pause and pause menu.
- Pixel art visuals.
- Sound effects and music.

## Screenshots

![2D Platformer](screenshots/platformer.webp)

## Music

[*Pompy*](https://soundcloud.com/madbr/pompy) by Hubert Lamontagne (madbr)

## How to Learn This Project

> Part of **Ch. 4 – 2D Physics** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

A complete `CharacterBody2D` platformer — the production-grade extension of the kinematic-character contract. On top of basic movement it adds collision **layers and masks**, cross-node **signals**, `RigidBody2D` bullets, `Area2D` pickups, a parallax background, a pause menu, and a two-player **splitscreen** built from `SubViewport`s.

### Key nodes & classes to understand

- `CharacterBody2D` — both the player (`player.gd`) and the enemies (`enemy.gd`).
- `RigidBody2D` — the bullet (`bullet.gd`); "natural" projectile physics with `contact_monitor` + `body_entered`.
- `Area2D` — the coins (`coin.gd`); non-solid pickups.
- `AnimatableBody2D` / `StaticBody2D` — moving and stationary platforms.
- **Collision layers/masks** — five named layers (`player`=1, `enemies`=2, `coins`=3, `platforms`=4, `ground`=5). Mask values are *bitmask sums*: the player's `collision_mask = 30` = layers 2+3+4+5; a bullet's `mask = 26` = enemies+platforms+ground (so bullets hit enemies/walls but never the player).
- `RayCast2D` (`PlatformDetector`, enemies' `FloorDetector*`) — used to gate slope-snapping and to detect platform edges.
- `ParallaxBackground` / `ParallaxLayer` — depth via `motion_scale` (far layers move slower).
- `SubViewportContainer` + `SubViewport` — splitscreen; two viewports share one `world_2d` and each player's `Camera2D` is redirected with `custom_viewport`.
- Custom `signal coin_collected` — declared on `Player`, emitted *by the `Coin`*, wired through the `.tscn` to the `PauseMenu` → `CoinsCounter`.

### Recommended reading order

1. `project.godot` — the input map, the five **layer names**, gravity (2100), and the main scene.
2. `player/player.gd` + `player.tscn` — the core: `move_toward()` accel/decel, terminal velocity, **variable jump height** (`velocity.y *= 0.6` on early release) and a recharging **double jump**, `floor_stop_on_slope` toggled by the `PlatformDetector` ray, and shooting via the `Gun` `Marker2D`. Note the `@export var action_suffix` that lets one scene serve both players.
3. `player/bullet.gd` + `bullet.tscn` + `player/gun.gd` — `RigidBody2D` with `contact_monitor`, instanced with `set_as_top_level(true)` and an initial `linear_velocity`; `_on_body_entered` calls `enemy.destroy()`.
4. `level/coin.gd` + `coin.tscn` — the `Area2D` pickup pattern and how it emits the *player's* `coin_collected` signal (note `@warning_ignore("unused_signal")` — the player itself never emits it).
5. `enemy/enemy.gd` + `enemy.tscn` — patrol AI with two `RayCast2D` edge detectors and `is_on_wall()` turn-around; death is driven entirely by an `AnimationPlayer` track that animates `collision_layer` to 0, plays sounds, emits particles, and calls `queue_free`.
6. `level/level.tscn` + `level.gd` — how tiles, coins, platforms, enemies, and parallax are composed, plus camera limits.
7. `gui/coins_counter.gd` + `gui/pause_menu.gd` — the signal destination and tween-animated, `process_mode = ALWAYS` pause menu (toggled by `tree.paused` in `game.gd`).
8. `game_splitscreen.gd` + `game_splitscreen.tscn` — read **last**: the `viewport_2.world_2d = viewport_1.world_2d` + `custom_viewport` trick that makes two players share one physics world.

> **Why the player is invincible:** enemies' masks exclude the player layer, so they pass through each other — combat is one-directional (you shoot them). This is a deliberate collision-mask design choice, not a bug.

### Hands-on exercise

1. Duplicate `enemy.tscn`/`enemy.gd` into a `FlyingEnemy`; drop gravity and the `FloorDetector` rays so it hovers, and bob it with `sin(time)` in `_physics_process`.
2. Place an instance under the `Enemies` node in `level.tscn` at an airborne position. Because `bullet.gd` checks `body is Enemy`, your new enemy is already shootable with **no bullet change**.
3. Stretch goal: emit a `destroyed` signal on `Enemy` and wire it to the `CoinsCounter` to also score kills.
