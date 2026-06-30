# Role Playing Game

This shows a method of creating grid-based movement with Godot
and GDScript. It also includes a simple JRPG-style dialogue and
battle system on top of it.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2729

## Screenshots

![Screenshot](screenshots/object.png)

![Screenshot](screenshots/battle.png)

## How to Learn This Project

> Part of **Ch. 8 – Game Architecture & Larger Projects** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

**Project-scale architecture: how to build a multi-screen game out of self-contained systems that talk over signals.** This is a complete, finishable JRPG in miniature — walk a slime around a tiled overworld, bump an NPC to read branching **JSON dialogue**, fade to black into a **turn-based battle** (Attack / Defend / Flee, with health bars and a turn queue), and read a win-or-lose line on the way back. The individual mechanics (grid movement, dialogue, combat) are each small; the lesson is how they are *composed*:

- **Screens are swapped, not hidden.** `game.gd` keeps the overworld and combat as two scene instances and switches between them by `add_child`/`remove_child` (detaching the inactive one from the tree entirely), bracketed by a `fade_to_black` tween.
- **Signals are the connective tissue.** A bump raises dialogue; finished dialogue starts combat; a death finishes combat; finished combat shows a closing line — each system knows almost nothing about the others, just which signals to emit and await.
- **Reusable component scenes.** The same `Health` node, the same `Walker` movement base, and the same dialogue player are shared between the overworld and the arena.

It is the capstone for the whole curriculum: grid movement reuses the Chapter 3 `TileMapLayer`, the slimes reuse animation, and the whole flow is stitched together with the signal-driven thinking introduced by 8.1 (the state-machine demo).

### Key nodes & classes to understand

- **`Grid`** (`grid_movement/grid/grid.gd`) — a `TileMapLayer` that is also the movement/collision authority. It carries a `CellType` enum (`ACTOR`/`OBSTACLE`/`OBJECT`), paints each child pawn's cell in `_ready()`, and answers **`request_move(pawn, direction)`**: map the pawn to a cell, look at the target cell's `source_id`, and either return the new `map_to_local` position, or — if the target holds an `ACTOR`/`OBJECT` with a `DialoguePlayer` — open dialogue with it (and return `Vector2i.ZERO` so the pawn stays put).
- **`Pawn → Walker → {Player, Opponent}`** (`grid_movement/pawns/`) — the inheritance chain. `Pawn` owns `type` + an `active` setter that flips `set_process`/`set_process_input`. `Walker` adds grid-aware **tweened cell-to-cell movement**: `move_to()` builds a `create_tween()` whose duration is read from the `walk` animation's `length`, so the slide and the step stay in lock-step, plus a `bump()` for blocked moves. `Player._process()` polls input and asks the grid for permission; `Opponent` just sits still (`set_process(false)`).
- **`game.gd`** — the orchestrator. Owns `combat_screen` and `exploration_screen`, **swaps them via `remove_child`/`add_child`**, drives the `fade_to_black` `AnimationPlayer` with `await animation_finished`, and in `_ready()` wires every overworld actor's `DialoguePlayer.dialogue_finished` to `_on_opponent_dialogue_finished` (using `.bind(n)` to remember *which* NPC). Follow this file end-to-end to see the whole game loop.
- **`DialoguePlayer` + `interface.gd`** (`dialogue/`) — JSON dialogue. `DialoguePlayer` opens a `.json` file with `FileAccess`, parses it with `JSON.new().parse()`, and walks `dialogue_keys` on `next_dialogue()`. `interface.gd` connects `dialogue_started`/`dialogue_finished` to `player.set_active` **with `.bind(false)`/`.bind(true)`** so the player freezes during conversation, then **disconnects** them on completion — a clean example of temporary, scoped signal wiring.
- **`combat.gd`** — the battle controller. Instantiates each combatant from a `PackedScene`, connects its `Health.dead` signal, and exposes `initialize()`/`clear_combat()`. `_on_combatant_death()` picks the *other* combatant as the winner and emits `combat_finished`.
- **`TurnQueue`** (`combat/turn_queue.gd`) — turn-based flow driven by `await`. `play_turn()` `await`s the active combatant's **`turn_finished`** signal, then `pop_front`/`append`s the queue (a *rotating* queue) and recurses. `active_combatant` is a property with a setter that toggles `active` and emits `active_combatant_changed`.
- **`Combatant` + `opponent.gd` + `health.gd`** (`combat/combatants/`) — `Combatant` has `attack`/`defend`/`flee` actions that each **`emit turn_finished`** (the exact signal the TurnQueue awaits); its `active` setter resets `armor` each round. `opponent.gd` is the AI: when it becomes active it `await`s a `Timer` then attacks — i.e. the enemy "takes a turn" by yielding on time. `Health` (`life`/`max_life`/`armor`, `take_damage`/`heal`, emits `health_changed`/`dead`) is shared by overworld pawns and combatants.
- **The combat UI** (`combat/interface/ui.gd`) — a `CanvasLayer` that builds a health-bar row by listening to each `Health.health_changed`, and routes the Attack/Defend/Flee buttons to the `Player` combatant only when it `is active`.

