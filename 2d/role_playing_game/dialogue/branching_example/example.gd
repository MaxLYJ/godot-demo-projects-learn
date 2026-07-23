extends Control

## Standalone demo of the branching dialogue system.
##
## Run this scene directly (File → Run) to see how one JSON file (mayor.json)
## produces different NPC lines depending on the live quest state in the
## DialogueState autoload. The right-hand panel shows the state mutating in
## real time as you accept / progress / complete the quest.

const MAYOR_DIALOGUE := "res://dialogue/dialogue_data/mayor.json"
const DIALOGUE_PLAYER_SCENE := preload("res://dialogue/dialogue_player/dialogue_player.tscn")

var dialogue_player: Node = null

@onready var talk_button: Button = $TalkButton
@onready var reset_button: Button = $ResetButton
@onready var name_label: RichTextLabel = $DialogueBox/NameLabel
@onready var text_label: RichTextLabel = $DialogueBox/TextLabel
@onready var next_button: Button = $DialogueBox/NextButton
@onready var choices_container: VBoxContainer = $DialogueBox/Choices
@onready var state_label: RichTextLabel = $StatePanel/StateText
@onready var hint_label: RichTextLabel = $HintLabel


func _ready() -> void:
	DialogueState.state_changed.connect(_refresh_state_label)
	_refresh_state_label()
	_hide_dialogue()


# ---------------------------------------------------------------------------
# Buttons
# ---------------------------------------------------------------------------

func _on_TalkButton_pressed() -> void:
	dialogue_player = DIALOGUE_PLAYER_SCENE.instantiate()
	dialogue_player.dialogue_file = MAYOR_DIALOGUE
	add_child(dialogue_player)

	dialogue_player.dialogue_finished.connect(_on_dialogue_finished)

	talk_button.hide()
	hint_label.hide()
	_show_dialogue()
	dialogue_player.start_dialogue()
	_refresh_line()


func _on_ResetButton_pressed() -> void:
	DialogueState.reset()
	# If a conversation is mid-flight, tear it down so we start fresh.
	if is_instance_valid(dialogue_player):
		dialogue_player.dialogue_finished.disconnect(_on_dialogue_finished)
		dialogue_player.queue_free()
		dialogue_player = null
	_hide_dialogue()
	talk_button.show()
	hint_label.show()


func _on_NextButton_pressed() -> void:
	if is_instance_valid(dialogue_player):
		dialogue_player.next_dialogue()
		_refresh_line()


func _on_choice_button_pressed(index: int) -> void:
	if is_instance_valid(dialogue_player):
		dialogue_player.choose(index)
		_refresh_line()


# ---------------------------------------------------------------------------
# View refresh
# ---------------------------------------------------------------------------

## Called after every state change in the conversation: redraw name/text and
## rebuild either the "Next" button or the choice buttons.
func _refresh_line() -> void:
	if not is_instance_valid(dialogue_player):
		return

	name_label.text = "[center]" + dialogue_player.dialogue_name + "[/center]"
	text_label.text = dialogue_player.dialogue_text

	# Clear any previous choice buttons.
	for c in choices_container.get_children():
		c.queue_free()

	var choices: Array = dialogue_player.current_choices
	if choices.is_empty():
		next_button.show()
	else:
		next_button.hide()
		for i: int in choices.size():
			var choice: Dictionary = choices[i]
			var btn: Button = Button.new()
			btn.text = str(choice.get("text", "(option)"))
			btn.custom_minimum_size = Vector2(400, 40)
			btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
			btn.pressed.connect(_on_choice_button_pressed.bind(i))
			choices_container.add_child(btn)


func _refresh_state_label() -> void:
	state_label.text = DialogueState.dump()


func _show_dialogue() -> void:
	$DialogueBox.show()


func _hide_dialogue() -> void:
	$DialogueBox.hide()


func _on_dialogue_finished() -> void:
	if is_instance_valid(dialogue_player):
		dialogue_player.queue_free()
	dialogue_player = null
	_hide_dialogue()
	talk_button.show()
	hint_label.show()
