extends CanvasLayer

var paused: bool = false


func _process(_delta: float) -> void:
	if (
		Input.is_action_just_pressed("pause")
		and get_tree().current_scene.scene_file_path != Utils.MAIN_MENU_FILEPATH
	):
		handle_pause()


func handle_pause() -> void:
	paused = !paused
	get_tree().paused = paused
	visible = paused


func _on_resume_button_pressed() -> void:
	handle_pause()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