### Recommended reading order

1. `game.gd` → the whole flow in 58 lines. Read `_ready()` (how overworld dialogue is wired), then `start_combat()` (the `fade → remove exploration → add combat → fade` swap), then the two `_on_*` callbacks that close the loop back to the overworld. This is the map of the game.
2. `grid_movement/grid/grid.gd` → the `CellType` enum and `request_move()`. This is the entire grid-collision and "bump to talk" model; `get_cell_source_id()` returning `-1` means "empty walkable cell".
3. `grid_movement/pawns/pawn.gd` → `walker.gd` → `player.gd` (then `opponent.gd`). Watch how `move_to()` ties the tween's duration to the `walk` animation length, and how `set_process(false)` during a move prevents input stacking.
4. `grid_movement/exploration.tscn` → note the multiple `TileMapLayer`s (`Ground`, `Pathways`, the actors' occupancy layer) and the instanced `Player`/`Opponent` pawns, each carrying an exported `combat_actor: PackedScene` and a `DialoguePlayer` child.
5. `dialogue/dialogue_player/dialogue_player.gd` → `dialogue/interface/interface.gd`. See `FileAccess` + `JSON.parse()`, then the `.bind()`/`disconnect` dance that freezes/unfreezes the player around a conversation.
6. `combat/combat.gd` → `combat/turn_queue.gd` → `combat/combatants/combatant.gd` → `opponent.gd` → `health.gd`. The chain to follow is the **`turn_finished` signal**: who emits it (the active combatant's actions), and who awaits it (the TurnQueue's `play_turn`).
7. `combat/combat.tscn` + `combat/interface/ui.gd` → the arena scene and its `CanvasLayer` UI (health bars built from the `info` scene, and the three buttons). Run the demo (`WASD`/arrows to walk, bump the NPC, Attack/Defend/Flee in battle) and follow a full overworld→dialogue→combat→overworld cycle.

> **The one-line contract:** each system (`Grid`, `DialoguePlayer`, `TurnQueue`, `Combatant`) is self-contained and exposes its state through **signals**; `game.gd` wires those signals together and `await`s them to drive the screen-by-screen flow. Nothing reaches into another system's internals.

### Hands-on exercise

1. Add a **heal pickup** on the overworld: a new `OBJECT`-typed pawn (give it a `CellType.OBJECT` `type` and a `DialoguePlayer`-like child) that, when bumped, calls the player's combat `Health.heal(...)` instead of starting combat. Reuse `request_move`'s `OBJECT` branch — you'll find it already routes objects through dialogue, so decide whether to heal before or after the line.
2. Make combat **turn-order depend on a stat**: give each `Combatant` an exported `speed`, and change `TurnQueue.set_queue` to sort by `speed` descending on `initialize()` instead of using raw child order. Confirm the faster combatant acts first.
3. Stretch goal: the game swaps screens by `remove_child`. Add a **third screen** — a simple "victory" `CanvasLayer` with stats — and extend `game.gd`'s `_on_combat_finished` to route to it on a player win before returning to the overworld, reusing the same `fade_to_black` tween pattern.
