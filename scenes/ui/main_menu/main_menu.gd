class_name MainMenu extends Control

@onready var button_container: VBoxContainer = $ButtonContainer


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(LevelManager.STARTING_LEVEL_PATH)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
