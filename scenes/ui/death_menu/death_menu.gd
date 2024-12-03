extends CanvasLayer


func _ready() -> void:
	connect_signals()
	visible = false


func connect_signals() -> void:
	PlayerManager.player.player_died.connect(_on_player_died)


func _on_restart_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	PlayerManager.player = PlayerManager.PLAYER.instantiate()
	connect_signals()
	LevelManager.change_level(LevelManager.STARTING_LEVEL_PATH)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_player_died() -> void:
	get_tree().paused = true
	visible = true
