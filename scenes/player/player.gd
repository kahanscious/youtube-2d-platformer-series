class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine

@export var gravity: float = 980.0
@export var speed: float = 200.0
@export var air_speed: float = 150.0
@export var air_acceleration: float = 0.1
@export var jump_force: float = -400.0

var direction: float


func _ready() -> void:
	state_machine.configure(self)


func _process(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	if direction:
		sprite.flip_h = direction < 0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()
