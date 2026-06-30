# Drawable Textures

This is a simple demo in which you can paint using a
[DrawableTexture](https://docs.godotengine.org/en/stable/tutorials/rendering/drawable_textures.html).

The code shows how to draw on the texture, and the same texture is being copied
to a sphere and cube mesh to give a better example of how it can be used in-game.

Language: GDScript

Renderer: Compatibility

## Screenshots

![Drawable Textures](screenshots/screenshot.webp)

## How to Learn This Project

> Part of **Ch. 2 – Custom Drawing & Vector Graphics** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches
A working **paint program** built on **`DrawableTexture2D`** — a GPU-side texture you can draw onto at runtime. You paint on a 2D `TextureRect`, and that *same* texture is simultaneously wrapped around a 3D cube/sphere, so every brushstroke updates the 3D model live. It is the modern, GPU-blit way to do runtime texture painting (decals, whiteboards, customizable skins).

### Key nodes & classes to understand
- **`DrawableTexture2D`** — the star. Created in code with `new()` + `setup(width, height, DRAWABLE_FORMAT_RGBA8)`. You paint onto it and read it back like any `Texture2D`.
- **`blit_rect(rect, texture, modulate, …)`** — the GPU blit that stamps one texture (the brush) into a region of the drawable texture. This is the entire paint operation.
- **Resource sharing** — one `DrawableTexture2D` is assigned to *both* `drawing_canvas.texture` (a `TextureRect`) and the cube's `StandardMaterial3D.albedo_texture`. Mutate the texture once; both views update.
- **The brushes** — a "brush" is just a `GradientTexture2D` with a radial fill and fading edges; the "eraser" is the same brush filled with the background color (erasing is painting background). A third brush is a preloaded `CompressedTexture2D` (the Godot logo stamp). Brush size is the texture's `width`/`height`.
- **`gui_input` signal** — the `Canvas` `TextureRect` emits `gui_input` for mouse events; `_on_canvas_gui_input()` routes left-button to paint and right-button to erase.
- **Signal `.bind()`** — the color-swatch `ColorRect`s connect `gui_input` to one handler bound with each swatch's color (`change_brush_color.bind(color_rect.color)`), so a single method handles all nine swatches.
- **3D preview plumbing** — `SubViewport` + `SubViewportContainer` embed a 3D scene (cube/sphere `MeshInstance3D`, `Camera3D`, `DirectionalLight3D`) inside the 2D UI; the Cube/Sphere buttons just toggle `visible`.
- `@export var` arrays (`color_rects: Array[ColorRect]`) and Inspector wiring in `main.tscn` — note the root node's `node_paths=...` assigning all the `@export` references at once.

### Recommended reading order
1. **`main.tscn`** — see the layout: a left "drawing panel" (`TextureRect` canvas + color swatches + Godot stamp + size `HSlider`) and a right `SubViewportContainer` showing the 3D cube/sphere. Read the root `Main` node's `node_paths=...` to see every `@export` wired up, and the `[connection ...]` block (`gui_input`, `value_changed`, two `pressed`) for the UI wiring.
2. **`main.gd → _ready()`** — the setup. In order: create + `setup()` the `DrawableTexture2D`; attach it to both the cube's material and the canvas; build the brush/eraser `GradientTexture2D`s; preload the Godot brush; then connect the swatch `gui_input` signals with `.bind(color)`.
3. **`_on_canvas_gui_input()` → `_paint_at()`** — the core loop. See how a mouse position becomes a centered `Rect2i` and a single `blit_rect()` stamps the brush (or eraser, or Godot stamp) onto the drawable texture.
4. **The color/size handlers** — `change_brush_color()` (recolours the gradient so the brush paints a new color), `change_brush_to_godot()`, and `_on_size_h_slider_value_changed()` (resizes brush + eraser). The cube/sphere buttons just flip visibility.

### Hands-on exercise
1. Add a "Clear" button that re-paints the entire drawable texture with the background color in one `blit_rect` call (use a full-size rect).
2. Give the brush a color picked from a new `ColorPicker` node instead of the fixed swatches.
3. Stamp the Godot-logo brush along the mouse's drag path continuously (right now `_paint_at` fires per event) so dragging leaves an unbroken trail.
