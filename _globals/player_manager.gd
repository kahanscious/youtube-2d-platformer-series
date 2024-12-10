extends Node

const PLAYER = preload("res://scenes/player/player.tscn")

var player: Player


func _ready() -> void:
	player = PLAYER.instantiate()


func level_setup(parent: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	parent.add_child(player)


func level_cleanup(parent: Node2D) -> void:
	parent.remove_child(player)
