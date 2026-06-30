# Skeleton2D Demo

This demo shows how to create a rigged and animated character in 2D using
Godot's Skeleton2D node. There are several movement-related animations and
there is a simple character controller that controls the animations.

Language: GDScript

Renderer: Compatibility

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/2731

## Licenses

GBot character Copyright &copy; circa 2020 Andreas Esau, MIT License.

Initial rigging and animating Copyright &copy; 2020 RustyStriker, MIT License.

## Screenshots

![Screenshot](screenshots/screenshot.png)

---

## How to Learn This Project

> Part of **Ch. 7 – Animation, Skeletons & Particles** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

**2D cut-out (skeletal) animation end-to-end.** The robot you control is not a sprite sheet — it is a *rig*: 7 visible `Polygon2D` "skin" pieces glued to a 14-bone `Skeleton2D`. An `AnimationPlayer` rotates the bones, the skinned polygons deform to follow, and an `AnimationTree` blends the 8 clips live so the on-screen pose always matches what the character is doing (idle/walk/run while grounded, fly/fall in the air, plus jump/land/land-hard layered on as one-shots). Crucially, the walk and run animations are *sped up and slowed down* to match the player's horizontal velocity — that responsiveness is what makes skeletal animation feel good, and it is the `AnimationTree` (not the `AnimationPlayer`) that delivers it. This is the only demo in the repo that touches rigging, skinning, and the AnimationTree at once, so it is the place to learn the whole pipeline.

### Key nodes & classes to understand

- **`Skeleton2D`** + **`Bone2D`** — the invisible rig. Open `player.tscn` and expand `Sprite2D/Skeleton2D`: `Hip → Chest → {Head → Chin, LeftArm/RightArm → Forearm → Hand}` and `Hip → {LeftLeg/RightLeg → LowerLeg → Foot}` — 14 bones, each with a `rest` pose (its default local transform). Bones are just `Node2D`s arranged in a parent chain, so rotating a parent bone rotates all its children.
- **`Polygon2D` (as a skinned mesh)** — under `Sprite2D/Polygons` are 7 polygons (`Body`, `Head`, `Chin`, `LeftArm`, `RightArm`, `LeftLeg`, `RightLeg`). Each has `skeleton = NodePath("../../Skeleton2D")` and a `bones` array giving **every vertex a weight per bone** (e.g. an elbow vertex is `0.5` upper-arm / `0.5` forearm). This weight-painting is what lets a single polygon bend smoothly across a joint. The texture is one shared `gBot.png`.
- **`AnimationPlayer`** — holds the `AnimationLibrary` of 8 clips (`idle`, `walk`, `run`, `fly`, `fall`, `jump`, `land`, `land_hard`). Each clip's tracks key `rotation_degrees` on the `Bone2D`s (and `Hip.position` for crouch) — i.e. **the animations move the bones, never the polygons directly**.
- **`AnimationTree`** (the real star) — its `tree_root` is an **`AnimationNodeBlendTree`** that wires together:
  - an **`AnimationNodeTransition`** named `state` — the 5-way locomotion blend (`idle`/`walk`/`run`/`fly`/`fall`) with a 0.1 s crossfade;
  - **`AnimationNodeTimeScale`** nodes on `walk` and `run` — scale playback speed to `velocity.x` so stride matches movement;
  - three **`AnimationNodeOneShot`** nodes — `jump`, `land`, `land_hard` — that fire once on top of the base locomotion (and `land_hard` uses a track **filter** so only some bones react).
- The **parameter API** in `player.gd` — you drive the tree by writing its parameter paths: `parameters/state/transition_request = States.WALK`, `parameters/jump/request = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE`, `parameters/run_timescale/scale = abs(velocity.x) / 60`.
- **`CharacterBody2D`** locomotion — `move_andoward` accel/decel, manual gravity + `TERMINAL_VELOCITY`, **variable jump height** (`velocity.y *= 0.6` when the player releases jump early), `floor_snap_length`, and facing by flipping `sprite.scale.x` (the rig sits under a `Node2D` *named* `"Sprite2D"`, not a `Sprite2D` node).

### Recommended reading order

1. `player/player.tscn` → the `Sprite2D/Skeleton2D` subtree first. Expand the `Bone2D` chain to see the rig, then look at one `Polygon2D` under `Polygons` (e.g. `RightArm`) and read its `bones` array to see vertex→bone weights — that is skinning in its raw form.
2. Still in `player.tscn`, jump to the bottom and read the `AnimationPlayer` (note the 8 animation names in its library) and the `AnimationTree` node (note its `tree_root` BlendTree and the `parameters/state/...` defaults). Open the BlendTree in the editor's Animation panel to *see* the graph.
3. `player/player.gd` → the whole controller. Read the `States` const (kept in sync with the tree's state names), `_physics_process()` for the locomotion, then the bottom half where every `parameters/...` write happens — that is the code↔tree contract. Note `try_jump()` and the early-release `velocity.y *= 0.6`.
4. `level.tscn` + `level/level.gd` → the world: a `TileMapLayer` for ground, an instanced `ParallaxBackground`, the instanced `SkeletalPlayer`, and two `Marker2D`s whose positions `level.gd` reads to clamp the `Camera2D`.

> **The one-line contract:** the `AnimationPlayer` *holds* the clips; the `AnimationTree` *blends* them; your script picks the state and fires one-shots by writing `parameters/...` paths.

### Hands-on exercise

1. In the AnimationTree editor, select the `state` transition node and drag the `walk`/`run` `scale` sliders while the game runs — then in `player.gd` change the `…/60` and `…/12` divisors in the timescale lines and feel the stride go out of sync with movement.
2. Add a 9th clip: in the AnimationPlayer, duplicate `jump`, rename it `wave`, key only `RightArm`/`RightForearm` to raise the hand, then add an `AnimationNodeOneShot` wired into the BlendTree and fire it from a new input key using the same `ONE_SHOT_REQUEST_FIRE` pattern as `jump`.
3. Stretch goal: expose a `parameters/aim/blend_amount` `AnimationNodeBlend2` that mixes a "look up" arm pose in proportion to `Input.get_axis("move_up","move_down")` while running — a first taste of *procedural* blending layered on top of the clip-based animation.
