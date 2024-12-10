class_name Level extends Node2D


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("00003c"))

	PlayerManager.level_setup(self)
	LevelManager.level_load_started.connect(_level_cleanup)

	PlayerManager.player.global_position = %PlayerSpawn.global_position


func _level_cleanup() -> void:
	PlayerManager.level_cleanup(self)
	queue_free()
