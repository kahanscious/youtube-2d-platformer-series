extends Node

signal inventory_updated(slot_data: Dictionary)

const MAX_SLOTS: int = 4

var inventory: Dictionary = {}


func _ready() -> void:
	for i in range(MAX_SLOTS):
		inventory[i] = null

	inventory_updated.emit(inventory)


func add_item(item_data: ItemData) -> bool:
	for slot_index in inventory:
		var slot_item = inventory[slot_index]
		if can_stack_with(slot_item, item_data):
			slot_item.quantity += 1
			inventory_updated.emit(inventory)
			return true

	for slot_index in inventory:
		if inventory[slot_index] == null:
			inventory[slot_index] = InventoryItem.new(item_data, 1)
			inventory_updated.emit(inventory)
			return true
	return false


func use_item(slot_index: int) -> void:
	var slot_item: InventoryItem = inventory[slot_index]
	if slot_item == null:
		return

	if slot_item.item_data.use(PlayerManager.player):
		slot_item.quantity -= 1

		if slot_item.quantity <= 0:
			inventory[slot_index] = null

		inventory_updated.emit(inventory)


func can_stack_with(slot_item: InventoryItem, item_data: ItemData) -> bool:
	if slot_item == null:
		return false
	return (
		slot_item.item_data.id == item_data.id
		and slot_item.quantity < slot_item.item_data.max_stack_size
	)


func swap_items(from_slot: int, to_slot: int) -> void:
	if !inventory.has(from_slot) or !inventory.has(to_slot):
		return

	var temp = inventory[to_slot]
	inventory[to_slot] = inventory[from_slot]
	inventory[from_slot] = temp

	inventory_updated.emit(inventory)
