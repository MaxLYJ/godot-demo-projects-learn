# 2D Lights and Shadows

Simple demo of 2D lights and shadows, using
[`Light2D`](https://docs.godotengine.org/en/latest/classes/class_light2d.html)
and [`LightOccluder2D`](https://docs.godotengine.org/en/latest/classes/class_lightoccluder2d.html).

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2721

## Screenshots

![Screenshot](screenshots/lights.png)

## How to Learn This Project

> Part of **Ch. 6 – Shaders & Lighting** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

**The complete 2D light-and-shadow system in one scene.** A dark canvas is lit by three colored `PointLight2D`s that cast real-time shadows from 15 blocks, plus a slowly-rotating `DirectionalLight2D` "sun." The lit sprites use a `CanvasTexture` with a **normal map**, so the lights shade them with genuine surface relief (and cheap specular highlights). `CanvasModulate` sets the gloomy ambient. Input lets you toggle lights and cycle shadow quality live, making this the reference room for every 2D lighting concept at once.

### Key nodes & classes to understand

- **`PointLight2D`** — the three colored pools (red/green/blue, all in the `point_light` group). Properties: `color`, `texture` (the light's shape), `range`, `energy`, and `shadow_enabled`.
- **`DirectionalLight2D`** — parallel "sun" rays that sweep as `rotation` animates 0→2π; has `height` (the Z offset that shifts where shadows fall).
- **Shadows** — `shadow_enabled`, `shadow_filter` (`SHADOW_FILTER_NONE` / `_PCF5` / `_PCF13`), and `shadow_filter_smooth`. The demo cycles `shadow_filter` at runtime with `wrapi(…, 0, 3)` so you can compare softness.
- **`LightOccluder2D`** + **`OccluderPolygon2D`** — each of the 15 `ShadowCaster` blocks carries one; the occluder's polygon is the silhouette that blocks light and casts the shadow.
- **`CanvasTexture`** — a richer texture than a plain image: `diffuse_texture` + **`normal_texture`** (`godot_normal.png`, the per-pixel surface normals the lights shade against for fake 3D relief) + `specular_shininess` (the cheap specular highlight). Shown in four flip variants (normal / flip-X / flip-Y / flip-both) to demonstrate that flipping scales the sprite but the lighting still reads correctly.
- **`CanvasModulate`** — the dark global ambient color (`Color(0.27, 0.27, 0.27)`) that tints everything the lights don't reach.
- Node **groups** (`point_light`) toggled via `get_nodes_in_group()`; `AnimationPlayer`s moving the lights and rotating the sun.

### Recommended reading order

1. `light_shadows.tscn` — the node tree is the whole lesson. Note `Ambient` (`CanvasModulate`), the four `CanvasTexture` normal-map sprites, the `Casters`/`ShadowCaster*` block each with a `LightOccluder2D`, the three colored `PointLight2D`s (group `point_light`, `shadow_enabled = true`), and the `DirectionalLight2D`.
2. `light_shadows.gd` — short. Read `_input`: `toggle_directional_light`, `toggle_point_lights` (group toggle), and the two `wrapi(…, 0, 3)` cycles that step `shadow_filter` for the sun and the point lights.
3. The `CanvasTexture` sub-resources — see how `diffuse_texture`, `normal_texture`, and `specular_shininess` combine; flip is done by scaling the `Sprite2D` (`scale = Vector2(-1, 1)` etc.).
4. `project.godot` — the `[input]` section defines the `D`/`P`/`S`/`H` actions shown in the on-screen help, and confirms the Compatibility renderer (2D lights + shadows work here).

### Hands-on exercise

1. Run it and press <kbd>S</kbd> repeatedly to cycle the directional light's `shadow_filter` through NONE/PCF5/PCF13 — watch the block shadows go from hard/jagged to soft. Then press <kbd>D</kbd> to toggle the sun off and see the scene lit only by the three colored pools.
2. Select one of the four normal-map sprites and clear its `CanvasTexture`'s `normal_texture` — the fake 3D relief should vanish and it should shade flatly, proving the normal map is what gives it surface detail.
3. Stretch goal: add a new `Sprite2D` block + `LightOccluder2D` somewhere in the scene and confirm the three point lights all cast a correct shadow from it; then raise `shadow_filter_smooth` to soften the new shadow's edge.
