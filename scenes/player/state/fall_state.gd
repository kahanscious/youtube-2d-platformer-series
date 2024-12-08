class_name FallState extends State

@onready var idle_state: IdleState = $"../IdleState"
@onready var run_state: RunState = $"../RunState"
@onready var knockback_state: KnockbackState = $"../KnockbackState"
@onready var jump_state: JumpState = $"../JumpState"


func enter() -> void:
	player.animation_player.play("fall")


func exit() -> void:
	pass


func process(_delta: float) -> State:
	return null


func physics(_delta: float) -> State:
	if player.direction:
		player.velocity.x = lerp(
			player.velocity.x, player.direction * player.air_speed, player.air_acceleration
		)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, player.air_acceleration * 0.5)

	if player.is_on_floor():
		if player.direction == 0:
			return idle_state
		else:
			return run_state

	if player.is_knocked_back:
		return knockback_state

	return null


func unhandled_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		if player.has_double_jump and player.can_double_jump and not player.is_on_floor():
			player.can_double_jump = false
			return jump_state
	return null
