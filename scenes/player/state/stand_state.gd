class_name StandState extends State

@onready var idle_state: IdleState = $"../IdleState"


# what happens when we enter the state
func enter() -> void:
	player.velocity.x = 0
	player.animation_player.play("stand")
	await player.animation_player.animation_finished


func exit() -> void:
	pass


# called every frame during _process
func process(delta: float) -> State:
	return idle_state


# called every physics frame during _physics_process
func physics(delta: float) -> State:
	return null


# called when input events occur
func unhandled_input(event: InputEvent) -> State:
	return null
