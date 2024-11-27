class_name Bullet extends Area2D

@export var bullet_speed: float = 600.0

var direction: int = 1


func _process(delta: float) -> void:
	position.x += bullet_speed * delta * direction


func _destroy() -> void:
	queue_free()
