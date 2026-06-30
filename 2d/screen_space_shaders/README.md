# Screen Space Shaders

Several examples of full screen 2D shader processing.
Many common full-res effects are implemented here for reference.

Language: [Godot shader language](https://docs.godotengine.org/en/latest/tutorials/shaders/shader_reference/shading_language.html) and GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2730

## Screenshots

![Screenshot](screenshots/whirl.png)

![Screenshot](screenshots/old_film.png)

## How to Learn This Project

> Part of **Ch. 6 – Shaders & Lighting** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

**Full-screen post-processing: a shader that reads the whole rendered frame.** Two dropdowns pick a source photo and an effect; 11 effects (vignette, blur, pixelize, whirl, sepia, negative, contrasted, normalized, BCS, mirage, old film) each transform the *entire screen*. The key leap from the per-sprite shaders earlier in the chapter: instead of sampling the sprite's own `TEXTURE`, these declare a `hint_screen_texture` uniform and sample the back-buffer at `SCREEN_UV` — so the shader is processing whatever Godot already drew. This is exactly how you build camera/scene-wide effects like color grading, distortion, and CRT/film looks.

### Key nodes & classes to understand

- **`hint_screen_texture`** — `uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;`. This opt-in uniform hands the fragment shader the rendered frame; without it, a `canvas_item` shader can't see the screen.
- **`SCREEN_UV`** vs `UV` — `SCREEN_UV` is the coordinate in the back-buffer (what you sample for screen-space effects); `UV` is the sprite's own 0–1 coordinate. They differ, and getting them wrong is the classic full-screen-shader bug.
- **`textureLod(screen_texture, SCREEN_UV, lod)`** — sampling at a specific mipmap level. The screen texture's mipmaps hold *Gaussian-blurred* copies, so raising the LOD is a cheap blur — the `vignette` shader blurs the scene more the darker the vignette gets.
- Effect families to study: **color math** (`sepia`/`negative`/`BCS`/`contrasted`/`normalized` — luminance via `dot(c, vec3(0.333,…))`, plus brightness/contrast/saturation); **coordinate warping** (`whirl` polar rotation, `mirage` sine wobble, `pixelize` `mod()`-quantized UVs); **multi-tap blur**; and **time-driven** film grain (`old_film` keys grain/scratch/flicker to `TIME` quantized by an `fps` uniform for a choppy stop-motion look).
- The **full-screen-quad pattern** — each effect is a full-rect `TextureRect` whose `texture` is a blank `white.png`; its `material` (`ShaderMaterial`) overrides `COLOR` entirely from the screen, so the TextureRect is just a screen-sized canvas for the shader.
- `screen_shaders.gd` — populates two `OptionButton`s from the `Pictures`/`Effects` children, and `_on_*_item_selected` shows the chosen child while hiding the rest.

### Recommended reading order

1. `screen_shaders.tscn` — the node tree: `Pictures` (four source-photo `TextureRect`s) and `Effects` (one `TextureRect` per shader, all sized to the screen), plus the `Picture`/`Effect` `OptionButton`s and their `item_selected` `[connection]` wiring at the bottom.
2. `screen_shaders.gd` — short. See `_ready()` enumerate children into the dropdowns, and the two `_on_*_item_selected` show-one-hide-all handlers.
3. `shaders/negative.gdshader` then `shaders/sepia.gdshader` — the simplest screen shaders. Note the `hint_screen_texture` uniform and the `textureLod(screen_texture, SCREEN_UV, 0.0)` read; everything else is color math.
4. `shaders/pixelize.gdshader` — the simplest *coordinate-warp* effect: `uv -= mod(uv, vec2(size_x, size_y))` before sampling quantizes the image into blocks.
5. `shaders/vignette.gdshader` then `shaders/old_film.gdshader` — the advanced end: mip-based blur (LOD) and `TIME`-driven grain/flicker respectively.

### Hands-on exercise

1. Run it, pick a photo from the left dropdown, and step through every effect in the right dropdown — then open `shaders/negative.gdshader` and confirm the one-line `COLOR.rgb = vec3(1.0) - …` inversion.
2. In `shaders/pixelize.gdshader`, animate the `size_x`/`size_y` uniforms from GDScript (`material.set_shader_parameter("size_x", …)`) over time so the picture pulses between sharp and blocky.
3. Stretch goal: write a new `greyscale_screen.gdshader` (declare `hint_screen_texture`, sample at `SCREEN_UV`, convert to luminance) and add it as an `Effects` child `TextureRect`; it should appear automatically in the dropdown because `_ready()` enumerates the children.
