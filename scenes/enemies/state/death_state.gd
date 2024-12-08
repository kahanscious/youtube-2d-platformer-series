class_name EnemyDeathState extends EnemyState


func enter() -> void:
	enemy_state_machine.lock_state()
	enemy.velocity.x = 0
	enemy.death_audio.play()
	enemy.animation_player.play("death")

	var xp_reward = enemy.get("xp_reward")
	if xp_reward:
		XPManager.add_xp(xp_reward, PlayerManager.player)

	await enemy.animation_player.animation_finished
	enemy.queue_free()
