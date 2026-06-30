# Hierarchical Finite State Machine

This example shows how to apply the State machine programming
pattern in GDscript, including Hierarchical States, and a
pushdown automaton.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2714

## Why use a state machine

States are common in games. You can use the pattern to:

1. Separate each behavior and transitions between behaviors,
   thus make scripts shorter and easier to manage.

2. Respect the Single Responsibility Principle.
   Each State object represents one action.

3. Improve your code's structure. Look at the scene tree and
   FileSystem tab: without looking at the code, you'll know
   what the Player can or cannot do.

You can read more about States in the excellent
[Game Programming Patterns ebook](https://gameprogrammingpatterns.com/state.html).

## Screenshots

![Screenshot](screenshots/fsm-attack.png)

## How to Learn This Project

> Part of **Ch. 8 – Game Architecture & Larger Projects** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

**The State pattern as a reusable *engine* — not one hand-written state machine, but a generic one you can drop into any character.** A top-down `CharacterBody2D` walks, runs, jumps, swings a 3-hit combo sword, and flinches when hit, and *each of those behaviors lives in its own tiny script*. Two ideas make it scale:

1. **Hierarchical states via `extends`.** States inherit from other states (`motion.gd → on_ground.gd → idle.gd`), and `return super.handle_input(input_event)` bubbles input *up* the chain — so the jump key is handled once in `on_ground`, the "simulate damage" key once in `motion`, and only the leftover reaches the leaf state.
2. **A pushdown automaton.** Interrupt states (`jump`/`attack`/`stagger`) aren't transitions that have to remember where to go back to — they are **pushed onto a stack** on top of the locomotion state, and emit `"previous"` to **pop** back to whatever was underneath.

There is even a **second, independent state machine inside the `Sword`** that owns the combo timing: the player FSM decides *when* to swing (the `attack` key can interrupt anything); the sword FSM decides *how* the swing plays (combo count, hit de-dup, animation function-track windows). It is the complete answer to "how do I keep a growing character organized?"

### Key nodes & classes to understand

- **`State`** (`state_machine/state.gd`) — the abstract interface every state implements: `enter()`/`exit()`/`handle_input()`/`update()`/`_on_animation_finished()`, plus the **`finished(next_state_name)`** signal. A state never loops or branches on "what am I currently doing" — it just does its thing and *emits* `finished` when it wants out.
- **`StateMachine`** (`state_machine/state_machine.gd`) — a plain `Node` that is the heart of the pattern. It owns a **`states_map`** (name→node), a **`states_stack`**, and the `current_state`. On `_enter_tree()` it connects **every child state's `finished` signal to `_change_state`**, picks the start state from `@export start_state` (or `get_child(0)`), and then *delegates*: `_unhandled_input` → `current_state.handle_input()`, `_physics_process` → `current_state.update()`. The body and the FSM are deliberately separate nodes.
- **`_change_state(name)`** — the one transition function. `current_state.exit()`; then the stack rule: `"previous"` **pops** the front of the stack (pushdown), otherwise the stack's top is **swapped** to `states_map[name]`; then `enter()` the new top.
- **`PlayerStateMachine`** (`player/player_state_machine.gd`) — extends the generic machine with player-specific rules: in its override of `_change_state` it **pushes** the interrupt states (`stagger`/`jump`/`attack`) onto the stack *before* calling `super`, and seeds `jump` with `move`'s `speed`/`velocity` so an in-air jump preserves momentum. Its `_unhandled_input` override lets the `attack` key interrupt *any* state except `attack`/`stagger`.
- **The `extends` hierarchy** under `player/states/` — `motion.gd` (shared: input direction, look direction, the `simulate_damage` key) → `on_ground.gd` (the `jump` key, walk/run `speed`) → `idle.gd` & `move.gd` (the two grounded locomotion states); and `motion.gd → jump.gd` (procedural arc: gravity on `vertical_speed`, `height`, `BodyPivot.position.y = -height`). `idle ↔ move` swap the stack top; `jump`/`attack`/`stagger` push and pop.
- **The `owner` convention** — every state reads/writes the body through `owner.` (`owner.velocity`, `owner.move_and_slide()`, `owner.get_node("AnimationPlayer").play(...)`). `player_controller.gd` is the `CharacterBody2D` body and knows nothing about states; it owns `look_direction`, `take_damage()` (sets knockback + pokes `$Health`), and `set_dead()` (disables input/physics/collision for the terminal `Die` state).
- **`Sword`** (`player/weapon/sword.gd`) — a **second FSM** (`States.IDLE/ATTACK` + `AttackInputStates.IDLE/LISTENING/REGISTERED`). It fires when the player FSM's `state_changed` signal reports the `Attack` node; runs a 3-step `combo` table; uses **AnimationPlayer function tracks** (`set_attack_input_listening`, `set_ready_for_next_attack`) to open/close combo windows; keeps a `hit_objects` list so one swing can't damage the same body twice; and reports back via `attack_finished` so the player FSM pops `"previous"`.
- **`BulletSpawn`/`Bullet`** — a separate, FSM-independent ranged attack: `BulletSpawn` fires on the `fire` key behind a `CooldownTimer`; `Bullet` is a `set_as_top_level(true)` `CharacterBody2D` that frees itself off-screen or on contact.
- **Debug UI** — `debug/states_stack_displayer.gd` reads `fsm_node.states_stack` every frame and prints it, so you can literally *watch* the stack grow when you jump/attack and shrink when you land. `StateNameDisplayer` labels the current state above the player's head.

### Recommended reading order

1. `state_machine/state.gd` (29 lines) → the contract. Read the five methods and the `finished` signal — this is *all* a state promises to do.
2. `state_machine/state_machine.gd` → the engine. Trace `_enter_tree()` (how it adopts its children and wires their `finished` signals), then `_change_state()` and the `"previous"` pop. Understand the delegation in `_unhandled_input`/`_physics_process` before anything else.
3. `player/player_state.gd` → just the `PLAYER_STATE` name dictionary; then `player/player_state_machine.gd` → see how it specializes the base: the push rule for `stagger`/`jump`/`attack`, the `jump.initialize(...)` hand-off, and the global `attack`-interrupt in `_unhandled_input`.
4. The state hierarchy in inheritance order: `player/states/motion/motion.gd` → `on_ground/on_ground.gd` → `on_ground/idle.gd` and `on_ground/move.gd`, then `in_air/jump.gd`. In each, find the one `super.handle_input()` call that bubbles input upward, and the one `finished.emit(...)` that requests a transition.
5. `player/Player.tscn` → read the node tree (`StateMachine` with its five child states + `Die`), then the `[connection ...]` block at the bottom — that is the runtime wiring: `state_changed → Sword` and `→ StateNameDisplayer`, `animation_finished → StateMachine`, `attack_finished → Attack`. Then `player/player_controller.gd` for the body itself.
6. `player/weapon/sword.gd` → the second FSM. Note the combo table, the `hit_objects` de-dup, and how function tracks call `set_attack_input_listening`/`set_ready_for_next_attack`.
7. `debug/states_stack_displayer.gd` → run the demo (`WASD`/arrows move, `Space` jump, `Shift` run, `F` attack, `R` fire, `X` simulate damage) and watch the printed stack push on jump/attack and pop on land.

> **The one-line contract:** a `State` does its job and `emit`s `finished` when it's done; the `StateMachine` owns the stack and decides what "finished" means (`"previous"` pops, a name swaps/pushes); the body is just a body.

### Hands-on exercise

1. Add a **`Block`** defense state: create `player/states/combat/block.gd` extending `player_state.gd`, make it push onto the stack (like `stagger`) when a new `block` key is held and pop on release, and have it tint the body via the existing `AnimationPlayer`. Add it to `states_map` in `player_state_machine.gd`. Watch it appear/disappear in the debug stack displayer.
2. Refactor so `attack` is **not** a global interrupt: right now `_unhandled_input` in `player_state_machine.gd` lets the attack key fire from any state. Move that decision into the locomotion states' `handle_input` instead, so you can *only* attack while `idle`/`move`, and observe how the Single-Responsibility split changes.
3. Stretch goal: the `Die` state exists in `Player.tscn` but is not wired into `states_map` and never fires. Wire it up — have `$Health` emit a signal on death (you'll need to give the player a `Health` node like the sword's targets have) that pushes `Die`, and confirm `set_dead(true)` cleanly halts the body.
