class_name PlayerCamera extends Camera2D

@export var tilemap: TileMapLayer


func _ready() -> void:
	if tilemap:
		setup_camera_limits(tilemap.get_used_rect())
	else:
		printerr("No Tilemap found.")


func setup_camera_limits(used_rect: Rect2i) -> void:
	limit_left = used_rect.position.x
	limit_right = (used_rect.position.x + used_rect.size.x) * 16
	limit_bottom = (used_rect.position.y + used_rect.size.y) * 16
