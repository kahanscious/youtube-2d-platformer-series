class_name NPC extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var interaction_area: Area2D = $InteractionArea
@onready var interaction_label: Label = $CanvasLayer/InteractionLabel

@export var npc_name: String = "NPC"
@export var interaction_text: String = "Press E to talk"
@export var portrait: Texture

var direction: int = -1
var interactable: bool = true
var _can_interact: bool = false
var dialogue_ui: DialogueUI
var _can_interact: bool = false


func _ready() -> void:
	await get_tree().process_frame

	interaction_label.hide()

	interaction_area.body_entered.connect(_on_interaction_area_entered)
	interaction_area.body_exited.connect(_on_interaction_area_exited)

	dialogue_ui = get_node_or_null("/root/DialogueUI")
	if not dialogue_ui:
		dialogue_ui = preload("res://scenes/ui/dialogue/dialogue_ui.tscn").instantiate()
		get_tree().root.add_child.call_deferred(dialogue_ui)


func _process(_delta: float) -> void:
	set_direction()


func _unhandled_input(event: InputEvent) -> void:
	if not interactable or not _can_interact:
		return

	if event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		_handle_interaction()


func _on_interaction_area_entered(body: Node2D) -> void:
	if not body is Player or not interactable:
		return

	_can_interact = true
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
	interaction_label.text = interaction_text

	var viewport_rect: Rect2 = get_viewport_rect()
	var camera_center: Vector2 = PlayerManager.player.player_camera.get_screen_center_position()
	var screen_pos: Vector2 = global_position - camera_center + viewport_rect.size / 2
	var label_pos: Vector2 = screen_pos

	label_pos.y -= 80
	label_pos.x -= interaction_label.size.x / 2

	label_pos.x = clampf(label_pos.x, 0, viewport_rect.size.x - interaction_label.size.x)
	label_pos.y = clampf(label_pos.y, 0, viewport_rect.size.y - interaction_label.size.y)

	interaction_label.position = label_pos
	interaction_label.show()


func _on_interaction_area_exited(body: Node2D) -> void:
	if body is Player:
		_can_interact = false
		interaction_label.hide()


func set_direction() -> void:
	if PlayerManager.player.position.x > position.x:
		direction = -1
	elif PlayerManager.player.position.x < position.x:
		direction = 1

	sprite_2d.flip_h = direction > 0


func _handle_interaction() -> void:
	if not interactable:
		return

	interactable = false
	dialogue_ui.dialogue_finished.connect(_on_dialogue_finished, CONNECT_ONE_SHOT)
	dialogue_ui.start_dialogue(get_dialogue_content())


func _on_dialogue_finished() -> void:
	interactable = true


func get_dialogue_content() -> Array[Dictionary]:
	return [
		{"name": npc_name, "text": "Hello there!", "portrait": portrait},
		{"name": npc_name, "text": "I'm a basic NPC.", "portrait": portrait}
	]
