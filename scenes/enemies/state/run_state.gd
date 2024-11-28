class_name EnemyRunState extends EnemyState

@onready var idle_state: EnemyIdleState = $"../IdleState"
@onready var detection_component: DetectionComponent = $"../../Components/DetectionComponent"


func enter() -> void:
	robocop.animation_player.play("run")
	detection_component.player_exited.connect(_on_player_exit)


func exit() -> void:
	pass


func process(_delta: float) -> EnemyState:
	return null


func physics(_delta: float) -> EnemyState:
	_handle_running()
	return null


func _on_player_exit() -> void:
	detection_component.player_exited.disconnect(_on_player_exit)
	enemy_state_machine.change_state(idle_state)


func _handle_running() -> void:
	if robocop.direction:
		robocop.velocity.x = robocop.direction * robocop.speed
	else:
		robocop.velocity.x = move_toward(robocop.velocity.x, 0, robocop.speed)
