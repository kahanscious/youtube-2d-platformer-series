class_name DetectionComponent extends Area2D

signal player_entered
signal player_exited


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit()


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_exited.emit()
