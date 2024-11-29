class_name KnockbackState extends State

@onready var idle_state: IdleState = $"../IdleState"
@onready var run_state: RunState = $"../RunState"
@onready var fall_state: FallState = $"../FallState"

@export var knockback_force: float = 15.0
@export var knockback_duration: float = 0.3
@export var knockback_horizontal_multiplier: float = 30.0
@export var knockback_reduction_speeed: float = 200.0

var current_knockback_time: float = 0.0
var knockback_direction: int = 0


func enter() -> void:
	player.animation_player.play("hurt")

	current_knockback_time = knockback_duration
	player.is_knocked_back = true

	if player.direction != 0:
		knockback_direction = -player.direction
	else:
		knockback_direction = -1 if player.sprite.flip_h else 1

	_handle_knockback()
	_play_damage_effect()


func exit() -> void:
	player.is_knocked_back = false
	player.velocity.x = 0
	knockback_direction = 0


func process(delta: float) -> State:
	current_knockback_time -= delta

	if current_knockback_time <= 0:
		return idle_state

	return null


func physics(delta: float) -> State:
	var reduction: float = knockback_force * knockback_reduction_speeed * delta

	if player.velocity.x > 0:
		player.velocity.x = max(0, player.velocity.x - reduction)
	else:
		player.velocity.x = min(0, player.velocity.x + reduction)

	return null


func unhandled_input(_event: InputEvent) -> State:
	return null


func _handle_knockback() -> void:
	var new_x_velocity: float = (
		knockback_direction * knockback_force * knockback_horizontal_multiplier
	)

	player.velocity.x = new_x_velocity if player.direction else -new_x_velocity


func _play_damage_effect() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(player.sprite, "modulate:v", 1, 0.25).from(15)
