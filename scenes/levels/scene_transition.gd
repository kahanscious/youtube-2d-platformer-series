extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func fade_out() -> bool:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	return true


func fade_in() -> bool:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	return true
