class_name EnemyDeathState extends EnemyState


func enter() -> void:
	enemy_state_machine.lock_state()
	enemy.velocity.x = 0
	enemy.death_audio.play()
	enemy.animation_player.play("death")

	await enemy.animation_player.animation_finished
	enemy.queue_free()
