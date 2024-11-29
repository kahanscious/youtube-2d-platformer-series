class_name IdleState extends State

@onready var run_state: RunState = $"../RunState"
@onready var jump_state: JumpState = $"../JumpState"
@onready var fall_state: FallState = $"../FallState"
@onready var crouch_state: CrouchState = $"../CrouchState"
@onready var attack_state: AttackState = $"../AttackState"
@onready var knockback_state: KnockbackState = $"../KnockbackState"


# what happens when we enter the state
func enter() -> void:
	player.velocity.x = 0
	player.animation_player.play("idle")


func exit() -> void:
	pass


# called every frame during _process
func process(_delta: float) -> State:
	if player.direction != 0:
		return run_state
	return null


# called every physics frame during _physics_process
func physics(_delta: float) -> State:
	if not player.is_on_floor():
		return fall_state
		
	if player.is_knocked_back:
		return knockback_state
	return null


# called when input events occur
func unhandled_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") and player.is_on_floor():
		return jump_state
	if event.is_action_pressed("crouch") and player.is_on_floor():
		return crouch_state
	if event.is_action_pressed("attack") and player.is_on_floor():
		return attack_state
	return null
