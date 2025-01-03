class_name DialogueUI extends CanvasLayer

signal dialogue_finished

@onready var dialogue_label: Label = $Panel/MarginContainer/VBoxContainer/DialogueLabel
@onready var continue_label: Label = $Panel/MarginContainer/VBoxContainer/ContinueLabel
@onready var name_label: Label = $Panel/MarginContainer/VBoxContainer/NameLabel
@onready var panel: Panel = $Panel

const CHAR_READ_RATE: float = 0.05
const PUNCTUATION_PAUSE: float = 0.02

var _current_dialogue: Array[Dictionary] = []
var _current_page_index: int = 0
var _is_dialogue_active: bool = false
var _is_text_revealing: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_dialogue()

	var pause_menu = get_node_or_null("/root/PauseMenu")
	if pause_menu:
		pause_menu.process_mode = Node.PROCESS_MODE_DISABLED


func _unhandled_input(event: InputEvent) -> void:
	if not _is_dialogue_active:
		return

	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()

		if _is_text_revealing:
			_finish_text_reveal()
		else:
			_try_advance_dialogue()


func start_dialogue(dialogue_data: Array[Dictionary]) -> void:
	_current_dialogue = dialogue_data
	_current_page_index = 0
	_is_dialogue_active = true

	get_tree().paused = true

	panel.show()
	_show_current_page()


func _show_current_page() -> void:
	var page: Dictionary = _current_dialogue[_current_page_index]

	name_label.text = page.get("name", "???")
	dialogue_label.text = ""
	continue_label.hide()

	_reveal_text(page.get("text", ""))


func _reveal_text(text: String) -> void:
	_is_text_revealing = true

	for i in range(text.length()):
		dialogue_label.text = text.substr(0, i + 1)

		var wait_time: float = CHAR_READ_RATE
		if text[i] in [".", "!", "?", ","]:
			wait_time = PUNCTUATION_PAUSE

		await get_tree().create_timer(wait_time).timeout

		if not _is_text_revealing:
			break

	_finish_text_reveal()


func _finish_text_reveal() -> void:
	dialogue_label.text = _current_dialogue[_current_page_index].get("text", "")
	_is_text_revealing = false

	continue_label.show()


func _try_advance_dialogue() -> void:
	_current_page_index += 1

	if _current_page_index >= _current_dialogue.size():
		hide_dialogue()
	else:
		_show_current_page()


func hide_dialogue() -> void:
	panel.hide()
	_is_dialogue_active = false
	_current_dialogue.clear()

	get_tree().paused = false

	dialogue_finished.emit()
