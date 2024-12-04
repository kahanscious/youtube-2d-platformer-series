class_name Enemy extends CharacterBody2D

signal enemy_death

@onready var sprite: Sprite2D = $Sprite2D
@onready var bullets: Node = $Bullets

var direction: float


func set_direction() -> void:
	if PlayerManager.player.position.x > position.x:
		direction = 1
	elif PlayerManager.player.position.x < position.x:
		direction = -1

	sprite.flip_h = direction > 0
