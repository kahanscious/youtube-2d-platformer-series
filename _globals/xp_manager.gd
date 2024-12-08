extends Node

signal level_up(new_level: int)
signal ability_unlocked(ability_name: Ability)

enum Ability {
	DOUBLE_JUMP,
}

const BASE_XP_FOR_LEVEL: int = 100
const XP_MULTIPLIER: float = 1.5

const ABILITY_LEVEL_REQUIREMENTS := {
	Ability.DOUBLE_JUMP: 3,
}

var current_xp: int = 0
var current_level: int = 1
var total_xp: int = 0

var unlocked_abilities: Dictionary = {
	Ability.DOUBLE_JUMP: false,
}


func get_xp_for_level(level: int) -> int:
	return int(BASE_XP_FOR_LEVEL * pow(XP_MULTIPLIER, level - 1))


func get_xp_for_next_level() -> int:
	return get_xp_for_level(current_level)


func initialize(player: Player) -> void:
	current_xp = 0
	current_level = 1

	for ability in Ability.values():
		unlocked_abilities[ability] = false

	player.xp_bar.max_value = get_xp_for_next_level()
	player.xp_bar.value = 0


func add_xp(amount: int, player: Player) -> void:
	current_xp += amount

	while current_xp >= get_xp_for_next_level():
		current_xp -= get_xp_for_next_level()
		current_level += 1
		level_up.emit(current_level)
		check_ability_unlocks(player)
		player.xp_bar.max_value = get_xp_for_next_level()

	player.xp_bar.value = current_xp


func check_ability_unlocks(player: Player) -> void:
	for ability in Ability.values():
		if current_level >= ABILITY_LEVEL_REQUIREMENTS[ability] and not unlocked_abilities[ability]:
			unlocked_abilities[ability] = true
			apply_ability_to_player(player, ability)
			ability_unlocked.emit(ability)


func apply_ability_to_player(player: Player, ability: Ability) -> void:
	match ability:
		Ability.DOUBLE_JUMP:
			player.has_double_jump = true
			player.player_camera.configure_shake(Utils.ShakeType.BIG)
			player.player_camera.add_trauma(0.4)
