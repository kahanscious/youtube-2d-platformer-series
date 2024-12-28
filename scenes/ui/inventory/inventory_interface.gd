class_name InventoryInterface extends CanvasLayer

@onready var slots_container: HBoxContainer = $SlotsContainer

const SLOT_SIZE: int = 64
const SLOT_MARGIN: int = 4

var inventory_slots: Array[InventorySlot] = []


func _ready() -> void:
	for i in range(InventoryManager.MAX_SLOTS):
		var slot: InventorySlot = (
			preload("res://scenes/ui/inventory/inventory_slot.tscn").instantiate()
		)

		slots_container.add_child(slot)
		inventory_slots.append(slot)

	InventoryManager.inventory_updated.connect(_on_inventory_updated)


func _on_inventory_updated(inventory_data: Dictionary) -> void:
	for slot_index in inventory_data:
		var slot_item = inventory_data[slot_index]
		if slot_item != null:
			inventory_slots[slot_index].display_item(slot_item.item_data, slot_item.quantity)
		else:
			inventory_slots[slot_index].clear()
