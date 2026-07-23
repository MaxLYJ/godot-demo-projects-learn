## Global, persistent store for quest progress and dialogue flags.
##
## Registered as an autoload singleton named `DialogueState` (see project.godot),
## so any script can read/write it via `DialogueState.get_state(...)` etc.
##
## The dialogue_player reads this to decide which branches are visible, and
## applies `sets` from JSON nodes/choices back into it. This is the single
## source of truth that ties "what the player has done" to "what an NPC says".
extends Node

signal state_changed


## Everything lives in one dictionary. Values can be bool, int, String, ...
## e.g. { "met_mayor": true, "quest_a": "in_progress", "gold": 50 }
var _state: Dictionary = {}


func _ready() -> void:
	reset()


## Reset back to a clean game (called on startup and by the example scene).
func reset() -> void:
	_state.clear()
	state_changed.emit()


func has_state(key: String) -> bool:
	return _state.has(key)


func get_state(key: String, default: Variant = null) -> Variant:
	return _state.get(key, default)


func set_state(key: String, value: Variant) -> void:
	_state[key] = value
	state_changed.emit()


func set_flag(key: String, value: bool = true) -> void:
	_state[key] = value
	state_changed.emit()


func clear_flag(key: String) -> void:
	_state[key] = false
	state_changed.emit()


## True if the flag exists and is truthy.
func is_true(key: String) -> bool:
	return bool(_state.get(key, false))


## Apply a batch of { key: value } changes, as used by the JSON `sets` field.
func apply(changes: Dictionary) -> void:
	for key: String in changes:
		_state[key] = changes[key]
	state_changed.emit()


## Human-readable dump, used by the example scene's debug label.
func dump() -> String:
	if _state.is_empty():
		return "{ }  (no state yet)"
	return JSON.stringify(_state, "  ")
