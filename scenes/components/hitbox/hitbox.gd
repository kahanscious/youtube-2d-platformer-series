class_name Hitbox extends Area2D

signal take_damage(amount: int)


func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		print(area.owner.name, " Hurtbox entered hitbox")
		take_damage.emit(area.damage)
