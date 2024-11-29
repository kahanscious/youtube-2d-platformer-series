class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: StateMachine = $StateMachine
@onready var gun_muzzle: Marker2D = $GunMuzzle
@onready var hitbox: Hitbox = $Hitbox
@onready var jump_audio: AudioStreamPlayer = $Audio/JumpAudio
@onready var shoot_audio: AudioStreamPlayer = $Audio/ShootAudio
@onready var damaged_audio: AudioStreamPlayer = $Audio/DamagedAudio
@onready var knockback_state: KnockbackState = $StateMachine/KnockbackState

@export_category("Physics")
@export var gravity: float = 980.0
@export var speed: float = 200.0
@export var air_speed: float = 150.0
@export var air_acceleration: float = 0.1
@export var jump_force: float = -400.0

@export_category("Attack")
@export var max_bullets: int = 3

@export_category("Health")
@export var max_health: int = 5
@export var current_health: int = 5

var direction: float
var is_knocked_back: bool = false

const GUN_MUZZLE_OFFSET: int = 26


func _ready() -> void:
	PlayerManager.player = self
	state_machine.configure(self)
	hitbox.take_damage.connect(_on_take_damage)


func _process(_delta: float) -> void:
	direction = Input.get_axis("left", "right")
	if direction:
		set_player_direction()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


func can_shoot() -> bool:
	var level: Level = owner.get_parent()
	if level is Level:
		return level.player_bullets.get_child_count() < max_bullets
	return false


func set_player_direction() -> void:
	sprite.flip_h = direction < 0
	gun_muzzle.position.x = -GUN_MUZZLE_OFFSET if direction < 0 else GUN_MUZZLE_OFFSET


func _on_take_damage(amount: int) -> void:
	if is_knocked_back:
		return

	current_health -= amount
	state_machine.change_state(knockback_state)
