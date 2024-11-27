class_name JumpState extends State

@onready var fall_state: FallState = $"../FallState"


# what happens when we enter the state
func enter() -> void:
	player.velocity.y = player.jump_force
	player.animation_player.play("jump")


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

	if player.velocity.y >= 0:
		return fall_state
		
	return null


# called when input events occur
func unhandled_input(_event: InputEvent) -> State:
	return null
