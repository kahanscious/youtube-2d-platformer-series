class_name DialogueUI extends CanvasLayer

signal dialogue_finished

@onready var main_container: Control = $MainContainer
@onready
var dialogue_label: Label = $MainContainer/ContentContainer/DialogueContent/TextContainer/DialogueLabel
@onready
var name_label: Label = $MainContainer/ContentContainer/DialogueContent/TextContainer/NameLabel
@onready
var continue_container: HBoxContainer = $MainContainer/ContentContainer/FooterContainer/ContinueContainer
@onready
var continue_sprite: TextureRect = $MainContainer/ContentContainer/FooterContainer/ContinueContainer/ContinueSprite
@onready var portrait_frame: TextureRect = $MainContainer/PortraitContainer/PortraitFrame

const CHAR_READ_RATE: float = 0.05
const PUNCTUATION_PAUSE: float = 0.2
const PUNCTUATION_MARKS: Array[String] = [".", "!", "?", ","]

var _current_dialogue: Array[Dictionary] = []
var _current_page_index: int = 0
var _is_dialogue_active: bool = false
var _is_text_revealing: bool = false
var _continue_tween: Tween
var _reveal_timer: SceneTreeTimer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_dialogue()

	var pause_menu = get_node_or_null("/root/PauseMenu")
	if pause_menu:
		pause_menu.process_mode = Node.PROCESS_MODE_DISABLED


func _unhandled_input(event: InputEvent) -> void:
	if not _is_dialogue_active:
		return

	if event.is_action_pressed("interact"):
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
	main_container.show()
	_show_current_page()


func hide_dialogue() -> void:
	main_container.hide()
	_stop_continue_blink()

	_is_dialogue_active = false
	_current_dialogue.clear()

	if _reveal_timer:
		_reveal_timer.timeout.disconnect(_on_reveal_timer_timeout)
		_reveal_timer = null

	get_tree().paused = false
	dialogue_finished.emit()


func _show_current_page() -> void:
	var page: Dictionary = _current_dialogue[_current_page_index]

	name_label.text = page.get("name", "???")
	dialogue_label.text = ""
	continue_container.hide()

	# Set portrait if provided
	if page.has("portrait") and page.portrait != null:
		portrait_frame.texture = page.portrait
		portrait_frame.show()
	else:
		portrait_frame.hide()

	_start_continue_blink()
	_reveal_text(page.get("text", ""))


func _reveal_text(text: String) -> void:
	_is_text_revealing = true

	for i in range(text.length()):
		dialogue_label.text = text.substr(0, i + 1)

		var wait_time: float = CHAR_READ_RATE
		if text[i] in PUNCTUATION_MARKS:
			wait_time = PUNCTUATION_PAUSE

		_reveal_timer = get_tree().create_timer(wait_time)
		_reveal_timer.timeout.connect(_on_reveal_timer_timeout)
		await _reveal_timer.timeout

		if not _is_text_revealing:
			break

	_finish_text_reveal()


func _start_continue_blink() -> void:
	if _continue_tween:
		_continue_tween.kill()

	_continue_tween = create_tween().set_loops()
	_continue_tween.tween_property(continue_sprite, "modulate:a", 0.2, 0.5)
	_continue_tween.tween_property(continue_sprite, "modulate:a", 1.0, 0.5)


func _stop_continue_blink() -> void:
	if _continue_tween:
		_continue_tween.kill()
		_continue_tween = null
	continue_sprite.modulate.a = 1.0


func _on_reveal_timer_timeout() -> void:
	if _reveal_timer:
		_reveal_timer.timeout.disconnect(_on_reveal_timer_timeout)
		_reveal_timer = null


func _finish_text_reveal() -> void:
	dialogue_label.text = _current_dialogue[_current_page_index].get("text", "")
	_is_text_revealing = false
	continue_container.show()


func _try_advance_dialogue() -> void:
	_current_page_index += 1

	if _current_page_index >= _current_dialogue.size():
		hide_dialogue()
	else:
		_show_current_page()
