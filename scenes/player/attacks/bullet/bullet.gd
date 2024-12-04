class_name Bullet extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var bullet_speed: float = 600.0

var direction: int = 1


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	position.x += bullet_speed * delta * direction


func _destroy() -> void:
	queue_free()
