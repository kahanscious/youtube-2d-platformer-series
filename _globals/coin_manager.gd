extends Node

signal coins_changed(new_amount: int)

var coins: int = 0:
	set(value):
		coins = value
		coins_changed.emit(coins)
	get:
		return coins


func add_coins(amount: int) -> void:
	coins += amount
