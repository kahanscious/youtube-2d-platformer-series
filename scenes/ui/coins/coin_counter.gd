extends CanvasLayer

@onready var count: Label = $Control/HBoxContainer/Count


func _ready() -> void:
	# Update initial display
	update_display(CoinManager.coins)
	# Connect to future changes
	CoinManager.coins_changed.connect(update_display)


func update_display(amount: int) -> void:
	count.text = str(amount)
