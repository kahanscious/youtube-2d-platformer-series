class_name InventoryInterface extends CanvasLayer

@onready var slots_container: HBoxContainer = $SlotsContainer
@onready var dragged_item: TextureRect = $DraggedItem

const HOTKEYS: Array[String] = ["1", "2", "3", "4"]
const FLASH_DURATION: float = 0.1

var inventory_slots: Array[InventorySlot] = []
var dragging_slot_index: int = -1
var is_dragging: bool = false
var current_hover_slot: int = -1


func _ready() -> void:
	await get_tree().process_frame
	dragged_item.visible = false

	for i in range(InventoryManager.MAX_SLOTS):
		var slot: InventorySlot = (
			preload("res://scenes/ui/inventory/inventory_slot.tscn").instantiate()
		)
		slot.slot_index = i
		slot.set_hotkey(HOTKEYS[i])
		slot.slot_clicked.connect(_on_slot_clicked)
		slots_container.add_child(slot)
		inventory_slots.append(slot)

	InventoryManager.inventory_updated.connect(_on_inventory_updated)


func _process(delta: float) -> void:
	if is_dragging:
		dragged_item.global_position = get_viewport().get_mouse_position() - dragged_item.size / 2

		var mouse_pos = get_viewport().get_mouse_position()
		current_hover_slot = -1

		for slot in inventory_slots:
			if slot.get_global_rect().has_point(mouse_pos):
				current_hover_slot = slot.slot_index
				break


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed and is_dragging:
			if current_hover_slot != -1 and current_hover_slot != dragging_slot_index:
				end_dragging(current_hover_slot)
			else:
				cancel_drag()


func end_dragging(target_slot_index: int) -> void:
	if dragging_slot_index != target_slot_index:
		InventoryManager.swap_items(dragging_slot_index, target_slot_index)

	dragged_item.visible = false
	inventory_slots[dragging_slot_index].item_texture.modulate.a = 1.0
	dragging_slot_index = -1
	is_dragging = false


func _on_slot_clicked(slot_index: int, button_index: int, pressed: bool) -> void:
	if button_index == MOUSE_BUTTON_LEFT and pressed:
		if !is_dragging and inventory_slots[slot_index].item_data != null:
			start_dragging(slot_index)
	elif button_index == MOUSE_BUTTON_RIGHT and pressed and !is_dragging:
		flash_and_use_slot(slot_index)


func start_dragging(slot_index: int) -> void:
	dragging_slot_index = slot_index
	is_dragging = true
	dragged_item.texture = inventory_slots[slot_index].item_data.texture
	dragged_item.visible = true
	inventory_slots[slot_index].item_texture.modulate.a = 0.5


func cancel_drag() -> void:
	dragged_item.visible = false
	inventory_slots[dragging_slot_index].item_texture.modulate.a = 1.0
	dragging_slot_index = -1
	is_dragging = false


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
