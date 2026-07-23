extends Node

signal dialogue_started
signal dialogue_finished
signal choices_presented(choices: Array)
signal choice_made(index: int)

## Text shown to the UI right now (speaker name + body).
var dialogue_text: String = ""
var dialogue_name: String = ""

## The currently-available choices, as [{text, ...}], or empty if a plain line.
var current_choices: Array = []

## The node we are currently sitting on (read from the JSON).
var _current_node: Dictionary = {}

# --- Original (flat-list) fields, kept for backward compatibility ---
@export_file("*.json") var dialogue_file: String
var dialogue_keys := []
var current := 0

# --- Branching-graph state ---
# Whole conversation loaded as { node_id -> node_dict }.
var nodes: Dictionary = {}
# ID of the node we are currently on ("" before start / after finish).
var _current_id: String = ""
# True when the file uses the branching format ("nodes" key), false for legacy flat lists.
var _branching: bool = false
# Guard against one node emitting `dialogue_finished` more than once.
var _finished: bool = false


func start_dialogue() -> void:
	dialogue_started.emit()
	_finished = false
	current = 0
	current_choices = []
	index_dialogue()

	if _branching:
		_enter_node(_first_node_id())
	else:
		# Legacy flat list: current 0 was set above, just publish it.
		dialogue_text = dialogue_keys[current].text
		dialogue_name = dialogue_keys[current].name


func next_dialogue() -> void:
	if _branching:
		_advance_from_node()
	else:
		_advance_flat()


# ---------------------------------------------------------------------------
# Branching format
# ---------------------------------------------------------------------------

## Parse the file. If it has a top-level "nodes" dictionary we use the new
## branching engine; otherwise we fall back to the original flat-list behaviour.
func index_dialogue() -> void:
	var dialogue: Dictionary = load_dialogue(dialogue_file)
	nodes.clear()
	dialogue_keys.clear()

	if dialogue.has("nodes") and dialogue["nodes"] is Dictionary:
		_branching = true
		var raw: Dictionary = dialogue["nodes"]
		for id: String in raw:
			nodes[id] = raw[id]
	else:
		_branching = false
		for key: String in dialogue:
			dialogue_keys.append(dialogue[key])


func _first_node_id() -> String:
	# Prefer an explicit start node; otherwise the first key in insertion order.
	if nodes.has("start"):
		return "start"
	for id: String in nodes:
		return id
	return ""


func _enter_node(node_id: String) -> void:
	_current_id = node_id

	if node_id == "" or not nodes.has(node_id):
		_finish()
		return

	var node: Dictionary = nodes[node_id]

	# "requires" gates a whole node: if it fails, follow `else_next` (or end).
	if not _requirements_met(node):
		var fallback: String = node.get("else_next", "")
		if fallback != "":
			_enter_node(fallback)
		else:
			_finish()
		return

	_current_node = node

	# Apply side effects up front so later nodes/choices in the same file see them.
	if node.has("sets") and node["sets"] is Dictionary:
		DialogueState.apply(node["sets"])

	current_choices = []
	if node.has("choices") and node["choices"] is Array and not node["choices"].is_empty():
		# Filter choices by their own "requires"; publish the visible ones.
		for choice: Dictionary in node["choices"]:
			if _requirements_met(choice):
				current_choices.append(choice)
		if current_choices.is_empty():
			# Every choice was gated out — treat as a normal terminal line.
			dialogue_name = node.get("name", "")
			dialogue_text = node.get("text", "")
			choices_presented.emit([])
			return
		dialogue_name = node.get("name", "")
		dialogue_text = node.get("text", "")
		choices_presented.emit(current_choices)
		return

	dialogue_name = node.get("name", "")
	dialogue_text = node.get("text", "")


func _advance_from_node() -> void:
	# If the current node offered choices, `next_dialogue()` should not be used
	# to advance — the UI must call `choose()` instead. Fall through to the
	# explicit `next` as a convenience for simple "press Next" flows.
	if _current_node.has("choices") and not _current_node["choices"].is_empty():
		# No choice selected yet: just stay (UI should be showing choice buttons).
		return

	var next_id: String = _current_node.get("next", "")
	if next_id == "":
		_finish()
	else:
		_enter_node(next_id)


## Called by the UI when the player picks a choice (index into current_choices).
func choose(index: int) -> void:
	choice_made.emit(index)
	if index < 0 or index >= current_choices.size():
		return
	var choice: Dictionary = current_choices[index]
	if choice.has("sets") and choice["sets"] is Dictionary:
		DialogueState.apply(choice["sets"])
	var next_id: String = choice.get("next", "")
	current_choices = []
	if next_id == "":
		_finish()
	else:
		_enter_node(next_id)


func _finish() -> void:
	if _finished:
		return
	_finished = true
	_current_id = ""
	dialogue_finished.emit()


# ---------------------------------------------------------------------------
# Condition evaluation
# ---------------------------------------------------------------------------

## Supports both:
##   "requires": "flag_name"            -> flag must be truthy
##   "requires": ["a", "b"]             -> all must be truthy
##   "requires": {"quest_a": "done"}    -> state[key] == value for all
func _requirements_met(node: Dictionary) -> bool:
	if not node.has("requires"):
		return true
	var req: Variant = node["requires"]

	if req is String:
		return DialogueState.is_true(req)

	if req is Array:
		for item: String in req:
			if not DialogueState.is_true(item):
				return false
		return true

	if req is Dictionary:
		for key: String in req:
			var expected: Variant = req[key]
			if DialogueState.get_state(key) != expected:
				return false
		return true

	return true


# ---------------------------------------------------------------------------
# Legacy flat-list path (original behaviour, unchanged)
# ---------------------------------------------------------------------------

func _advance_flat() -> void:
	current += 1
	if current == dialogue_keys.size():
		dialogue_finished.emit()
		return
	dialogue_text = dialogue_keys[current].text
	dialogue_name = dialogue_keys[current].name


# ---------------------------------------------------------------------------
# File loading (unchanged)
# ---------------------------------------------------------------------------

func load_dialogue(file_path: String) -> Dictionary:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file:
		var test_json_conv := JSON.new()
		test_json_conv.parse(file.get_as_text())
		return test_json_conv.data

	return {}
