extends Node

const BACKGROUND_MUSIC: AudioStream = preload("res://assets/music/background_music.wav")

const MIN_VOLUME_DB: float = -40.0
const MAX_VOLUME_DB: float = 0.0
const DEFAULT_MUSIC_VOLUME: float = -20.0

var _music_player: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	initialize_music_player()
	adjust_music_volume(DEFAULT_MUSIC_VOLUME)
	play_music(BACKGROUND_MUSIC)


func initialize_music_player() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)


func play_music(stream: AudioStream, start_position: float = 0.0) -> void:
	_music_player.stream = stream
	_music_player.play(start_position)


func adjust_music_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
