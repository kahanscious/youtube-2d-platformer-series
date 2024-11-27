class_name StateMachine extends Node

var states: Array[State] = []
var current_state: State
var previous_state: State


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	change_state(current_state.process(delta))


func _physics_process(delta: float) -> void:
	change_state(current_state.physics(delta))


func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.unhandled_input(event))


func configure(player: Player) -> void:
	for child in get_children():
		if child is State:
			states.append(child)

	if not states:
		return

	states[0].player = player
	states[0].state_machine = self

	change_state(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT


func change_state(new_state: State) -> void:
	if new_state == null or new_state == current_state:
		return

	if current_state:
		current_state.exit()

	previous_state = current_state
	current_state = new_state
	current_state.enter()
