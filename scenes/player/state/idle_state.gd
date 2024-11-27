class_name IdleState extends State

@onready var run_state: RunState = $"../RunState"
@onready var jump_state: JumpState = $"../JumpState"
@onready var fall_state: FallState = $"../FallState"


# what happens when we enter the state
func enter() -> void:
	player.velocity.x = 0
	player.animation_player.play("idle")


func exit() -> void:
	pass


# called every frame during _process
func process(delta: float) -> State:
	if player.direction != 0:
		return run_state
	return null


# called every physics frame during _physics_process
func physics(delta: float) -> State:
	if not player.is_on_floor():
		return fall_state
	return null


# called when input events occur
func unhandled_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") and player.is_on_floor():
		return jump_state
	return null
