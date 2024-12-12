class_name WaterZone extends Area2D

@export var slow_speed: float

var original_speed: float


func _ready() -> void:
	slow_speed = PlayerManager.player.speed * .5
	original_speed = PlayerManager.player.speed


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		PlayerManager.player.speed = slow_speed
		PlayerManager.player.is_in_water = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		PlayerManager.player.speed = original_speed
		PlayerManager.player.is_in_water = false
