extends Node

signal resolution_changed
signal window_mode_changed

const DEFAULT_RESOLUTION_INDEX: int = 0
const DEFAULT_WINDOW_TYPE_INDEX: int = 0

var _resolutions: Array[Vector2i] = []


func _ready() -> void:
	set_resolution(DEFAULT_RESOLUTION_INDEX)
	set_window_type(DEFAULT_WINDOW_TYPE_INDEX)


func set_resolution(res_enum: int) -> void:
	if not Utils.RESOLUTIONS.has(res_enum):
		printerr("Invalid resolution enum: ", res_enum)
		return

	var new_resolution: Vector2i = Utils.RESOLUTIONS[res_enum]
	DisplayServer.window_set_size(new_resolution)
	print_debug("Resolution set to: ", Utils.get_resolution_text(res_enum))
	resolution_changed.emit()


func set_window_type(mode_enum: int) -> void:
	if not Utils.WINDOW_MODES.has(mode_enum):
		printerr("Invalid window mode enum: ", mode_enum)
		return

	var display_mode: DisplayServer.WindowMode = Utils.WINDOW_MODES[mode_enum]
	DisplayServer.window_set_mode(display_mode)
	print_debug("Window mode set to: ", Utils.get_window_mode_name(mode_enum))
	window_mode_changed.emit()
