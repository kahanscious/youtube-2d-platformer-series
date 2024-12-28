class_name InventorySlot extends Panel

@onready var quantity_label: Label = $QuantityLabel
@onready var item_texture: TextureRect = $ItemTexture


func _ready() -> void:
	quantity_label.visible = false


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
