# Navigation Mesh Chunks 2D

Demo that shows how to bake navigation meshes for large world chunk systems.

A mouse cursor left click changes the start position for the debug paths.

Language: GDScript

Renderer: Compatibility

> Note: this demo requires Godot 4.3 or later

## Screenshots

![Screenshot](screenshots/navigation_mesh_chunks.webp)

## How to Learn This Project

> Part of **Ch. 5 – Navigation & Pathfinding** in [*Let's Learn 2D Demos*](../../Let's%20Learn%202D%20Demos.md).

### What it teaches

The **low-level capstone of the navigation chapter.** Where 5.1 used an editor-baked polygon behind friendly nodes, this demo drops down to `NavigationServer2D` and **bakes the navigation mesh at runtime** from the scene's own collision shapes — then **chunks** the world into a grid of separately-baked `NavigationRegion2D`s whose edges align and merge across borders, the pattern you need for large or streamed worlds. It also visualizes the three `path_postprocessing` modes as three colored debug paths drawn over the same start → target. Requires Godot 4.3+.

### Key nodes & classes to understand

- `NavigationServer2D` — the engine service, used **directly** here instead of through convenience nodes. `parse_source_geometry_data()` collects walkable-blocking shapes; `bake_from_source_geometry_data()` bakes a mesh; `map_get_closest_point()` snaps the cursor onto the navmesh; `map_set_cell_size()` / `map_set_use_edge_connections()` tune the map; `map_get_iteration_id()` guards against querying a map that hasn't synchronized yet.
- `NavigationMeshSourceGeometryData2D` — the collected geometry fed to the baker. Filled from collision shapes (`parsed_geometry_type = PARSED_GEOMETRY_STATIC_COLLIDERS` under the `%ParseRootNode`) **plus** an explicit `add_traversable_outline()` (the 1920×1080 world rectangle the obstacles "cut" into).
- `NavigationPolygon` baking properties — `parsed_geometry_type`, `baking_rect` (limit the bake to one chunk's region), `border_size` (pull in neighbor geometry beyond `baking_rect` so chunk edges meet), and `agent_radius` (inflate obstacles away from walls). Note `baking_rect` is cleared after baking only to hide its debug gizmo.
- **Chunking** — `create_region_chunks()` rasterizes the geometry bounds into a chunk grid, then for each chunk `grow()`s its bake rect by a full `chunk_size` so adjacent chunks share overlapping geometry. Combined with `snappedf()` vertex snapping (to dodge float-precision rasterization gaps) and `map_set_use_edge_connections(map, false)`, the per-chunk meshes merge seamlessly by **edge key** rather than via the costly edge-connection feature.
- `NavigationRegion2D` — created **at runtime**, one per chunk (`NavigationRegion2D.new()` → assign `navigation_polygon` → `add_child`), and tracked in a `chunk_id_to_region` dictionary. No regions are placed in the editor at all.
- `NavigationAgent2D` `path_postprocessing` — three debug agents demonstrate `PATH_POSTPROCESSING_CORRIDOR_FUNNEL` (default, magenta — smooth corner-cutting), `PATH_POSTPROCESSING_EDGE_CENTERED` (yellow — waypoints at shared-edge midpoints), and `PATH_POSTPROCESSING_NONE` (red — raw polygon vertices). Calling `get_next_path_position()` each frame forces them to recompute for the visualization.

### Recommended reading order

1. `navmesh_chunks_demo_2d.tscn` — first, to see what is *not* there: no `NavigationRegion2D` placed in the editor (they're spawned at runtime), and a `%ParseRootNode` of `StaticBody2D` + `CollisionPolygon2D` obstacles. Then note the three `NavigationAgent2D` debug agents under `%DebugPaths` with their three `path_postprocessing` values and custom debug colors.
2. `navmesh_chunks_demo_2d.gd` `_ready()` — the setup: enable server debug, grab the world's `navigation_map` RID, tune the map (`map_set_cell_size`, disable edge connections), parse the collision geometry into a `NavigationMeshSourceGeometryData2D`, add the traversable outline, then call `create_region_chunks()`.
3. `navmesh_chunks_demo_2d.gd` `create_region_chunks()` — **the heart of the demo.** Walk through the bounding-box → chunk-grid rasterization, the per-chunk `baking_rect = chunk_bbox.grow(chunk_size)` trick, the `bake_from_source_geometry_data()` call, the `snappedf()` vertex cleanup, and the runtime `NavigationRegion2D` creation.
4. `navmesh_chunks_demo_2d.gd` `_process()` — the runtime query loop: snap the cursor with `map_get_closest_point()`, set the path start on left-click, and push one `target_position` to all three debug agents so you can compare their post-processing side by side.

> **The chunking insight:** a single giant navmesh is expensive to bake and impossible to stream. Bake many small ones, but give each a `border_size`/grown `baking_rect` so it knows about its neighbors' geometry — then the edges line up and the server stitches them into one continuous map automatically.

### Hands-on exercise

1. Run it and left-click around: compare the magenta (corridor-funnel), yellow (edge-centered), and red (no post-processing) paths to the same target — corridor-funnel cuts corners aggressively, edge-centered threads edge midpoints, none hugs raw vertices.
2. In `create_region_chunks()`, raise `chunk_size` (e.g. from 256 to 512) and observe fewer, larger `NavigationRegion2D` nodes spawned under `%ChunksContainer`; then shrink it (e.g. 128) and confirm the merged result still routes correctly, validating the edge-alignment logic.
3. Stretch goal: the demo bakes from a fixed traversable outline. Replace the hardcoded `traversable_outline` rectangle by adding your own `add_traversable_outline()` polygons (e.g. separate rooms) and a `CollisionPolygon2D` doorway, then confirm paths route through the door and not through walls.
