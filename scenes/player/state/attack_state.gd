class_name AttackState extends State

@onready var idle_state: IdleState = $"../IdleState"
@onready var run_state: RunState = $"../RunState"
@onready var fall_state: FallState = $"../FallState"
@onready var jump_state: JumpState = $"../JumpState"
@onready var crouch_state: CrouchState = $"../CrouchState"
@onready var knockback_state: KnockbackState = $"../KnockbackState"
@onready var bullet_scene: PackedScene = preload("res://scenes/player/attacks/bullet/bullet.tscn")


func enter() -> void:
	_shoot()
	player.velocity.x = 0
	player.animation_player.play("attack")
	await player.animation_player.animation_finished


func exit() -> void:
	pass


# called every frame during _process
func process(_delta: float) -> State:
	if player.animation_player.is_playing():
		return
	else:
		if not player.direction:
			return run_state
		elif player.direction:
			return idle_state

	if not player.is_on_floor():
		return fall_state

	return null


# called every physics frame during _physics_process
func physics(_delta: float) -> State:
	if player.is_knocked_back:
		return knockback_state
	return null


# called when input events occur
func unhandled_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") and player.is_on_floor():
		return jump_state
	if event.is_action_pressed("crouch") and player.is_on_floor():
		return crouch_state
	return null


func _shoot() -> void:
	var parent: Node2D = owner.get_parent()
	if owner is Player and owner.has_node("Bullets"):
		var bullet: Bullet = bullet_scene.instantiate()
		var bullet_position: Vector2 = player.gun_muzzle.global_position

		player.shoot_audio.play()
		player.get_node("Bullets").add_child(bullet)
		bullet.direction = -1 if player.sprite.flip_h else 1
		bullet.global_position = bullet_position
