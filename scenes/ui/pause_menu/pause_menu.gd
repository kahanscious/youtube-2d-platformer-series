extends CanvasLayer

@onready var button_container: VBoxContainer = $Control/ButtonContainer
@onready var options_menu: OptionsMenu = $OptionsMenu

var paused: bool = false
var options_menu_visible: bool = false


func _ready() -> void:
	options_menu.set_process(options_menu_visible)
	options_menu.visible = options_menu_visible
	options_menu.exit_options_window.connect(_on_exit_options_window)


func _process(_delta: float) -> void:
	if (
		Input.is_action_just_pressed("pause")
		and get_tree().current_scene.scene_file_path != Utils.MAIN_MENU_FILEPATH
	):
		handle_pause()

	set_options_menu_processing(options_menu_visible)


func handle_pause() -> void:
	paused = !paused
	get_tree().paused = paused
	visible = paused


func _on_resume_button_pressed() -> void:
	handle_pause()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	for button: Button in button_container.get_children():
		button.disabled = true
	options_menu_visible = true


func set_options_menu_processing(value: bool) -> void:
	options_menu_visible = value
	options_menu.set_process(options_menu_visible)
	options_menu.visible = options_menu_visible


func _on_exit_options_window(value: bool) -> void:
	set_options_menu_processing(value)
	allow_pause_menu_buttons(value)


func allow_pause_menu_buttons(value: bool = true) -> void:
	for button: Button in button_container.get_children():
		button.disabled = value
