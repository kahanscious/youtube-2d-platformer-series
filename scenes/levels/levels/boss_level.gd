class_name BossLevel extends Level

signal boss_battle_started
signal boss_battle_ended

@onready var boss: Boss = $Boss
@onready var boss_music: AudioStreamPlayer = $BossMusic
@onready var boss_entrance_trigger: Area2D = $BossEntranceTrigger

var battle_started: bool = false
var music_tween: Tween


func _ready() -> void:
	super._ready()


func _on_boss_entrance_trigger_body_entered(body: Node2D) -> void:
	if body is Player and not battle_started:
		start_boss_battle()


func start_boss_battle() -> void:
	if battle_started:
		return

	battle_started = true
	boss_battle_started.emit()

	PlayerManager.player.player_camera.reveal_boss(boss)

	PlayerManager.player.player_camera.configure_shake(Utils.ShakeType.EARTHQUAKE)
	PlayerManager.player.player_camera.add_trauma(0.6)

	await get_tree().create_timer(0.75).timeout
	boss.animation_player.play_backwards("death")
	boss.entrance_audio.play()

	transition_to_boss_music()


func transition_to_boss_music() -> void:
	if music_tween:
		music_tween.kill()

	music_tween = create_tween().set_parallel(true)

	var current_volume_db: float = AudioServer.get_bus_volume_db(Utils.get_bus_index("Music"))
	music_tween.tween_method(
		AudioManager.adjust_music_volume, current_volume_db, AudioManager.MIN_VOLUME_DB, 1.0
	)

	boss_music.volume_db = AudioManager.MIN_VOLUME_DB
	boss_music.play()
	music_tween.tween_property(boss_music, "volume_db", AudioManager.DEFAULT_MUSIC_VOLUME, 1.0)

	await music_tween.finished
	AudioManager._music_player.stop()


func end_boss_battle() -> void:
	if not battle_started:
		return

	battle_started = false
	boss_battle_ended.emit()


func _level_cleanup() -> void:
	if music_tween:
		music_tween.kill()

	if boss_music.playing:
		boss_music.stop()

	super._level_cleanup()
