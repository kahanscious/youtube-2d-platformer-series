class_name HealthPotion extends Collectible

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var potion_data: HealthPotionData


func _ready() -> void:
	super._ready()

	potion_data = HealthPotionData.new()
	potion_data.texture = sprite.texture


func collect(player: Player) -> void:
	if InventoryManager.add_item(potion_data):
		super.collect(player)
		audio.play()
		await audio.finished
		queue_free()
