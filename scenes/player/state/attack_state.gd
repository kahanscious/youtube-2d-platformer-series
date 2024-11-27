class_name AttackState extends State

@onready var idle_state: IdleState = $"../IdleState"
@onready var run_state: RunState = $"../RunState"
@onready var fall_state: FallState = $"../FallState"
@onready var jump_state: JumpState = $"../JumpState"
@onready var crouch_state: CrouchState = $"../CrouchState"


func enter() -> void:
	player.velocity.x = 0
	player.animation_player.play("attack")
	await player.animation_player.animation_finished


func exit() -> void:
	pass


# called every frame during _process
func process(delta: float) -> State:
	if player.animation_player.is_playing():
		return
	else:
		if player.direction != 0:
			return run_state
		else:
			return idle_state

	if not player.is_on_floor():
		return fall_state

	return null


# called every physics frame during _physics_process
func physics(delta: float) -> State:
	return null


# called when input events occur
func unhandled_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") and player.is_on_floor():
		return jump_state
	if event.is_action_pressed("crouch") and player.is_on_floor():
		return crouch_state
	return null
