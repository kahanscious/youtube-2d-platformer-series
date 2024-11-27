class_name FallState extends State

@onready var idle_state: IdleState = $"../IdleState"
@onready var run_state: RunState = $"../RunState"


# what happens when we enter the state
func enter() -> void:
	player.animation_player.play("fall")


func exit() -> void:
	pass


# called every frame during _process
func process(_delta: float) -> State:
	return null


# called every physics frame during _physics_process
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
	return null


# called when input events occur
func unhandled_input(_event: InputEvent) -> State:
	return null
