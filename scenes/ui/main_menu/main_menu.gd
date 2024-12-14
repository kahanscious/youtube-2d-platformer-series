class_name MainMenu extends Control

@onready var button_container: VBoxContainer = $ButtonContainer
@onready var options_menu: OptionsMenu = $OptionsMenu

var options_menu_visible: bool = false


func _ready() -> void:
	options_menu.set_process(options_menu_visible)
	options_menu.visible = options_menu_visible
	options_menu.exit_options_window.connect(_on_exit_options_window)


func _process(delta: float) -> void:
	set_options_menu_processing(options_menu_visible)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(LevelManager.STARTING_LEVEL_PATH)


func _on_exit_button_pressed() -> void:
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
	allow_main_menu_buttons(value)


func allow_main_menu_buttons(value: bool = true) -> void:
	for button: Button in button_container.get_children():
		button.disabled = value
