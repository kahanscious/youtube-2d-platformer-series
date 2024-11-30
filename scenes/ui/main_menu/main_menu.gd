class_name MainMenu extends Control

@onready var button_container: VBoxContainer = $ButtonContainer

var starting_level_path: String = "res://scenes/test_scene.tscn"


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(starting_level_path)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
