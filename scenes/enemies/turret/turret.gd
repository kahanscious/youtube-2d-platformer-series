class_name Turret extends Enemy

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gun_muzzle: Marker2D = $GunMuzzle
@onready var detection_component: DetectionComponent = $DetectionComponent
@onready var bullet_scene: PackedScene = preload("res://scenes/enemies/enemy_bullet.tscn")
const GUN_MUZZLE_OFFSET: int = 8


func _ready() -> void:
	detection_component.player_entered.connect(_on_player_entered)
	detection_component.player_exited.connect(_on_player_exited)

	direction = 1.0


func _process(delta: float) -> void:
	set_direction()


func _on_player_entered() -> void:
	animation_player.play("shoot")
	if bullets.get_children().size() < 3:
		shoot()


func _on_player_exited() -> void:
	animation_player.play("idle")


func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	var bullet_position: Vector2 = gun_muzzle.global_position

	gun_muzzle.position.x = -GUN_MUZZLE_OFFSET if direction < 0 else GUN_MUZZLE_OFFSET

	if bullets:
		bullets.call_deferred("add_child", bullet)
		bullet.direction = 1 if sprite.flip_h else -1
		bullet.global_position = bullet_position
