class_name Level extends Node2D


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("00003c"))

	add_child(PlayerManager.player)
	PlayerManager.player.global_position = %PlayerSpawn.global_position
