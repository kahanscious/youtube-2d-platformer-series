class_name IdleState extends State

@onready var run_state: RunState = $"../RunState"
@onready var jump_state: JumpState = $"../JumpState"
@onready var fall_state: FallState = $"../FallState"
@onready var crouch_state: CrouchState = $"../CrouchState"
@onready var attack_state: AttackState = $"../AttackState"
@onready var knockback_state: KnockbackState = $"../KnockbackState"


func enter() -> void:
	player.velocity.x = 0
	player.animation_player.play("idle")
	player.can_double_jump = true


func exit() -> void:
	pass


func process(_delta: float) -> State:
	if player.direction != 0:
		return run_state
	return null


func physics(_delta: float) -> State:
	if not player.is_on_floor():
		return fall_state

	if player.is_knocked_back:
		return knockback_state
	return null


func unhandled_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") and player.is_on_floor():
		return jump_state
	if event.is_action_pressed("crouch") and player.is_on_floor() and not player.is_in_water:
		return crouch_state
	if event.is_action_pressed("attack") and player.is_on_floor():
		return attack_state
	return null
