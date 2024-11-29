class_name Hitbox extends Area2D

signal take_damage(amount: int)


func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		if area.owner is Bullet:
			var bullet: Bullet = area.owner
			bullet._destroy()
		take_damage.emit(area.damage)
