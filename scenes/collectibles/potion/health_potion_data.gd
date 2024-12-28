class_name HealthPotionData extends ItemData

@export var heal_amount: int = 1


func _init() -> void:
	id = "health_potion"
	name = "Health Potion"
	max_stack_size = 5


func use(player: Player) -> bool:
	if player.current_health < player.max_health:
		player.heal(heal_amount)
		return true
	return false
