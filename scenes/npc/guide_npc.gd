class_name GuideNPC extends NPC

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	super._ready()

	animation_player.play("default")


func get_dialogue_content() -> Array[Dictionary]:
	if not PlayerManager.player.has_double_jump:
		return [
			{
				"name": npc_name,
				"text": "Welcome, traveler! I see you're just starting your journey."
			},
			{
				"name": npc_name,
				"text": "Keep defeating enemies and collecting coins to gain experience."
			},
			{
				"name": npc_name,
				"text": "Once you reach level 3, you'll unlock the ability to double jump!"
			}
		]
	else:
		return [
			{"name": npc_name, "text": "Ah, you've learned to double jump! Well done!"},
			{
				"name": npc_name,
				"text": "Try combining it with your regular abilities for better mobility."
			},
			{"name": npc_name, "text": "Good luck on your journey!"}
		]


func _on_dialogue_finished() -> void:
	if PlayerManager.player.has_double_jump:
		interactable = false
	else:
		interactable = true