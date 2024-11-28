class_name Robocop extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hitbox: Hitbox = $Hitbox

@export_category("Physics")
@export var speed: float
@export var gravity: float = 980.0

@export_category("Health")
@export var max_health: int = 3
@export var current_health: int = 3

var direction: float = -1.0


func _ready() -> void:
	print("Robocop current health: ", current_health)
	hitbox.take_damage.connect(_on_take_damage)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


func _on_take_damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		queue_free()
