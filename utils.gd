class_name Utils

const MAIN_MENU_FILEPATH: String = "res://scenes/ui/main_menu/main_menu.tscn"

enum ShakeType { SMALL, MEDIUM, BIG, EXPLOSION, EARTHQUAKE }

const SHAKE_CONFIGS: Dictionary = {
	ShakeType.SMALL: {"offset": Vector2(8.0, 6.0), "reduction": 7.0, "frequency": 50.0},
	ShakeType.MEDIUM: {"offset": Vector2(15.0, 12.0), "reduction": 5.0, "frequency": 40.0},
	ShakeType.BIG: {"offset": Vector2(25.0, 20.0), "reduction": 3.5, "frequency": 35.0},
	ShakeType.EXPLOSION: {"offset": Vector2(35.0, 30.0), "reduction": 2.5, "frequency": 30.0},
	ShakeType.EARTHQUAKE: {"offset": Vector2(40.0, 35.0), "reduction": 1.5, "frequency": 45.0},
}


static func get_bus_index(bus_name: String) -> int:
	return AudioServer.get_bus_index(bus_name)


enum Resolution { RES_720P, RES_900P, RES_1080P, RES_1440P }

const RESOLUTIONS: Dictionary = {
	Resolution.RES_720P: Vector2i(1280, 720),  # HD
	Resolution.RES_900P: Vector2i(1600, 900),  # HD+
	Resolution.RES_1080P: Vector2i(1920, 1080),  # FHD
	Resolution.RES_1440P: Vector2i(2560, 1440)  # 2K
}


static func get_resolution_text(res_enum: Resolution) -> String:
	var res: Vector2i = RESOLUTIONS[res_enum]
	return "%dx%d" % [res.x, res.y]


enum WindowMode { WINDOWED, BORDERLESS, FULLSCREEN }

const WINDOW_MODES: Dictionary = {
	WindowMode.WINDOWED: DisplayServer.WINDOW_MODE_WINDOWED,
	WindowMode.BORDERLESS: DisplayServer.WINDOW_MODE_MAXIMIZED,
	WindowMode.FULLSCREEN: DisplayServer.WINDOW_MODE_FULLSCREEN
}

const WINDOW_MODE_NAMES: Dictionary = {
	WindowMode.WINDOWED: "Windowed",
	WindowMode.BORDERLESS: "Borderless",
	WindowMode.FULLSCREEN: "Fullscreen"
}


static func get_window_mode_name(mode: WindowMode) -> String:
	return WINDOW_MODE_NAMES[mode]
