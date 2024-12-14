extends Node

const BACKGROUND_MUSIC: AudioStream = preload("res://assets/music/background_music.wav")

const MIN_VOLUME_DB: float = -40.0
const MAX_VOLUME_DB: float = 0.0
const DEFAULT_MUSIC_VOLUME: float = -20.0
const DEFAULT_SFX_VOLUME: float = -10.0

var _music_player: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	initialize_music_player()
	adjust_music_volume(DEFAULT_MUSIC_VOLUME)
	adjust_sfx_volume(DEFAULT_SFX_VOLUME)

	play_music(BACKGROUND_MUSIC)


func initialize_music_player() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)


func play_music(stream: AudioStream, start_position: float = 0.0) -> void:
	_music_player.stream = stream
	_music_player.play(start_position)


func adjust_music_volume(value: float) -> void:
	var bus_index: int = Utils.get_bus_index("Music")
	if bus_index < 0:
		printerr("Music bus not found!")
		return

	var clamped_value: float = clampf(value, MIN_VOLUME_DB, MAX_VOLUME_DB)
	AudioServer.set_bus_volume_db(bus_index, clamped_value)


func adjust_sfx_volume(value: float) -> void:
	var bus_index: int = Utils.get_bus_index("SFX")
	if bus_index < 0:
		printerr("SFX bus not found!")
		return

	var clamped_value: float = clampf(value, MIN_VOLUME_DB, MAX_VOLUME_DB)
	AudioServer.set_bus_volume_db(bus_index, clamped_value)


func toggle_mute(is_muted: bool) -> void:
	var bus_index: int = Utils.get_bus_index("Master")
	if bus_index < 0:
		printerr("Master bus not found!")
		return

	AudioServer.set_bus_mute(bus_index, is_muted)


func get_music_volume() -> float:
	var bus_index: int = Utils.get_bus_index("Music")
	return AudioServer.get_bus_volume_db(bus_index) if bus_index >= 0 else DEFAULT_MUSIC_VOLUME


func get_sfx_volume() -> float:
	var bus_index: int = Utils.get_bus_index("SFX")
	return AudioServer.get_bus_volume_db(bus_index) if bus_index >= 0 else DEFAULT_SFX_VOLUME


func is_muted() -> bool:
	var bus_index: int = Utils.get_bus_index("Master")
	return AudioServer.is_bus_mute(bus_index) if bus_index >= 0 else false
