class_name InventorySlot extends Panel

@onready var quantity_label: Label = $QuantityLabel
@onready var item_texture: TextureRect = $ItemTexture
@onready var hotkey_label: Label = $HotkeyLabel

var slot_index: int = -1
var pending_hotkey: String = ""


func _ready() -> void:
	quantity_label.visible = false

	if pending_hotkey != "":
		hotkey_label.text = pending_hotkey
		pending_hotkey = ""


func display_item(item_data: ItemData, quantity: int) -> void:
	item_texture.texture = item_data.texture
	quantity_label.text = str(quantity)
	quantity_label.visible = quantity > 1
	item_texture.visible = true


func clear() -> void:
	item_texture.texture = null
	quantity_label.text = ""
	quantity_label.visible = false
	item_texture.visible = false


func set_hotkey(key: String) -> void:
	if not is_node_ready():
		pending_hotkey = key
	else:
		hotkey_label.text = key
