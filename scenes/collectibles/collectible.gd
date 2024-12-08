class_name Collectible extends Area2D

signal collected

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collect(body)


func collect(_player: Player) -> void:
	# we are going to set this further on each collectible we have
	collected.emit()
	collision_shape.set_deferred("disabled", true)
	sprite.visible = false
