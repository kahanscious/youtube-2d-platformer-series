class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var gravity: float = 980.0
@export var speed: float = 200.0
@export var air_speed: float = 150.0
@export var air_acceleration: float = 0.1
@export var jump_force: float = -400.0

var direction: float


func _process(delta: float) -> void:
	direction = Input.get_axis("left", "right")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		handle_air_movement()
	else:
		handle_ground_movement(delta)

	handle_jump()
	update_animations()
	move_and_slide()


func handle_ground_movement(delta: float) -> void:
	if direction:
		velocity.x = direction * speed
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


func handle_air_movement() -> void:
	if direction:
		velocity.x = lerp(velocity.x, direction * air_speed, air_acceleration)
		sprite.flip_h = direction < 0
	else:
		velocity.x = lerp(velocity.x, 0.0, air_acceleration * 0.5)


func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force


func update_animations() -> void:
	if not is_on_floor():
		if velocity.y < 0:
			animation_player.play("jump")
		else:
			animation_player.play("fall")
	else:
		if velocity.x != 0:
			animation_player.play("run")
		else:
			animation_player.play("idle")
