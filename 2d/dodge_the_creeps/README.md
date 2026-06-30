# Dodge the Creeps

This is a simple game where your character must move
and avoid the enemies for as long as possible.

This is a finished version of the game featured in the
["Your first 2D game"](https://docs.godotengine.org/en/latest/getting_started/first_2d_game/index.html)
tutorial in the documentation. For more details,
consider following the tutorial in the documentation.

Language: GDScript

Renderer: Compatibility

> [!NOTE]
>
> There is a C# version available [here](https://github.com/godotengine/godot-demo-projects/tree/master/mono/dodge_the_creeps).

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2712

## Screenshots

![GIF from the documentation](https://docs.godotengine.org/en/latest/_images/dodge_preview.gif)

![Screenshot](screenshots/dodge.png)

## Copying

`art/House In a Forest Loop.ogg` Copyright &copy; 2012 [HorrorPen](https://opengameart.org/users/horrorpen), [CC-BY 3.0: Attribution](https://creativecommons.org/licenses/by/3.0/). Source: https://opengameart.org/content/loop-house-in-a-forest

Images are from "Abstract Platformer". Created in 2016 by kenney.nl, [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/). Source: https://www.kenney.nl/assets/abstract-platformer

Font is "Xolonium". Copyright &copy; 2011-2016 Severin Meyer <sev.ch@web.de>, with Reserved Font Name Xolonium, SIL open font license version 1.1. Details are in `fonts/LICENSE.txt`.

## How to Learn This Project

> Part of **Ch. 1 – First Steps: Nodes, Scenes & Scripts** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md). This is Godot's official ["Your first 2D game"](https://docs.godotengine.org/en/latest/getting_started/first_2d_game/index.html) tutorial — the recommended starting point for the whole curriculum.

### What it teaches
A *complete* mini-game assembled from fundamentals: instancing, custom signals, `Timer`-driven game loops, `Path2D`/`PathFollow2D` for randomized spawn points, `AnimatedSprite2D`, audio, a `CanvasLayer` HUD, and node **groups**. If you understand this demo, you understand the backbone of most Godot games.

### Key nodes & classes to understand
- `Timer` (×3: `MobTimer`, `ScoreTimer`, `StartTimer`) — the game's heartbeat; each `timeout` signal triggers a scripted event.
- `Path2D` + `PathFollow2D` (`MobPath` / `MobSpawnLocation`) — picking a random point *along a curve* to spawn each mob.
- `Area2D` (player) with a custom `signal hit` — decoupled "I was hit" notification.
- `RigidBody2D` (mob) + `AnimatedSprite2D` + `VisibleOnScreenNotifier2D` — self-removing enemies.
- `CanvasLayer` (HUD) with its own `signal start_game` — UI talking back to the game.
- `@export var mob_scene: PackedScene` + `instantiate()` — spawning enemies from a template.
- `call_group("mobs", "queue_free")`, `await`, `set_deferred()`, `randf_range()` — cleanup, waiting, safe physics changes, randomness.

### Recommended reading order
1. **`player.gd`** — input → velocity → movement, animation flipping, and the `hit` signal. Note `set_deferred("disabled", true)` in `_on_body_entered()` (you can't toggle a physics shape mid-collision).
2. **`mob.gd`** — tiny: picks a random animation on `_ready()` and `queue_free()`s itself when it leaves the screen.
3. **`hud.gd`** — the UI layer. Trace `show_game_over()`'s `await` chains (it waits on timers before changing the message) and the `start_game` signal it emits.
4. **`main.gd`** — the conductor. Read `new_game()` (reset + start timers), `_on_MobTimer_timeout()` (instantiate a mob, place it on the path, launch it perpendicular), `_on_ScoreTimer_timeout()`, and `game_over()`.
5. **`main.tscn`** — finally, see how all of the above is wired together via the `[connection ...]` block (signals `hit`, `timeout`, `start_game` all route back to `Main`).

### Hands-on exercise
1. **Escalating difficulty**: make mobs spawn faster over time by reducing `MobTimer.wait_period` as the score grows (or pick higher mob velocities).
2. **A pick-up**: add a collectible scene that, when the player overlaps it, grants bonus score — reusing the same `Area2D` + signal pattern as the player.
3. **A second player animation**: add a new `AnimatedSprite2D` animation and switch to it when the player is moving fast.
