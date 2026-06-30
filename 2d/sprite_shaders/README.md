# Sprite Shaders

This is a sample consisting of different shaders applied to some sprites.
Effects include outlines, blurs, distorts, shadows, glows, and more.

Language: [Godot shader language](https://docs.godotengine.org/en/latest/tutorials/shaders/shader_reference/shading_language.html)

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2732

## Screenshots

![Screenshot](screenshots/sprite.png)

## How to Learn This Project

> Part of **Ch. 6 – Shaders & Lighting** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

**How to write a 2D fragment shader.** The same `godotea.png` sprite is shown ten times, and each copy wears a different `.gdshader` file that rewrites its pixels: outlines, auras, blur, a "fatty" inflate, drop/offset shadows, a silhouette recolor, glow, and disintegrate. Every effect is small (10–40 lines of GLSL) and built from the same handful of building blocks, so this is the place to learn the *vocabulary* of Godot's `canvas_item` shaders — the built-in variables every `fragment()` function starts from, and the two tricks (neighbor sampling and hash noise) that most 2D sprite effects reduce to.

### Key nodes & classes to understand

- `shader_type canvas_item;` — declares a 2D shader. Its `fragment()` function runs once per pixel of the sprite.
- The fragment built-ins: **`TEXTURE`** (the sprite's own image), **`UV`** (the 0–1 coordinate of the current pixel), **`COLOR`** (your output), and crucially **`TEXTURE_PIXEL_SIZE`** — the size of one texel, which you multiply by an offset to sample a *neighboring* pixel (the basis of outline, blur, and glow).
- **`uniform`** variables — shader parameters exposed to the Inspector as `shader_parameter/…` (`outline_width`, `aura_color`, `radius`, `amount`, `fattyness`, `offset`). The `: source_color` hint marks a `vec4` as a color so it gets a color picker.
- `render_mode` (`blend_mix`, `blend_premul_alpha`) — how the result blends over what's behind it.
- The two recurring techniques: **multi-tap neighbor sampling** (sample `TEXTURE` at `UV ± offset * TEXTURE_PIXEL_SIZE`, then `max`/`min` the alpha for an outline or average several taps for blur/glow) and **hash-based pseudo-noise** (`fract(sin(dot(UV, vec2(12.9898, 78.233))) * 438.5453)`) used to scatter/discard pixels in `dissintegrate.gdshader`.
- `ShaderMaterial` — the resource that binds a `.gdshader` to a `Sprite2D`; one per effect, defined inline in `sprite_shaders.tscn`.

### Recommended reading order

1. `sprite_shaders.tscn` — read the node tree first: ten `Sprite2D`s side by side, all sharing the same `godotea.png` texture but each carrying a different `ShaderMaterial`. Note the root `Node2D` *also* has a `ShaderMaterial` (the outline) that its children inherit.
2. `shaders/outline.gdshader` — the gentlest entry point. See how it samples four neighbors, tracks the `max`/`min` alpha, and draws the outline wherever `maxa - mina` is high.
3. `shaders/blur.gdshader` then `shaders/glow.gdshader` — the same neighbor-sampling idea (a 5-tap then a 17-tap average), with `glow.gdshader` adding `render_mode blend_premul_alpha` and an additive bloom pass.
4. `shaders/dissintegrate.gdshader` — the noise technique: a one-line hash produces per-pixel randomness that gates `col.a`, dissolving the sprite.
5. The rest (`aura`, `fatty`, `dropshadow`, `offsetshadow`, `silouette`) — variants that reuse the same two techniques; read whichever effect you want to recreate.

### Hands-on exercise

1. Open `outline.gdshader` and raise `outline_width` from the Inspector (it's a `shader_parameter`) while the project runs — watch the outline thicken. Then add four *diagonal* taps to the sampling so the outline is uniform on corners as well as edges.
2. In `dissintegrate.gdshader`, animate the `amount` uniform from GDScript (`material.set_shader_parameter("amount", …)`) over time so the sprite progressively crumbles apart instead of dissolving all at once.
3. Stretch goal: write a brand-new `greyscale.gdshader` from scratch — in `fragment()`, sample `TEXTURE`, compute luminance with `dot(col.rgb, vec3(0.299, 0.587, 0.114))`, and assign it back to `COLOR.rgb`. Assign it to one of the sprites to confirm your first hand-written effect.
