class_name Level extends Node2D

@onready var player_bullets: Node = $PlayerBullets
@onready var player: Player = $Player


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("00003c"))


func _process(delta: float) -> void:
	for bullet: Bullet in player_bullets.get_children():
		if abs(bullet.global_position.x - player.global_position.x) > 500:
			bullet._destroy()
