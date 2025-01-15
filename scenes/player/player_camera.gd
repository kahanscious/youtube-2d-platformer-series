class_name PlayerCamera extends Camera2D

@export_group("Shake Settings")
@export_range(0.0, 10.0, 0.1) var trauma_reduction: float = 6.0
@export var max_offset: Vector2 = Vector2(8.0, 6.0)
@export_range(0.0, 100.0, 1.0) var shake_frequency: float = 45.0

var reveal_tween: Tween
var is_revealing_boss: bool = false

var trauma: float = 0.0:
	set(value):
		trauma = clampf(value, 0.0, 1.0)
	get:
		return trauma
var time: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	setup_camera_limits()


func _process(delta: float) -> void:
	if trauma:
		var old_trauma: float = trauma

		trauma = maxf(trauma - trauma_reduction * delta, 0.0)
		time += delta * shake_frequency
		apply_shake()


func setup_camera_limits() -> void:
	var current_node: Node = self
	var level: Level

	while current_node:
		if current_node is Level:
			level = current_node
			break
		current_node = current_node.get_parent()

	if not level:
		return

	var tilemap: TileMapLayer
	for child in level.get_children():
		if child is TileMapLayer:
			tilemap = child
			break

	if not tilemap:
		return

	var used_rect: Rect2i = tilemap.get_used_rect()

	limit_left = used_rect.position.x
	limit_right = (used_rect.position.x + used_rect.size.x) * 16
	limit_bottom = (used_rect.position.y + used_rect.size.y) * 16
	limit_top = used_rect.position.y * 16


func apply_shake() -> void:
	var shake_intesity: float = pow(trauma, 2.0)
	var offset_x: float = max_offset.x * shake_intesity * sin(time * PI * 0.7)
	var offset_y: float = max_offset.y * shake_intesity * sin(time * PI * 1.3)
	var rotation: float = offset_x * 0.02

	offset = Vector2(offset_x, offset_y)
	rotation_degrees = rotation


func add_trauma(amount: float) -> void:
	trauma += amount


func configure_shake(shake_type: Utils.ShakeType) -> void:
	var config: Dictionary = Utils.SHAKE_CONFIGS[shake_type]

	max_offset = config["offset"]
	trauma_reduction = config["reduction"]
	shake_frequency = config["frequency"]


func reveal_boss(boss_node: Node2D) -> void:
	if is_revealing_boss:
		return

	is_revealing_boss = true

	if reveal_tween:
		reveal_tween.kill()

	reveal_tween = create_tween()
	reveal_tween.set_trans(Tween.TRANS_SINE)
	reveal_tween.set_ease(Tween.EASE_IN_OUT)

	reveal_tween.tween_property(
		self, "position", position + (boss_node.position - PlayerManager.player.position), 1.0
	)

	reveal_tween.tween_callback(func(): add_trauma(0.6))
	reveal_tween.tween_interval(0.5)

	reveal_tween.tween_property(self, "position", Vector2.ZERO, 0.8)
	reveal_tween.tween_callback(end_boss_reveal)


func end_boss_reveal() -> void:
	is_revealing_boss = false
