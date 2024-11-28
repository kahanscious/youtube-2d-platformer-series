class_name EnemyIdleState extends EnemyState

@onready var run_state: EnemyRunState = $"../RunState"
@onready var detection_component: DetectionComponent = $"../../DetectionComponent"


func enter() -> void:
	robocop.animation_player.play("idle")
	robocop.velocity.x = 0
	detection_component.player_entered.connect(_on_player_entered)


func exit() -> void:
	pass


func process(_delta: float) -> EnemyState:
	return null


func physics(_delta: float) -> EnemyState:
	return null


func _on_player_entered() -> void:
	detection_component.player_entered.disconnect(_on_player_entered)
	enemy_state_machine.change_state(run_state)
