class_name Level extends Node2D

@onready var player_bullets: Node = $PlayerBullets


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("00003c"))

	add_child(PlayerManager.player)
	PlayerManager.player.global_position = %PlayerSpawn.global_position


func _process(delta: float) -> void:
	for bullet: Bullet in player_bullets.get_children():
		if abs(bullet.global_position.x - PlayerManager.player.global_position.x) > 500:
			bullet._destroy()
