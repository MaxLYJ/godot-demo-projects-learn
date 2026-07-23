# Branching Dialogue Example

This folder demonstrates a **quest-state-aware dialogue system** added on top of
the JRPG demo's existing `DialoguePlayer`. The goal: keep **one JSON file per
NPC**, and let the dialogue engine itself pick which lines to show based on the
current game state (e.g. before / during / after a quest).

## Run it

Open `example.tscn` in the Godot editor and press **F6** (Run Current Scene),
or from the editor menu: **File → Run**.

You'll see:
- A **Talk to Mayor** button that opens a conversation.
- A **live state panel** on the right showing the `DialogueState` singleton's
  contents updating in real time.
- The same Mayor NPC saying *different things* as the quest moves from
  `not_started → in_progress → completed`.

## Files

| File | Purpose |
|------|---------|
| `../dialogue_state.gd` | Autoload singleton (`DialogueState`) — the global quest/flag store. |
| `../dialogue_player/dialogue_player.gd` | Upgraded engine. Reads the new branching JSON, falls back to the original flat-list behaviour for legacy files. |
| `../dialogue_data/mayor.json` | Example NPC: one file, every quest state. |
| `example.gd` | UI controller for the demo scene. |
| `example.tscn` | Runnable standalone scene. |

## JSON schema

A branching file has a top-level `nodes` dictionary. Each node is an object:

```jsonc
{
  "nodes": {
    "start": {                 // node id (referenced by "next")
      "name": "MAYOR",         // speaker name shown in the UI
      "text": "Hello!",        // body text
      "next": "intro",         // id of the node to go to on "Next"
      "requires": { ... },     // optional: only show this node if condition met
      "sets": { ... },         // optional: write state when this node is entered
      "choices": [ ... ]       // optional: present buttons instead of "Next"
    }
  }
}
```

### `requires` — gate a node or a choice

A node/choice is only shown if its `requires` passes. Three forms:

```jsonc
"requires": "met_mayor"                  // flag must be truthy
"requires": ["met_mayor", "has_key"]     // all must be truthy
"requires": { "quest_a": "in_progress" } // state[key] must equal value
```

Special value `null` means "the key is **not set**" — handy for an initial
branch that should only appear before the quest has started:

```jsonc
"requires": { "quest_a": null }   // shown only while quest_a has never been set
```

If a node's `requires` fails, the engine follows `else_next` if present,
otherwise ends the conversation.

### `sets` — mutate state

Whenever a node is entered or a choice is picked, its `sets` dictionary is
written into `DialogueState`. This is how a line of dialogue advances a quest:

```jsonc
"sets": { "quest_a": "in_progress", "talked_to_mayor": true }
```

### `next` — where to go next

- A string id → go to that node.
- `""` (empty) → end the conversation.
- Omit it on a node that has `choices` (the choice picks the next node).

### `choices` — player choices

An array of `{ text, requires?, sets?, next }`. Each choice is filtered by its
own `requires`, so you can show/hide options by state:

```jsonc
"choices": [
  { "text": "I'll take the quest.",  "requires": { "quest_a": null },
    "sets": { "quest_a": "in_progress" }, "next": "quest_branch" },
  { "text": "I finished it!",        "requires": { "quest_a": "in_progress" },
    "sets": { "quest_a": "completed" },   "next": "thank_you" },
  { "text": "Goodbye.", "next": "" }
]
```

## How the flow works at runtime

1. `example.gd` instantiates a `DialoguePlayer`, points it at `mayor.json`,
   and calls `start_dialogue()`.
2. `DialoguePlayer.index_dialogue()` sees the file has a `"nodes"` key and
   switches into branching mode.
3. `start_dialogue()` enters node `"start"`, then follows `next` links.
4. At a `choices` node, `current_choices` is populated and the UI builds a
   button per choice; clicking one calls `dialogue_player.choose(index)`.
5. `sets` dictionaries are applied to `DialogueState` as nodes are entered /
   choices picked — which is why the right-hand panel updates live.
6. Reaching `"next": ""` emits `dialogue_finished` and closes the box.

## Backward compatibility

The original flat-list files (`npc.json`, `object.json`, `player_won.json`,
`player_lose.json`) are unchanged and still work: if a file has **no** top-level
`"nodes"` key, `DialoguePlayer` uses the original index-incrementing behaviour.
No existing scene or script needed to change.

## Using it in the real game

To gate an overworld NPC's dialogue by quest state, point its `DialoguePlayer`
at a branching file (set `dialogue_file` in the editor or in the `.tscn`).
`DialogueState` is global, so combat wins, item pickups, etc. can call
`DialogueState.set_state("quest_a", "completed")` from anywhere and the NPC
will immediately reflect it on the next talk.
