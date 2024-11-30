class_name LevelTransition extends Area2D

@export_file("*.tscn") var next_level_path: String


func _on_body_entered(body: Node2D) -> void:
	if body is Player and next_level_path:
		LevelManager.change_level(next_level_path)
