class_name Coin extends Collectible

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

@export var xp_value: int = 10


func collect(player: Player) -> void:
	XPManager.add_xp(xp_value, player)
	super.collect(player)
	audio.play()

	await audio.finished

	queue_free()
