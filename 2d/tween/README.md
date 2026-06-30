# Tween Interpolation

A demo showing advanced tween usage.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2733

## Screenshots

![Screenshot](screenshots/tween.png)

## How to Learn This Project

> Part of **Ch. 1 – First Steps: Nodes, Scenes & Scripts** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches
A deep tour of **`Tween`** — Godot's built-in animation system for interpolating *any* property or method over time without an `AnimationPlayer`. The UI lets you toggle ten independent animation "steps," each demonstrating a different Tween technique: chained tweens, parallel tweens, easing/transitions, looping, callbacks, method-tweening along a path, and even sub-tweens.

### Key nodes & classes to understand
- `create_tween()` → `Tween`, and the `Tweener` objects returned by `tween_property()` / `tween_method()` / `tween_callback()` / `tween_interval()`.
- Method chaining — `Tween` and `Tweener` methods return `self`, so calls link together.
- `parallel()` — run a tweener alongside the previous one instead of after it.
- `set_ease()` / `set_trans()` — controlling *how* a value moves (e.g. `EASE_OUT`, `TRANS_ELASTIC`).
- `set_loops()`, `set_speed_scale()`, `as_relative()`, `bind()` — looping, time-scaling, relative motion, and bound callbacks.
- `%UniqueNode` access (e.g. `%Icon`, `%SpeedSlider`) — the `%` syntax for reaching uniquely-named nodes.
- `Path2D` / `Curve2D` + `sample_baked()` — used by the "Curve" step to move the icon along a path.

### Recommended reading order
1. **`main.tscn`** — the UI is the spec. Each of the ten columns is one step: a `CheckBox` plus optional `Ease`/`Trans` `OptionButton`s. Read the `[connection ...]` block to see which button calls which method (`start_animation`, `pause_resume`, `kill_tween`, `speed_changed`).
2. **`main.gd` → `start_animation()`** — read it **step by step (1–10)**. Each `if is_step_enabled(...)` block is one technique: (1) tween a position, (2) tween color, (3) relative move + parallel `rotation`, (4) relative move + a lambda **sub-tween** for a jump arc, (5) hide/show blinking via callbacks, (6) zero-duration "teleport" + `bind`, (7) `tween_method` along a `Path2D`, (8) `tween_interval` wait, (9) countdown via `tween_method`, (10) scale + fade out.
3. **Helper functions** — `is_step_enabled()` (also accumulates the progress bar's max), `reset()`, `pause_resume()`, `kill_tween()`, `speed_changed()`. These show how to *control* a running tween.

### Hands-on exercise
1. Add an **11th step** (a new `CheckBox` + block in `start_animation()`) that scales the icon's `scale` in a `TRANS_BOUNCE` loop.
2. In the "Curve" step, redraw the `Path2D`'s curve in the editor and watch the icon follow your new shape.
3. Replace the icon's `position` tween with a `tween_method` that draws a perfect circle around the screen center using `sin`/`cos`.
