class_name CrouchState extends State

@onready var stand_state: StandState = $"../StandState"


# what happens when we enter the state
func enter() -> void:
	player.velocity.x = 0
	player.animation_player.play("crouch")


func exit() -> void:
	pass


# called every frame during _process
func process(delta: float) -> State:
	return null


# called every physics frame during _physics_process
func physics(delta: float) -> State:
	return null


# called when input events occur
func unhandled_input(event: InputEvent) -> State:
	if event.is_action_released("crouch"):
		return stand_state
	return null
