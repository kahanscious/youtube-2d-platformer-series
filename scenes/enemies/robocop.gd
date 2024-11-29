class_name Robocop extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hitbox: Hitbox = $Hitbox
@onready var detection_component: DetectionComponent = $Components/DetectionComponent
@onready var enemy_state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var damaged_audio: AudioStreamPlayer = $Audio/DamagedAudio

@export_category("Physics")
@export var speed: float = 50.0
@export var gravity: float = 980.0

@export_category("Health")
@export var max_health: int = 3
@export var current_health: int = 3

var direction: float = -1.0


func _ready() -> void:
	enemy_state_machine.configure(self)
	hitbox.take_damage.connect(_on_take_damage)


func _process(delta: float) -> void:
	set_direction()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


func set_direction() -> void:
	if PlayerManager.player.position.x > position.x:
		direction = 1
	elif PlayerManager.player.position.x < position.x:
		direction = -1

	sprite.flip_h = direction > 0


func _on_take_damage(amount: int) -> void:
	damaged_audio.play()
	current_health -= amount
	if current_health <= 0:
		damaged_audio.finished.connect(queue_free)
		damaged_audio.play()
