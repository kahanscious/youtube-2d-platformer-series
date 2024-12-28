class_name ItemData extends Resource

signal item_used

@export var id: String = ""
@export var name: String = ""
@export var max_stack_size: int = 99
@export var texture: AtlasTexture


func use(player: Player) -> bool:
	item_used.emit()
	return true
