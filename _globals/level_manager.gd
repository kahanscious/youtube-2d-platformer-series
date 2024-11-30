extends Node

signal level_load_started
signal level_load_finished

var current_level: Level
var next_level: Level


func _ready() -> void:
	await get_tree().process_frame
	level_load_finished.emit()


func change_level(level_path: String) -> void:
	if not is_valid_level_path(level_path):
		return

	get_tree().paused = true
	level_load_started.emit()
	await SceneTransition.fade_out()

	for child in get_tree().root.get_children():
		if child is Level:
			child.queue_free()

	await get_tree().process_frame

	next_level = load_new_level(level_path)
	if not next_level:
		printerr("Failed to load level: ", level_path)
		get_tree().paused = false
		return

	add_new_level()
	await SceneTransition.fade_in()

	get_tree().paused = false
	level_load_finished.emit()


func is_valid_level_path(level_path: String) -> bool:
	if not level_path or not FileAccess.file_exists(level_path):
		printerr("Invalid level path: ", level_path)
		return false
	return true


func load_new_level(level_path: String) -> Level:
	var level_scene = load(level_path) as PackedScene
	if not level_scene:
		return null

	var instance = level_scene.instantiate() as Level
	if not instance:
		return null

	return instance


func add_new_level() -> void:
	get_tree().root.add_child(next_level)
	current_level = next_level


func restart_curent_level() -> void:
	if current_level:
		change_level(current_level.scene_file_path)
