class_name Enemy extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var bullets: Node

var direction: float


func _ready() -> void:
	if owner.has_node("Bullets"):
		bullets = $Bullets


func set_direction() -> void:
	if PlayerManager.player.position.x > position.x:
		direction = 1
	elif PlayerManager.player.position.x < position.x:
		direction = -1

	sprite.flip_h = direction > 0
