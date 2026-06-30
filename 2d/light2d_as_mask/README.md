# 2D Lights as Mask

Example of how to use 2D lights to mask objects on screen.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2720

## Screenshots

![Screenshot](screenshots/mask.png)

## How to Learn This Project

> Part of **Ch. 6 – Shaders & Lighting** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

**Using a 2D light as a reveal mask.** The photograph (`burano.png`) is completely hidden in darkness and appears *only* inside three moving pools of light. The effect hinges on one `CanvasItemMaterial` property — `light_mode = LIGHT_MODE_ONLY_LIGHT` — which makes the sprite render solely where a `Light2D` illuminates it. Three `PointLight2D`s, each shaped by a `splat.png` texture and set to `blend_mode = MIX`, sweep across the image driven by an `AnimationPlayer`. This is the smallest possible "what does a `Light2D` do to a sprite" demo — no shadows, no occluders, no normal maps, just the mask.

### Key nodes & classes to understand

- **`CanvasItemMaterial.light_mode`** — the crux. `LIGHT_MODE_ONLY_LIGHT` (= 2) means the surface is black where unlit and visible only inside a light's coverage; that single property *is* the masking effect.
- **`PointLight2D`** — the moving light source. Its **`texture`** (`splat.png`) shapes the light's intensity falloff into an organic blob instead of the default radial gradient, so the "reveal" has soft, irregular edges.
- **`Light2D.blend_mode`** — the lights use `MIX` (= 2), which reveals the photo at its true color. (`ADD`, the default, would brighten/wash out the lit region instead.)
- **`AnimationPlayer`** — a single looping `maskmotion` animation drives three value tracks, one per light's `position`, so the three pools roam independently.
- `TextureRect` + `Camera2D` — the photo is a UI `TextureRect` (not a `Sprite2D`); lights still affect it because `Light2D` illuminates any `CanvasItem` whose material opt in.

### Recommended reading order

1. `lightmask.tscn` — read the whole tree (this demo is one file). Start with the `Burano` `TextureRect` and its `CanvasItemMaterial` sub-resource: that `light_mode = 2` line is the entire trick.
2. The three `PointLight2D` nodes (`Light1/2/3`) — note the shared `splat.png` `texture` and `blend_mode = 2`.
3. The `Animation` sub-resource (`maskmotion`) — see the three `position` value tracks that move the lights, and the `autoplay` on the `AnimationPlayer`.
4. `project.godot` — note `renderer/rendering_method = "gl_compatibility"`; `Light2D` masking works on the Compatibility renderer, unlike the HDR glow in the `glow` demo.

### Hands-on exercise

1. Select the `Burano` `TextureRect`, change its material's `light_mode` back to `LIGHT_MODE_NORMAL` (0), and re-run — the full photo should reappear, confirming that `ONLY_LIGHT` is what hides it.
2. Swap one light's `texture` from `splat.png` to the default `null` and watch its reveal become a clean radial circle; then try `blend_mode = ADD` to see the photo get washed bright instead of cleanly revealed.
3. Stretch goal: add a fourth `PointLight2D` and a fourth `position` track to the `maskmotion` animation so a new pool of light joins the sweep.
