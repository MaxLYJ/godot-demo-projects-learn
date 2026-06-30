# 2D Particles

This demo showcases how 2D particle systems work in Godot.

Language: GDScript

Renderer: Mobile

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2724

## How does it work?

It uses [`GPUParticles2D`](https://docs.godotengine.org/en/latest/classes/class_gpuparticles2d.html) nodes
with [`ParticleProcessMaterial`](https://docs.godotengine.org/en/latest/classes/class_particleprocessmaterial.html)
materials. Note that `ParticleProcessMaterial` is agnostic between 2D and 3D,
so when used in 2D, the "Disable Z" flag should be enabled.

## Screenshots

![Screenshot of particles](screenshots/particles.webp)

---

## How to Learn This Project

> Part of **Ch. 7 – Animation, Skeletons & Particles** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

**The 2D GPU particle system in full breadth.** The scene is not a game — it is a wall of **17 labeled `GPUParticles2D` emitters**, each isolating one feature so you can see exactly which property produces which effect. Together they cover everything you need: basic emission (fire/smoke/magic), animated **flipbook** textures, **mask-shaped** emission from a texture, **sub-emitter** chains, **turbulence**, all three **collision** modes, **trails**, and **global-coordinate** emission from a moving emitter. The single script (`pause.gd`) only wires up keyboard toggles; every visual is configured purely through the node + its `ParticleProcessMaterial` in the Inspector. Treat this project as a reference catalog: pick the effect you want, find its emitter, read its properties.

### Key nodes & classes to understand

- **`GPUParticles2D`** — the emitter node. Core properties to learn from this scene: `amount`, `lifetime`, `explosiveness` (the *Explosion* node sets `1.0` for a single burst), `randomness`, **`preprocess`** (*Fire* = 1 s, *Flipbook* = a full lifetime — pre-simulates so particles are already mid-stream when the scene opens), `texture`, and `interpolate` (several nodes set it `false`). Node-level **trails** live here too: `trail_enabled`/`trail_lifetime`/`trail_sections` (see *CollisionRigid*).
- **`ParticleProcessMaterial`** — the simulation material. It is **shared between 2D and 3D**, which is why the single most important 2D setting is **`particle_flag_disable_z = true`** (9 of the 17 emitters set it; without it particles fly off into the Z axis). Every emitter in the scene owns one.
- **Emission shapes** — the `emission_shape` enum, exercised across the gallery: `SPHERE`, `SPHERE_SURFACE`, `BOX`, `POINTS`, `POINTS_NORMALS`, `DIRECTED_POINTS`. The three **mask** emitters (*EmitMask* / *OutlineMask* / *DirectionMask*) go further, using `emission_point_texture` and `emission_normal_texture` to emit from a shape's fill, outline, and outline-with-direction.
- **Velocity & forces** — `direction` + `spread` + `initial_velocity_min/max` (how fast and how wide particles launch), `gravity` (note several emitters set it to `Vector3(0,0,0)` so particles drift), `scale_curve` (a `CurveTexture` shrinking particles over their lifetime), and `color` (HDR-overbright values `> 1.0` bloom via the scene's `WorldEnvironment` glow — the same trick as Ch. 6.2).
- **Sub-emitters** — `sub_emitter` (a `NodePath` to another `GPUParticles2D`) + `sub_emitter_mode`: `AT_END` fires when a particle dies (*ParticlesWithSubemitter → Sparks → Smoke* is a chain), `AT_COLLISION` fires on contact; `sub_emitter_keep_velocity` hands the parent's velocity to the child.
- **Turbulence** — `turbulence_enabled` + `turbulence_noise_strength` / `_speed` / `_speed_random` add a swirling vector field (the *Turbulence* node).
- **Collision** — `collision_mode` against the scene's `LightOccluder2D` colliders: `RIGID` bounces (*CollisionRigid*, `collision_base_size = 0.5`), `HIDE_ON_CONTACT` kills the particle on touch (*CollisionHideOnContact*), and *CollisionHideOnContactSpawnSubemitter* hides *and* spawns a sub-emitter on impact.
- **Global coordinates** — *MagicGlobalCoordinates* is a child of a `Path2D`/`PathFollow2D` so its particles stay in world space while the emitter moves (an `AnimationPlayer` drives `PathFollow2D.progress_ratio` on loop).
- **Renderer caveat** — particle **trails** are a Forward+/Mobile feature. `pause.gd` checks `RenderingServer.get_current_rendering_method()` and, on the Compatibility renderer, hides the trail controls (showing an `UnsupportedLabel`) and bumps `glow_intensity` to compensate for the lower dynamic range. This is why the demo runs on the **Mobile** renderer.

### Recommended reading order

1. `particles.tscn` → scan the 17 `GPUParticles2D` nodes (each is clearly named for what it teaches: *Fire*, *Smoke*, *Magic*, *Flipbook*, *EmitMask*, *ParticlesWithSubemitter*, *Turbulence*, *CollisionRigid*, …). Note the 5 `LightOccluder2D` nodes near the bottom — those are the colliders the collision demos bounce off.
2. Pick **two emitters and diff their materials**: open *Fire*'s `ParticleProcessMaterial` (sphere emission, upward gravity, `scale_curve`) and *Explosion*'s (node `explosiveness = 1.0` + `emission_shape = SPHERE_SURFACE`). Seeing what differs between a continuous flame and a one-shot burst is the fastest way to internalize the property set.
3. Open the **mask** trio (*EmitMask*, *OutlineMask*, *DirectionMask*) and compare their `emission_shape` and textures — this teaches texture-driven emission, the most flexible way to shape a particle source.
4. Read the **sub-emitter** and **collision** clusters as small node trees: *ParticlesWithSubemitter → SubemitterEndSparks → SubemitterEndSmoke* (a 3-deep chain) and *CollisionHideOnContactSpawnSubemitter → CollisionSubemitter* (spawn on impact). Note each parent's `sub_emitter` `NodePath` and `sub_emitter_mode`.
5. `pause.gd` → the only script. Read `_ready()` (the renderer check + `UnsupportedLabel` + `glow_intensity` bump) and `_input()` (the `trailable_particles` group loop for trails, and the glow toggle). Everything else is data on the nodes.

> **The two settings you must not forget for 2D:** `particle_flag_disable_z = true` on the material, and the renderer caveat that **trails** need Forward+/Mobile.

### Hands-on exercise

1. With the game running, press <kbd>T</kbd> to toggle trails on the `trailable_particles` group, then <kbd>+</kbd>/<kbd>-</kbd> to grow/shrink `trail_lifetime` — watch the *Fire* and *Magic* emitters draw streaks. (On the Compatibility renderer this is disabled; note the `UnsupportedLabel`.)
2. Duplicate the *Explosion* node and turn it into a continuous fountain: set `explosiveness = 0.0`, give the material an upward `gravity` and a `scale_curve` that grows then shrinks, then trigger it from `pause.gd` with a new input key.
3. Stretch goal: add a new `GPUParticles2D` that emits from `emission_shape = BOX` shaped like a thin bar (a "laser charging" effect), then make it spawn a `HIDE_ON_CONTACT` sub-emitter on impact with one of the `LightOccluder2D` colliders — combining mask emission, collision, and sub-emitters from earlier exercises.
