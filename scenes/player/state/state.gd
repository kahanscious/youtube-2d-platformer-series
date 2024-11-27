class_name State extends Node

static var player: Player
static var state_machine: StateMachine


# what happens when we enter the state
func enter() -> void:
	pass


func exit() -> void:
	pass


# called every frame during _process
func process(_delta: float) -> State:
	return null


# called every physics frame during _physics_process
func physics(_delta: float) -> State:
	return null


# called when input events occur
func unhandled_input(_event: InputEvent) -> State:
	return null
