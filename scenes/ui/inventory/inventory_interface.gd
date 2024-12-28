class_name InventoryInterface extends CanvasLayer

@onready var slots_container: HBoxContainer = $SlotsContainer

const HOTKEYS: Array[String] = ["1", "2", "3", "4"]
const FLASH_DURATION: float = 0.1

var inventory_slots: Array[InventorySlot] = []


func _ready() -> void:
	await get_tree().process_frame

	for i in range(InventoryManager.MAX_SLOTS):
		var slot: InventorySlot = (
			preload("res://scenes/ui/inventory/inventory_slot.tscn").instantiate()
		)
		slot.slot_index = i
		slot.set_hotkey(HOTKEYS[i])
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


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("slot1"):
		flash_and_use_slot(0)
	elif event.is_action_pressed("slot2"):
		flash_and_use_slot(1)
	elif event.is_action_pressed("slot3"):
		flash_and_use_slot(2)
	elif event.is_action_pressed("slot4"):
		flash_and_use_slot(3)


func flash_and_use_slot(index: int) -> void:
	if index < 0 or index >= inventory_slots.size():
		return

	inventory_slots[index].modulate = Color(0.8, 0.8, 1.0)
	InventoryManager.use_item(index)

	get_tree().create_timer(FLASH_DURATION).timeout.connect(
		func(): inventory_slots[index].modulate = Color.WHITE
	)
